//
//  JRFrequentOrderBill.swift
//  Jarvis
//
//  Created by Sandeep Chhabra on 09/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRFrequentOrderBill: NSObject {
    @objc public var dueDate:Date?
    @objc public var billDate:Date?        //For Postpaid only
    @objc public var amount:Double = 0.0
    @objc public var minAmount: NSNumber?
    @objc public var lastPaidAmount: NSNumber?
    @objc public var planName:String! //For Prepaid plans only
    @objc public var displayLabel:String!
    @objc public var orderId: String?
    @objc public var displayLabelColor: String!
    public var isBillDueLocally:Bool?

    @objc public var isBillDue:Bool {
        get{
            if let isBillDueLocally = isBillDueLocally {
                return isBillDueLocally
            }
            
            guard amount > 0 else {
                return false
            }
            
            guard let dueDateRef = dueDate else {
                return true
            }
            
            if let todayDateWithoutTime = Date().removeTimeFromDate(),
                let dueDateWithoutTime = dueDateRef.removeTimeFromDate() {
                let daysSinceToday: Int = dueDateWithoutTime.numberOfDaysSinceDate(todayDateWithoutTime)
                if daysSinceToday + 3 >= 0 {
                    return true
                }
            }
          return false
        }
    }
    
    @objc public required init(withDictionary dict:[AnyHashable:Any]){
        super.init()
        displayLabel = dict.getStringKey("label")
        planName = dict.getStringKey("plan")
        displayLabelColor = dict.getStringKey("bills_label_color").replacingOccurrences(of: "#", with: "0x")

        if let dueDateString = dict.getOptionalStringForKey("due_date"){   //For Postpaid
            dueDate = dueDateString.dateIn(formate: .YYYYmmdd)
        }
        else if let expiryDateString = dict.getOptionalStringForKey("expiry"){  //For Prepaid
            dueDate = expiryDateString.dateIn(formate: .YYYYmmdd)
        }
        
        if let billDateString = dict.getOptionalStringForKey("bill_date") {
            billDate = billDateString.dateIn(formate: .YYYYmmdd)
        }
        
        if let billAmount = dict["amount"] as? NSNumber{
            amount = billAmount.doubleValue
        }

        if let minAmount = dict["min_due_amount"] as? NSNumber{
            self.minAmount = minAmount
        }

        if let billAmount = dict["last_paid_amount"] as? NSNumber{
            lastPaidAmount = billAmount
        }

        if let orderId = dict["order_id"] as? NSNumber {
            self.orderId = "\(orderId)"
        }
    }
}
