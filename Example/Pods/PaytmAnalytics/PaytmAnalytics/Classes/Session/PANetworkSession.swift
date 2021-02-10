//
//  PASession.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PANetworkSession: PABaseSession {
    
    static let shared = PANetworkSession()
    
    var sessionId: Int64 = 0
    var origin: String = PAConstant.EMPTY_STRING
    var clientId: String = PAConstant.EMPTY_STRING
    var appId: String = PAConstant.EMPTY_STRING
    var appSecret: String = PAConstant.EMPTY_STRING
    
    func push(withPANCEvent networkEvent: PANCEvent) {
        // NOTE: We're limiting the number of network events that can be stored in our local database
        // to just half of the maximum storage, which is 1000 logs in our case.
        if PANetworkSession.shared.getCurrentDataCount() < PANetworkSession.shared.maxBatchSizeToCapture / 2 {
            PAEventLogCoreDataManager.shared.insertNewNetworkEvent(networkEvent) { success in
                if success {
                    PALogger.log(message: "Pushed Network Event: \(networkEvent.dictionaryRepresentation())", withPAType: .networkSDK, andMessageType: .success)
                }
            }
        } else {
            PALogger.log(message: "MAX DATA COUNT REACHED", withPAType: .networkSDK)
        }
    }
    
    // MARK: - CoreData interaction
    
    func setNetworkSessionId() {
        PAEventLogCoreDataManager.shared.updateCurrentSessionId(forPALogType: .networkSDK)
    }
    
    func getCurrentDataCount() -> Int {
        PAEventLogCoreDataManager.shared.getDataCount(forPALogType: .networkSDK)
    }
    
    func markStaged(upUntil: Double, withCompletionHandler completion: @escaping (_ success: Bool) -> ()) {
        PAEventLogCoreDataManager.shared.markLogsAsStaged(loggedUpUntil: upUntil,
                                                          forPALogType: .networkSDK,
                                                          maximumNumberOfLogsToBeMarked: maxBatchSizeToUpload,
                                                          completion: completion)
    }
    
    func deleteStagedData(completion: PABoolVoidCompletion? = nil) {
        PAEventLogCoreDataManager.shared.deleteStagedLogs(forPALogType: .networkSDK,
                                                          maximumNumberOfLogsToBeDeleted: maxBatchSizeToUpload,
                                                          completion: completion)
    }
    
    func deleteAllData() {
        PAEventLogCoreDataManager.shared.deleteAllData(forPALogType: .networkSDK)
    }
    
    func sendDataToServer(withCompletionHandler completion: @escaping (_ success: Bool) -> ()) {
        let dataArray = PAEventLogCoreDataManager.shared.getStagedNetworkEventsForUpload()
        let resultDataToSend = PANCLog()
        resultDataToSend.events = dataArray
        resultDataToSend.userID = PAAnalyticManager.shared.analyticDelegate?.userID
        resultDataToSend.origin = PANetworkSession.shared.origin
        
        if PANetworkSession.shared.clientId.count > 0 {
            resultDataToSend.clientid = PANetworkSession.shared.clientId
        } else {
            resultDataToSend.clientid = PANetworkSession.shared.appId
        }
        
        if let deviceID = UIDevice.current.identifierForVendor?.uuidString {
            resultDataToSend.deviceId = deviceID
        } else {
            resultDataToSend.deviceId = PAConstant.EMPTY_STRING
        }
        
        resultDataToSend.osType = UIDevice.current.systemName
        resultDataToSend.osVersion = UIDevice.current.systemVersion
        resultDataToSend.deviceManufacturer = "Apple"
        resultDataToSend.deviceName = UIDevice.current.model
        
        PALogger.log(message: "HawkEye sent total = \(dataArray.count)\n", withPAType: .networkSDK, andMessageType: .success )

        if dataArray.count > 0 {
            let dataTosend = resultDataToSend.dictionaryRepresentation()
            if let url = PANetworkSession.shared.requestUrlString, url.count > 0 {
                var headerDic = [String: String]()
                let authKey = PANetworkSession.shared.appId + ":" + PANetworkSession.shared.appSecret
                headerDic["authorization"] = "Basic " + authKey.toBase64()
                let requestTuple: PARequestTuple = (inUrl: url, inJsonDic: dataTosend as AnyObject, isCookiesRequired: false, inRequestType: PAConstant.HTTP_POST, inContentType: PAContentType.eRequestJsonType, inHeaderDic: headerDic, isGzipRequired: false)
                PASessionManager().sendRequest(requestTuple: requestTuple) { (success, _) in
                    completion(success)
                }
            } else {
                completion(false)
            }
        } else {
            completion(false)
            PALogger.log(message: "NO DATA TO UPLOAD", withPAType: .networkSDK)
        }
    }

    // MARK: - For testing
    func printAllData() {
        PAEventLogCoreDataManager.shared.printAllLogs(forPALogType: .networkSDK)
    }
    
}
