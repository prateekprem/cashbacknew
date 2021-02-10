//
//  JRCBScratchContentVM.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 23/05/20.
//

import Foundation

enum JRCBCardTriggerType: String {
    case appOpen = "app_open"
    case postTransaction = "post_transaction"
    case cashbackSection = "cashback"
}

class JRCBScratchContentVM {
    
    private(set) var logoImageURL: String = ""
    private(set) var congratsText: String = ""
    private(set) var wonText: String = ""
    private(set) var prizeText: String = ""
    private(set) var frontRedText: String = ""
    private(set) var offerNameText: String = ""
    private var assuredOfferNameTxt: String = ""
    private(set) var bannerText: String = ""
    private(set) var detailBtnText: String = ""
    private(set) var redemptionText: String = ""

    private(set) var placeholderIcon: UIImage = UIImage()
    
    private(set) var cardType: JRCBCardType = .unknown
    private(set) var detailDeeplink: String = ""

    private(set) var modelData: JRCBGratification!
    
    private(set) var isFromScrstchCardSection = true
    private(set) var campaignId: String = ""
    
    private(set) var isLuckyDrawCard = false
    private(set) var luckyDrawAmountText: NSMutableAttributedString = NSMutableAttributedString()
    private(set) var cardHeadlineText: String = ""
    
    private(set) var collectibleStickerText: String = ""
    private(set) var cardTriggerType: JRCBCardTriggerType = .postTransaction
    
    var canScratch: Bool {
        if !self.shouldShowScratch { return false }
        
        if let dm = self.modelData, let redumpInfo = dm.redumptionInfo as? JRCBRedumptionScratchCard  {
            if self.cardType == .locked || self.cardType == .superCashGame      { return false }
            if redumpInfo.isUserScratched     { return false }
            if redumpInfo.status.canScratch() { return true }
            if redumpInfo.loadingState != .cbSuccess { return false }
            
        }
        return false
    }
    
    var shouldShowScratch: Bool {
        if let dm = self.modelData, let redumpInfo = dm.redumptionInfo as? JRCBRedumptionScratchCard  {
            if self.cardType == .locked || self.cardType == .superCashGame  { return false }
            if dm.isAssuredCard                { return false }
            if redumpInfo.status.isScratched() { return false }
            return true
        }
        return false
    }
    
    var scratchId: String? {
        if modelData == nil { return nil }
        
        if let info = modelData.redumptionInfo as? JRCBRedumptionScratchCard {
            return info.scratchId
        }
        return nil
    }
    
    var getCardMaskConfig: kScratchImageConfigEnum? {
        if let scratchIds = self.scratchId {
           return kScratchImageConfigEnum.getRandomCardConfigInfo(scratchId: scratchIds)
        }
        
        return nil
    }
    
    init(modelData: JRCBGratification, assuredOfferName: String = "") {
        self.updateWith(grtfInfo: modelData, offerName: assuredOfferName)
    }
    
    func updateWith(grtfInfo: JRCBGratification, offerName: String = "") {
        self.modelData = grtfInfo
        if let scratchCardInfo = modelData.redumptionInfo as? JRCBRedumptionScratchCard {
            //Scratch Card Data handling
            self.setScratchCardData(cashbackModel: scratchCardInfo)
            
        } else { //Assured Card Data handling
            self.assuredOfferNameTxt = offerName
            self.setAssuredCardData(cashbackModel: modelData)
            
        }
    }
    
    func updatewith(grDist: JRCBJSONDictionary) {
        if self.modelData == nil { return }
        
        if let scratchCardInfo = modelData.redumptionInfo as? JRCBRedumptionScratchCard {
            scratchCardInfo.updateScratchCardWith(dict: grDist)
            scratchCardInfo.setLoadingState(state: .cbSuccess)
            self.updateWith(grtfInfo: modelData)
        }
    }
    
    private func setScratchCardData(cashbackModel: JRCBRedumptionScratchCard) {
        
        let cardType = JRCBCardType.getCardTypeForScratchCard(modelData: cashbackModel)
        self.cardType = cardType
        
        self.cardHeadlineText = cashbackModel.cardHeadline
        if cardType != .unknown {
            isLuckyDrawCard = cashbackModel.isLuckyDraw
            let attrStr = JRCBUtils.getLuckyDrawAmount(amount: cashbackModel.redemptionMaxAmount, amountFontSize: 40.0, rupeeFontSize: 16.0)
            luckyDrawAmountText = NSMutableAttributedString(attributedString: attrStr)
            
            if cardType == .betterLuckNextTime {
                redemptionText = cashbackModel.winningText.isEmpty ? JRCBConstants.Symbol.kBetterLuck : cashbackModel.winningText
                logoImageURL = self.getScratchImageURL(cashbackModel: cashbackModel)
                placeholderIcon = UIImage.ScratchCard.ScratchIcon.betterLuck
            } else if cardType == .locked {
                bannerText = cashbackModel.unlockText
                
            } else if cardType == .superCashGame {
                bannerText = cashbackModel.unlockText
                logoImageURL = cashbackModel.redemMetedata?.redemptionIconUrl ?? ""
                placeholderIcon = UIImage.Grid.Placeholder.offersPlaceholder
            } else if cardType == .flipCard {
                logoImageURL = self.getScratchImageURL(cashbackModel: cashbackModel)
                placeholderIcon = UIImage.ScratchCard.ScratchIcon.betterLuck
                detailBtnText = cashbackModel.flipCtaText
                redemptionText = cashbackModel.flipText
            } else {
                placeholderIcon = UIImage.Grid.Placeholder.offersPlaceholder
                logoImageURL = self.getScratchImageURL(cashbackModel: cashbackModel)
                if cashbackModel.earnedForText.isEmpty {
                    redemptionText = cashbackModel.redemptionText
                } else {
                    redemptionText = cashbackModel.earnedForText + ". " + cashbackModel.redemptionText
                }
                congratsText = cashbackModel.winningTitle
                wonText = cashbackModel.winningText.capitalized
                if cardType != .cricketCard {
                    frontRedText = cashbackModel.frontendRedemptionType.capitalized
                }
                if let redMetaData = cashbackModel.redemMetedata {
                    if cardType == .coins {
                        prizeText = redMetaData.amount.cleanValue
                    } else if cardType == .cricketCard {
                        prizeText = cashbackModel.frontendRedemptionType.capitalized
                    } else {
                        prizeText = JRCBConstants.Symbol.kRupee + redMetaData.amount.cleanValue
                    }
                }
                
                if let extraInfo = cashbackModel.extraInfo as? JRCBRedumptionCashGoldBack {
                    if extraInfo.collectibleDisplayType.lowercased() == JRCBConstants.Common.kStickerCollectibleType {
                        collectibleStickerText = "jr_CB_StickerString".localized
                    } else {
                        collectibleStickerText = ""
                    }
                }
                
                if let sourceMetaData = cashbackModel.sourceMetedata {
                    offerNameText = sourceMetaData.offerName
                }
                
                detailDeeplink = cashbackModel.redemptionCtaDeeplink
                if !cashbackModel.redemptionCtaText.isEmpty {
                    detailBtnText = cashbackModel.redemptionCtaText
                }
            }
            
        } else {
            bannerText = JRCBRemoteConfig.kCBScratchAppUpdateMsg.strValue
        }
    }
    
    private func getScratchImageURL(cashbackModel: JRCBRedumptionScratchCard) -> String {
        var imageURL = ""
        
        if self.cardType == .cricketCard || self.cardType == .betterLuckNextTime || self.cardType == .flipCard {
            if let redMetaData = cashbackModel.redemMetedata {
                imageURL = redMetaData.redemptionIconUrl
            }
        } else if let dealModel = cashbackModel.extraInfo as? JRCBRedumptionDeal {
            imageURL = dealModel.deal_icon
        } else if let voucherModel = cashbackModel.extraInfo as? JRCBRedumptionCrossPromo {
            imageURL = voucherModel.cross_promocode_icon
        }
        
        return imageURL
    }
    
    
    private func setAssuredCardData(cashbackModel: JRCBGratification) {
        let cardType = JRCBCardType.getCardTypeForAssured(modelData: cashbackModel)
        self.cardType = cardType
        
        if cardType != .unknown {
            if cardType == .betterLuckNextTime {
                resetData()
                redemptionText = JRCBConstants.Symbol.kBetterLuck
                placeholderIcon = UIImage.ScratchCard.ScratchIcon.betterLuck
            } else if cardType == .superCashGame {
                if let superGameData = cashbackModel.redumptionInfo as? JRCBRedumptionSuperCashGame {
                    bannerText = superGameData.unlock_text
                    logoImageURL = superGameData.offer_image_url
                }
            } else {
                placeholderIcon = UIImage.Grid.Placeholder.offersPlaceholder
                logoImageURL = getAssuredImageURL(cashbackModel: cashbackModel)
                redemptionText = cashbackModel.redemption_text
                congratsText = cashbackModel.winnning_title
                wonText = cashbackModel.progrss_text.capitalized
                frontRedText = cashbackModel.frontend_redemption_typeBase.capitalized
                if cashbackModel.redemption_type == .rCoins {
                    prizeText = cashbackModel.bonus_amount.cleanValue
                } else {
                    prizeText = JRCBConstants.Symbol.kRupee + cashbackModel.bonus_amount.cleanValue
                }
                
                offerNameText = self.assuredOfferNameTxt
            }
        } else {
            bannerText = JRCBRemoteConfig.kCBScratchAppUpdateMsg.strValue
        }
    }
    
    private func getAssuredImageURL(cashbackModel: JRCBGratification) -> String {
        var imageURL = ""
        
        if let dealModel = cashbackModel.redumptionInfo as? JRCBRedumptionDeal {
            imageURL = dealModel.deal_icon
        } else if let voucherModel = cashbackModel.redumptionInfo as? JRCBRedumptionCrossPromo {
            imageURL = voucherModel.cross_promocode_icon
        }
        
        return imageURL
    }
    
    private func resetData() {
        redemptionText = ""
        congratsText = ""
        wonText = ""
        frontRedText = ""
        prizeText = ""
        offerNameText = ""
        detailBtnText = ""
        detailDeeplink = ""
    }
}

extension JRCBScratchContentVM {
    
    func setIsFromScratchCardSection(_ value: Bool) {
        self.isFromScrstchCardSection = value
    }
    
    func getCurrentGratification() -> JRCBGratification {
        return self.modelData
    }
    
    func getFlipCardReferenceId() -> String? {
        if let scratchData = self.modelData.redumptionInfo as? JRCBRedumptionScratchCard {
            if !scratchData.referenceId.isEmpty {
                return scratchData.referenceId
            }
        }
        return nil
    }
    
    func getAnalyticsScreen() -> JRCBAnalyticsScreen {
        let screen: JRCBAnalyticsScreen = isFromScrstchCardSection ? .screen_CashbackLanding: .screen_PostOrder
        return screen
    }
    
    func setCampaignId(campId: String? = "") {
        self.campaignId = campId ?? ""
    }
    
    func getCampaignId() -> String {
        return self.campaignId
    }
    
    func setCardTriggerType(_ val: JRCBCardTriggerType) {
        self.cardTriggerType = val
    }
}
