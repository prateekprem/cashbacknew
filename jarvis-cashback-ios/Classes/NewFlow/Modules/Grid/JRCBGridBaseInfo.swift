//
//  JRCBGridBaseInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 04/02/20.
//

import UIKit

class JRCBGridBaseInfo {
    var title: String = ""
    var subTitle: String = ""
    var backgroundImage: String = ""
    var offerIconImage: String = ""
    var isOverlay = false
    var cellType: JRCBGridViewSubType = .tUnknown
    var metaData: Any?
    var isSupported = true
    var isUnscratchCard = false
    var cardConfig = kScratchImageConfigEnum.getActiveGameInfo()
    var offerTag = ""
    
    init(dict: JRCBJSONDictionary, index: Int) {

    }
    
    var scratchCardID: String? {
        if let mmInfo = self.metaData as? JRCBLandingScratchCardInfo {
            return mmInfo.unscratchedCardData?.scratchId
        }
        return nil
    }
    
    var campain: JRCBCampaign? { // gameId
        if let mCamp = self.metaData as? JRCBCampaign {
            return mCamp
        }
        
        if let mInfo = self.metaData as? JRCBPostTrnsactionData {
            return mInfo.mCampain
        }
        
        if let mInfo = self.metaData as? JRCBLandingScratchCardInfo {
            if mInfo.sType == .sTypeActiveOffer {
                return mInfo.activeOfferData?.mCampain
            }
            
            if mInfo.sType == .sTypeNew_Offer {
                return mInfo.newOfferData
            }
        }
        
        return nil
    }
    
    func setOfferTag(_ val: String) {
        self.offerTag = val
    }
}

// used for top offers
class JRCBGridCategoryOffersInfo: JRCBGridBaseInfo {
    override init(dict: JRCBJSONDictionary, index: Int) {
        super.init(dict: dict, index: index)
        cellType = .tCategoryOffers
        let mCampain = JRCBCampaign(dict: dict)
        metaData = mCampain
        if let metaModel = metaData as? JRCBCampaign {
            title = metaModel.offer_keyword
            subTitle = metaModel.offer_text_override
            backgroundImage = metaModel.background_image_url
            if backgroundImage.isEmpty {
                backgroundImage = "https://s3-ap-southeast-1.amazonaws.com/assets.paytm.com/promotion/Rituraj/Backgrounds/background2.png?isScalingRequired=false"
            }
            offerIconImage = metaModel.new_offers_image_url
            isOverlay = metaModel.background_overlay
        }
    }
}

// used for deal and voucher data
class JRCBGridVoucherInfo: JRCBGridBaseInfo {
    var isDeal = false
    override init(dict: JRCBJSONDictionary, index: Int) {
        super.init(dict: dict, index: index)
        let scratchInfo = JRCBRedumptionScratchCard(dict: dict)
        metaData = scratchInfo
        
        if let metaModel = metaData as? JRCBRedumptionScratchCard {
            title = metaModel.frontendRedemptionType.capitalized
            if let redMetaData = metaModel.redemMetedata {
                subTitle = JRCBConstants.Symbol.kRupee + redMetaData.amount.cleanValue
                if redMetaData.redemptionType == .rDeal {
                    self.backgroundImage = metaModel.bgImageUrl
                    if let dealModel = metaModel.extraInfo  as? JRCBRedumptionDeal, !dealModel.deal_icon.isEmpty {
                        offerIconImage = dealModel.deal_icon
                    } else {
                        offerIconImage = redMetaData.redemptionIconUrl
                    }
                } else if redMetaData.redemptionType == .rCrosspromo {
                    if let voucherModel = metaModel.extraInfo as? JRCBRedumptionCrossPromo, !voucherModel.cross_promocode_icon.isEmpty {
                        offerIconImage = voucherModel.cross_promocode_icon
                    } else {
                        offerIconImage = redMetaData.redemptionIconUrl
                    }
                }
            }
        }
    }
}



//Used for offer tag
class JRCBGridScratchInfo: JRCBGridBaseInfo {
    override init(dict: JRCBJSONDictionary, index: Int) {
        super.init(dict: dict, index: index)
        cellType = .tScratchGame
        let transInfo = JRCBPostTrnsactionData(dict: dict)
        self.metaData = transInfo
        title = transInfo.unlockText
        self.offerIconImage = transInfo.mCampain?.new_offers_image_url ?? ""
        
    }
}

//Used for merged scratch grid
class JRCBGridScratchMergedInfo: JRCBGridBaseInfo {
    override init(dict: JRCBJSONDictionary, index: Int) {
        super.init(dict: dict, index: index)
        
        cellType = .tScratchGame
        metaData = JRCBLandingScratchCardInfo(dict: dict)
        if let metaModel = metaData as? JRCBLandingScratchCardInfo {
            self.cardConfig = metaModel.sCardConfig
            switch metaModel.sType {
            case .sTypeActiveOffer:
                title = metaModel.message
                self.offerIconImage = metaModel.activeOfferData?.mCampain?.new_offers_image_url ?? ""
            case .sTypeNew_Offer:
                title = metaModel.message
                self.offerIconImage = metaModel.newOfferData?.new_offers_image_url ?? ""
            default:
                self.isSupported = false
                break
            }
        }
    }
}

//Used for merged scratch grid
class JRCBGridUnscratchCardInfo: JRCBGridBaseInfo {
    
    override init(dict: JRCBJSONDictionary, index: Int) {
        super.init(dict: dict, index: index)
        
        cellType = .tScratchGame
        metaData = JRCBLandingScratchCardInfo(dict: ["unscratchedCardData": dict])
        if let metaModel = metaData as? JRCBLandingScratchCardInfo {
            self.cardConfig = metaModel.sCardConfig
            switch metaModel.sType {
            case .sTypeLockdCard:
                title = metaModel.message
            case .sTypeUnscratchCard:
                isUnscratchCard = true
                self.isSupported = metaModel.unscratchedCardData?.isSupported ?? true
                if !self.isSupported {
                    title = JRCBRemoteConfig.kCBScratchAppUpdateMsg.strValue
                } else {
                    title = metaModel.message
                }
            default:
                self.isSupported = false
                break
            }
        }
    }
}

// JRCBCampaign

class JRCBReferralInfo {
    var bonus_detail: [ReferralUserInfo]?
    var campaigns: [JRCBCampaign]?
    var referral_links: [String: Any] = [:]
    
    init(_ info: JRCBJSONDictionary) {
        if let bonus = info["bonus_detail"] as? [[String: Any]] {
            self.bonus_detail = []
            for index in bonus {
                let referral = ReferralUserInfo(index)
                self.bonus_detail?.append(referral)
            }
        }
        
        if let campai = info["campaigns"] as? [[String: Any]] {
            self.campaigns = []
            for campaign in campai {
                let cam = JRCBCampaign(dict: campaign)
                self.campaigns?.append(cam)
            }
        }
        
        if let link = info["referral_links"] as? [String: Any] {
            self.referral_links =  link
        }
    }
}

class ReferralUserInfo {
    var total_bonus: Double?
    var bonus_tile_title: String?
    var bonus_tile_icon: String?
    var bonus_detail_screen_title: String?
    var redemption_type: String?
    var info: [ReferralUser]?
    
    init(_ info: JRCBJSONDictionary) {
        self.total_bonus = info["total_bonus"] as? Double
        self.bonus_tile_title = info["bonus_tile_title"] as? String
        self.bonus_tile_icon = info["bonus_tile_icon"] as? String
        self.bonus_detail_screen_title = info["bonus_detail_screen_title"] as? String
        self.redemption_type = info["redemption_type"] as? String
 
        if let users = info["referee_info"] as? [[String: Any]] {
            self.info = []
            for user in users {
                let referralUser = ReferralUser(user)
                self.info?.append(referralUser)
            }
        }
    }
}

class ReferralUser {

    var bonus: Double?
    var display_name: String?
    var image_url: String?
    var referee_id: String?
    var image_bg_color: String?
    var display_name_initial: String?
 
    init(_ info: JRCBJSONDictionary) {
        self.bonus = info["bonus"] as? Double
        self.referee_id = info["referee_id"] as? String
        self.display_name = info["display_name"] as? String
        self.image_url = info["image_url"] as? String
        self.image_bg_color = info["image_bg_color"] as? String
        self.display_name_initial = info["display_name_initial"] as? String
    }
}


