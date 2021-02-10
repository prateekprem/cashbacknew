//
//  PAEventLogCoreDataManager.swift
//  PaytmAnalytics
//
//  Created by Paytm Labs on 2020-06-11.
//  Copyright © 2020 Paytm Labs. All rights reserved.
//

import Foundation
import CoreData

class PAEventLogCoreDataManager {
    
    static let shared = PAEventLogCoreDataManager()
    
    //MARK: - insert methods

    /// Asynchronously pushes a new signal log to local database
    ///
    /// - Parameters:
    ///     - signalLog: A `PASignalLog` instance of which the information will be used to create a
    ///                  corresponding CoreData entity and be stored accordingly
    ///     - completion: A block object to be executed after the insertion has finished. This block
    ///                   takes a single Boolean argument that indicates whether or not the insertion
    ///                   is successfully performed
    func insertNewSignalLog(_ signalLog: PASignalLog, completion: PABoolVoidCompletion? = nil) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            let sessionId = PASignalSession.shared.sessionId
            
            // Create a new PAEventLogData instance under provided context
            let _ = PAEventLogData(sessionId: sessionId,
                                   eventId: PADateHelper.getCurrentDateInMillis(),
                                   customerId: signalLog.customerId,
                                   logTime: PADateHelper.getCurrentDateInMillis(),
                                   logType: .signalSDK,
                                   eventPriority: 1,
                                   eventData: NSKeyedArchiver.archivedData(withRootObject: signalLog),
                                   isStaged: false,
                                   context: context)
        }, completion: { success in
            if !success {
                PALogger.log(message: "[Signal DB] Error inserting a new signal log into DB!", andMessageType: .fail)
            }
            
            completion?(success)
        })
    }
    
    /// Asynchronously pushes a new network event to local database
    ///
    /// - Parameters:
    ///     - networkEvent: A `PANCEvent` instance of which the information will be used to create a
    ///                  corresponding CoreData entity and be stored accordingly
    ///     - completion: A block object to be executed after the insertion has finished. This block
    ///                   takes a single Boolean argument that indicates whether or not the insertion
    ///                   is successfully performed
    func insertNewNetworkEvent(_ networkEvent: PANCEvent, completion: PABoolVoidCompletion? = nil) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            let sessionId = PANetworkSession.shared.sessionId
            
            // Create a new PAEventLogData instance under provided context
            let _ = PAEventLogData(sessionId: sessionId,
                                   eventId: PADateHelper.getCurrentDateInMillis(),
                                   customerId: nil,
                                   logTime: PADateHelper.getCurrentDateInMillis(),
                                   logType: .networkSDK,
                                   eventPriority: 1,
                                   eventData: NSKeyedArchiver.archivedData(withRootObject: networkEvent),
                                   isStaged: false,
                                   context: context)
        }, completion: { success in
            if !success {
                PALogger.log(message: "[Signal DB] Error inserting a new signal log into DB!", withPAType: .networkSDK, andMessageType: .fail)
            }
            
            completion?(success)
        })
    }
    
    //MARK: - update methods
    
    /// Asynchronously updates the `isStaged` property to `true` for events pushed to local database
    /// up until the given timestamp
    ///
    /// - Parameters:
    ///     - timestamp: The timestamp specified such that only logs stored before it will
    ///                  be updated
    ///     - type: Event type to be specified
    ///     - limit: The maximum number of events allowed to be marked as stage
    ///     - completion: A block object to be executed after the update has finished. This block
    ///                   takes a single Boolean argument that indicates whether or not the update
    ///                   is successfully performed
    func markLogsAsStaged(loggedUpUntil timestamp: Double,
                          forPALogType type: PALogType,
                          maximumNumberOfLogsToBeMarked limit: Int?,
                          completion: @escaping PABoolVoidCompletion) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            //always update the records from the earliest record no matter the value of isStaged true or false
            let predicate = NSPredicate(format: "\(PAEventLogData.logTime) <= \(timestamp) && \(PAEventLogData.logType) == \(type.rawValue)")   
            let sortDescriptor = NSSortDescriptor(key: PAEventLogData.logTime, ascending: true)
            
            do {
                let numOfLogsUpdated = try PAEventLogData.updateRecords(predicate: predicate,
                                                                        sortDescriptors: [sortDescriptor],
                                                                        fetchLimit: limit,
                                                                        context: context,
                                                                        propertyToUpdate: PAEventLogData.isStaged,
                                                                        newValue: true)
                PALogger.log(message: "[Signal DB] Finish marking event logs as staged: total = \(numOfLogsUpdated), withPAType: type, andMessageType: .success")
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in marking event logs as staged: error = \(error)", withPAType: type, andMessageType: .fail)
            }
        }, completion: completion)
    }
    
    //MARK: - Fetch methods
    
    /// Retrieves the signal logs that are ready to be uploaded, namely those that have
    /// `isStaged` property updated to `true`
    ///
    /// - Returns: An array of `PASignalLog` instances that are ready to be uploaded
    func getStagedSignalLogsForUpload() -> [PASignalLog] {
        let predicate = NSPredicate(format: "\(PAEventLogData.isStaged) == \(NSNumber(value: true)) && \(PAEventLogData.logType) == \(PALogType.signalSDK.rawValue)")
        let sortDescriptor = NSSortDescriptor(key: PAEventLogData.logTime, ascending: true)
        
        var stagedSignalLogs = [PASignalLog]()
        PACoreDataManager.shared.performSyncTask(performBlock: { context in
            do {
                let stagedSignalLogsData = try PAEventLogData.fetchRecords(predicate: predicate,
                                                                           sortDescriptors: [sortDescriptor],
                                                                           fetchLimit: PAConstant.Signal.V2_BATCH_SIZE_LIMIT,
                                                                           context: context)
                stagedSignalLogsData.forEach {
                    let eventData = $0.eventData
                    if let signalLog = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(eventData)) as? PASignalLog {
                        stagedSignalLogs.append(signalLog)
                    }
                }
                
                PALogger.log(message: "[Signal DB] Retrieved staged signals from DB for upload: total = \(stagedSignalLogs.count)", andMessageType: .success)
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in retrieving staged signal logs: error = \(error)", andMessageType: .fail)
            }
        })
        
        return stagedSignalLogs
    }
    
    /// Retrieves the network events that are ready to be uploaded, namely those that have
    /// `isStaged` property updated to `true`
    ///
    /// - Returns: An array of `PANCEvent` instances that are ready to be uploaded
    func getStagedNetworkEventsForUpload() -> [PANCEvent] {
        let predicate = NSPredicate(format: "\(PAEventLogData.isStaged) == \(NSNumber(value: true)) && \(PAEventLogData.logType) == \(PALogType.networkSDK.rawValue)")
        let sortDescriptor = NSSortDescriptor(key: PAEventLogData.logTime, ascending: true)
        
        var stagedNetworkEvents = [PANCEvent]()
        PACoreDataManager.shared.performSyncTask(performBlock: { context in
            do {
                let stagedEventLogsData = try PAEventLogData.fetchRecords(predicate: predicate,
                                                                          sortDescriptors: [sortDescriptor],
                                                                          fetchLimit: PANetworkSession.shared.maxBatchSizeToUpload,
                                                                          context: context)
                stagedEventLogsData.forEach {
                    let eventData = $0.eventData
                    if let networkEvent = (try? NSKeyedUnarchiver.unarchiveTopLevelObjectWithData(eventData)) as? PANCEvent {
                        stagedNetworkEvents.append(networkEvent)
                    }
                }
                
                PALogger.log(message: "[Signal DB] Number of staged network events retrieved for upload: \(stagedNetworkEvents.count)", withPAType: .networkSDK, andMessageType: .success)
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in retrieving staged network events: \(error)", withPAType: .networkSDK, andMessageType: .fail)
            }
        })
        
        return stagedNetworkEvents
    }
    
    /// Update the session id asynchronously
    func updateCurrentSessionId(forPALogType type: PALogType, completion: ((Int64) -> Void)? = nil) {
        PALogger.log(message: "[Signal DB] Fetching last used session id", withPAType: type)
        
        let predicate = NSPredicate(format: "\(PAEventLogData.logType) == \(type.rawValue)")
        let descendingSortDescriptor = NSSortDescriptor(key: PAEventLogData.sessionId, ascending: false)
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            var updatedSessionId: Int64 = 1
            do {
                let signalLogWithLastSessionId = try PAEventLogData.fetchRecords(predicate: predicate,
                                                                                 sortDescriptors: [descendingSortDescriptor],
                                                                                 fetchLimit: 1,
                                                                                 context: context).first
                if let lastSessionId = signalLogWithLastSessionId?.sessionId {
                    updatedSessionId = lastSessionId + 1
                }
                
                if signalLogWithLastSessionId == nil {
                    PALogger.log(message: "[Signal DB] No signal log found in database", withPAType: type)
                }
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in fetching last session used sessionId: \(error)", withPAType: type, andMessageType: .fail)
            }
            
            PASignalSession.shared.sessionId = updatedSessionId
            completion?(updatedSessionId)
        }, completion: nil)
    }
    
    // MARK: - Public instance methods
    /// Returns the number of events stored in database for the specified event type
    ///
    /// - Parameters:
    ///     - type: Event type to be specified
    ///
    /// - Returns: The number of events stored in database for the specified event type
    func getDataCount(forPALogType type: PALogType) -> Int {
        let fetchRequest: NSFetchRequest<PAEventLogData> = PAEventLogData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "\(PAEventLogData.logType) == \(type.rawValue)")

        var count = PASignalSession.shared.maxBatchSizeToCapture
        PACoreDataManager.shared.performSyncTask { context in
            do {
                count = try context.count(for: fetchRequest)
                
                if count == 0 {
                    PALogger.log(message: "[Signal DB] No event log in database", withPAType: type)
                }
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in fetching data count: \(error)", withPAType: type, andMessageType: .fail)
            }
        }
        
        return count
    }
    
    //MARK: - delete methods
    
    /// Deletes all events stored in local database whose `isStatged` property
    /// is `true`
    ///
    /// Please note that this function is executed within the same thread from
    /// which it's called, so be aware that the deletion completes only when this
    /// function has returned
    ///
    /// - Parameters:
    ///     - type: Event type to be specified
    ///     - limit: The maximum number of staged events allowed to be deleted
    ///     - completion: A block object to be executed after the deletion has finished. This block
    ///                   takes a single Boolean argument that indicates whether or not the deletion
    ///                   is successfully performed
    func deleteStagedLogs(forPALogType type: PALogType,
                          maximumNumberOfLogsToBeDeleted limit: Int?,
                          completion: PABoolVoidCompletion? = nil) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            let predicate = NSPredicate(format: "\(PAEventLogData.isStaged) == \(NSNumber(value: true)) && \(PAEventLogData.logType) == \(type.rawValue)")
            let sortDescriptor = NSSortDescriptor(key: PAEventLogData.logTime, ascending: true)
            
            do {
                let numOfLogsDeleted = try PAEventLogData.deleteRecords(predicate: predicate,
                                                                        sortDescriptors: [sortDescriptor],
                                                                        fetchLimit: limit,
                                                                        context: context)
                PALogger.log(message: "[Signal DB] Finish deleting event logs marked as staged w/o customer id - \(numOfLogsDeleted) deleted", withPAType: type, andMessageType: .success)
            } catch let error {
                PALogger.log(message: "[Signal DB] Error in deleting event logs marked as staged: \(error)", withPAType: type, andMessageType: .fail)
            }
        }, completion: completion)
    }
    
    /// Asynchronously deletes all stored events which have been obsolete for more than 30 days
    ///
    /// - Parameters:
    ///     - type: Event type to be specified
    ///     - completion: A block object to be executed after all data has been deleted. This block
    ///                   takes a single Boolean argument that indicates whether or not the update
    ///                   is successfully performed
    func deleteExpiredLogs(forPALogType type: PALogType, completion: PABoolVoidCompletion? = nil) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            do {
                let thirtyDaysBefore = PADateHelper.getCurrentDate().addingTimeInterval(-PAConstant.EVENT_EXPIRATION_INTERVAL).timeIntervalSince1970
                let predicate = NSPredicate(format: "\(PAEventLogData.logType) == \(type.rawValue) && \(PAEventLogData.logTime) < \(thirtyDaysBefore)")
                let numOfLogsDeleted = try PAEventLogData.deleteRecords(predicate: predicate, context: context)
                PALogger.log(message: "[Signal DB] Finish deleting expired logs for \(type): total = \(numOfLogsDeleted) logs deleted", withPAType: type, andMessageType: .success)
            } catch let error {
                PALogger.log(message: "[Signal DB] Error deleting logs for \(type): \(error)", withPAType: type, andMessageType: .fail)
            }
        }, completion: completion)
    }
    
    /// Asynchronously deletes all stored events for the specified event type
    ///
    /// - Parameters:
    ///     - type: Event type to be specified
    ///     - completion: A block object to be executed after all data has been deleted. This block
    ///                   takes a single Boolean argument that indicates whether or not the update
    ///                   is successfully performed
    func deleteAllData(forPALogType type: PALogType, completion: PABoolVoidCompletion? = nil) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            do {
                let predicate = NSPredicate(format: "\(PAEventLogData.logType) == \(type.rawValue)")
                let numOfLogsDeleted = try PAEventLogData.deleteRecords(predicate: predicate, context: context)
                PALogger.log(message: "[Signal DB] Finish deleting logs for \(type) - \(numOfLogsDeleted) logs deleted", withPAType: type, andMessageType: .success)
            } catch let error {
                PALogger.log(message: "[Signal DB] Error deleting logs for \(type): \(error)", withPAType: type, andMessageType: .fail)
            }
        }, completion: completion)
    }
    
}

// MARK: - For testing purpose

extension PAEventLogCoreDataManager {
    
    func printAllLogs(forPALogType type: PALogType) {
        PACoreDataManager.shared.performBackgroundTask(performBlock: { context in
            do {
                PALogger.log(message: "====Printing event logs for: \(type)====", withPAType: type)
                
                let predicate = NSPredicate(format: "\(PAEventLogData.logType) == \(type.rawValue)")
                let allLogs = try PAEventLogData.fetchRecords(predicate: predicate, context: context)
                allLogs.forEach {
                    PALogger.log(message: "\($0.debugDescription)", withPAType: type)
                }
                
                PALogger.log(message: "====Finish printing event logs for: \(type)====", withPAType: type)
            } catch let error {
                PALogger.log(message: "Error in printing current event logs in database: \(error)", withPAType: type, andMessageType: .fail)
            }
        }, completion: nil)
    }
    
}
