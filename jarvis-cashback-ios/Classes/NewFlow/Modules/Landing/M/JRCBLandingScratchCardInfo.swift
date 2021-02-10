//
//  JRCBLandingScratchCardInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 03/02/20.
//

import UIKit

enum JRCBLandingScratchType: String {
    case sTypeUnscratchCard = "UNSCRATCHED_CARD"
    case sTypeActiveOffer   = "ACTIVE_OFFER"
    case sTypeLockdCard     = "LOCKED_CARD"
    case sTypeNew_Offer     = "NEW_OFFER"
    case sTypeUnknown       = "unknown"
}

class JRCBLandingScratchCardInfo: JRCBSFItem {
    
    private(set) var sType: JRCBLandingScratchType = .sTypeUnscratchCard
    private(set) var message : String = ""
    private(set) var bgImage: String = ""
    private(set) var moreData: JRCBJSONDictionary = [:]
    private(set) var unscratchedCardData : JRCBRedumptionScratchCard?
    private(set) var lockedCardData: JRCBRedumptionScratchCard?
    var activeOfferData: JRCBPostTrnsactionData?
    var newOfferData: JRCBCampaign?
    private(set) var cardConfig: JRCBScratchConfigEnum = JRCBScratchConfigEnum.randomScratchColor().config
    private(set) var sCardConfig: kScratchImageConfigEnum = .trumpet
    private(set) var isCardExpiring: Bool = false
    private(set) var isLuckyDrawCard: Bool = false
    private(set) var luckyDrawAmount: NSAttributedString = NSAttributedString(string: "")
    
    func setCard(config: JRCBScratchConfigEnum) {
        self.cardConfig = config
        activeOfferData?.mCampain?.cardConfig = cardConfig
        newOfferData?.cardConfig = self.cardConfig
    }
    //shubham please check
    override init(dict: JRCBJSONDictionary) {
        message = dict.stringFor(key: "message")
        bgImage = dict.stringFor(key: "backgroundImage")
        super.init(title: message, viewAll: false, backImg: bgImage)

        if let mType = JRCBLandingScratchType(rawValue: dict.stringFor(key: "type")) {
            self.sType = mType
        }
        
        var moreDataKey = ""
        switch self.sType {
        case .sTypeUnscratchCard: moreDataKey = "unscratchedCardData"
        case .sTypeActiveOffer: moreDataKey = "activeOfferData"
        case .sTypeNew_Offer: moreDataKey = "newOfferData"
        default: break
        
        }
        
        if let mData = dict[moreDataKey] as? JRCBJSONDictionary {
            self.moreData = mData
            switch self.sType {
            case .sTypeUnscratchCard:
                let redmpScCard = JRCBRedumptionScratchCard(dict: mData)
                sCardConfig = kScratchImageConfigEnum.getRandomCardConfigInfo(scratchId: redmpScCard.scratchId)
                self.isCardExpiring = redmpScCard.isExpiring
                self.isLuckyDrawCard = redmpScCard.isLuckyDraw
                if self.isLuckyDrawCard {
                    self.luckyDrawAmount = JRCBUtils.getLuckyDrawAmount(amount: redmpScCard.redemptionMaxAmount, amountFontSize: 26.0, rupeeFontSize: 11.0)
                }
                if redmpScCard.status == .stLocked {
                    self.sType = .sTypeLockdCard
                    self.lockedCardData = redmpScCard
                    self.message = redmpScCard.unlockText
                    unscratchedCardData = nil
                } else {
                    unscratchedCardData = redmpScCard
                    if self.isCardExpiring {
                        self.message = redmpScCard.expiryText
                    } else {
                        self.message = "jr_co_scratch_now_text".localized
                    }
                }
            case .sTypeActiveOffer:
                sCardConfig = kScratchImageConfigEnum.getActiveGameInfo()
                activeOfferData = JRCBPostTrnsactionData(dict: mData)
                activeOfferData?.mCampain?.cardConfig = self.cardConfig
            case .sTypeNew_Offer:
                sCardConfig = kScratchImageConfigEnum.getActiveGameInfo()
                newOfferData = JRCBCampaign(dict: mData)
                newOfferData?.cardConfig = self.cardConfig
            default: break
                
            }
        }
    }
    
    override init(title: String, viewAll: Bool, backImg: String) {
        super.init(title: title, viewAll: viewAll, backImg: backImg)
    }
    
    func updateCardConfig(index: Int) {
        if let _ = self.lockedCardData {
            self.cardConfig = JRCBScratchConfigEnum.getLockedConfig()
        } else {
             self.cardConfig  = JRCBScratchConfigEnum.configWith(index: index)
        }
    }
}

