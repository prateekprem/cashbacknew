//
//  JRCONewOfferModel.swift
//  SampleCashback
//
//  Created by Ankit Agarwal on 04/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

public class JRCONewOfferModel: NSObject,GenericProtocol {
    public private(set) var id : String = "" // campaign_id
    public private(set) var title:String = ""
    public private(set) var offer_text_override:String = ""
    
    var valid_upto: String = ""
    var campaign: String = ""
    var descript:String = ""
    var tnc: String = ""
    var initial_amount:String = "" // Initial amount to be given, if user does not accept offer
    var bonus_amount:String = ""  // Amount that would be won on clearing stage
    var deeplink_url:String = ""
    var short_description:String =  ""
    var stage_txn_count:String = ""   // Required transaction count for completing offer
    var game_expiry:String = "" // Signifies game expire time i.e. time to complete all transactions in minutes
    var offer_type_id:String = ""
    var offer_type_text:String = ""
    var offer_image_url:String = ""
    var promocode:String = ""
    var firstTransactionCTA: String = ""
    var offer_keyword:String = ""
    var progress_screen_cta:String = ""
    var isDeeplink:Bool = false
    var new_offers_image_url : String = ""
    var background_image_url : String = ""
    var off_us_transaction_text : String = ""
    var offer_tag: String = ""
    var important_terms: String = ""
    var frontend_redemption_type: String = ""
    var max_cashback_value_initial_stage : Int = 0
    var max_cashback_value_bonus_stage : Int = 0
    var redemption_type_flat_percent : String = ""
    var percent_redemption : Int = 0
    var multi_stage_campaign : Bool = false
    var isBackgroundOverlay: Bool = false
    
    var surprise_text : String = ""
    var surprise_text_title : String = ""
    var multi_stage_icon : String = ""
    var total_offer_value : String = ""
    var total_cashback_earned : String = ""
    var pending_offer_value : String = ""
    var offer_summary : String = ""
    var deeplink_text : String?
    
    //Not in API
    var tncModel : JRCOTNCModel = JRCOTNCModel(dict: [:])
    public init(dict: [String:Any]) {
        id = dict.getStringKey("id")
        valid_upto = dict.getStringKey("valid_upto")
        campaign = dict.getStringKey("campaign")
        descript = dict.getStringKey("description")
        tnc = dict.getStringKey("tnc")
        initial_amount = dict.getStringKey("initial_amount")
        bonus_amount = dict.getStringKey("bonus_amount")
        title = dict.getStringKey("title")
        deeplink_url = dict.getStringKey("deeplink_url")
        short_description = dict.getStringKey("short_description")
        stage_txn_count = dict.getStringKey("stage_txn_count")
        game_expiry = dict.getStringKey("game_expiry")
        offer_type_id = dict.getStringKey("offer_type_id")
        offer_type_text = dict.getStringKey("offer_type_text")
        offer_image_url = dict.getStringKey("offer_image_url")
        offer_text_override = dict.getStringKey("offer_text_override")
        promocode = dict.getStringKey("promocode")
        firstTransactionCTA = dict.getStringKey("first_transaction_cta")
        offer_keyword = dict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: "")
        progress_screen_cta = dict.getStringKey("progress_screen_cta")
        isDeeplink = dict.getBoolForKey("is_offus_transaction")
        new_offers_image_url = dict.getStringKey("new_offers_image_url")
        important_terms = dict.getStringKey("important_terms")
        max_cashback_value_bonus_stage = dict.getIntKey("max_cashback_value_bonus_stage")
        max_cashback_value_initial_stage = dict.getIntKey("max_cashback_value_initial_stage")
        percent_redemption = dict.getIntKey("percent_redemption")
        redemption_type_flat_percent = dict.getStringKey("redemption_type_flat_percent")
        let baseBackgroundImageUrl = dict.getStringKey("background_image_url")
        if (baseBackgroundImageUrl.isEmpty){
            background_image_url = "https://s3-ap-southeast-1.amazonaws.com/assets.paytm.com/promotion/Rituraj/Backgrounds/background2.png?isScalingRequired=false"
        }else{
            let params = baseBackgroundImageUrl.contains("?") ? "&" : "?"
            background_image_url = "\(baseBackgroundImageUrl)\(params)isScalingRequired=false"
        }
        off_us_transaction_text = dict.getStringKey("off_us_transaction_text")
        offer_tag = dict.getStringKey("offer_tag")
        frontend_redemption_type = dict.getStringKey("frontend_redemption_type")
        multi_stage_campaign = dict.getBoolForKey("multi_stage_campaign")
        total_offer_value = dict.getStringKey("total_offer_value")
        total_cashback_earned = dict.getStringKey("total_cashback_earned")
        pending_offer_value = dict.getStringKey("pending_offer_value")
        offer_summary = dict.getStringKey("offer_summary")
        surprise_text = dict.getStringKey("surprise_text")
        surprise_text_title = dict.getStringKey("surprise_text_title")
        multi_stage_icon = dict.getStringKey("multi_stage_icon")
        isBackgroundOverlay = dict.getBoolForKey("background_overlay")
        self.deeplink_text = dict.getOptionalDictionaryKey("referral_data")?.getOptionalStringForKey("deeplink_text")
    }
}



public class JRCONewOfferSModel {
    var page_offset:String = ""
    var is_next:Bool = false
    public var campaigns:[JRCONewOfferModel] = []
    
    public init(dict:[String:Any]) {
        if let offersArray = dict["campaigns"] as? [Any] {
        for offer in offersArray {
            if let cashbackOffer = offer as? [String:Any]{
                let offerObj = JRCONewOfferModel(dict:cashbackOffer)
                campaigns.append(offerObj)
            }
        }
        }
        is_next = dict.booleanFor(key:"is_next")
        page_offset = dict.stringFor(key:"page_offset")
    }
}
