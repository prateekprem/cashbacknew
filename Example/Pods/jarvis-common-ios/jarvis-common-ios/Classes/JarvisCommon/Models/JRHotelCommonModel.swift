//
//  JRHotelCommonModel.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 30/05/19.
//


// MARK: - JRHotelPromoCode
@objc public class JRHotelPromoCode: NSObject {
    @objc public let promoStatus: String?
    @objc public let promoText: String?
    
    @objc public let promoCode: String?
    @objc public let paytmCashBack: Double
    
    @objc public init(responseDictionary: [String: Any]) {
        promoStatus = responseDictionary["promostatus"] as? String
        promoText = responseDictionary["promotext"] as? String
        promoCode = responseDictionary["promocode"] as? String
        paytmCashBack = responseDictionary.getDoubleKey("paytm_cashback")
        super.init()
    }
}

