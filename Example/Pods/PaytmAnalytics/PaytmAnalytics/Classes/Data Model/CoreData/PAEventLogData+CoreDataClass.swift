//
//  PAEventLogData+CoreDataClass.swift
//  PaytmAnalytics
//
//  Created by Paytm Labs on 2020-06-23.
//  Copyright © 2020 Paytm Labs. All rights reserved.
//

import Foundation
import CoreData

@objc(PAEventLogData)
class PAEventLogData: NSManagedObject {
    
    convenience init(sessionId: Int64,
                     eventId: Double,
                     customerId: String? = nil,
                     logTime: Double,
                     logType: PALogType,
                     eventPriority: Int64,
                     eventData: Data = Data(),
                     isStaged: Bool,
                     context: NSManagedObjectContext) {
        self.init(context: context)
        
        self.sessionId = sessionId
        self.eventId = eventId
        self.customerId = customerId
        self.logTime = logTime
        self.logType = Int64(logType.rawValue)
        self.eventPriority = eventPriority
        self.eventData = eventData
        self.isStaged = isStaged
    }
        
    // MARK: - Class methods
    /// Fetches all `PAEventLogData` records stored in database that match the given predicate.
    /// Those records will be sorted by the given sort descriptors and the maximum number of records
    /// that can be fetched will be limited by `fetchLimit`
    ///
    /// This function is performed synchronously within the thread from which it's called
    ///
    /// - Parameters:
    ///     - predicate: A `NSPredicate` instance that indicates how the records will be selected,
    ///                  if `nil` is provided, then all records stored will be taken into consideration
    ///     - sortDescriptors: An array of `NSSortDescriptor` instances that define how the fetched
    ///                        records will be sorted
    ///     - fetchLimit: The maximum number of event logs to be returned, all event logs that match
    ///                   the given predicate will be returned if no value is provided
    ///     - context: The *Managed Object Context* instance under which the operation is performed
    ///
    /// - Returns: An array of `PAEventLogData` instances retrieved from local database
    class func fetchRecords(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, context: NSManagedObjectContext) throws -> [PAEventLogData] {
        let fetchRequest: NSFetchRequest<PAEventLogData> = PAEventLogData.fetchRequest()
        fetchRequest.predicate = predicate
        fetchRequest.sortDescriptors = sortDescriptors
        
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
        }
        
        do {
            let fetchedObjects = try context.fetch(fetchRequest)
            return fetchedObjects.count > 0 ? fetchedObjects : []
        } catch let error {
            throw error
        }
    }
    
    /// Deletes all `PAEventLogData` records stored in database that match the given predicate
    /// and returns the number of deleted records.
    /// If the maximum number of records to be deleted is specified by `fetchLimit`, then those
    /// records will be sorted by the given sort descriptors first
    ///
    /// This function is performed synchronously within the thread from which it's called
    ///
    /// - Parameters:
    ///     - predicate: A `NSPredicate` instance that indicates how the records will be selected,
    ///                  if `nil` is provided, then all records stored will be taken into consideration
    ///     - sortDescriptors: An array of `NSSortDescriptor` instances that define how the records will
    ///                        be sorted, this parameter only works if the `fetchLimit` is not `nil`
    ///     - fetchLimit: The maximum number of event logs to be deleted, all event logs that match
    ///                   the given predicate will be deleted if no value is provided
    ///     - context: The *Managed Object Context* instance under which the operation is performed
    ///
    /// - Returns: The number of `PAEventLogData` instances deleted
    class func deleteRecords(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, context: NSManagedObjectContext) throws -> Int {
        guard !PACoreDataManager.shared.isUsingInMemoryPersistentStore else {
            // Fetch the matching records first before deletion if in-memory persistent store is being used
            do {
                let fetchedRecords = try fetchRecords(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, context: context)
                
                fetchedRecords.forEach {
                    context.delete($0)
                }
                
                return fetchedRecords.count
            } catch let error {
                throw error
            }
        }
        
        let fetchRequest = PAEventLogData.fetchRequest() as NSFetchRequest<NSFetchRequestResult>
        fetchRequest.predicate = predicate

        // If there is no fetch limit specified, then sortDescriptors won't be applied
        // as we're deleting every event log that matches the predicate
        if let fetchLimit = fetchLimit {
            fetchRequest.fetchLimit = fetchLimit
            fetchRequest.sortDescriptors = sortDescriptors
        }
        
        let deleteRequest: NSBatchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        deleteRequest.resultType = .resultTypeCount
        
        do {
            let deleteResult = try context.execute(deleteRequest) as? NSBatchDeleteResult
            return deleteResult?.result as? Int ?? 0
        } catch let error {
            throw error
        }
    }
    
    /// Updates the given property to the given new value for all `PAEventLogData` records stored
    /// in database that match the given predicate and returns the number of records updated.
    /// If the maximum number of records to be updated is specified by `fetchLimit`, then those
    /// records will be sorted by the given sort descriptors first
    ///
    /// This function is performed synchronously within the thread from which it's called
    ///
    /// - Parameters:
    ///     - predicate: A `NSPredicate` instance that indicates how the records will be selected,
    ///                  if `nil` is provided, then all records stored will be taken into consideration
    ///     - sortDescriptors: An array of `NSSortDescriptor` instances that define how the records will
    ///                        be sorted, this parameter only works if the `fetchLimit` is not `nil`
    ///     - fetchLimit: The maximum number of event logs to be updated, all event logs that match
    ///                   the given predicate will be updated if no value is provided
    ///     - context: The *Managed Object Context* instance under which the operation is performed
    ///     - propertyToUpdte: The string representation of the property to be updated
    ///     - newValue: The updated new value for the given property
    ///
    /// - Returns: The number of `PAEventLogData` instances updated
    class func updateRecords(predicate: NSPredicate? = nil, sortDescriptors: [NSSortDescriptor]? = nil, fetchLimit: Int? = nil, context: NSManagedObjectContext, propertyToUpdate: String, newValue: Any?) throws -> Int {
        if fetchLimit != nil || PACoreDataManager.shared.isUsingInMemoryPersistentStore {
            do {
                let fetchedRecords = try fetchRecords(predicate: predicate, sortDescriptors: sortDescriptors, fetchLimit: fetchLimit, context: context)
                
                fetchedRecords.forEach {
                    $0.setValue(newValue, forKey: propertyToUpdate)
                }
                
                return fetchedRecords.count
            } catch let error {
                throw error
            }
        }
        
        // If there is no fetch limit specified and SQLite-backed persistent store is being used,
        // use NSBatchUpdateRequest for maximum efficiency
        let batchUpdateRequest = NSBatchUpdateRequest(entity: PAEventLogData.entity())
        batchUpdateRequest.predicate = predicate
        batchUpdateRequest.propertiesToUpdate = [propertyToUpdate: newValue ?? NSExpression(forConstantValue: nil)]
        batchUpdateRequest.affectedStores = PACoreDataManager.shared.persistentContainer.persistentStoreCoordinator.persistentStores
        batchUpdateRequest.resultType = .updatedObjectsCountResultType
        
        do {
            let updateResult = try context.execute(batchUpdateRequest) as? NSBatchUpdateResult
            return updateResult?.result as? Int ?? 0
        } catch let error {
            throw error
        }
    }
    
}

// MARK: - Property literals

extension PAEventLogData {
    
    static let logTime = "logTime"
    static let isStaged = "isStaged"
    static let logType = "logType"
    static let eventData = "eventData"
    static let eventPriority = "eventPriority"
    static let eventId = "eventId"
    static let sessionId = "sessionId"
    static let customerId = "customerId"
    
    override var debugDescription: String {
        return "session_id = \(sessionId), event_id = \(eventId), log_type = \(logType), event_priority = \(eventPriority), customer_id = \(customerId ?? ""), event_log_time = \(logTime), event_data = \(eventData), is_staged = \(isStaged)"
    }
    
}
