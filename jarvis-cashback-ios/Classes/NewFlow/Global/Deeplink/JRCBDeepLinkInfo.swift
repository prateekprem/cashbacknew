//
//  JRCBDeepLinkInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 05/02/20.
//

import UIKit

public enum JRCBDeepLinkScreen: String, CaseIterable {
    case cbConsumerLanding         = "homescreen"    // show landing with consumer data
    case cbMerchantLanding         = "homescreenMerchant" // show landing with Merchant data
    case cbMyOffers                = "myoffers"
    case cbMyOfferDetail           = "offerdetails"
    case cbCompletion              = "completion"
    case cbVoucherdetails          = "voucherdetails"
    case cbCategoryNewOffer        = "categoryNewOffers"
    case cbMyOfferDetailMerchant   = "myOfferDetailMerchant"
    case cbMerchantCampaignDetail  = "merchantCampaignDetail"
    case cbMyVoucherDetail         = "myvoucherdetails"
    case cbMyVoucherList           = "myvouchers"
    case cbCampaigndetails         = "campaigndetails"
    case cbTopOffer                = "topoffer"
    case cbCashbacksummary         = "cashbacksummary"
    case cbMyScratchCards          = "myscratchcards"
    case cbSupercashCampaign       = "supercampaigndetails"
    case cbReferral                = "referral"
}

typealias cbControllerTransition = (vc: JRCBBaseVC?, shuldPush: Bool, resetStack: Bool)

class JRCBDeepLinkInfo {
    private(set) var dlURL = URL(string: "paytmmp://cash_wallet")
    private(set) var screen = JRCBDeepLinkScreen.cbConsumerLanding
    private(set) var infoDict = JRCBJSONDictionary()
    
    var shouldPopToRoot: Bool {
         return infoDict.booleanFor(key: "showHomeOnBack")
    }
    
    init(dict: JRCBJSONDictionary) {
        self.infoDict = dict
        self.parseMe()
    }
    
    init(urlS: String, param: JRCBJSONDictionary? = nil) {
        if let mURL = URL(string: urlS) {
            self.dlURL = mURL
            var mDict: JRCBJSONDictionary = self.dlURL?.queryItemsDictionary ?? [:]
            if let lParam = param {
                mDict = mDict.merge(dict: lParam)
            }
            self.infoDict = mDict
            self.parseMe()
        }
    }
    
    private func parseMe() {
        let screenNM = infoDict.stringFor(key: "screen")
        if let mScreen = JRCBDeepLinkScreen(rawValue: screenNM) { self.screen = mScreen }
    }
}


extension JRCBDeepLinkInfo {
    
    private func deeplinkVCTouple(instId: Int, txnNum: Int = -1) -> cbControllerTransition {
        let dlVC = JRCBDeepLinkVC.instance(instanceId: instId, txnNumber: txnNum, screen: screen)
        return (dlVC, true, false)
    }
    
    
    var nextVCConfig: cbControllerTransition {
        switch screen {
        case .cbConsumerLanding:
            if let offerTag = infoDict["offertag"] as? String {
                let gridVC = JRCBGridVC.gridVCWith(offerTag:offerTag, type: .tOfferTag, extraParam: infoDict)
                return (gridVC, true, false)
            }
            
            return (JRCBLandingVC.newInstance, true, false)
            
        case .cbMerchantLanding :
            if let screenType = infoDict["screentype"] as? String, screenType.lowercased() == "voucher" {
                let landingVC = JRCBMerchLandingVC.newInstance
                landingVC.setLandingType(lType: .typeVoucher)
                return (landingVC, true, false)
            }
            return (JRCBMerchLandingVC.newInstance, true, false)
            
        case .cbMyOffers: return (JRCBLandingVC.newInstance, true, false)
            
        case .cbCategoryNewOffer :
            if let offertag = infoDict["offertag"] as? String {
                let gridVC = JRCBGridVC.gridVCWith(offerTag: offertag, type: .tCategoryOffers, extraParam: infoDict)
                return (gridVC, true, false)
            }
            
            let landingVC = JRCBLandingVC.newInstance
            return (landingVC, true, false)
            
        case .cbMyVoucherDetail:
           
            if let promocode = infoDict["promocode"] as? String {
                let siteid = infoDict.intFor(key: "siteid")
                let clientid = infoDict.stringFor(key: "clientid")
                let type = infoDict.stringFor(key: "type")

                let input = JRCBVoucherDetailInput(promoCode: promocode, site_id: siteid, client_id: clientid, type: type)
                return (input.detailVC(), true, false)
            }
            
        case .cbMyVoucherList, .cbVoucherdetails:
            let vc = JRCBVoucherDealsListVC.newInstance
            return (vc, true, false)
            
//            let gridVC = JRCBGridVC.newInstance
//            let gridType: JRCBGridViewType = .tVouchers
//            gridVC.setGrid(type: gridType, headerInfo: gridType.defaultHeaderInfo)
//            return (gridVC, true, false)
            
        case .cbCashbacksummary:
            if let offerTag = infoDict["offerType"] as? String,
                let lType = JRCBPointListVM.typeWith(offerType: offerTag) {
                let vc = JRCBPointListVC.newInstance(type: lType)
                return (vc, true, false)
            }
        
            let landingVC = JRCBLandingVC.newInstance
            return (landingVC, true, false)
            
        case .cbMyScratchCards:
            let gridVC = JRCBGridVC.newInstance
            let gridType: JRCBGridViewType = .tAllScratchCard
            gridVC.setGrid(type: gridType, headerInfo: gridType.defaultHeaderInfo)
            return (gridVC, true, false)
            
        case .cbMyOfferDetail, .cbCompletion, .cbMyOfferDetailMerchant:
            let gameid = infoDict.intFor(key: "gameid")
            if let stage = infoDict["stageNumber"] as? String {
                return self.deeplinkVCTouple(instId: gameid, txnNum: Int(stage) ?? 0)
            }
            return self.deeplinkVCTouple(instId: gameid)
            
        case .cbMerchantCampaignDetail, .cbCampaigndetails, .cbTopOffer, .cbSupercashCampaign:
            let campaignid = infoDict.intFor(key: "campaignid")
            return self.deeplinkVCTouple(instId: campaignid)
        case .cbReferral:
            let tag = infoDict.stringFor(key: "tag")
            let utmS = infoDict.stringFor(key: "utm_source")
            let viewController = CBReferralLandingViewController.newInstanse(tag: tag, utmSource: utmS)
            return (viewController, true, false)
        }
                
        return (nil, true, false)
    }
}
