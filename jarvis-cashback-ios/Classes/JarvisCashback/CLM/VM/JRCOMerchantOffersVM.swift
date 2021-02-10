//
//  JRCOMerchantOffersVM.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 21/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

public class JRMCBOfferViewModel {
    
}

public class JRMCONewOfferViewModel: JRMCBOfferViewModel {
    private var model:MerchantCampaignViewModel?
    
    public init(dict: JRCBJSONDictionary) {
        model = MerchantCampaignViewModel(dict: dict)
    }
    
    public func getMerchantCampaignVMData() -> MerchantCampaignViewModel {
        return model ?? MerchantCampaignViewModel(dict: [:])
    }
}

public class JRMCOMyOfferViewModel: JRMCBOfferViewModel {
    public enum GameStatus: String {
        case none         = ""
        case inProgress   = "INPROGRESS"    // participated in offer to earn higher cashback
        case initialized  = "INITIALIZED"   // activated the offer by doing 1 transaction
        case completed    = "COMPLETED"     // completed the offer  - either claimed initial cashback or earned higher cashback
        case expired      = "GAME_EXPIRED"  // participated in offer to earn higher cashback, but did not complete all the transactions
        case offerExpired = "OFFER_EXPIRED" // did not chose - claim or participate option
        case denied       = "DENIED"        // claimed initial cashback and denied to participate further to earn cashback
        case unacked      = "OFFER_UNACKED"
    }
    
    private(set) var stage                 : Int = 0
    private(set) var game_expiry_amount    : Int = 0
    private(set) var total_txn_count       : Int = 0
    private(set) var max_bonus_amount_game : Int = 0
    private(set) var max_cap_bonus_amount_game: Int = 0
    private(set) var bonus_amount_earned: Int = 0
    private(set) var success_txn_count:Int = 0
    private(set) var game_completion_time:String = ""
    private(set) var success_txn_text:String = ""
    private(set) var game_gratification_message:String = ""
    private(set) var offer_id:String = ""
    private(set) var game_status:String = ""
    private(set) var game_expiry:String = ""
    private(set) var created_at:String = ""
    private(set) var game_expiry_reason_text:String = ""
    private(set) var txn_count_text:String = ""
    private(set) var is_multistage:String = ""
    private(set) var remaining_time:String = ""
    private(set) var offer_completion_text:String = ""
    private(set) var initialized_offer_text: String = ""
    private(set) var offer_remaining_time: String = ""
    
    public private(set) var offer_progress_construct:String = ""
    public private(set) var stagesVM :[StageViewModel] = []
    public private(set) var campaignViewModel = MerchantCampaignViewModel(dict: [:])
    public private(set) var game_status_enum: GameStatus = .none
    
    public init(dict: JRCBJSONDictionary) {
        var mDict = dict
        if let data = dict["data"] as? JRCBJSONDictionary {
            mDict = data
        }
        
        self.stage                      = mDict.getIntKey("stage")
        self.game_expiry_amount         = mDict.getIntKey("game_expiry_amount")
        self.total_txn_count            = mDict.getIntKey("total_txn_count")
        self.max_bonus_amount_game      = mDict.getIntKey("max_bonus_amount_game")
        self.max_cap_bonus_amount_game  = mDict.getIntKey("max_cap_bonus_amount_game")
        self.bonus_amount_earned        = mDict.getIntKey("bonus_amount_earned")
        self.success_txn_text           = mDict.getStringKey("success_txn_text")
        self.game_gratification_message = mDict.getStringKey("game_gratification_message")
        self.offer_id                   = mDict.getStringKey("offer_id")
        self.game_status                = mDict.getStringKey("game_status")
        self.game_expiry                = mDict.getStringKey("game_expiry")
        self.created_at                 = mDict.getStringKey("created_at")
        self.game_expiry_reason_text    = mDict.getStringKey("game_expiry_reason_text")
        self.txn_count_text             = mDict.getStringKey("txn_count_text")
        self.success_txn_count          = mDict.getIntKey("success_txn_count")
        self.is_multistage              = mDict.getStringKey("is_multistage")
        self.offer_progress_construct   = mDict.getStringKey("offer_progress_construct")
        self.remaining_time             = mDict.getStringKey("remaining_time")
        self.game_completion_time       = mDict.getStringKey("game_completion_time")
        self.offer_completion_text      = mDict.getStringKey("offer_completion_text")
        self.initialized_offer_text     = mDict.getStringKey("initialized_offer_text")
        self.offer_remaining_time       = mDict.getStringKey("offer_remaining_time")
        
        let campaignDict = mDict.getDictionaryKey("campaign")
        self.campaignViewModel = MerchantCampaignViewModel(dict: campaignDict)
        
        if let stagesArrays = mDict.getArrayKey("stages") as? [[String : Any]] {
            for stageDict in stagesArrays {
                let stgeVMObj:StageViewModel = StageViewModel(dict: stageDict)
                self.stagesVM.append(stgeVMObj)
            }
        }
        game_status_enum = GameStatus(rawValue: mDict.getStringKey("game_status")) ?? .none
    }
    
    
    func getTransactionsLeftText() -> String {
        return String(format: "jr_pay_transLeft".localized, total_txn_count - success_txn_count)
    }
    
    func getProgressValue() -> Float {
        return (Float(success_txn_count) / Float(total_txn_count))
    }
    
    func getStageVMForIndex(index:Int) -> StageViewModel {
        if index < 0 { return stagesVM[0] }
        return stagesVM[index]
    }
}



public class StageViewModel {
    
    public enum StageStatus: String {
        case inProgress   = "INPROGRESS"     // participated in offer to earn higher cashback
        case initialized  = "INITIALIZED"    // activated the offer by doing 1 transaction
        case completed    = "COMPLETED"      // completed the offer  - either claimed initial cashback or earned higher cashback
        case expired      = "GAME_EXPIRED"   // participated in offer to earn higher cashback, but did not complete all the transactions
        case offerExpired = "OFFER_EXPIRED"  // did not chose - claim or participate option
        case denied       = "DENIED"         // claimed initial cashback and denied to participate further to earn cashback
        case unacked      = "OFFER_UNACKED"
        case notStarted   = "NOT_STARTED"
        case none         = ""
    }
    
    public private(set) var stage_status_enum: StageStatus = .none
    public private(set) var stage_total_txn_count: Int = 0
    public private(set) var stage_success_txn_count: Int = 0
    private(set) var stage_status:String = ""
    private(set) var stage_screen_construct1:String = ""
    private(set) var tasksVM:[TaskViewModel] = []
    private(set) var allStage:[Int] = []
    private(set) var stage_gratification_text:String = ""
    
    public init(dict: [String:Any]) {
        stage_total_txn_count = dict.getIntKey("stage_total_txn_count")
        stage_success_txn_count = dict.getIntKey("stage_success_txn_count")
        stage_status = dict.getStringKey("stage_status")
        stage_screen_construct1 = dict.getStringKey("stage_screen_construct1")
        stage_status_enum = StageStatus(rawValue: dict.getStringKey("stage_status")) ?? .none
        stage_gratification_text = dict.getStringKey("stage_gratification_text")
        
        if let tasksArrays = dict.getArrayKey("tasks") as? [[String : Any]] {
            for taskDict in tasksArrays {
                let taskVMObj:TaskViewModel = TaskViewModel(dict: taskDict)
                tasksVM.append(taskVMObj)
            }
        }
        if let stageArrays = dict.getArrayKey("stage") as? [Int] {
            for stageInt in stageArrays {
                allStage.append(stageInt)
            }
        }
    }

    func getStageHeaderRightText() -> String {
        var resultString = ""
        if stage_status_enum == .inProgress {
            resultString = "\(stage_success_txn_count)/\(stage_total_txn_count)"
        }
        return resultString
    }
   
    func getStageTransactionsLeftText() -> String {
        return " " + String(format: "jr_pay_transLeft".localized, stage_total_txn_count - stage_success_txn_count) + " "
    }
    func getStageProgressValue() -> Float {
        return (Float(stage_success_txn_count) / Float(stage_total_txn_count))
    }
}




class CrossPromoDataVM {
   private(set) var cross_promo_code  : String = ""
    private(set) var applicable_on    : String = ""
    private(set) var valid_from       : String = ""
    private(set) var valid_upto       : String = ""
    private(set) var site_id          : String = ""
    private(set) var campaign_id      : String = ""
    private(set) var campaign_name    : String = ""
    private(set) var redemption_type  : String = ""
    private(set) var cap              : String = ""
    private(set) var type             : String = ""
    private(set) var val              : String = ""
    private(set) var terms_conditions : String = ""
    private(set) var creation_level   : String = ""
    private(set) var cta              : String = ""
    private(set) var cta_deeplink     : String = ""
    private(set) var cross_promocode_icon   : String = ""
    private(set) var cross_promo_usage_text : String = ""
    
    init(dict: JRCBJSONDictionary) {
        self.cross_promo_code = dict.getStringKey("code")
        self.applicable_on    = dict.getStringKey("applicable_on")
        self.valid_from       = dict.getStringKey("valid_from")
        self.valid_upto       = dict.getStringKey("valid_upto")
        self.site_id          = dict.getStringKey("site_id")
        self.campaign_id      = dict.getStringKey("campaign_id")
        self.campaign_name    = dict.getStringKey("campaign_name")
        self.redemption_type  = dict.getStringKey("redemption_type")
        self.cap              = dict.getStringKey("cap")
        self.type             = dict.getStringKey("type")
        self.val              = dict.getStringKey("val")
        self.terms_conditions = dict.getStringKey("terms_conditions")
        self.creation_level   = dict.getStringKey("creation_level")
        self.cross_promocode_icon   = dict.getStringKey("cross_promocode_icon")
        self.cross_promo_usage_text = dict.getStringKey("cross_promo_usage_text")
        self.cta                    = dict.getStringKey("cta")
        self.cta_deeplink           = dict.getStringKey("cta_deeplink")
    }
}

class TaskViewModel {
    private(set) var redemptionType: RedemptionType = .cashback
    private(set) var redemption_status : RedemptionStatus = RedemptionStatus.redeemRequested
    private(set) var bonus_amount: Int = 0
    private(set) var cap_bonus_amount: Int = 0
    private(set) var bonus_amount_earned: Int = 0
    private(set) var gratification_type_flat:String = ""
    private(set) var stage_redemption_type:String = ""
    private(set) var gratification_processed:Bool = false
    private(set) var frontend_redemption_type:String = ""
    private(set) var redemption_type_icon_url:String = ""
    private(set) var fulfilment_at:String = ""
    private(set) var rrn_no:String = ""
    private(set) var redemption_text:String = ""
    private(set) var crosspromoDataVM: [CrossPromoDataVM] = []
    private(set) var dealDataVM: [DealDataModel] = []
    
    init(dict: JRCBJSONDictionary) {
        bonus_amount = dict.getIntKey("bonus_amount")
        cap_bonus_amount = dict.getIntKey("cap_bonus_amount")
        bonus_amount_earned = dict.getIntKey("bonus_amount_earned")
        
        gratification_type_flat = dict.getStringKey("gratification_type_flat")
        stage_redemption_type = dict.getStringKey("stage_redemption_type")
        gratification_processed = dict.getBoolForKey("gratification_processed")
        frontend_redemption_type = dict.getStringKey("frontend_redemption_type")
        redemption_type_icon_url = dict.getStringKey("redemption_type_icon_url")
        fulfilment_at = dict.getStringKey("fulfilment_at")
        rrn_no = dict.getStringKey("rrn_no")
        redemption_text = dict.getStringKey("redemption_text")
        redemptionType = RedemptionType(rawValue: dict.getStringKey("redemption_type")) ?? .cashback
        redemption_status  = RedemptionStatus(rawValue:dict.getStringKey("redemption_status")) ?? RedemptionStatus.redeemRequested
        
        if let crossPromoData = dict.getArrayKey("crosspromo_data") as? [[String : Any]] {
            for data in crossPromoData {
                let crosspromoObj:CrossPromoDataVM = CrossPromoDataVM(dict: data)
                crosspromoDataVM.append(crosspromoObj)
            }
        }
        
        if let dealData = dict.getOptionalDictionaryKey("deal_data") {
            let dealObj = DealDataModel(dict: dealData)
            dealDataVM.append(dealObj)
        }
    }
}


public class MerchantCampaignViewModel {
    public private(set) var campId               : Int = 0
    public private(set) var short_description    : String = ""
    public private(set) var title                : String = ""
    public private(set) var new_offers_image_url : String = ""
    public private(set) var background_image_url : String = ""
    
    private(set) var valid_upto                  : String = ""
    private(set) var campaignDescription         : String = ""
    private(set) var offer_text_override         : String = ""
    private(set) var offer_type_text             : String = ""
    private(set) var tnc                         : String = ""
    private(set) var important_terms             : String = ""
    private(set) var offer_keyword               : String = ""
    private(set) var tnc_url                     : String = ""
    private(set) var campaign                    : String = ""
    private(set) var deeplink_url                : String = ""
    private(set) var surprise_text               : String = ""
    private(set) var auto_activate               : Bool = false
    private(set) var isDeeplink                  : Bool = false
    private(set) var cashback_process_delay_unit : String = ""
    private(set) var off_us_transaction_text     : String = ""
    private(set) var offer_icon_override_url     : String = ""
    private(set) var cashback_process_delay      : String = ""


    public init(dict: JRCBJSONDictionary) {
        campId                  = dict.getIntKey("id")
        valid_upto              = dict.getStringKey("valid_upto")
        campaignDescription     = dict.getStringKey("description")
        short_description       = dict.getStringKey("short_description")
        offer_text_override     = dict.getStringKey("offer_text_override")
        offer_type_text         = dict.getStringKey("offer_type_text")
        offer_icon_override_url = dict.getStringKey("offer_icon_override_url")
        background_image_url    = dict.getStringKey("background_image_url")
        new_offers_image_url    = dict.getStringKey("new_offers_image_url")
        tnc                     = dict.getStringKey("tnc")
        important_terms         = dict.getStringKey("important_terms")
        offer_keyword           = dict.getStringKey("offer_keyword")
        tnc_url                 = dict.getStringKey("tnc_url")
        off_us_transaction_text = dict.getStringKey("off_us_transaction_text")
        campaign                = dict.getStringKey("campaign")
        cashback_process_delay  = dict.getStringKey("cashback_process_delay")
        title                   = dict.getStringKey("title")
        deeplink_url            = dict.getStringKey("deeplink_url")
        surprise_text           = dict.getStringKey("surprise_text")
        auto_activate           = dict.getBoolForKey("auto_activate")
        isDeeplink              = dict.getBoolForKey("isDeeplink")
        cashback_process_delay_unit = dict.getStringKey("cashback_process_delay_unit")
    }
    
    public func getCampaignTitleText() -> String {
        return offer_text_override.count == 0 ?  offer_type_text : offer_text_override
    }
}
