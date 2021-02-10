//
//  PAEventLogData+CoreDataProperties.swift
//  PaytmAnalytics
//
//  Created by Paytm Labs on 2020-06-23.
//  Copyright © 2020 Paytm Labs. All rights reserved.
//

import Foundation
import CoreData

extension PAEventLogData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<PAEventLogData> {
        return NSFetchRequest<PAEventLogData>(entityName: "PAEventLogData")
    }

    @NSManaged public var customerId: String?
    @NSManaged public var eventData: Data
    @NSManaged public var eventId: Double
    @NSManaged public var logType: Int64
    @NSManaged public var eventPriority: Int64
    @NSManaged public var isStaged: Bool
    @NSManaged public var logTime: Double
    @NSManaged public var sessionId: Int64

}
