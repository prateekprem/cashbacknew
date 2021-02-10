//
//  PACoreDataManager.swift
//
//
//  Created by Abhishek Sharma on 23/07/18.
//  Copyright © 2018 Abhishek Sharma. All rights reserved.
//

import UIKit
import CoreData

class PACoreDataManager {
    
    static let shared = PACoreDataManager()
    
    private let dataModelName = "PaytmAnalytics"
    
    // MARK: - CoreData stack

    /// Returns the singleton instance of a container that manages everything in our
    /// CoreData stack. It's a lazily initialized static property by default and thread
    /// safe.
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: dataModelName, managedObjectModel: managedObjectModel)
        container.loadPersistentStores { (_, error) in
            if let error = error {
                fatalError("Failed to load persistent store: \(error.localizedDescription)")
            }
        }
        return container
    }()
    
    /// Returns the managed object model for the application. This property is not optional.
    /// It is a fatal error for the application not to be able to find and load its model.
    private lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle(for: PAHelper.self).url(forResource: dataModelName, withExtension: "momd")!
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    private lazy var privateContext: NSManagedObjectContext = {
        return persistentContainer.newBackgroundContext()
    }()

    // MARK: CoreData task execution
    
    /// Performs the CoreData-related operations synchronously within the thread from
    /// which this function is called
    ///
    /// - Parameters:
    ///   - performBlock: A block instance to be executed that contains CoreData-related
    ///                   operations
    func performSyncTask(performBlock: (NSManagedObjectContext) -> ()) {
        // Grab the corresponding managed object context based on the thread from which
        // this function is called
        if Thread.isMainThread {
            performTaskOnMainThread(performBlock: performBlock)
        } else {
            performTaskOnBackgroundThread(performBlock: performBlock)
        }
    }
    
    /// Performs the CoreData-related operations in a background operation queue
    ///
    /// - Parameters:
    ///   - performBlock: A block instance to be executed that contains CoreData-related
    ///                   operations
    ///   - completion: A block instance to be executed when the operations complete
    func performBackgroundTask(performBlock: @escaping (NSManagedObjectContext) -> (), completion: PABoolVoidCompletion?) -> Void {
        var success = true
        
        let moc = privateContext
        // Call performAndWait(_:) to execute the specified CoreData-related operations synchronously
        // within the current background thread. After the operations submitted have finish, schedule
        // the completion block back to the caller's queue
        moc.performAndWait {
            performBlock(moc)
            
            guard moc.hasChanges else {
                return
            }
            
            do {
                try moc.save()
            } catch let error as NSError {
                success = false
                PALogger.log(message: "[Signal DB] Error saving changes to background thread's moc: error =\(error)", andMessageType: .fail)
            }
        }
        
        completion?(success)
    }
    
    // MARK: - Private methods
    
    private func performTaskOnMainThread(performBlock: (NSManagedObjectContext) -> ()) {
        let moc = persistentContainer.viewContext
        // Call performAndWait(_:) to execute the specified CoreData-related operations synchronously
        // on the main thread
        moc.performAndWait {
            performBlock(moc)
            
            guard moc.hasChanges else { return }
            
            do {
                try moc.save()
            } catch let error as NSError {
                PALogger.log(message: "[Signal DB] Error saving changes to main thread's moc: \(error)", andMessageType: .fail)
            }
        }
    }
    
    private func performTaskOnBackgroundThread(performBlock: (NSManagedObjectContext) -> ()) {
        let moc = privateContext
        let dispatchGroup = DispatchGroup()
        dispatchGroup.enter()
        // Call performAndWait(_:) to execute the specified CoreData-related operations synchronously
        // within the same thread where the private managed object context is created. Dispatch group
        // is used here to ensure the exectution flow returns to the calling thread once the CoreData
        // operation is finished.
        moc.performAndWait {
            performBlock(moc)
            
            guard moc.hasChanges else {
                dispatchGroup.leave()
                return
            }
            
            do {
                try moc.save()
                dispatchGroup.leave()
            } catch let error as NSError {
                PALogger.log(message: "[Signal DB] Error saving changes to background thread's moc: \(error)", andMessageType: .fail)
                dispatchGroup.leave()
            }
        }
        
        dispatchGroup.wait()
        
        PALogger.log(message: "[Signal DB] Synchrous CoreData operation is finished on the background thread", andMessageType: .success)
    }
    
    /// Checks if the type of the current persistent store is in-memory
    ///
    /// The property returns `true` if unit test is running, otherwise
    /// `false` is returned
    var isUsingInMemoryPersistentStore: Bool {   //unit test only
        if let persistentStore = persistentContainer.persistentStoreCoordinator.persistentStores.last, persistentStore.type == NSInMemoryStoreType {
            return true
        }
        return false
    }
    
}
