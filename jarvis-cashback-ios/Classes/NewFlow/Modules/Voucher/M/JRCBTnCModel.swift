//
//  JRCBTnCModel.swift
//  jarvis-cashback-ios
//
//  Created by Siddharth Suneel on 06/02/20.
//

import Foundation

struct JRCBOfferDetailModel {
    var titleText = ""
    var subtitleText = ""
    var validityText = ""
    var ctaTitle = ""
    var termsUrl: String?
    var tncModel: JRCBTnCModel?
    var isActivate: Bool = false
    var isCampaign: Bool = false
    var deeplinkURL: String = ""
    var campaignId: String = ""
    var gameId: String = ""
    
    init(model: JRCBCampaign) {
        self.isCampaign = true
        self.campaignId = model.campId
        self.titleText = model.offer_text_override
        self.subtitleText = model.short_description
        self.validityText = model.getExpiryDate()
        self.ctaTitle = self.setCTABtnTitleForCampaign(data: model)
        self.termsUrl = model.tnc
        self.tncModel = JRCBTnCModel(dict: ["termsTitle": "jr_CB_TermsConditions".localized,
                                            "terms": model.important_terms])
    }
    
    init(model: JRCBPostTrnsactionData) {
        if let trnsInfo = model.nextTransInfo {
            self.subtitleText = trnsInfo.stageObject?.stage_progress_construct ?? ""
        }
        if let campM = model.mCampain {
            self.isCampaign = false
            self.gameId = model.dataId
            self.campaignId = campM.campId
            self.titleText = campM.offer_text_override
            self.termsUrl = campM.tnc
            self.tncModel = JRCBTnCModel(dict: ["termsTitle": "jr_CB_TermsConditions".localized,
                                                "terms": campM.important_terms])
            self.validityText = self.getValidityText(model: model)
            switch model.gameStatus {
            case .gmInitialized:
                self.ctaTitle = self.setCTABtnTitleForCampaign(data: campM)
            case .gmInProgress:
                if campM.isDeeplink {
                    isActivate = false
                    deeplinkURL = campM.deeplink_url
                    ctaTitle = campM.progress_screen_cta
                } else {
                    ctaTitle = ""
                }
            default: break
                
            }
        }
    }
    
    init(model: JRCBVoucherDetailModel) {
        self.titleText = model.savingsText ?? ""
        self.subtitleText = model.descriptionText ?? ""
        self.validityText = model.validity ?? ""
        self.ctaTitle = model.cta ?? ""
        self.termsUrl = model.termsUrl
        self.isActivate = false
        self.deeplinkURL = model.deeplink ?? ""
        self.tncModel = JRCBTnCModel(dict: [:])
    }
    
    private mutating func setCTABtnTitleForCampaign(data: JRCBCampaign) -> String {
        if !data.auto_activate {
            isActivate = true
            if JRCBManager.userMode == .Merchant {
                return "jr_pay_participate".localized
            } else {
                return "jr_pay_activateOffer".localized
            }
        } else if data.isDeeplink {
            isActivate = false
            deeplinkURL = data.deeplink_url
           return data.progress_screen_cta
        } else {
           return ""
        }
    }
    
    private func getValidityText(model: JRCBPostTrnsactionData) -> String {
        if model.gameStatus == .gmInProgress || model.gameStatus == .gmInitialized {
            let expiryTime = model.getGameExpiryTime()
            if !expiryTime.isEmpty {
                return String(format: "jr_pay_timeleft".localized, expiryTime)
            }
        }
        return ""
    }
}

struct JRCBTnCModel: Codable {
    var termsTitle: String = "jr_CB_TermsConditions".localized
    var terms: String?
    
    init(dict: [String: Any]) {
        terms = dict.getStringKey("terms")
    }
}
