//
//  JRCBRedumptionScratchCard.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 30/12/19.
//

import Foundation

enum JRCBRedumptionScratchStatus: String {
    case stScratched   = "SCRATCHED"
    case stUnScratched = "UNSCRATCHED"
    case stInitialised = "INITIALISED"
    case stExpired     = "EXPIRED"
    case stCancelled   = "CANCELLED"
    case stRedeemed    = "REDEEMED"
    case stLocked      = "LOCKED"
    case stUnknown     = ""
    
    func isScratched() -> Bool {
        switch self {
        case .stUnknown, .stUnScratched : return false
        default: return true
        }
    }
    
    func canScratch() -> Bool {
        switch self {
        case .stUnScratched, .stUnknown : return true
        default: return false
        }
    }
}


class JRCBRedumptionScratchCard: JRCBRedumptionInfo {
    var scratchId = ""
    var extraInfo: JRCBRedumptionInfo?  // extra info deal/crosspromo/cb/gb
    var sourceMetedata:  JRCBScratchCardSourceMetaData?
    var redemMetedata: JRCBScratchCardRedemptionMetaData?
    var iconUrl = ""
    var backgroundImage = ""
    
    
    var statusText = ""
    var earnedText = ""
    var displayType = ""
    var redemptionText = ""
    var redemptionCtaText = ""
    var redemptionCtaDeeplink = ""
    
    var winningText = ""
    var subRedemptionType = ""
    var frontendRedemptionType = ""
    
    var noneRedemption = 0
    var assured = 0
    var expiryText = ""
    var initializationText = ""
    var winningTitle = ""
    var unlockText = ""
    
    private(set) var isExpiring = false
    private(set) var status = JRCBRedumptionScratchStatus.stUnknown
    private(set) var loadingState: JRCBLoadingState = .cbNotStarted // scratch card by id
    private(set) var updateState: JRCBLoadingState = .cbNotStarted // update on scratch
    private(set) var cardConfig = JRCBScratchConfigEnum.getPlaceholderConfig()
    private(set) var isSupported : Bool = true
    private(set) var referenceId: String = ""
    private(set) var flipText: String = ""
    private(set) var flipCtaText: String = ""
    private(set) var isUserScratched: Bool = false
    private(set) var isLuckyDraw: Bool = false
    private(set) var cardHeadline: String = ""
    private(set) var redemptionMaxAmount = 0
    private(set) var earnedForText: String = ""
    
    private(set) var bgImageUrl: String = ""
    
    
    func set(userScratched: Bool) {
        self.isUserScratched = userScratched
    }
    
    init(sId: String, unlockText: String = "") {
        super.init(dict: [:])
        self.scratchId = sId
        if !unlockText.isEmpty {
            self.unlockText = unlockText
            self.status = .stLocked
        }
    }
    
    override init(dict: JRCBJSONDictionary, isScratch: Bool = false) {
        super.init(dict: dict, isScratch: isScratch)
        self.rType = .rScratchCard
        self.scratchId = dict.getStringKey("id")
        self.updateScratchCardWith(dict: dict)
    }

    func setCard(config: JRCBScratchConfigEnum) {
        self.cardConfig = config
    }
    
    func setLoadingState(state: JRCBLoadingState) {
        self.loadingState = state
    }
    
    private func shouldSupport() -> Bool {
        if self.status == .stLocked {
            return true
        }
        if let rmetadata = self.redemMetedata {
            if rmetadata.redemptionType == .rUnknown { return false }
            
            if self.status == .stUnScratched {
                if self.displayType.lowercased() != "scratch_card" { return false }
            }
            return true
        }
        return false
    }
    
    func updateScratchCardWith(dict: JRCBJSONDictionary) { //
        
        if let mStatus = JRCBRedumptionScratchStatus(rawValue: dict.stringFor(key: "status")) {
            self.status = mStatus
        }
        
        self.statusText = dict.getStringKey("statusText")
        self.earnedText = dict.stringFor(key: "earnedText")
        self.displayType = dict.stringFor(key: "displayType")
        self.redemptionText = dict.stringFor(key: "redemptionText")
        self.iconUrl = dict.stringFor(key: "iconUrl")
        self.backgroundImage = dict.stringFor(key: "backgroundImage")
        
        self.winningText = dict.stringFor(key: "winningText")
        self.subRedemptionType = dict.stringFor(key: "subRedemptionType")
        self.frontendRedemptionType = dict.stringFor(key: "frontendRedemptionType")
        
        self.noneRedemption = dict.intFor(key: "noneRedemption")
        self.assured = dict.intFor(key: "assured")
        
        self.expiryText = dict.stringFor(key: "expiryText")
        self.initializationText = dict.stringFor(key: "initializationText")
        self.winningTitle = dict.stringFor(key: "winningTitle")
        self.unlockText = dict.stringFor(key: "unlockText")
        self.redemptionCtaText = dict.getStringKey("redemptionCtaText")
        self.redemptionCtaDeeplink = dict.getStringKey("redemptionCtaDeeplink")
        self.isLuckyDraw = dict.getBoolForKey("luckyDraw")
        self.cardHeadline = dict.getStringKey("cardHeadline")
        self.redemptionMaxAmount = dict.getIntKey("redemptionMaxAmount")
        self.earnedForText = dict.getStringKey("earnedForText")
        
        if let redemDict = dict["redemptionMetaData"] as? JRCBJSONDictionary {
            self.redemMetedata = JRCBScratchCardRedemptionMetaData(dict: redemDict)
        }
        
        if let redemDict = dict["sourceMetaData"] as? JRCBJSONDictionary {
            self.sourceMetedata = JRCBScratchCardSourceMetaData(dict: redemDict)
        }
        
        self.isSupported = self.shouldSupport()
        self.referenceId = dict.getStringKey("referenceId")
        self.flipText = dict.getStringKey("flipText")
        self.flipCtaText = dict.getStringKey("flipCtaText")
        self.isExpiring = JRCBUtils.isExpiryWith(expireAt: dict.getStringKey("expireAt"))
        if let extraData = dict["extraInfo"] as? JRCBJSONDictionary {
            self.bgImageUrl = extraData.getStringKey("bgImageUrl")
            if let type = JRCBScratchRedumptionType(rawValue: extraData.stringFor(key: "redemptionType").lowercased()) {
                switch type {
                case .rDeal:
                     let dInfo = JRCBRedumptionDeal(dict: extraData, isScratch: true)
                    self.extraInfo = dInfo
                    
                case .rCrosspromo:
                    let dInfo = JRCBRedumptionCrossPromo(dict: extraData, isScratch: true)
                    self.extraInfo = dInfo
                    
                case .rCashback, .rGoldback, .rCoins, .rCricket, .rPBPL, .rGV_Cashback, .rUPI:
                    let dInfo = JRCBRedumptionCashGoldBack(dict: extraData, isScratch: true)
                    self.extraInfo = dInfo
                
                default: break
                }
            }
        }
    }
}

// API Calls
extension JRCBRedumptionScratchCard {
    func getScratchCardById(completion: ((Bool, String) -> Void)?) { // API... on click opf banner
        self.setLoadingState(state: .cbInProgress)
        if JRCashbackManager.shared.shouldMock { // Mock...
            if let mResp = JRCBMockUtils.kJRCBScratchByIdMockFile.getDictFromBundle().dict {
                self.parseForId(resp: mResp, err: nil, completion: completion)
                return
            }
        }
        
        let mParam: JRCBJSONDictionary? = nil
        let apiModel = JRCBApiModel(type: JRCBApiType.pathScratchCardById, param: mParam, appendUrlExt: self.scratchId)
        JRCBServiceManager.execute(apiModel: apiModel) { [weak mSelf = self](success, resp, err) in
            mSelf?.parseForId(resp: resp, err: err, completion: completion)
        }
    }
    
    private func parseForId(resp: JRCBJSONDictionary?, err: Error?, completion: ((Bool, String) -> Void)?) {
        // parse here..
        if let mResp = resp, let tDict = mResp["data"] as? JRCBJSONDictionary {
            self.updateScratchCardWith(dict: tDict)
            self.setLoadingState(state: .cbSuccess)
            completion?(true, "")
            
        } else if let mErr = err {
            self.setLoadingState(state: .cbFailed)
            completion?(false, mErr.localizedDescription)
            
        } else {
            // default handling..
            self.setLoadingState(state: .cbFailed)
            completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
        }
    }
    
    func updateScratchCard(completion: ((Bool, String) -> Void)?) { // API.... on scratch of card
        if JRCashbackManager.shared.shouldMock { // Mock...
            if let mResp = JRCBMockUtils.kJRCBUpdateScrachMockFile.getDictFromBundle().dict {
                self.parseScratch(resp: mResp, err: nil, completion: completion)
                return
            }
        }
        
        let mParam : JRCBJSONDictionary? = ["scratchCardAction": "SCRATCHED"]
        let apiModel = JRCBApiModel(type: JRCBApiType.pathUpdateScratchCard, param: nil, body: mParam, appendUrlExt: "\(self.scratchId)/status")
        JRCBServiceManager.execute(apiModel: apiModel) { [weak mSelf = self](success, resp, err) in
            mSelf?.parseScratch(resp: resp, err: err, completion: completion)
        }
    }
    
    private func parseScratch(resp: JRCBJSONDictionary?, err: Error?, completion: ((Bool, String) -> Void)?) {
        // parse here..
        if let mResp = resp, let tDict = mResp["data"] as? JRCBJSONDictionary {
            JRCBNotificationName.notifRemoveScreatchCard.fireMeWith(userInfo: ["sId": self.scratchId])
            self.updateScratchCardWith(dict: tDict)
            self.updateState = .cbUpdate
            completion?(true, "")
            
        } else if let mErr = err {
            self.updateState = .cbUpdateFailed
            completion?(false, mErr.localizedDescription)
            
        } else {
            // default handling..
            self.updateState = .cbUpdateFailed
            completion?(false, JRCBConstants.Common.kDefaultErrorMsg)
        }
    }
}

// MARK: - JRCBScratchCardRedemptionMetaData
class JRCBScratchCardRedemptionMetaData {
    var redemptionType = JRCBScratchRedumptionType.rUnknown
    var amount: Double = 0
    
    var dealId = ""
    var redeemedTime = ""
    var redemptionDelay = ""
    var redemptionIconUrl = ""
    var deeplink = ""
    
    var secret = ""
    var validFrom = ""
    var validUpto = ""
    var voucherCode = ""
    
    var voucherDeeplink = ""
    var voucherName = ""
    var flip = false
    
    init(dict: JRCBJSONDictionary) {
        if let rType = JRCBScratchRedumptionType(rawValue: dict.stringFor(key: "redemptionType").lowercased()) {
            self.redemptionType = rType
        }
        self.amount = dict.doubleFor(key: "amount")
        self.dealId = dict.stringFor(key: "dealId")
        self.redeemedTime = (dict["redeemedTime"] as? String) ?? ""
            //.stringFor(key: "redeemedTime")
        self.redemptionDelay = dict.stringFor(key: "redemptionDelay")
        self.redemptionIconUrl = dict.stringFor(key: "redemptionIconUrl")
        self.deeplink = dict.stringFor(key: "deeplink")
        
        self.secret = dict.stringFor(key: "secret")
        self.validFrom = dict.stringFor(key: "validFrom")
        self.validUpto = dict.stringFor(key: "validUpto")
        self.voucherCode = dict.stringFor(key: "voucherCode")
        
        self.voucherDeeplink = dict.stringFor(key: "voucherDeeplink")
        self.voucherName = dict.stringFor(key: "voucherName")
        
        self.flip = dict.getBoolForKey("flip")
    }
}

// MARK: - JRCBScratchCardSourceMetaData
class JRCBScratchCardSourceMetaData {
    var deeplink = ""
    var offerDescription = ""
    var offerIconUrl = ""
    var offerId = ""
    
    var offerName = ""
    var stage = 0
    var type = ""
    
    init(dict: JRCBJSONDictionary) {
        self.deeplink = dict.stringFor(key: "deeplink")
        self.offerDescription = dict.stringFor(key: "offerDescription")
        self.offerIconUrl = dict.stringFor(key: "offerIconUrl")
        self.offerId = dict.stringFor(key: "offerId")
        
        self.offerName = dict.stringFor(key: "offerName")
        self.stage = dict.intFor(key: "stage")
        self.type = dict.stringFor(key: "type")
    }
}
