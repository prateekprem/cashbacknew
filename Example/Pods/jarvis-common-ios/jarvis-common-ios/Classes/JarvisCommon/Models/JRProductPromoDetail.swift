//
//  JRProductPromoDetail.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 22/12/20.
//

import UIKit

@objcMembers open class JRProductPromoDetail: NSObject {
    public var promoCode: String?
    public var promoOfferText: String?
    public var promoTermsTitle: String?
    public var promoTerms: String?
    public var promoValidUpto: String?
    public var promoText: String?
    public var promoUpdatedAt: NSNumber?
    public var effectivePrice: NSNumber?
    public var savings: NSNumber?
    public var cellHeight: CGFloat = 0.0
    public var paymentFilters: [AnyHashable : Any]?
    public var promoOfferIcon: String?
    //PromoTerms with html tag
    public var htmlPromoTerms: String?
    public var isPromoOfferSelected = false
    //This is a convenience for verticals using this model as view model.
    public var verticalContext: Any?
    
    public init(dictionary dict: [AnyHashable : Any]) {
        super.init()
        self.setWithDictionary(dict)
    }

    public convenience override init() {
        self.init(dictionary: [:])
    }
    
    public convenience init(promoCode: String?) {
        self.init(dictionary: [:])
        self.promoCode = promoCode
    }

    public convenience init(promoDetails promoCode: JRHotelPromoCode) {
        self.init(dictionary: [:])
        self.promoCode = promoCode.promoCode
        self.savings = NSNumber(floatLiteral: promoCode.paytmCashBack)
    }

    public convenience init(promoCode: String?, savings: NSNumber?) {
        self.init(dictionary: [:])
        self.promoCode = promoCode
        self.savings = savings
    }

    public convenience init(gridOfferDictionary dict: [AnyHashable : Any]) {
        self.init(dictionary: [:])
        self.promoCode = dict["code"] as? String
        self.savings = dict["code"] as? NSNumber
        self.promoOfferText = ((dict["cashbackText"] as? String) as NSString?)?.trimWhitespace()
    }
    
    private func setWithDictionary(_ dict: [AnyHashable : Any]) {
        let dict = dict as NSDictionary
        promoCode = dict["code"] as? String
        promoOfferText = (dict.string(forKey: "offerText") as NSString).trimWhitespace()
        promoTermsTitle = (dict.string(forKey: "terms_title") as NSString).trimWhitespace()
        promoTerms = (dict.string(forKey: "terms") as NSString).removeHTMLTag()
        promoValidUpto = dict["valid_upto"] as? String
        promoUpdatedAt = dict["updated_at"] as? NSNumber
        isPromoOfferSelected = false
        effectivePrice = dict["effective_price"] as? NSNumber
        savings = (dict["savings"] as? NSNumber) ?? (dict["totalSaving"] as? NSNumber)
        promoText = dict.string(forKey: "promo_text")
        htmlPromoTerms = dict.string(forKey: "terms")
        paymentFilters = dict["paymentFilters"] as? [AnyHashable: Any]
        if let savings = self.savings, savings.intValue == 0, let promoCode = promoCode {
            promoText = "\(promoCode) Applied!"
        }
        
        let offerDict = dict["offer"] as? [AnyHashable: Any]
        promoOfferIcon = offerDict?["icon"] as? String
    }
}
