//
//  JRCBDeelNVoucherDetailCellVM.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 30/07/20.
//

import Foundation

class JRCBDeelNVoucherDetailCellVM {
    private(set) var bannerImgUrl = JRCBRemoteConfig.kCBGridHeaderVoucherURL.strValue
    private(set) var wonUpToTxt = "jr_CB_YouWon".localized
    private(set) var titleTxt  =  ""
    private(set) var validity  = ""
    private(set) var descTxt   = ""
    
    private(set) var pinTtl   = "jr_CB_PINString".localized
    private(set) var pinValue = ""
    
    private(set) var voucherCodeTtl = "jr_CB_CopyAndAvail".localized
    private(set) var mPromoCode: String?
    
    private(set) var cta       = ""
    private(set) var earnedForText =  ""
    
    private(set) var deepLink: String?
    private(set) var tnc     : String?
    private(set) var tncModel: JRCOTNCModel?
    
    private(set) var iconUrl = ""
    private(set) var mOfferDetailModel: JRCBOfferDetailModel?
    private(set) var isExpiredSoon = false
    private(set) var status: String?
    
    private(set) var cellCount = 0
    
    var isExpired: Bool {
        if let vStatus = self.status, vStatus != "ACTIVE" {
            return true
        }
        return false
    }
    
    var isCTAAvailable: Bool {
        var showCTA = false
        if let aDeepLink = self.deepLink, aDeepLink.count > 0 {
            showCTA = self.cta.count > 0
        }
        return showCTA
    }
    
    var ctaTitle: String? {
        return self.isCTAAvailable ? self.cta : "jr_CB_MoreDetails".localized
    }
    
    var mIconPlaceholder: UIImage { UIImage.Grid.Placeholder.offersPlaceholder }
    
    func fetchDetailWith(input: JRCBVoucherDetailInput,
                         completion: @escaping (Bool, JRCBError?) -> Void) {
        guard JRCBCommonBridge.isNetworkAvailable else {
            completion(false, JRCBError.networkError)
            return
        }
        
        switch input.detailType {
        case .voucher:
            self.fetchVoucherDetailWith(input: input, completion:completion)
        case .deal:
            self.fetchDealDetailWith(input: input, completion:completion)
        }
    }
    
    func updateWith(dealModel: Any?) {
        if let dealVM = dealModel as? DealDataModel { //From Deeplink
            setupDealForDealDataModel(dealData: dealVM)
        } else if let dealData = dealModel as? DealDataModel {
            setupDealForDealDataModel(dealData: dealData)
            
        } else if let dealData = dealModel as? JRCODealModel {
            self.cellCount = 1
            self.iconUrl = dealData.deal_icon
            self.titleTxt = dealData.deal_text
            self.mPromoCode = dealData.deal_voucher_code
            self.descTxt = dealData.deal_usage_text
            self.validity = self.expiryText(frmDt: dealData.display_valid_from, toDt: dealData.display_valid_upto)
            if dealData.secret != "" {
                self.pinValue =  dealData.secret
            }
            self.tncModel = dealData.tnc_model
        }
    }
}

// MARK: - API and rtesponse
private extension JRCBDeelNVoucherDetailCellVM {
    
    func fetchVoucherDetailWith(input: JRCBVoucherDetailInput,
                                completion: @escaping (Bool, JRCBError?) -> Void) {
        
        let params : [String : Any] = ["site_id": input.siteID, "locale": "\(Locale.current.identifier)", "client_id": input.clientId ?? "", "type": input.type ?? ""]
        JRCBServices.serviceGetVoucherDetail(voucherCode: input.promocode ?? "", params: params) {[weak self](voucherDetailModel, error) in
            if error == nil && voucherDetailModel != nil {
                self?.cellCount = 1
                self?.updateWith(voucherResp: voucherDetailModel?.response)
                completion(true, nil)
            } else {
                completion(false, error)
            }
        }
    }
    
    func fetchDealDetailWith(input: JRCBVoucherDetailInput,
                             completion: @escaping (Bool, JRCBError?) -> Void) {
        guard let sId = input.scratchId else {
            completion(false, nil)
            return
        }
        
        let mScratchCard = JRCBRedumptionScratchCard(sId: sId)
        mScratchCard.getScratchCardById { [weak self](isSuccess, errS) in
            self?.cellCount = 1
            self?.updateWith(scratchCard: mScratchCard)
            completion(isSuccess, isSuccess ? nil : JRCBError(aTitle: nil, aMessage: errS))
        }
    }
    
    private func updateWith(voucherResp: JRCOMyVoucherDetailModel?) {
        guard let vDetail = voucherResp else { return }
        
        self.iconUrl    = vDetail.icon ?? ""
        let savingTxt  = vDetail.savingsText ?? ""
        
        if vDetail.redemptionType == "VOUCHER" {
            var ttl = ""
            if let mTitle = vDetail.title {
                ttl = mTitle + " voucher - " + savingTxt
            } else {
                ttl = "Voucher - " + savingTxt
            }
            self.titleTxt = ttl
            self.validity   = vDetail.validity ?? ""
        }
        else{
            self.titleTxt = vDetail.descriptionText ?? ""
            self.validity   = getValidity(fromDate: vDetail.validFrom, toDate: vDetail.validUpto)
        }
        if let winningText =  vDetail.winningText, winningText.length > 0 {
            self.wonUpToTxt = winningText
        }
        
        if vDetail.redemptionType == "VOUCHER", let mDesc = vDetail.descriptionText {
            self.descTxt    = "\("jr_CB_VoucherDetailsDescPreText".localized) \(mDesc)"
        }
        else {
            self.descTxt = vDetail.usageText ?? ""
        }
        self.mPromoCode = vDetail.promocode ?? ""
        self.cta        = vDetail.cta ?? ""
        
        
        self.deepLink   = vDetail.deeplink
        
        if vDetail.redemptionType == "DEAL" {
            var termT = ""
            var redeemT = ""
            if let tT = vDetail.termsText {
                termT = tT
            }
            if let rT = vDetail.redemptionTermsText {
                redeemT = "<br><h3>" +  "jr_CB_HowtoRedeem".localized + "</h3>"  + rT
            }
            
            self.tncModel = JRCOTNCModel( termsTitle: "jr_CB_TermsConditions".localized, termsDescription: termT + redeemT)

        } else {
            self.tnc = vDetail.termsUrl
        }
        
        self.pinValue  =  vDetail.secret ?? ""
        
       
        self.isExpiredSoon = vDetail.isExpireSoon ?? false
        self.status        = vDetail.status
        if let bg = vDetail.bgImage {
            self.bannerImgUrl = bg
        }
        
         self.earnedForText  = vDetail.earnedForText ?? ""
        if let earnTxt = vDetail.earnedForText , !earnTxt.isEmpty {
            self.earnedForText = "jr_CB_VoucherWonForText".localized + earnTxt
        }
    }
    
    private func getValidity(fromDate: String?, toDate: String?) -> String {
        
         let fromStr = getFormatedDate(dateStr: fromDate)
         let toStr = getFormatedDate(dateStr: toDate)
         return self.expiryText(frmDt: fromStr ?? "", toDt: toStr ?? "")
    }
    
    private func getFormatedDate(dateStr: String?) -> String? {
        if dateStr != nil {
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "en_IN")
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
            if let date = dateFormatter.date(from: dateStr!) {
                dateFormatter.dateFormat = "d MMM yyyy"
                return dateFormatter.string(from: date)
            }
        }
        
        return nil
    }
    
    
    
    private func updateWith(scratchCard: JRCBRedumptionScratchCard) {
        if scratchCard.bgImageUrl.count > 0 { self.bannerImgUrl = scratchCard.bgImageUrl }
        if !scratchCard.earnedForText.isEmpty {
            self.earnedForText = "jr_CB_VoucherWonText".localized + scratchCard.earnedForText
        }
        
        if let data = scratchCard.extraInfo as? JRCBRedumptionDeal {
            self.iconUrl = data.deal_icon
            self.titleTxt = data.deal_text
            
            let validFrom = JRCOUtils.getDateForDeal(inputDate: data.deal_valid_from)
            let validTo = JRCOUtils.getDateForDeal(inputDate: data.deal_expiry)
            self.validity = self.expiryText(frmDt: validFrom, toDt: validTo)
            
            self.descTxt = data.deal_usage_text
            
            self.mPromoCode = data.deal_voucher_code
            self.pinValue  = data.secret
        
            self.cta  = data.cta
            self.deepLink  = data.ctaDeeplink
            self.tncModel = JRCOTNCModel( termsTitle: "jr_CB_TermsConditions".localized, termsDescription: data.deal_redemption_terms)
            
        } else if let data = scratchCard.extraInfo as? JRCBRedumptionCrossPromo {
            self.iconUrl = data.cross_promocode_icon
            self.titleTxt = data.cross_promo_text
            
            let validFrom = JRCOUtils.getDateForDeal(inputDate: data.valid_from)
            let validTo = JRCOUtils.getDateForDeal(inputDate: data.valid_upto)
            self.validity = self.expiryText(frmDt: validFrom, toDt: validTo)
            self.descTxt = data.cross_promo_usage_text
            
            self.cta  = data.cta
            self.deepLink  = data.cta_deeplink
            self.tnc  = data.terms_conditions
        }
    }
    
    
    private func expiryText(frmDt: String, toDt: String) -> String {
        if frmDt.isEmpty, toDt.isEmpty { return "" }
        if frmDt.isEmpty { return JRCBConstants.Common.kValidTill + toDt }
        if toDt.isEmpty { return JRCBConstants.Common.kValidFrom + frmDt }
        return "\(JRCBConstants.Common.kValidFrom) \(frmDt) \(JRCBConstants.Common.kToString) \(toDt)"
    }
    
    
    private func setupDealForDealDataModel(dealData: DealDataModel) {
        self.cellCount = 1
        self.iconUrl = dealData.deal_icon
        self.titleTxt = dealData.deal_text
        self.mPromoCode = dealData.deal_voucher_code
        self.descTxt = dealData.deal_usage_text
        self.validity = self.expiryText(frmDt: dealData.display_valid_from, toDt: dealData.display_valid_upto)
        if dealData.secret != "" {
            self.pinValue =  dealData.secret
        }
        self.tncModel = dealData.tnc_model
    }
}


struct JRCBVoucherDetailModel: Codable {
    var savingsText: String?
    var promocode: String?
    var usageText: String?
    var icon: String?
    var descriptionText: String?
    var cta: String?
    var termsUrl: String?
    var status: String?
    var validity: String?
    var deeplink: String?
    var isExpireSoon: Bool?
}
