//
//  JRCBPostTrnsactionInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 26/12/19.
//

import UIKit

//FOR ASSURED CARD
enum JRCBRedumptionType: String {
    case rCashback    = "cashback"
    case rGoldback    = "goldback"
    case rCrosspromo  = "crosspromo"
    case rDeal        = "deal"
    case rRandomBonus = "random_bonus"
    case rCoins       = "coins"
    case rCricket     = "collectible"
    case rPBPL        = "ppbl"
    case rUPI         = "upi"
    case rGV_Cashback = "gvcashback"
    case rScratchCard = "scratchcard"
    case rSuperCashgame = "supercash_game"
    case rUnknown     = ""
}

//FOR SCRATCH CARD
enum JRCBScratchRedumptionType: String {
    case rCashback    = "cashback"
    case rGoldback    = "goldback"
    case rCrosspromo  = "cross_promo"
    case rDeal        = "deal"
    case rCoins       = "coins"
    case rCricket     = "collectible"
    case rPBPL        = "ppbl"
    case rUPI         = "upi"
    case rGV_Cashback = "gv_cashback"
    case rScratchCard = "scratchcard"
    case rRandomBonus = "random_bonus"
    case rSuperCashgame = "supercash_game"
    case rUnknown     = ""
}

enum JRCBRedemptionStatus : String {
    case stRequested = "REDEEM_REQUESTED"
    case stRequired = "NO_REDEMPTION_REQUIRED"
    case stRedeemed = "REDEEMED"
    case stUnknown  = ""
}

enum JRCBStageStatus: String {
    case stInProgress   = "INPROGRESS"      // user has participated in offer to earn higher cashback
    case stInitialized  = "INITIALIZED"     // user has activated the offer by doing 1 transaction
    case stCompleted    = "COMPLETED"       // user has completed the offer - either claimed initial cashback or earned higher cashback
    case stExpired      = "GAME_EXPIRED"    // user participated in offer to earn higher cashback, but did not complete all the transactions
    case stOfferExpired = "OFFER_EXPIRED"   // user did not chose - claim or participate option
    case stDenied       = "DENIED"          // user claimed initial cashback and denied to participate further to earn cashback
    case stUnacked      = "OFFER_UNACKED"
    case stNotStarted   = "NOT_STARTED"
    case stNone         = ""
}

enum JRCBGameStatus: String {
    case gmInProgress   = "INPROGRESS"      // user has participated in offer to earn higher cashback
    case gmInitialized  = "INITIALIZED"     // user has activated the offer by doing 1 transaction
    case gmCompleted    = "COMPLETED"       // user has completed the offer - either claimed initial cashback or earned higher cashback
    case gmExpired      = "GAME_EXPIRED"    // user participated in offer to earn higher cashback, but did not complete all the transactions
    case gmOfferExpired = "OFFER_EXPIRED"   // user did not chose - claim or participate option
    case gmDenied       = "DENIED"          // user claimed initial cashback and denied to participate further to earn cashback
    case gmUnacked      = "OFFER_UNACKED"
    case gmNotStarted   = "NOT_STARTED"
    case gmNone         = ""
}

enum JRCBEventType: String {
    case accept = "ACCEPT_OFFER"
    case reject = "REJECT_OFFER"
}

class JRCBPostTxnSuperModel {
    var status: Int = 0
    var error: [JRCBPostTxnErrorModel] = []
    var data: JRCBPostTrnsactionData?
    
    init(dict: JRCBJSONDictionary) {
        self.status = dict.getIntKey("status")
        if let dataObj = dict["data"] as? JRCBJSONDictionary {
            self.data = JRCBPostTrnsactionData(dict: dataObj)
        }
        if let error = dict["errors"] as? [JRCBJSONDictionary] {
            for errorObj in error {
                let error = JRCBPostTxnErrorModel(dict: errorObj)
                self.error.append(error)
            }
        }
    }
}

class JRCBPostTxnErrorModel {
    var status: Int = 0
    var code: String = ""
    var message: String = ""
    var title: String = ""
    var errorCode: String = ""
    
    init(dict: JRCBJSONDictionary) {
        self.status = dict.getIntKey("status")
        self.code = dict.stringFor(key: "code")
        self.message = dict.getStringKey("message")
        self.title = dict.getStringKey("title")
        self.errorCode = dict.getStringKey("errorCode")
    }
}


class JRCBPostTrnsactionData {
    var dataId = ""
    var success_txn_count = 0
    var total_txn_count = 0
    var gameStatus = JRCBGameStatus.gmNone
    
    var offer_expiry = ""
    var game_expiry = ""
    var server_timestamp = ""
    var offer_summary = ""
    var offer_status_text = ""
    
    var offer_badge = ""
    var current_stage = -1
    var txn_linkedId = ""
    var txn_linkedStage = -1
    
    // under info
    var offer_expiry_reason = ""
    var game_expiry_reason = ""
    var transactions = [JRCBPostTrnsactionInfo]()
    var mCampain : JRCBCampaign?
    
    var currentTransInfo: JRCBPostTrnsactionInfo?
    var nextTransInfo: JRCBPostTrnsactionInfo?
    var errorMsg = ""
    var unlockText = ""
    
    var opt_out_time = ""
    var offer_status_info = ""
    var claimCTA = ""
    var offer_end_time = ""
    
    init() {}
    
    init(dict: JRCBJSONDictionary) {
        self.dataId = dict.getStringKey("id")
        self.success_txn_count = dict.intFor(key: "success_txn_count")
        self.total_txn_count = dict.intFor(key: "total_txn_count")
        if let gameStatus = JRCBGameStatus(rawValue: dict.stringFor(key: "status")) {
            self.gameStatus = gameStatus
        }
        
        self.offer_expiry = dict.stringFor(key: "offer_expiry")
        self.game_expiry = dict.stringFor(key: "game_expiry")
        self.server_timestamp = dict.getStringKey("server_timestamp")
        self.offer_summary = dict.stringFor(key: "offer_summary")
        self.offer_status_text = dict.stringFor(key: "offer_status_text")
        self.unlockText = dict.getStringKey("unlock_text")
        
        self.opt_out_time = dict.getStringKey("opt_out_time")
        self.offer_status_info = dict.getStringKey("offer_status_info")
        self.claimCTA = dict.getStringKey("Claim_CTA")
        self.offer_end_time = dict.getStringKey("offer_end_time")
        
        self.offer_badge = dict.stringFor(key: "offer_badge")
        self.current_stage = dict.intFor(key: "current_stage")
        if let txnLinked = dict["txn_linked"] as? JRCBJSONDictionary {
            self.txn_linkedId = txnLinked.getStringKey("id")
            self.txn_linkedStage = txnLinked.intFor(key: "stage")
        }
        
        // info
        if let infoDict = dict["info"] as? JRCBJSONDictionary {
            self.offer_expiry_reason = infoDict.stringFor(key: "offer_expiry_reason")
            self.game_expiry_reason = infoDict.stringFor(key: "game_expiry_reason")
            
            // transaction..
            if let sObjs =  infoDict["transactions"] as? [JRCBJSONDictionary] {
                for tDict in sObjs {
                    let transInfo = JRCBPostTrnsactionInfo(dict: tDict)
                    transactions.append(transInfo)
                    
                    if transInfo.stage == self.txn_linkedStage, let _ = transInfo.stageObject {
                        self.currentTransInfo = transInfo // used in post transaction
                    }
                    if transInfo.stage == self.current_stage, let _ = transInfo.stageObject {
                        self.nextTransInfo = transInfo // Used in game details
                    }
                }
            }
            
            // campain
            if let campObj = infoDict["campaign"] as? JRCBJSONDictionary {
                self.mCampain = JRCBCampaign(dict: campObj)
            }
        }
        
        if nil == self.currentTransInfo {
            self.errorMsg = "matching transaction not found"
        
        }
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
    
    func getExpiryDate() -> String {
        if !self.game_expiry.isEmpty {
            let expiryDate = game_expiry.getFormattedDateString("dd MMM yyyy")
            if !expiryDate.isEmpty {
                return JRCBConstants.Common.kValidTill + expiryDate
            }
        }
        return ""
    }
}


class JRCBPostTrnsactionInfo {
    var txn_id = ""
    var txn_source = ""
    var order_id = ""
    var stage = 0
    var status = ""
    var created_at = ""
    var txn_amount: Double =  0
    var progress_screen_construct = ""
    var offer_expiry_reason = ""
    var game_expiry_reason = ""
    
    var stageObject: JRCBPostTransStageInfo?
        
    init(dict: JRCBJSONDictionary) {
        self.txn_id = dict.getStringKey("txn_id")
        self.txn_source = dict.stringFor(key: "txn_source")
        self.order_id = dict.stringFor(key: "order_id")
        self.stage = dict.intFor(key: "stage")
        self.status = dict.stringFor(key: "status")
        self.txn_amount = dict.doubleFor(key: "txn_amount")
        self.progress_screen_construct = dict.stringFor(key: "progress_screen_construct")
        self.offer_expiry_reason = dict.stringFor(key: "offer_expiry_reason")
        self.game_expiry_reason = dict.stringFor(key: "game_expiry_reason")
        
        if let sObj = dict["stage_object"] as? JRCBJSONDictionary {
            self.stageObject = JRCBPostTransStageInfo(dict: sObj)
        }
    }
}


class JRCBPostTransStageInfo {
    var stage_status = JRCBStageStatus.stNone
    var stage_txn_count = 0
    var stage_success_txn_count = 0
    var surprise_stage = false
    var stage_progress_construct = ""
    var bonus_amount : Double = 0
    var gratifications = [JRCBGratification]() // gratifications
    
    init(dict: JRCBJSONDictionary) {
        if let stage = JRCBStageStatus(rawValue: dict.stringFor(key: "stage_status")) {
            self.stage_status = stage
        }
        
        self.stage_txn_count = dict.intFor(key: "stage_txn_count")
        self.stage_success_txn_count = dict.intFor(key: "stage_success_txn_count")
        self.surprise_stage = dict.booleanFor(key: "surprise_stage")
        self.bonus_amount = dict.doubleFor(key: "bonus_amount")
        self.stage_progress_construct = dict.stringFor(key: "stage_progress_construct")
        
        gratifications.removeAll()
        if let rList = dict["gratification_objects"] as? [JRCBJSONDictionary] {
            for aDict in rList {
                gratifications.append(JRCBGratification(dict: aDict))
            }
        }
    }
}


class JRCBGratification {
    var redemption_status = JRCBRedemptionStatus.stUnknown
    var redemption_type = JRCBRedumptionType.rUnknown
    
    var winnning_title = ""
    var winning_text = ""
    var frontend_redemption_typeBase = ""
    var cashback_text = ""
    var progrss_text = ""
    
    var redemption_text = ""
    var earned_text = ""
    var bonus_amount: Double = 0
    var redemption_type_icon = ""
    
    var redumptionInfo = JRCBRedumptionInfo(dict: [:])
    
    var isAssuredCard: Bool {
        if let rInfo = self.redumptionInfo as? JRCBRedumptionScratchCard {
            if !rInfo.scratchId.isEmpty {
                return false
            }
        }
        return true
    }
    
    var isLockedScratchCard: Bool {
        if let rInfo = self.redumptionInfo as? JRCBRedumptionScratchCard {
            if !rInfo.scratchId.isEmpty, !rInfo.unlockText.isEmpty {
                return true
            }
        }
        return false
    }
    
    var isUnlockedScratchCard: Bool {
        if let rInfo = self.redumptionInfo as? JRCBRedumptionScratchCard {
            if !rInfo.scratchId.isEmpty, rInfo.unlockText.isEmpty {
                return true
            }
        }
        return false
    }
    
    init(redumpInfo: JRCBRedumptionInfo) {
        self.redumptionInfo = redumpInfo
    }
    
    init(dict: JRCBJSONDictionary) {
        if let sData = dict["scratchCardData"] as? JRCBJSONDictionary, !sData.getStringKey("id").isEmpty {
            self.redemption_type = .rScratchCard
            self.redumptionInfo = JRCBRedumptionScratchCard(sId: sData.getStringKey("id"), unlockText: sData.getStringKey("unlockText"))
            return
        }
        
        if let sData = dict["supercashGameData"] as? JRCBJSONDictionary {
            self.redemption_type = .rSuperCashgame
            self.redumptionInfo = JRCBRedumptionSuperCashGame(dict: sData)
            return
        }
        
        if let status = JRCBRedemptionStatus(rawValue: dict.stringFor(key: "redemption_status")) {
            self.redemption_status = status
        }
        
        if let aType = JRCBRedumptionType(rawValue: dict.stringFor(key: "redemption_type").lowercased()),
            aType != .rUnknown {
           
            self.redemption_type = aType
            switch redemption_type {
            case .rCrosspromo :
                if let mDict = dict["crosspromo_data"] as? JRCBJSONDictionary {
                    self.redumptionInfo = JRCBRedumptionCrossPromo(dict: mDict)
                }
            case .rDeal :
                if let mDict = dict["deal_data"] as? JRCBJSONDictionary {
                    self.redumptionInfo = JRCBRedumptionDeal(dict: mDict)
                }
                
            default: break
            }
        }
        
        self.winnning_title = dict.stringFor(key: "winnning_title")
        self.winning_text = dict.stringFor(key: "winning_text")
        self.frontend_redemption_typeBase = dict.stringFor(key: "frontend_redemption_type")
        self.cashback_text = dict.stringFor(key: "cashback_text")
        self.progrss_text = dict.stringFor(key: "progress_text")
        
        self.redemption_text = dict.stringFor(key: "redemption_text")
        self.earned_text = dict.stringFor(key: "earned_text")
        self.bonus_amount = dict.doubleFor(key: "bonus_amount")
        self.redemption_type_icon = dict.stringFor(key: "redemption_type_icon")
    }
}
