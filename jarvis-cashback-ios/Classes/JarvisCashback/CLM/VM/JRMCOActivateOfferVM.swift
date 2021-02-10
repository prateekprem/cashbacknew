//
//  JRMCOActivateOfferVM.swift
//  jarvis-cashback-ios
//
//  Created by Nikita Maheshwari on 13/08/19.
//

import Foundation

enum MerchantOfferType {
    case newOffer
    case myOffer
}

enum ActivateNewOfferRows{
    case offerDetails
    case clockView
    case activaterBtn
    case stageDetail
}

class JRMCOActivateOfferVM {
    
    private(set) var headerTitle: String = ""
    private(set) var offerImage: String = ""
    private(set) var headerSubTitle: String = ""
    private(set) var headerBackgroundImage: String = ""

    private(set) var tncHeadingTxt: String = ""
    private(set) var tncLabelTxt: String = ""
    private(set) var offerImpTerms: String = ""
    private(set) var viewAllBtnText: String = ""
    private(set) var navigationTitle: String = ""
    
    private(set) var multiStageIcon: String = ""
    private(set) var multiStageTitle: String = ""
    private(set) var offerLabelTxt: String = ""

    private(set) var clockImage: String = ""
    private(set) var validityLabelText: String = ""

    private(set) var offusTxnLblText: String = ""
    private(set) var deeplinkBtnTxt: String = ""
    private(set) var activateBtnAnimationLblTxt: String = ""
    private(set) var activateBtnTxt: String = ""
    private(set) var isDeeplink: Bool = false
    
    private(set) var campaignID: Int = 0
    private(set) var tncUrl: String = ""
    private(set) var merchantOfferType: MerchantOfferType = .newOffer
    private(set) var activateOfferTitleTxt: String = ""
    private(set) var stageLblText: String = ""
    private(set) var offerID: String = ""

    private(set) var offersList: [ActivateNewOfferRows] = [.offerDetails, .clockView, .activaterBtn]
    
    init() {}
    
    init(viewModel: Any) {
        if viewModel is JRMCONewOfferViewModel {
            let data = viewModel as! JRMCONewOfferViewModel
            let campaignData = data.getMerchantCampaignVMData()
            merchantOfferType = .newOffer
            validityLabelText = String(format: "jr_pay_offerValid".localized,
                                       campaignData.valid_upto.getFormattedDateString("dd MMM yyyy"))
            parseNewOfferDataInVM(campaignData: campaignData)
            
        } else if viewModel is JRMCOMyOfferViewModel {
            let data = viewModel as! JRMCOMyOfferViewModel
            activateOfferTitleTxt = data.initialized_offer_text
            validityLabelText = data.offer_remaining_time
            offerID = data.offer_id
            merchantOfferType = .myOffer
            parseNewOfferDataInVM(campaignData: data.campaignViewModel)
        }
    }
    
    private func parseNewOfferDataInVM(campaignData: MerchantCampaignViewModel) {
        stageLblText = "jr_CB_FirstPaymntRecv".localized
        multiStageIcon = "icTick3"
        multiStageTitle = "jr_co_Offer_detail".localized.uppercased()
        offerLabelTxt = campaignData.surprise_text
        if merchantOfferType == .newOffer {
            clockImage = "icTime_gray"
            offersList = [.offerDetails, .clockView, .activaterBtn]
        } else {
            clockImage = "icTime_orange"
            offersList = [.stageDetail, .clockView, .activaterBtn, .offerDetails]
        }
        
        if JRCBManager.userMode == .Merchant {
            activateBtnTxt = "jr_pay_participate".localized
            activateBtnAnimationLblTxt = "jr_pay_participated".localized
        } else {
            activateBtnTxt = "jr_pay_activateOffer".localized
            activateBtnAnimationLblTxt = "jr_pay_activatedOffer".localized
        }
        
        offusTxnLblText = ""
        tncHeadingTxt = "jr_pay_offerterms".localized
        tncLabelTxt = campaignData.important_terms
        isDeeplink = campaignData.isDeeplink
        campaignID = campaignData.campId
        headerTitle = campaignData.getCampaignTitleText()
        headerBackgroundImage = campaignData.background_image_url
        headerSubTitle = campaignData.short_description
        tncUrl = campaignData.tnc_url
    }
    
    
    func numberOfRows() -> Int {
        return offersList.count
    }
    
    func getRowForIndex(row: Int) -> ActivateNewOfferRows {
        var mRow = max(0, row)
        mRow = min(offersList.count-1, mRow)
        return offersList[mRow]
    }
    
    func activateMerchantOffers(completion: @escaping (JRMCOMyOfferViewModel,Bool, NSError?) -> Void) {
        var aModel : JRCBApiModel?
        if merchantOfferType == .newOffer {
            aModel = JRCBApiModel(type: .pathCBMerchantActivateOfferV2, param: nil, body: ["action": "ACCEPT_OFFER"], appendUrlExt: "/\(campaignID)")
        } else {
            aModel = JRCBApiModel(type: .pathCBMerchantActivateGame, param: nil, body: ["action": "ACCEPT_OFFER"], appendUrlExt: "/\(offerID)")
        }
        guard let apiModel = aModel else { return }
        
        JRCBServiceManager.executeAPI(model: apiModel) { (isSuccess, response, error) in
            guard let resp = response as? JRCBJSONDictionary else {
                if let err = error {
                    completion(JRMCOMyOfferViewModel(dict: [:]), false, err as NSError)
                } else {
                    completion(JRMCOMyOfferViewModel(dict: [:]), false, JRCBServiceManager.genericError as NSError?)
                }
                return
            }
            
            completion(JRMCOMyOfferViewModel(dict: resp), true, nil)
        }
    }
}

