//
//  PASignalSession.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PASignalSession: PABaseSession {
    
    static let shared = PASignalSession()

    var sessionId: Int64 = 0
    var appLaunchTime = PAConstant.EMPTY_STRING
    
    //signal endpoint V2
    var clientID: String?
    var secretKey: String?
    
    /// The serial queue used for dispatching & uploading signal events
    lazy var eventsUploadQueue: DispatchQueue = {
        return DispatchQueue(label: "Signal Events Upload Queue", qos: .default)
    }()
    
    /// Pushes a signal event and store it in local database
    ///
    /// - Parameter signalLog: The signal event to be inserted to local database
    func push(withPASignalLog signalLog: PASignalLog) {
        guard signalLog.isValidSignaEvent() else { return }
        
        if PASignalSession.shared.getCurrentDataCount() < PASignalSession.shared.maxBatchSizeToCapture {
            signalLog.appLaunchTime = appLaunchTime
            
            PAEventLogCoreDataManager.shared.insertNewSignalLog(signalLog) { success in
                if success {
                    PALogger.log(message: "[Signal Push] Just pushed one signal event to DB: signal = \(signalLog)", andMessageType: .success)
                } else {
                    PALogger.log(message: "[Signal Push] Failed to push signal event to DB: signal = \(signalLog)", andMessageType: .fail, isCritical: true)
                }
            }
        } else {
            PALogger.log(message: "[Signal Push] DB max batch size reached: max = \(PASignalSession.shared.maxBatchSizeToCapture), push signal failed!")
        }
    }
    
    // MARK: - Send signal events to server
    
    /// Sends an array of critical events to server directly using specific completion handler without push them into database.
    /// Please note that the events will be divided into batches of at most 10 events if the total number of events is greater than 10.
    ///
    /// - Parameters:
    ///     - signalLogs: An array of critical events to be sent to server
    ///     - completion: A completion block to be executed when sending critical events to server finishes, this
    ///                   block takes two parameters of which the first indicates whether there are errors occurred
    ///                   when sending given events to server, the second is an array contains the events that failed
    ///                   to be sent to server, which have been pushed into database
    func sendCriticalEvents(_ signalLogs: [PASignalLog], completion: ((Bool, [PASignalLog]?) -> Void)?) {
        eventsUploadQueue.async { [weak self] in
            guard let self = self else { return }
            
            let signalEventsWithCustomerId = signalLogs.filter { $0.customerId != nil }
            let signalEventsWithoutCustomerId = signalLogs.filter { $0.customerId == nil }
            
            var unsentEvents = [PASignalLog]()
            self.performBatchUploadWithoutSaving(for: signalEventsWithCustomerId, hasCustomerId: true) { (successWithCustomerId, unsentEventsWithCustomerId) in
                unsentEvents.append(contentsOf: unsentEventsWithCustomerId)
                self.performBatchUploadWithoutSaving(for: signalEventsWithoutCustomerId, hasCustomerId: false) { (successWithoutCustomerId, unsentEventsWithoutCustomerId) in
                    unsentEvents.append(contentsOf: unsentEventsWithoutCustomerId)
                    completion?(successWithCustomerId && successWithoutCustomerId, unsentEvents)
                }
            }
        }
    }
    
    //calling from dispatcher for one batch signals
    func sendSignalEventsToServer(withCompletion completion: @escaping (_ successWithCustomerId: Bool, _ successWithoutCustomerId: Bool) -> ()) {
        let signalList = PAEventLogCoreDataManager.shared.getStagedSignalLogsForUpload()
        let signalWithCustomerIdList = signalList.filter { $0.customerId != nil }
        let signalWithoutCustomerIdList = signalList.filter { $0.customerId == nil }
        
        //first send ones with customerId
        self.createAndSendBatchRequestToServer(signalWithCustomerIdList, hasCustomerId: true) { successWithCustomerId in
            //when response back, send ones without customerId
            self.createAndSendBatchRequestToServer(signalWithoutCustomerIdList, hasCustomerId: false) { successWithoutCustomerId in
                completion(successWithCustomerId, successWithoutCustomerId)
            }
        }
    }
    
    //construct request and call signal end point
    private func createAndSendBatchRequestToServer(_ signalEvents: [PASignalLog], hasCustomerId: Bool, completion: @escaping PABoolVoidCompletion) {
        let hasCustomerIdOrNotString = "\(hasCustomerId ? "with" : "without") customer id"
        guard signalEvents.count > 0 else {
            PALogger.log(message: "[Signal Send] No data to be sent for signal events \(hasCustomerIdOrNotString))")
            completion(false)
            return
        }
        
        guard let urlString = PASignalSession.shared.requestUrlString, urlString.count > 0 else {
            PALogger.log(message: "[Signal Send] No request url provided for uploading signal events \(hasCustomerIdOrNotString)", andMessageType: .fail)
            completion(false)
            return
        }
        
        let signalEventsDictionaryArray = signalEvents.compactMap { $0.dictionaryRepresentation() }

        var headerDic = [String: String]()
        if let clientID = clientID, let secretKey = secretKey, let data = try? JSONSerialization.data(withJSONObject: signalEventsDictionaryArray), let url = URL(string: urlString) {
            // Use HMAC for encryption
            headerDic[PAConstant.XREQUESTER_HEADER] = clientID
            headerDic[PAConstant.HMAC_HEADER] = PAHelper.hmac(requestMethod: PAConstant.HTTP_POST, apiPath: url.path, xRequester: clientID, secretKey: secretKey, payload: data)
        }
        
        PALogger.log(message: "[Signal Send] Signal events \(hasCustomerIdOrNotString) sending to server: total = \(signalEventsDictionaryArray.count) \nfirst signal event = \(signalEventsDictionaryArray[0])\n")
        
        let requestTuple: PARequestTuple = (inUrl: urlString, inJsonDic: signalEventsDictionaryArray as AnyObject, isCookiesRequired: false, inRequestType: PAConstant.HTTP_POST, inContentType: PAContentType.eRequestJsonType, inHeaderDic: headerDic, isGzipRequired: true)
        PASessionManager().sendRequest(requestTuple: requestTuple) { (success, data) in
            do {
                guard let data = data, let responseJson = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any],
                      let success = responseJson[PAConstant.RESPONSE_STATUS] as? String, success == PAConstant.RESPONSE_SUCCESS else {
                    completion(false)
                    return
                }
                completion(true)
            } catch let error {
                PALogger.log(message: "[Signal Send] Error formatting signal events \(hasCustomerIdOrNotString): \(error)", andMessageType: .fail)
                completion(false)
            }
        }
    }

    private func performBatchUploadWithoutSaving(for signalLogs: [PASignalLog], hasCustomerId: Bool, completion: @escaping (Bool, [PASignalLog]) -> Void) {
        let batchLimit = PAConstant.Signal.V2_BATCH_SIZE_LIMIT
        let numberOfBatchesWithCustList = signalLogs.count / batchLimit + (signalLogs.count % batchLimit == 0 ? 0 : 1)
        var didSendAllBatches = true
        let sendDataGroup = DispatchGroup()
        var unsuccessfullySentLogs = [PASignalLog]()
        
        for i in 0..<numberOfBatchesWithCustList {
            sendDataGroup.enter()
            
            let subArrayStart = batchLimit * i
            let subArrayEnd = min(subArrayStart + batchLimit - 1, signalLogs.count - 1)
            let batchToBeSent = [PASignalLog](signalLogs[subArrayStart...subArrayEnd])
            createAndSendBatchRequestToServer(batchToBeSent, hasCustomerId: hasCustomerId) { [weak self] success in
                sendDataGroup.leave()

                guard let self = self else { return }
                
                if !success {
                    didSendAllBatches = false
                    unsuccessfullySentLogs.append(contentsOf: batchToBeSent)
                    
                    //Store unsuccessfully sent signal events to local database so that they can be sent later via dispatcher
                    batchToBeSent.forEach { self.push(withPASignalLog: $0) }
                    
                    PALogger.log(message: "[Signal Push] Failed to send signals \(hasCustomerId ? "with" : "without") customer id to server with range from: \(subArrayStart) to \(subArrayEnd)", andMessageType: .fail)
                }
            }
        }
        
        sendDataGroup.notify(queue: eventsUploadQueue) {
            completion(didSendAllBatches, unsuccessfullySentLogs)
        }
    }
    
    // MARK: - CoreData interaction
    
    func deleteExpiredEvents(completion: @escaping PABoolVoidCompletion) {
        PAEventLogCoreDataManager.shared.deleteExpiredLogs(forPALogType: .signalSDK, completion: completion)
    }
    
    func setSignalSessionId() {
        PAEventLogCoreDataManager.shared.updateCurrentSessionId(forPALogType: .signalSDK)
    }
    
    func getCurrentDataCount() -> Int {
        return PAEventLogCoreDataManager.shared.getDataCount(forPALogType: .signalSDK)
    }
    
    func markStaged(upUntil: Double, numberOfEventsToBeMarked: Int = PAConstant.Signal.V2_BATCH_SIZE_LIMIT, withCompletionHandler completion: @escaping PABoolVoidCompletion) {
        PAEventLogCoreDataManager.shared.markLogsAsStaged(loggedUpUntil: upUntil,
                                                          forPALogType: .signalSDK,
                                                          maximumNumberOfLogsToBeMarked: numberOfEventsToBeMarked,
                                                          completion: completion)
    }
    
    func deleteStagedData(completion: @escaping PABoolVoidCompletion) {
        PAEventLogCoreDataManager.shared.deleteStagedLogs(forPALogType: .signalSDK,
                                                          maximumNumberOfLogsToBeDeleted: PAConstant.Signal.V2_BATCH_SIZE_LIMIT,
                                                          completion: completion)
    }
    
    // MARK: - For testing
    
    func printAllData() {
        PAEventLogCoreDataManager.shared.printAllLogs(forPALogType: .signalSDK)
    }

}
