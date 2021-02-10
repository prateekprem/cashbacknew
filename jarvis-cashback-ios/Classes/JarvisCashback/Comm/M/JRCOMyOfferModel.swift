//
//  JRCOMyOfferModel.swift
//  SampleCashback
//
//  Created by Ankit Agarwal on 04/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

protocol GenericProtocol {
    var tnc: String {get}
    var short_description:String {get}
    var id : String {get}
}


enum RedemptionType : String {
    case cashback = "cashback"
    case goldback = "goldback"
    case deal = "deal"
    case crosspromo = "crosspromo"
    case coins = "coins"
}

enum RedemptionStatus : String {
    case redeemRequested = "REDEEM_REQUESTED"
    case redeemed = "REDEEMED"
}

public class JRCOMyOfferModel: NSObject, GenericProtocol {
  
    enum OfferRedemptionStatus : String{
        case redeem_requested = "REDEEM_REQUESTED"
        case no_redemption_required = "NO_REDEMPTION_REQUIRED"
        case redeemed = "REDEEMED"
        case none = ""
    }
    
    enum BonusType : String{
        case percent = "percentage"
        case flat = "flat"
    }
    var offerTag : String? = ""
    var id: String = "" // Signifies: Game id
    var stage_txn_count: Int = 0   // Required transaction count for completing offer
    var total_txn_count:Int =  0   // Current number of transactions user has done
    var initial_amount : Int = 0 // Initial amount to be given, if user does not accept offer
    var offer_expiry_amount:Int = 0
    var game_expiry_amount:Int = 0
    var bonus_amount :Int = 0
    var redemption_status : OfferRedemptionStatus = .none // Other values REDEEM_REQUESTED/NO_REDEMPTION_REQUIRED/REDEEMED
    var status : OfferStatus = .none
    var game_expiry:String = "" // Signifies game expire time i.e. time to complete all transactions
    var offer_expiry:String = "" //Signifies offer expire time i.e. time to claim or participate in offer
    var opt_out_time: String = "" //Signifies quit offer time
    var promocode:String = ""
    var campaign_id: Int = 0
    var server_timestamp: String = ""
    var max_cashback_value_bonus_stage:Int = 0
    var max_cashback_value_initial_stage:Int = 0
    var percent_redemption:Int = 0
    var redemption_type_flat_percent : BonusType = .flat
    var redemption_type : RedemptionType = .cashback
    var frontend_redemption_type: String = ""
    var redemption_text: String = ""
   public var offer_progress_construct : String = ""
    var initialized_transaction_construct : String = ""
    var Claim_CTA : String = ""
    var post_transaction_initialized_title : String = ""
    var post_transaction_initialized : String = ""
    var post_transaction_progress_status : String = ""
    var post_transaction_collapsed_completed : String = ""
    var post_transaction_collapsed_progress :String = ""
    var post_transaction_collapsed_initialized:String = ""
    var post_transaction_completed_status : String = ""
    var redemption_type_icon : String = ""
    var offer_status_text: String = ""
    //Inside Info
    var offer_reset_count: Int = 0
    var cashback_delay : String = ""
    var offerEarnedTime: String = ""
    var offer_expiry_reason: String = ""
    var game_expiry_reason: String = ""
    var cancelled_txn_count: Int = 0
    //Inside Info Inside Campaign
    var title:String = ""
    var descript:String = ""
    var deeplink_url:String = ""
    var short_description:String =  ""
    var offer_type_id = 0
    var offer_type_text:String = ""
    var offer_image_url:String = ""
    var offer_text_override:String = ""
    var background_image_url : String = ""
    var off_us_transaction_text : String = ""
    var new_offers_image_url : String = ""
    var tnc: String = ""
    var progress_screen_cta:String = ""
    var isDeeplink:Bool = false
    var offer_keyword:String = ""
    var important_terms: String = ""
    var transactions : [JRTransactionModel] = []
    var isBackgroundOverlay: Bool = false
    
    var surprise_text : String = ""
    var surprise_text_title : String = ""
    var multi_stage_icon : String = ""
    var multi_stage_campaign : Bool = false
    var total_offer_value : String = ""
    var total_cashback_earned : String = ""
    var pending_offer_value : String = ""
    var offer_summary : String = ""
    
    //Inside Info Inside Campaign Inside Info
    var superCashStages : [JRSuperCashStageModel] = []
    var firstTransactionCta: String = ""

    // Local Handling Fields
    var numberOfTransactionsLeft:Int = 0
    var offer_keyword_transcationLeft:String = ""
    var offer_keyword_total_txn_count: String = ""
    var offer_keyword_stage_txn_count : String = ""
    var tncModel : JRCOTNCModel = JRCOTNCModel(dict: [:])
    var lastSuccesTxn : JRTransactionModel = JRTransactionModel(dict:[:])

    override init() {}
    
    init(dict: [String:Any]) {
        offerTag = dict.getOptionalStringForKey("offer_tag")
        id = dict.getStringKey("offer_id")
        stage_txn_count = dict.getIntKey("stage_txn_count")
        total_txn_count = dict.getIntKey("total_txn_count")
        initial_amount = dict.getIntKey("initial_amount")
        bonus_amount = dict.getIntKey("bonus_amount")
        offer_expiry_amount = dict.getIntKey("offer_expiry_amount")
        game_expiry_amount = dict.getIntKey("game_expiry_amount")
        redemption_status = OfferRedemptionStatus(rawValue: dict.getStringKey("redemption_status")) ?? .none
        status = OfferStatus(rawValue: dict.getStringKey("status")) ?? .none
        offer_expiry = dict.getStringKey("offer_expiry")
        game_expiry = dict.getStringKey("game_expiry")
        opt_out_time = dict.getStringKey("opt_out_time")
        promocode = dict.getStringKey("promocode")
        campaign_id = dict.getIntKey("campaign_id")
        server_timestamp = dict.getStringKey("server_timestamp")
        redemption_text = dict.getStringKey("redemption_text")
        max_cashback_value_bonus_stage = dict.getIntKey("max_cashback_value_bonus_stage")
        max_cashback_value_initial_stage = dict.getIntKey("max_cashback_value_initial_stage")
        percent_redemption = dict.getIntKey("percent_redemption")
        redemption_type_flat_percent = BonusType(rawValue: dict.getStringKey("redemption_type_flat_percent")) ?? .flat
        frontend_redemption_type = dict.getStringKey("frontend_redemption_type")
        redemption_type  = RedemptionType(rawValue:  dict.getStringKey("redemption_type")) ?? .cashback
        offer_progress_construct = dict.getStringKey("offer_progress_construct")
        initialized_transaction_construct = dict.getStringKey("initialized_transaction_construct")
        Claim_CTA = dict.getStringKey("Claim_CTA")
        post_transaction_initialized_title = dict.getStringKey("post_transaction_initialized_title")
        post_transaction_initialized = dict.getStringKey("post_transaction_initialized")
        post_transaction_completed_status = dict.getStringKey("post_transaction_completed_status")
        post_transaction_progress_status = dict.getStringKey("post_transaction_progress_status")
        post_transaction_collapsed_completed = dict.getStringKey("post_transaction_collapsed_completed")
        post_transaction_collapsed_progress = dict.getStringKey("post_transaction_collapsed_progress")
        post_transaction_collapsed_initialized = dict.getStringKey("post_transaction_collapsed_initialized")
        redemption_type_icon = dict.getStringKey("redemption_type_icon")
        offer_status_text = dict.getStringKey("offer_status_text")
    //Inside info
        let infoDict = dict.getDictionaryKey("info")
        offer_reset_count = infoDict.getIntKey("offer_reset_count")
        cashback_delay = infoDict.getStringKey("cashback_delay")
        offerEarnedTime = infoDict.getStringKey("cb_earned_at")
        offer_expiry_reason = infoDict.getStringKey("offer_expiry_reason")
        game_expiry_reason = infoDict.getStringKey("game_expiry_reason")
        cancelled_txn_count = infoDict.getIntKey("cancelled_txn_count")
        
    //Inside Info Inside Campaign
        let campaignDict:[String:Any] = infoDict.getDictionaryKey("campaign")
        title = campaignDict.getStringKey("title")
        descript = campaignDict.getStringKey("description")
        deeplink_url = campaignDict.getStringKey("deeplink_url")
        short_description = campaignDict.getStringKey("short_description")
        offer_type_id = campaignDict.getIntKey("offer_type_id")
        offer_type_text = campaignDict.getStringKey("offer_type_text")
        offer_image_url = campaignDict.getStringKey("offer_image_url")
        offer_text_override = campaignDict.getStringKey("offer_text_override")
        let baseBackgroundImageUrl = campaignDict.getStringKey("background_image_url")
        if (baseBackgroundImageUrl.isEmpty){
            background_image_url = "https://s3-ap-southeast-1.amazonaws.com/assets.paytm.com/promotion/Rituraj/Backgrounds/background2.png?isScalingRequired=false"
        }else{
            let params = baseBackgroundImageUrl.contains("?") ? "&" : "?"
            background_image_url = "\(baseBackgroundImageUrl)\(params)isScalingRequired=false"
        }
        off_us_transaction_text = campaignDict.getStringKey("off_us_transaction_text")
        new_offers_image_url = campaignDict.getStringKey("new_offers_image_url")
        tnc = campaignDict.getStringKey("tnc")
        progress_screen_cta = campaignDict.getStringKey("progress_screen_cta")
        isDeeplink = campaignDict.getBoolForKey("is_offus_transaction")
        offer_keyword = campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: "")
        important_terms = campaignDict.getStringKey("important_terms")
        isBackgroundOverlay = campaignDict.getBoolForKey("background_overlay")
        
        surprise_text = campaignDict.getStringKey("surprise_text")
        surprise_text_title = campaignDict.getStringKey("surprise_text_title")
        multi_stage_icon = campaignDict.getStringKey("multi_stage_icon")
        multi_stage_campaign = campaignDict.getBoolForKey("multi_stage_campaign")
        total_offer_value = campaignDict.getStringKey("total_offer_value")
        total_cashback_earned = campaignDict.getStringKey("total_cashback_earned")
        pending_offer_value = campaignDict.getStringKey("pending_offer_value")
        offer_summary = campaignDict.getStringKey("offer_summary")
    //Inside Info Transactions
        
        if let transactionsArray = infoDict.getArrayKey("transactions") as? [[String : Any]]{
            for transaction in transactionsArray{
                let tr:JRTransactionModel = JRTransactionModel(dict: transaction)
                if tr.status == JRTransactionModel.TransactionStatus.success {
                    lastSuccesTxn = tr
                }
                transactions.append(tr)
            }
        }
    //Inside Info Inside Campaign Inside Info
        let campaignDictInfo = campaignDict.getDictionaryKey("info")
        firstTransactionCta = campaignDict.getStringKey("first_transaction_cta")
        let stageObj = campaignDictInfo.getDictionaryKey("supercash_stages").getDictionaryKey("0")
        let tr:JRSuperCashStageModel = JRSuperCashStageModel(dict: stageObj)
        superCashStages.append(tr)
        
    // Local Handling Fields
        numberOfTransactionsLeft = self.stage_txn_count - self.total_txn_count
        offer_keyword_transcationLeft = (numberOfTransactionsLeft > 1 ? campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: "s") : campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: ""))
        offer_keyword_total_txn_count = (total_txn_count > 1 ? campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: "s") : campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: ""))
        offer_keyword_stage_txn_count = (stage_txn_count > 1 ? campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: "s") : campaignDict.getStringKey("offer_keyword").replacingOccurrences(of: "%s", with: ""))
        super.init()

    }
    
    func getGameExpiryTime() -> String {
        
        let _now = NSDate.dateFromServerString(self.server_timestamp)
        let _endDate = NSDate.dateFromServerString(self.game_expiry)
        
        guard let now = _now, let endDate = _endDate else {
            return ""
        }
        
        let dateComponents = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: now, to: endDate)
        guard let daysLeft = dateComponents.day else {
            return ""
        }
        
        if daysLeft > 0 {
            return (daysLeft > 1 ? String(format: "jr_pay_days".localized, daysLeft) : String(format: "jr_pay_day".localized, daysLeft))
        } else if let hoursLeft = dateComponents.hour, hoursLeft > 0{
            return (hoursLeft > 1 ? String(format: "jr_pay_hrs".localized, hoursLeft) : String(format: "jr_pay_hr".localized, hoursLeft))
        }else if let minsLeft = dateComponents.minute, minsLeft > 0{
            return (minsLeft > 1 ? String(format: "jr_pay_mins".localized, minsLeft):String(format: "jr_pay_min".localized, minsLeft))
        }else if let secondsLeft = dateComponents.second, secondsLeft > 0{
            return (secondsLeft > 1 ? String(format: "jr_pay_secs".localized, secondsLeft):String(format: "jr_pay_sec".localized, secondsLeft))
        }
        return ""
    }
    
    func getOfferExpiryTime() -> String {
        
        let _now = NSDate.dateFromServerString(self.server_timestamp)
        let _endDate = NSDate.dateFromServerString(self.offer_expiry)
        
        guard let now = _now, let endDate = _endDate else {
            return ""
        }
        
        let dateComponents = Calendar.current.dateComponents([.day,.hour,.minute,.second], from: now, to: endDate)
        guard let daysLeft = dateComponents.day else {
            return ""
        }
        
        if daysLeft > 0 {
            return (daysLeft > 1 ? String(format: "jr_pay_days".localized, daysLeft) : String(format: "jr_pay_day".localized, daysLeft))
        } else if let hoursLeft = dateComponents.hour, hoursLeft > 0{
            return (hoursLeft > 1 ? String(format: "jr_pay_hrs".localized, hoursLeft) : String(format: "jr_pay_hr".localized, hoursLeft))
        }else if let minsLeft = dateComponents.minute, minsLeft > 0{
            return (minsLeft > 1 ? String(format: "jr_pay_mins".localized, minsLeft):String(format: "jr_pay_min".localized, minsLeft))
        }else if let secondsLeft = dateComponents.second, secondsLeft > 0{
            return (secondsLeft > 1 ? String(format: "jr_pay_secs".localized, secondsLeft):String(format: "jr_pay_sec".localized, secondsLeft))
        }
        return ""
    }
}

class JRTransactionModel: NSObject {
    enum TransactionStatus :String{
        case none = ""
        case success = "SUCCESS"
        case cancelled = "CANCELLED"
    }
    var txn_id:String = ""
    var txn_type:String = ""
    var order_id:String = ""
    var txn_source:String = ""
    var created_at:String = ""
    var txn_amount:Double = 0
    var order_name:String = ""
    var merchant_name:String = ""
    var payee_name:String = ""
    var status:TransactionStatus = .none
    var cancellation_time:String = ""
    var progress_screen_construct:String = ""
    var stage : Int = 0
    var stages : [JRTransactionStageModel] = []
    init(dict:[String:Any]) {
        txn_id = dict.getStringKey("txn_id")
        txn_type = dict.getStringKey("txn_type")
        order_id = dict.getStringKey("order_id")
        txn_source = dict.getStringKey("txn_source")
        created_at = dict.getStringKey("created_at")
        txn_amount = dict.getDoubleKey("txn_amount")
        order_name = dict.getStringKey("order_name")
        merchant_name = dict.getStringKey("merchant_name")
        payee_name = dict.getStringKey("payee_name")
        status = TransactionStatus(rawValue: dict.getStringKey("status")) ?? .none
        cancellation_time = dict.getStringKey("cancellation_time")
        progress_screen_construct = dict.getStringKey("progress_screen_construct")
        stage = dict.getIntKey("stage")
        if let stageArray = dict.getArrayKey("stage_objects") as? [[String : Any]]{
            for stagesObject in stageArray{
                let st:JRTransactionStageModel = JRTransactionStageModel(dict: stagesObject)
                stages.append(st)
            }
        }
        super.init()
    }
    
}

class JRSuperCashStageModel: NSObject {
    var event : String = ""
    var surprise_stage : String = ""
    
    init(dict:[String:Any]) {
        event  = dict.getStringKey("event")
        surprise_stage  = dict.getStringKey("surprise_stage")
        super.init()
    }
}


class JRTransactionStageModel: NSObject {
    var cashback_text : String = ""
    var earned_text : String = ""
    var redemption_text : String = ""
    var redemption_type : RedemptionType = .cashback
    var frontend_redemption_type : String = ""
    var redemption_type_flat_percentage : String = ""
    var percentage_redemption : String = ""
    var bonus_amount : Int = 0
    var max_cashback : String = ""
    var fulfillment_at : String = ""
    var redemption_status : RedemptionStatus = RedemptionStatus.redeemRequested
    var post_transaction_completed_status : String = ""
    var stage_txn_count : String = ""
    var stage_status : String = ""
    var surprise_stage : Bool = true
    var redemption_type_object : NSObject = NSObject.init()
    var isExpanded : Bool = false
    
    init(dict:[String:Any]) {
        cashback_text  = dict.getStringKey("cashback_text")
        earned_text  = dict.getStringKey("earned_text")
        redemption_text  = dict.getStringKey("redemption_text")
        redemption_type  = RedemptionType(rawValue:  dict.getStringKey("redemption_type")) ?? .cashback
        frontend_redemption_type = dict.getStringKey("frontend_redemption_type")
        redemption_type_flat_percentage  = dict.getStringKey("redemption_type_flat_percentage")
        percentage_redemption  = dict.getStringKey("percentage_redemption")
        bonus_amount  = dict.getIntKey("bonus_amount")
        post_transaction_completed_status = dict.getStringKey("post_transaction_completed_status")
        max_cashback  = dict.getStringKey("max_cashback")
        fulfillment_at  = dict.getStringKey("fulfillment_at")
        redemption_status  = RedemptionStatus(rawValue:dict.getStringKey("redemption_status")) ?? RedemptionStatus.redeemRequested
        stage_txn_count  = dict.getStringKey("stage_txn_count")
        stage_status  = dict.getStringKey("stage_status")
        surprise_stage = dict.getBoolForKey("surprise_stage")
        isExpanded = false
        switch redemption_type {
        case .deal :
            if let obj = dict.getOptionalDictionaryKey("deal_data") {
                redemption_type_object = JRCODealModel.init(dict: obj)
            }
        case .crosspromo :
            if let obj = dict.getOptionalDictionaryKey("crosspromo_data") {
                redemption_type_object = JRCOCrossPromoModel.init(dict: obj)
            }
        default:
            break
        }
        super.init()
    }
}

class JRCODealModel: NSObject {
    var type: RedemptionType = .cashback
    var deal_voucher_code : String = ""
    var hasTnc : Bool = true
    var hasOfferText : String = ""
    var deal_icon : String = ""
    var deal_brand : String = ""
    var deal_terms : String = ""
    var deal_valid_from : String = ""
    var deal_expiry : String = ""
    var tnc_text : String = ""
    var tnc_model : JRCOTNCModel = JRCOTNCModel(dict: [:])
    var redeem_tnc_model : JRCOTNCModel = JRCOTNCModel(dict: [:])
    var deal_text : String = ""
    var deal_usage_text : String = ""
    var deal_redemption_terms : String = ""
    var display_valid_from : String = ""
    var display_valid_upto : String = ""
    var secret: String = ""
    
    init(dict: [String:Any]) {
        type = RedemptionType(rawValue:  dict.getStringKey("type")) ?? .deal
        deal_voucher_code = dict.getStringKey("deal_voucher_code")
        hasTnc = dict.getBoolForKey("hasTnc")
        hasOfferText = dict.getStringKey("hasOfferText")
        deal_icon = dict.getStringKey("deal_icon")
        deal_brand = dict.getStringKey("deal_brand")
        deal_terms = dict.getStringKey("deal_terms")
        deal_valid_from = dict.getStringKey("deal_valid_from")
        deal_expiry = dict.getStringKey("deal_expiry")
        secret = dict.getStringKey("secret")
        display_valid_from = JRCOUtils.getDateForDealsAndCrossPromo(inputDate:deal_valid_from)
        display_valid_upto = JRCOUtils.getDateForDealsAndCrossPromo(inputDate:deal_expiry)
        
        tnc_text = dict.getStringKey("tnc_text")
        tnc_model = JRCOTNCModel(termsTitle: "jr_ac_termsNConditions".localized, termsDescription: deal_terms)
        deal_text = dict.getStringKey("deal_text")
        deal_usage_text = dict.getStringKey("deal_usage_text")
        deal_redemption_terms = dict.getStringKey("deal_redemption_terms")
        redeem_tnc_model = JRCOTNCModel(termsTitle: "jr_mp_how_redeem".localized, termsDescription: deal_redemption_terms)
        super.init()
    }
}


class JRCOCrossPromoModel: NSObject {
    var cross_promo_code : String = ""
    var cross_promo_text : String = ""
    var applicable_on : String = ""
    var valid_from : String = ""
    var valid_upto : String = ""
    var site_id : String = ""
    var campaign_id : String = ""
    var campaign_name : String = ""
    var redemption_type : RedemptionType = .cashback
    var cap : String = ""
    var type : String = ""
    var val : String = ""
    var terms_conditions : String = ""
    var creation_level : String = ""
    var cross_promocode_icon : String = ""
    var cross_promo_usage_text : String = ""
    var cta : String = ""
    var cta_deeplink : String = ""
    var tnc_model : JRCOTNCModel = JRCOTNCModel(dict: [:])
    var display_valid_from : String = ""
    var display_valid_upto : String = ""
    
    init(dict: [String:Any]) {
        cross_promo_code = dict.getStringKey("code")
        cross_promo_text = dict.getStringKey("cross_promo_text")
        applicable_on = dict.getStringKey("applicable_on")
        valid_from = dict.getStringKey("valid_from")
        valid_upto = dict.getStringKey("valid_upto")
        display_valid_from = valid_from.getFormattedDateString("d MMM yyyy")
        display_valid_upto = valid_upto.getFormattedDateString("d MMM yyyy")
        site_id = dict.getStringKey("site_id")
        campaign_id = dict.getStringKey("campaign_id")
        campaign_name = dict.getStringKey("campaign_name")
        redemption_type = RedemptionType(rawValue:  dict.getStringKey("redemption_type")) ?? .crosspromo
        cap = dict.getStringKey("cap")
        type = dict.getStringKey("type")
        val = dict.getStringKey("val")
        terms_conditions = dict.getStringKey("terms_conditions")
        tnc_model = JRCOTNCModel(termsTitle: "jr_ac_termsNConditions".localized, termsDescription: terms_conditions)
        creation_level = dict.getStringKey("creation_level")
        cross_promocode_icon = dict.getStringKey("cross_promocode_icon")
        cross_promo_usage_text = dict.getStringKey("cross_promo_usage_text")
        cta = dict.getStringKey("cta")
        cta_deeplink = dict.getStringKey("cta_deeplink")
        super.init()
    }
}

