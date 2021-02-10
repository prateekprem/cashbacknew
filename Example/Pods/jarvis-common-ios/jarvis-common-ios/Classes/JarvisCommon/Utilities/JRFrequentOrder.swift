
//
//  JRFrequentOrder.swift
//  Jarvis
//
//  Created by Gulshan Kumar on 21/12/20.
//  Copyright © 2020 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

@objcMembers
public class JRFrequentOrder: NSObject {
    
    public var purchasedDate: String?
    public var productType: String = ""
    public var productSubType: String = ""
    public var productLabel: String?
    public var svpPrice: String?
    public var rechargeNumber: String?
    public var rechargeAmount: String?
    public var rechargeNewAmount: String?
    public var configuration: [AnyHashable : Any]?
    public var rawAttributes: [String : Any]?
    public var sourceObject: [String : Any]?
    public var destinationObject: [String : Any]?
    public var service: String?
    public var circle: String?
    public var bill: JRFrequentOrderBill?
    public var cta: [String : Any]?
    // TODO: What is the difference
    public var payType: String?
    public var payTypeLabel: String?
    public var categoryID: String = ""
    public var productID: String?
    public var rechargeOperator: String?
    public var favLabel: String?
    public var rechargeNumber2: String?
    public var rechargeNumber3: String?
    public var rechargeNumber4: String?
    public var isFastForwardSelected = false
    public var frequency: String?
    public var updatedAt: String?
    public var operatorLogourlString: String? // ope_logo_url
    public var passengers: String?
    public var noOfPassengerMessage: String?
    public var billAmountWithDueDate: String?
    public var isEligibleForAutomaticBillPayment = false
    public var shouldShowAutomaticAlert = false
    public var operatorLabel: String?
    public var serviceDisplayLabel: String?
    public var operatorDisplayLabel: String?
    public var payTypeDisplayLabel: String?
    public var cardNetwork: String?
    public var bankCode: String?
    public var creditCardId: String?
    // UI Related
    public var isSelected = false
    public var isSchedulable = false
    public var attributes: [AnyHashable : Any]?
    public var isFromContactList = false
    public var isDeletable = false
    public var billReminder = false
    public var remindable: NSNumber = NSNumber(value: 0)
    public var tokenType: NSNumber?
    public var displayValues: [AnyHashable]?
    // For setting automatic recharge
    public var subscriptionStartDate: Date?
    public var rechargeFrequency = 0
    public var subscriptionId: String?
    
    
    public init(_ dict: [String : Any]?=nil) {
        super.init()
        billReminder = true
        isDeletable = true
        
        if dict != nil {
            setWithDict(dict: dict as NSDictionary?)
        }
    }
        
    public func setWithDict(dict: NSDictionary?) {
        
        self.configuration = dict?["configuration"] as? [AnyHashable: Any]
        self.rawAttributes = dict?.value(forKeyPath: "product.attributes") as? [String: Any]
        self.favLabel = dict?["favLabel"] as? String
        self.rechargeAmount = "\(self.configuration?["price"] ?? "")"
        self.rechargeNewAmount = "\(self.configuration?["price_new"] ?? "")"
        self.svpPrice = "\(self.configuration?["price"] ?? "")"
        if let billsArrayObj: [Any] = dict?["bills"] as? [Any], !billsArrayObj.isEmpty {
            if let dicttionary = billsArrayObj.first as? [AnyHashable: Any] {
                self.bill = JRFrequentOrderBill(withDictionary: dicttionary)
            }
        }
        
        self.cta = dict?["cta"] as? [String: Any]
        
        if let billReminderLocal: NSNumber = dict?["BillReminder"] as? NSNumber {
            var value: Bool = true
            if billReminderLocal.intValue == 0 {
                value = false
            }
            self.billReminder = value
        }
        
        if let remindableLocal:Int = dict?.value(forKeyPath: "product.attributes.remindable") as? Int {
            self.remindable = NSNumber(value: remindableLocal)
        }
        
        
        self.rechargeNumber = self.configuration?["recharge_number"] as? String
        self.rechargeNumber2 = self.configuration?["recharge_number_2"] as? String
        self.rechargeNumber3 = self.configuration?["recharge_number_3"] as? String
        self.rechargeNumber3 = self.configuration?["recharge_number_4"] as? String
        self.service = dict?.value(forKeyPath: "product.attributes.service") as? String
        self.serviceDisplayLabel = dict?.value(forKeyPath: "product.attributes.service_display_label") as? String
        self.circle = dict?.value(forKeyPath: "product.attributes.circle") as? String
        
        self.payType = dict?.value(forKeyPath: "product.attributes.paytype") as? String
        self.payTypeLabel = dict?.value(forKeyPath: "product.attributes.paytype_label") as? String
        self.payTypeDisplayLabel = dict?.value(forKeyPath: "product.attributes.paytype_display_label") as? String
        self.updatedAt = self.convertUpdatedAtStringToDate(updatedAtString: dict?["updated_at"] as? String)
        
        self.productID = dict?["product_id"] as? String
        if self.productID == nil {
            let pid = dict?["product_id"]
            if let pidInt = pid as? Int {
                self.productID = String(pidInt)
            } else if let pidNum = pid as? NSNumber {
                self.productID = pidNum.stringValue
            }
        }
        
        self.rechargeOperator = dict?.value(forKeyPath: "product.attributes.operator") as? String
        
        if let freq = dict?["frequency"] as? String {
            self.frequency = freq
        }
        
        var vals: NSMutableDictionary = NSMutableDictionary()
        if let attrs = dict?.value(forKeyPath: "product.attributes") as? NSMutableDictionary {
            vals = attrs
        }
        
        if let pid = self.productID {
            vals["product_id"] = pid
        }
        
        if let conf = self.configuration, !conf.isEmpty {
            vals.addEntries(from: conf)
        }
        
        if let brand:String = dict?.value(forKeyPath: "product.brand") as? String , !brand.isEmpty {
            vals["brand"] = brand
        }
        
        self.attributes = vals as? [AnyHashable : Any]
        self.purchasedDate = dict?["created_desc"] as? String
        
        if let type = dict?["product_type"] as? String {
            self.productType = type
        }
        
        self.productLabel = dict?["product_label"] as? String
        self.sourceObject = dict?["source"] as? [String : Any]
        self.destinationObject = dict?["destination"] as? [String : Any]
        
        if let type = dict?["product_sub_type"] as? String {
            self.productSubType = type
        }
        
        if let sourceDisplayName = self.sourceObject?["display_name"] as? String , let destinationDisplayName = self.destinationObject?["display_name"] as? String {
            self.rechargeNumber = String(format:"%@ to %@", sourceDisplayName, destinationDisplayName)
        }
        
        let passengersValue = dict?["passengers"]
        if let value = passengersValue as? Int {
            self.passengers = String(value)
        } else if let value = passengersValue as? NSNumber {
            self.passengers = value.stringValue
        }
        
        self.tokenType = dict?["code"] as? NSNumber
        
        if self.tokenType == nil {
            if let intValue:Int = dict?["code"] as? Int {
                self.tokenType = NSNumber(integerLiteral: intValue)
            }
        }
        
        if self.passengers != nil && !(self.passengers == "0") {
            self.noOfPassengerMessage = String(format:"%@ Metro QR Tickets", self.passengers!)
        }
        
        let operatorLogourlString: String? = dict?["ope_logo_url"] as? String
        if let url = operatorLogourlString {
            self.operatorLogourlString = url
        }
        
        let operatorUrl = JRRemoteConfigManager.stringFor(key: "operatorImageUrl")
        if operatorLogourlString == nil && operatorUrl != nil && self.rechargeOperator != nil {
            self.operatorLogourlString = String(format:"%@/%@.png", operatorUrl!, self.rechargeOperator!)
            if let str = self.operatorLogourlString?.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                self.operatorLogourlString = str
            }
        }
        
        var isSchedulable: Bool = false
        if let schedulable:Int = dict?.value(forKeyPath: "product.schedulable") as? Int, schedulable > 0 {
            isSchedulable = true
        }
        self.isSchedulable = isSchedulable
        
        var cID : String = ""
        if let categoryID:Int = dict?.value(forKeyPath: "product.category_id") as? Int, categoryID > 0 {
            cID = String("categoryID")
        }
        self.categoryID = cID
        self.operatorLabel = dict?.value(forKeyPath: "product.attributes.operator_label") as? String
        self.operatorDisplayLabel = dict?.value(forKeyPath: "product.attributes.operator_display_label") as? String
        self.cardNetwork = dict?.value(forKeyPath: "product.attributes.card_network") as? String
        self.bankCode = dict?.value(forKeyPath: "product.attributes.bank_code")  as? String
        self.creditCardId = dict?.value(forKeyPath: "operatorData.creditCardId") as? String
        
        if let dictOperData: [String: Any] = dict?["operatorRecentData"] as? [String: Any] {
            self.displayValues = dictOperData["displayValues"] as? [AnyHashable]
        }
        
    }
    
    public func convertUpdatedAtStringToDate(updatedAtString: String?) -> String {
        var formattedUIString: String = ""
        if let updatedAt = updatedAtString {
            if let updatedDate = Date.dateFromServerString(updatedAt) {
                if let string = Date.date(updatedDate, inFormat:"dd LLLL yyyy") {
                    formattedUIString = string
                }
            }
        }
        return formattedUIString
    }
}
