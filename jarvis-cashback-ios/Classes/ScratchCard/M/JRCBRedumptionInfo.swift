//
//  JRCBRedumptionInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 26/12/19.
//

import UIKit

class JRCBRedumptionInfo {
    var isFromScratchCard = false
    var rType = JRCBRedumptionType.rUnknown
    var collectibleDisplayType = ""
    
    init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        isFromScratchCard = isScratch
        self.collectibleDisplayType = dict.getStringKey("collectibleDisplayType")
    }
}

class JRCBRedumptionSuperCashGame: JRCBRedumptionInfo {
    var offer_image_url = ""
    var background_image_url = ""
    var unlock_text = ""
    var background_overlay = false
    
    override init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        super.init(dict: dict, isScratch: isScratch)
        self.parse(dict: dict)
    }
    
    func parse(dict: JRCBJSONDictionary) {
        self.offer_image_url = dict.getStringKey("offer_image_url")
        self.background_image_url = dict.getStringKey("background_image_url")
        self.unlock_text = dict.getStringKey("unlock_text")
        self.background_overlay = dict.getBoolForKey("background_overlay")
    }
}

class JRCBRedumptionDeal: JRCBRedumptionInfo {
    var dealId = ""
    var secret = ""
    var deal_text = ""
    var deal_usage_text = ""
    
    var deal_icon = ""
    var deal_valid_from = ""
    var deal_expiry = ""
    var frontend_redemption_type = ""
    var cta = ""
    var ctaDeeplink = ""
    
    // scratch case..
    var amount: Double = 0
    var deal_terms = ""
    var deal_redemption_terms = ""
    var deal_voucher_code     = ""
    var code_type = ""
    
    override init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        super.init(dict: dict, isScratch: isScratch)
        rType = .rDeal
        if isScratch {
            self.parseForScratch(dict: dict)
        } else {
            self.parse(dict: dict)
        }
        
    }
    
    private func parse(dict: JRCBJSONDictionary) {
        self.dealId = dict.getStringKey("id")
        self.secret = dict.stringFor(key: "secret")
        self.deal_text = dict.stringFor(key: "deal_text")
        self.deal_usage_text = dict.stringFor(key: "deal_usage_text")
        
        self.deal_icon = dict.stringFor(key: "deal_icon")
        self.deal_valid_from = dict.stringFor(key: "deal_valid_from")
        self.deal_expiry = dict.stringFor(key: "deal_expiry")
        self.frontend_redemption_type = dict.stringFor(key: "frontend_redemption_type")
        self.cta = dict.stringFor(key: "cta")
        self.ctaDeeplink = dict.stringFor(key: "ctaDeeplink")
    }
        
    private func parseForScratch(dict: JRCBJSONDictionary) {
        self.deal_text = dict.stringFor(key: "deal_text")
        self.deal_terms = dict.stringFor(key: "deal_terms")
        self.deal_icon = dict.stringFor(key: "deal_icon")
        self.deal_expiry = dict.stringFor(key: "deal_expiry")
        self.secret = dict.stringFor(key: "secret")
        self.deal_usage_text = dict.stringFor(key: "deal_usage_text")
        self.deal_valid_from = dict.stringFor(key: "deal_valid_from")
        self.deal_redemption_terms = dict.stringFor(key: "deal_redemption_terms")
        self.deal_voucher_code = dict.stringFor(key: "deal_voucher_code")
        self.code_type = dict.stringFor(key: "code_type")
        self.cta = dict.stringFor(key: "cta")
        self.ctaDeeplink = dict.stringFor(key: "ctaDeeplink")
    }
}

class JRCBRedumptionCrossPromo: JRCBRedumptionInfo {
    var code = ""
    var valid_from =  ""
    var valid_upto = ""
    var frontend_redemption_type = ""
    
    var terms_conditions = ""
    var site_id = 0
    var cross_promo_text = ""
    var cross_promo_usage_text = ""
    
    var cross_promocode_icon = ""
    var cta_deeplink = ""
    var cta = ""
    
    override init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        super.init(dict: dict, isScratch: isScratch)
        rType = .rCrosspromo
        if isScratch {
            self.parseForScratch(dict: dict)
        } else {
            self.parse(dict: dict)
        }
    }
    
    func parse(dict: JRCBJSONDictionary) {
        self.code = dict.stringFor(key: "code")
        self.valid_from = dict.stringFor(key: "valid_from")
        self.valid_upto = dict.stringFor(key: "valid_upto")
        self.frontend_redemption_type = dict.stringFor(key: "frontend_redemption_type")
        
        self.terms_conditions = dict.stringFor(key: "terms_conditions")
        self.site_id = dict.intFor(key: "site_id")
        self.cross_promo_text = dict.stringFor(key: "cross_promo_text")
        self.cross_promo_usage_text = dict.stringFor(key: "cross_promo_usage_text")
        
        self.cross_promocode_icon = dict.stringFor(key: "cross_promocode_icon")
        self.cta_deeplink = dict.stringFor(key: "cta_deeplink")
        self.cta = dict.stringFor(key: "cta")
    }
    
    func parseForScratch(dict: JRCBJSONDictionary) {
        self.code = dict.stringFor(key: "code")
        self.valid_from = dict.stringFor(key: "valid_from")
        self.valid_upto = dict.stringFor(key: "valid_upto")
        
        self.terms_conditions = dict.stringFor(key: "terms_conditions")
        self.site_id = dict.intFor(key: "site_id")
        self.cross_promo_text = dict.stringFor(key: "cross_promo_text")
        self.cross_promo_usage_text = dict.stringFor(key: "cross_promo_usage_text")
        
        self.cross_promocode_icon = dict.stringFor(key: "cross_promocode_icon")
        self.cta_deeplink = dict.stringFor(key: "cta_deeplink")
        self.cta = dict.stringFor(key: "cta")
    }
}

class JRCBRedumptionCashGoldBack: JRCBRedumptionInfo {
    override init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        super.init(dict: dict, isScratch: isScratch)
        rType = .rCashback
    }
}


class JRCBCampaign {
    var campId = ""
    var event = JRCBEventType.accept
    var deeplink_url = ""
    var offer_text_override = ""
    var background_image_url = ""
    
    var new_offers_image_url = ""
    var progress_screen_cta = ""
    
    var tnc = ""
    var campaign = ""
    var isDeeplink = true
    var short_description = ""
    var offer_image_url = ""
    var offer_type_id = ""
    var background_overlay = false
    var first_transaction_cta = ""
    var surprise_text_title = ""
    
    var offer_keyword = ""
    var important_terms = ""
    var surprise_text = ""
    var unlock_text = ""
    var campaign_detail_deeplink = ""
    var validUpto = ""
    var auto_activate = false
    var cardConfig: JRCBScratchConfigEnum = JRCBScratchConfigEnum.getPlaceholderConfig()
    var show_game_progress = true
      var deeplink_text : String?
    
    init(dict: JRCBJSONDictionary) {
        self.campId = dict.getStringKey("id")
        
        if let eventType =  JRCBEventType(rawValue: dict.stringFor(key: "event")) {
            self.event = eventType
        }
        self.deeplink_url = dict.stringFor(key: "deeplink_url")
        self.offer_text_override = dict.stringFor(key: "offer_text_override")
        self.background_image_url = dict.stringFor(key: "background_image_url")
        
        self.new_offers_image_url = dict.stringFor(key: "new_offers_image_url")
        self.progress_screen_cta = dict.stringFor(key: "progress_screen_cta")
        
        self.tnc = dict.stringFor(key: "tnc")
        self.campaign = dict.stringFor(key: "campaign")
        
        self.isDeeplink = dict.booleanFor(key: "isDeeplink")
        self.short_description = dict.stringFor(key: "short_description")
        self.offer_type_id = dict.stringFor(key: "offer_type_id")
        self.background_overlay = dict.booleanFor(key: "background_overlay")
        
        self.first_transaction_cta = dict.stringFor(key: "first_transaction_cta")
        self.surprise_text_title = dict.stringFor(key: "surprise_text_title")
        
        self.offer_keyword = dict.stringFor(key: "offer_keyword").replacingOccurrences(of: "%", with: "").capitalizingFirstLetter()
        self.important_terms = dict.stringFor(key: "important_terms")
        self.surprise_text = dict.stringFor(key: "surprise_text")
        self.unlock_text = dict.stringFor(key: "unlock_text").replacingOccurrences(of: "%s", with: "s")
        self.campaign_detail_deeplink = dict.stringFor(key: "campaign_detail_deeplink")
        self.validUpto = dict.stringFor(key: "valid_upto")
        self.auto_activate = dict.booleanFor(key: "auto_activate")
        self.show_game_progress = dict.getOptionalBoolKey("show_game_progress") ?? true
        self.deeplink_text = dict.getOptionalDictionaryKey("referral_data")?.getOptionalStringForKey("deeplink_text")
     }
    
    func getExpiryDate() -> String {
        if !self.validUpto.isEmpty {
            let expiryDate = self.validUpto.getFormattedDateString("dd MMM yyyy")
            if !expiryDate.isEmpty {
                return JRCBConstants.Common.kValidTill + expiryDate
            }
        }
        return ""
    }
}
