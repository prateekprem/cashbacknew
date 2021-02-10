//
//  PADispatchManager.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PASignalDispatcher: NSObject {
    
    static let shared = PASignalDispatcher()
    
    private var isDispatching = false
    private var willEndBackgroundTaskSoon = false
    private let backgroundDispatchTaskReason = "Finish Sending Remaining Signal Events"
    
    // MARK: - Initization & Deinitization
    
    override init() {
        super.init()
        
        NotificationCenter.default.addObserver(self, selector: #selector(shouldEndBackgroundTaskSoon), name: UIApplication.willEnterForegroundNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(forceDispatchRemainingEvents), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    // MARK: - Public methods
    
    func startDispatching() {
        switch PASignalSession.shared.dispatchStrategy {
        case .manual:
            //DO NOTHING ON INITIALIZATION : USER WILL CHOOSE WHEN TO DISOATCH DATA TO SERVER
            //CALL METHOD PASignalDispatcher.shared.dispatch() to start dispatch
            break
        case .intervalBased(let interval):
            //UPLOAD DATA AFTER EACH INTEVAL CONFIGURED AT THE INITIALIAZATION
            startIntervalDispatch(interval: interval)
            break
        case .background:
            //UPLOAD DATA WHEN APP GOES TO BACKGROUNND
            break
        }
    }
 
}

// MARK: - Interval-based dispatch

private extension PASignalDispatcher {
  
    //worker thread
    @objc func uploadDataToServer(completion: PABoolVoidCompletion? = nil) {
        let numberOfEventsInDatabase = PAEventLogCoreDataManager.shared.getDataCount(forPALogType: .signalSDK)
        
        guard numberOfEventsInDatabase > 0 else { return }
        
        let currentTimeStamp = PADateHelper.getCurrentDateInMillis()

        PALogger.log(message: "[Event Dispatch] Total signal events in DB now: count = \(numberOfEventsInDatabase)")
        PALogger.log(message: "[Event Dispatch] Start to upload signals to server at: time =  \(currentTimeStamp)")
        
        isDispatching = true
        
        // Calculate the number of batches needed based the number of remaining signal events currently in database
        let maximumSizePerBatch = PAConstant.Signal.V2_BATCH_SIZE_LIMIT
        let maximumBatchSizeToUpload = min(PASignalSession.shared.maxBatchSizeToUpload, numberOfEventsInDatabase)    // = 25
        let numberOfBatches = maximumBatchSizeToUpload / maximumSizePerBatch + (maximumBatchSizeToUpload % maximumSizePerBatch == 0 ? 0 : 1)
        sendDataWithinBatchLimit(upUntil: currentTimeStamp, currentBatch: 0, totalNumberOfBatches: numberOfBatches, totalNumberOfEvents: maximumBatchSizeToUpload) { [weak self] success in
            guard let self = self else { return }
            
            self.isDispatching = false
            completion?(success)
                        
            PALogger.log(message: "[Event Dispatch] Upload to server completes, remainig events in DB: total = \(PAEventLogCoreDataManager.shared.getDataCount(forPALogType: .signalSDK))", andMessageType: .success)
        }
    }
    
    //Recursive calls until reaching totalNumberOfBatches
    func sendDataWithinBatchLimit(upUntil timestamp: Double, currentBatch: Int, totalNumberOfBatches: Int, totalNumberOfEvents: Int, completion: @escaping PABoolVoidCompletion) {
        guard currentBatch < totalNumberOfBatches else {
            // If all batches are sent, call the completion handler to notify the caller
            completion(true)
            return
        }
        
        // Calculate the number of events to be marked in the current batch.
        // If this is already the last batch in the current cycle, then the number of
        // events to be marked should be equal to the number of remaining events
        var numberOfEventsToBeMarked = PAConstant.Signal.V2_BATCH_SIZE_LIMIT
        if currentBatch == totalNumberOfBatches - 1 {
            numberOfEventsToBeMarked = totalNumberOfEvents % PAConstant.Signal.V2_BATCH_SIZE_LIMIT
        }
        
        PASignalSession.shared.markStaged(upUntil: timestamp, numberOfEventsToBeMarked: numberOfEventsToBeMarked) { success in
            guard success else {
                PALogger.log(message: "[Event Dispatch] Error in staging data in DB", andMessageType: .fail, isCritical: true)
                completion(false)
                return
            }

            PASignalSession.shared.sendSignalEventsToServer(withCompletion: { (successWithCust, successWithoutCust) in
                guard successWithCust || successWithoutCust else {
                    // Events upload fails either because there is no more data to upload or there is a network error.
                    // Either way, we're stopping the upload right away
                    completion(false)
                    return
                }
                
                PASignalSession.shared.deleteStagedData { [weak self] success in
                    guard let self = self, success else {
                        completion(false)
                        return
                    }

                    self.sendDataWithinBatchLimit(upUntil: timestamp,
                                                  currentBatch: currentBatch + 1,
                                                  totalNumberOfBatches: totalNumberOfBatches,
                                                  totalNumberOfEvents: totalNumberOfEvents,
                                                  completion: completion)
                }
            })
        }
    }

    /// Triggers event dispatching that will upload all remaining events stored in
    /// the local database to server side
    @objc func forceDispatchRemainingEvents() {
        //If there are any events left in DB, they will be send out at time interval of 2 seconds
        //Suspend the process: the system executes your block a second time with the expired parameter set to true.
        
        //Use this method to perform tasks when your process is executing in the background
        ProcessInfo.processInfo.performExpiringActivity(withReason: backgroundDispatchTaskReason) { [weak self] taskWillExpire in
            guard let self = self else { return }
            
            self.willEndBackgroundTaskSoon = false
            
            // The expiring activity being performed by the ProcessInfo agent will return and end
            // itself once the control flow returns from the closure, therefore we have to make the
            // asynchronous upload logic synchronous by blocking the current thread until the upload
            // is finished
            let dispatchGroup = DispatchGroup()
            dispatchGroup.enter()
            
            func endBackgroundTask() {
                self.isDispatching = false
                
                guard !self.willEndBackgroundTaskSoon else { return }
                
                PALogger.log(message: "[Event Dispatch] Background task has ended")
                self.willEndBackgroundTaskSoon = true
                dispatchGroup.leave()
            }
            
            func sendAllEvents() {
                // End the task if background execution time is about to expire
                guard !taskWillExpire else {
                    endBackgroundTask()
                    return
                }
                
                // If there is no remaining events in the database, end the background task immediately
                guard PAEventLogCoreDataManager.shared.getDataCount(forPALogType: .signalSDK) != 0 else {
                    PALogger.log(message: "[Event Dispatch] Ending background task due to no event")
                    endBackgroundTask()
                    return
                }
                
                guard !self.isDispatching else {
                    PALogger.log(message: "[Event Dispatch] Background task paused, wait for 2s for another try")
                    
                    sleep(UInt32(PAConstant.Signal.FORCED_DISPATCH_INTERVAL))
                    sendAllEvents()
                    return
                }

                self.uploadDataToServer { success in
                    guard success else {
                        PALogger.log(message: "[Event Dispatch] Ending background task due to upload error or no event")
                        endBackgroundTask()
                        return
                    }
                    
                    if self.willEndBackgroundTaskSoon {
                        PALogger.log(message: "[Event Dispatch] This is the last batch being uploaded before background task is terminated")
                        return
                    }

                    // When the previous attemp finishes, make another attemp to keep sending
                    // remaing events until the granted background execution time has expired
                    PALogger.log(message: "[Event Dispatch] Background task continuing")
                    
                    //trigger a new dispatching after 2 seconds
                    sleep(UInt32(PAConstant.Signal.FORCED_DISPATCH_INTERVAL))

                    sendAllEvents()
                }
            }
            
            sendAllEvents()
            
            // The background upload task thread is blocked until it finishes on itself or being terminated
            // by the system
            dispatchGroup.wait()
        }
        
    }
    
    @objc func shouldEndBackgroundTaskSoon() {
        willEndBackgroundTaskSoon = true
    }
    
    func startIntervalDispatch(interval: TimeInterval) {
        let timer = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            guard let self = self else { return }
            
            PASignalSession.shared.eventsUploadQueue.async {
                self.runInLoop()
            }
        }
        
        // Start interval-based dispatcher immediately so that we can send events as soon
        // as possible when app launches
        timer.fire()
    }
    
    func runInLoop() {
        guard !isDispatching else {
            // Wait for next dispatch cycle: Data is being uploaded
            PALogger.log(message: "[Event Dispatch] Interval-based dispatch skipped --")
            return
        }
        
        PALogger.log(message: "[Event Dispatch] Interval-based signal dispatch hit --")
        
        uploadDataToServer()
    }
    
}

//MARK: - Manual dispatch

extension PASignalDispatcher {
    
    func dispatch() {
        if isDispatching {
            // Data already being dispatched, try after an interval of 10 seconds
            perform(#selector(uploadDataToServer), with: nil, afterDelay: 10.0)
        } else {
            uploadDataToServer()
        }
    }
    
}
