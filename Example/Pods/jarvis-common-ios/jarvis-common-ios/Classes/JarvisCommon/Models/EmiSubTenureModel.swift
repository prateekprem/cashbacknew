//
//  EmiSubTenureModel.swift
//  Jarvis
//
//  Created by Brammanand Soni on 16/08/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

@objc public class EmiSubTenureModel: NSObject {

    @objc public var planId: String?
    @objc public var pgPlanId: String?
    @objc public var emiType: String?
    @objc public var emiLabel: String?
    public var rate: Double?
    public var interval: Double?
    public var emi: Double?
     public var interest: Double?
     public var effectivePrice: Double?
     public var gratifications: [EmiSubGratificationModel] = [EmiSubGratificationModel]()
     public var finalPriceForEMIPG: Double?
    
    // For Selected EMI PLan in EMI Validation api
    @objc public var status:String?
    @objc public var bankName: String?
    @objc public var bankCode: String?
    @objc public var cardType: String?
    @objc public var bankLogoUrl: String?

    @objc  public init(dictionary: [String: Any]) {
        planId = dictionary["planId"] as? String
        pgPlanId = dictionary["pgPlanId"] as? String
        emiType = dictionary["emiType"] as? String
        emiLabel = dictionary["emiLabel"] as? String
        rate = dictionary["rate"] as? Double
        interval = dictionary["interval"] as? Double
        emi = dictionary["emi"] as? Double
        interest = dictionary["interest"] as? Double
        effectivePrice = dictionary["effectivePrice"] as? Double
        finalPriceForEMIPG = dictionary["finalPriceForEMIPG"] as? Double
        
        if let gratsDictArray = dictionary["gratifications"] as? [[String: Any]], !gratsDictArray.isEmpty {
            gratifications.removeAll()
            for gratDict in gratsDictArray {
                let gratModel = EmiSubGratificationModel(gratDict)
                gratifications.append(gratModel)
            }
        }
        bankName = dictionary["bankName"] as? String
        bankCode = dictionary["bankCode"] as? String
        cardType = dictionary["cardType"] as? String
        status = dictionary["status"] as? String
        bankLogoUrl = dictionary["bankLogoUrl"] as? String
    }
    
    @objc public func getDisplayTextForPG() -> String? {
        if let emi = emi, let interval = interval, let rate = rate {
            let emiText = "₹\(JRUtility.getFormattedAmount(numberStr: String(format: "%.2f", CGFloat(emi))))"
            return "EMI of \(emiText) for \(interval.cleanValue) months @\(rate.cleanValue)% p.a."
        }
        return nil
    }
    
    @objc public func getEmiPerMonthText() -> String? {
        var completeStr: String = ""
        if let emi = emi {
            completeStr = "₹\(JRUtility.getFormattedAmount(numberStr: String(format: "%.2f", CGFloat(emi))))"
        }
        
        if let rate = rate {
            completeStr = completeStr + " (\(rate.cleanValue)% p.a.)"
        }
        
        return completeStr
    }
    
    @objc public func getGratificationStringWithAmount() -> String? {
        if gratifications.isEmpty {
            return nil
        }
        
        var completeStr: String = ""
        for (index, grat) in gratifications.enumerated() {
            var str: String = ""
            if let val = grat.value {
                let amount = JRUtility.getFormattedAmount(numberStr: String(format: "%.2f", CGFloat(val)))
                str = "₹\(amount) \(grat.label ?? "")"
            }
            
            completeStr = completeStr + str
            if index != gratifications.count - 1, !completeStr.isEmpty {
                completeStr = completeStr + " + "
            }
        }
        
        if completeStr.isValidString() {
            return completeStr
        }
        
        return nil
    }
    
    @objc public func getGratificationString() -> String? {
        if gratifications.isEmpty {
            return nil
        }
        
        var completeStr: String = ""
        for (index, grat) in gratifications.enumerated() {
            var str: String = ""
            if let label = grat.label {
                str = "\(label)"
            }
            
            completeStr = completeStr + str
            if index != gratifications.count - 1, !completeStr.isEmpty {
                completeStr = completeStr + " + "
            }
        }
        
        if completeStr.isValidString() {
            return completeStr
        }
        
        return nil
    }
    
    public func getTotalDiscount() -> Double? {
        if gratifications.isEmpty {
            return nil
        }
        
        var totalDiscount: Double = 0.0
        for grat in gratifications {
            if let val = grat.value {
                totalDiscount += val
            }
        }
        
        return totalDiscount
    }
}

@objc public class EmiSubGratificationModel: NSObject {
    public var value: Double?
    public var type: String?
    public var label: String?
    
    @objc public init(_ dict: [String: Any]) {
        value = dict["value"] as? Double
        type = dict["type"] as? String
        label = dict["label"] as? String
    }
}
