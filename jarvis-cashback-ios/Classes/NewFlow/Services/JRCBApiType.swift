//
//  JRCBApiType.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 27/12/19.
//

import Foundation
import jarvis_network_ios

enum JRCBApiType: String {
    case pathCustomAPI        = "" //For API where path is not defined
    case pathV4PostTxnAsync             = "cashbackPostTxnAsyncV4Url"
    case pathScratchCardById            = "cashbackScratchCardById"
    case pathUpdateScratchCard          = "pathUpdateScratchCard"
    case pathFetchUserTransAnalytics    = "fetchTotalCashback"
    case pathFetchCampaignsList         = "cashbackNewOffersV4"
    
    case pathFetchCashbackCoinList      = "pathCashbackCoinList"
    case pathFetchCashbackLandingSF     = "cashbackLandingSFV2"//cashbackLandingSF
    case pathFetchCBLandingScratchCard  = "cblandingMergedOffers"
    case pathFetchCBCoinSummary         = "cbLandingCBCoins"
    case pathFetchCampaignDetail        = "cashbackCampaignDetailV4Url"
    case pathFetchGameDetail            = "pathFetchGameDetail"
    case pathSelectOfferV4              = "cashbackSelectOfferV4Url"
    case pathActivateGameV4             = "cashbackAllOffersV4Url"
    
    case pathVoucherList                = "cashBackMyVouchersV3Url"
    case pathMyVouchersDetailV3Url      = "cashBackMyVouchersDetailV3Url"
    case pathMyVoucherFilterV1Url       = "cashbackMyVoucherFilterV1Url"
    case pathPostTxnStoreFrontUrl       = "postTxnStoreFrontUrl"
    case pathCBMerchGamePmntDetailV1    = "merchantCashbackGameTransactions"
    case pathCBMerchantNewOffersV1      = "merchantActivateNewOfferV1"
    case pathCBMerchantGameListV2       = "merchantCashbackGameListV2"
    case pathCBMerchantActivateOfferV2  = "merchantCashbackActivateOfferV2"
    case pathCBMerchantActivateGame     = "merchantCashbackActivateGame"
    case pathGetMerchantContext         = "accept_payment_merchant_context"
    
    case appOpen                        = "appOpen"
    
    case referralLanding                = "referral_landing"
    case referrallink                   = "referral_offer_link"
    case referral_campign_image         = "referral_campign_image"
    case saveShortURL                   = "referral_caching_short_url"
    
}

extension JRCBApiType {
    var urlString: String {
        if JRCashbackManager.shared.shouldMock {
            return mockDefaultValues
        }
        
        var key = self.rawValue
        if self.rawValue == JRCBApiType.pathUpdateScratchCard.rawValue || self.rawValue == JRCBApiType.pathFetchCashbackCoinList.rawValue {
            key = JRCBApiType.pathScratchCardById.rawValue
        }
        
        guard let value = JRCBCommonBridge.remoteStringFor(key: key), value != "" else {
            return defaultURLString
        }
        return value
    }
    
    var defaultURLString: String {
        
        if JRCashbackManager.shared.config.cbEnvironment == .staging {
            return stagingDefaultValues
        }
        switch self {
        case .pathCustomAPI: return ""
        case .pathV4PostTxnAsync            : return "https://gateway.paytm.com/api/v4/promocard/supercash/check/txn-order-status"
        case .pathScratchCardById           : return "https://gateway.paytm.com/api/v1/scratch-card/ext/"
        case .pathFetchCashbackCoinList     : return "https://gateway.paytm.com/papi/v1/scratch-card/ext/"
        case .pathUpdateScratchCard         : return "https://gateway.paytm.com/api/v1/scratch-card/ext/"
        case .pathFetchUserTransAnalytics   : return "https://trust.paytm.in/service/fetchUserTransactionAnalytics"
        case .pathFetchCampaignsList        : return "https://gateway.paytm.com/api/v4/promocard/supercash/campaigns/list"
        case .pathFetchCashbackLandingSF    : return "https://storefront.paytm.com/v2/h/game-widget"
        case .pathFetchCBLandingScratchCard : return "https://gateway.paytm.com/api/v4/promocard/supercash/cashbackLandingPage"
        case .pathFetchCBCoinSummary        : return "https://gateway.paytm.com/api/promoapi/v1/scratchcard/summary"
        case .pathFetchCampaignDetail       : return "https://gateway.paytm.com/api/v4/promocard/supercash/campaign-games/"
        case .pathFetchGameDetail           : return "https://gateway.paytm.com/api/v4/promocard/supercash/"
        case .pathSelectOfferV4             : return "https://gateway.paytm.com/api/v4/promocard/supercash/campaigns/select-offer"
        case .pathActivateGameV4            : return "https://gateway.paytm.com/api/v4/promocard/supercash"
        case .pathVoucherList               : return "https://gateway.paytm.com/api/v1/promosearch/voucher/list"
        case .pathMyVouchersDetailV3Url     : return "https://gateway.paytm.com/api/v1/promosearch/voucher/detail"
        case .pathMyVoucherFilterV1Url      : return "https://gateway.paytm.com/api/v1/promosearch/voucher/facets"
        case .pathPostTxnStoreFrontUrl      : return "https://storefront.paytm.com/v2/h/post-txn-banner"
        case .pathCBMerchGamePmntDetailV1   : return "https://gateway.paytm.com/api/v1/mpromocard/supercash/%d/transactions"
        case .pathCBMerchantNewOffersV1     : return "https://gateway.paytm.com/api/v1/mpromocard/campaigns"
        case .pathCBMerchantGameListV2      : return "https://gateway.paytm.com/api/v2/mpromocard/supercash"
        case .pathCBMerchantActivateOfferV2 : return "https://gateway.paytm.com/api/v2/mpromocard/campaigns"
        case .pathCBMerchantActivateGame    : return "https://gateway.paytm.com/api/v1/mpromocard/supercash"
        case .pathGetMerchantContext        : return "https://dashboard.paytm.com/api/v1/context"
        case .appOpen: return "https://gateway.paytm.com/api/v4/promocard/supercash/eventOffer"
        case .referralLanding               : return "https://gateway.paytm.com/api/v5/promocard/supercash/referral"
        case .referrallink : return "https://gateway.paytm.com/api/v5/promocard/supercash/referral/link"
        case .referral_campign_image : return "https://paytm.s3-ap-southeast-1.amazonaws.com/promo_seller_panel_uploads/production/referEarnHeroBanner%402x%5B1%5D.png"
            
        case .saveShortURL                  : return "https://gateway.paytm.com/api/v5/promocard/supercash/referral/short-url"
        
        }
    }
    
    var stagingDefaultValues: String {
        switch self {
        case .pathCustomAPI                 : return ""
        case .pathV4PostTxnAsync            : return "https://staging.paytm.com/papi/v4/promocard/supercash/check/txn-order-status"
        case .pathScratchCardById           : return "https://staging.paytm.com/papi/v1/scratch-card/ext/"
        case .pathFetchCashbackCoinList     : return "https://staging.paytm.com/papi/v1/scratch-card/ext/"
        case .pathUpdateScratchCard         : return "https://staging.paytm.com/papi/v1/scratch-card/ext/"
        case .pathFetchUserTransAnalytics   : return "https://trust.paytm.in/service/fetchUserTransactionAnalytics"
        case .pathFetchCampaignsList        : return "https://staging.paytm.com/papi/v4/promocard/supercash/campaigns/list"
        case .pathFetchCashbackLandingSF    : return "https://storefront-staging.paytm.com/v2/h/game-widget"
        case .pathFetchCBLandingScratchCard : return "https://staging.paytm.com/papi/v4/promocard/supercash/cashbackLandingPage"
        case .pathFetchCBCoinSummary        : return "https://staging.paytm.com/papi/promoapi/v1/scratchcard/summary"
        case .pathFetchCampaignDetail       : return "https://staging.paytm.com/papi/v4/promocard/supercash/campaign-games/"
        case .pathFetchGameDetail           : return "https://staging.paytm.com/papi/v4/promocard/supercash/"
        case .pathSelectOfferV4             : return "https://staging.paytm.com/papi/v4/promocard/supercash/campaigns/select-offer"
        case .pathActivateGameV4            : return "https://staging.paytm.com/papi/v4/promocard/supercash"
        case .pathVoucherList               : return "https://staging.paytm.com/papi/v1/promosearch/voucher/list"
        case .pathMyVouchersDetailV3Url     : return "https://staging.paytm.com/papi/v1/promosearch/voucher/detail"
        case .pathMyVoucherFilterV1Url      : return "https://staging.paytm.com/papi/v1/promosearch/voucher/facets"
        case .pathPostTxnStoreFrontUrl      : return "https://storefront-staging.paytm.com/v2/h/post-txn-banner"
        case .pathCBMerchGamePmntDetailV1   : return "https://staging.paytm.com/api/v1/mpromocard/supercash/%d/transactions"
        case .pathCBMerchantNewOffersV1     : return "https://staging.paytm.com/papi/v1/mpromocard/campaigns"
        case .pathCBMerchantGameListV2      : return "https://staging.paytm.com/papi/v2/mpromocard/supercash"
        case .pathCBMerchantActivateOfferV2 : return "https://staging.paytm.com/papi/v2/mpromocard/campaigns"
        case .pathCBMerchantActivateGame    : return "https://staging.paytm.com/papi/v1/mpromocard/supercash"
        case .pathGetMerchantContext        : return "https://ump-staging2.paytm.com/api/v1/context"
        case .appOpen: return "https://staging.paytm.com/api/v4/promocard/supercash/eventOffer"
        case .referralLanding               : return "https://staging.paytm.com/papi/v5/promocard/supercash/referral"
        case .referrallink: return "https://staging.paytm.com/papi/v5/promocard/supercash/referral/link"
             case .referral_campign_image : return "https://paytm.s3-ap-southeast-1.amazonaws.com/promo_seller_panel_uploads/production/referEarnHeroBanner%402x%5B1%5D.png"
        case .saveShortURL                  : return "https://staging.paytm.com/papi/v5/promocard/supercash/referral/short-url"
        }
    }
    
    var mockDefaultValues: String {
        switch self {
        case .pathV4PostTxnAsync            : return "https://demo3131569.mockable.io/postTransErr"
        case .pathScratchCardById           : return "http://www.mocky.io/v2/5e18b1452f0000770097e122"
        case .pathUpdateScratchCard         : return "http://www.mocky.io/v2/5e18a7362f0000680097e0f4"
        case .pathFetchUserTransAnalytics   : return "https://demo3373227.mockable.io/totalCashback"
        case .pathFetchCashbackCoinList     : return "https://demo3373227.mockable.io/paytmcashbacklist"
        case .pathFetchCashbackLandingSF    : return "http://demo7067493.mockable.io/ashbacklandingsf"
        case .pathFetchCBLandingScratchCard : return "https://demo3373227.mockable.io/cashbackandothers"
        case .pathFetchCBCoinSummary        : return "http://demo3131569.mockable.io/landingHeaderSummary"
        case .appOpen: return "https://demo8339336.mockable.io/appopen"
        case .referralLanding: return "https://run.mocky.io/v3/02b55ad5-5ac3-4933-9aa8-704d340ec2bf"
        default: return ""
        }
    }
}

extension JRCBApiType {
    var header: [String: String] {
        var headers: [String: String] = [String: String]()
        switch self {
        case .referrallink,.referralLanding:
            if let ssoToken = JRCOAuthWrapper.ssoToken {
                headers["sso_token"] = ssoToken
            }
            headers["cache-control"] = "no-cache"
            headers["content-Type"] = "application/json"
            
        case .pathFetchUserTransAnalytics:
            if let ssoToken = JRCOAuthWrapper.ssoToken {
                headers["ssotoken"] = ssoToken
            }
            headers["cache-control"] = "no-cache"
            headers["content-Type"] = "application/json"
        case .pathGetMerchantContext:
            if let ssoToken = JRCOAuthWrapper.ssoToken {
                headers["x-user-token"] = ssoToken
            }
            headers["x-auth-ump"] = "umpapp-3754-36d-aqr-cn7"
        case .pathFetchCBCoinSummary:
            return self.defaultHeader(appendUserId: true)
        default:
            return self.defaultHeader(appendUserId: false)
        }
        return headers
    }
    
    private func defaultHeader(appendUserId: Bool, ssoTokenKey: String = "sso_token") -> [String: String] {
        var headers: [String: String] = [String: String]()
        if let ssoToken = JRCOAuthWrapper.ssoToken {
            headers[ssoTokenKey] = ssoToken
            headers["Content-Type"] = "application/json"
            headers["api_role"] = "detailed"
            headers["mktplace-apikey"] = "7S4h-4jl4-115D"
            headers["x-client-id"] = "APP_CLIENT"
            headers["Accept"] = "application/json"
            if self == .pathCBMerchantActivateOfferV2 || self == .pathCBMerchantActivateGame {
                headers["User-Agent"] = "B2C_IPHONE"
            }
            
            if appendUserId {
                headers["X-USER-ID"] = JRCOAuthWrapper.usrIdEitherBlank
            }
            
            if JRCashbackManager.shared.config.cbVarient == .merchantApp {
                headers["x-auth-ump"] = JRCOAuthWrapper.authUMP
                headers["x-user-token"] = ssoToken
                headers["x-user-mid"] = JRCOAuthWrapper.merchantID
            }
            return headers
        }
        return headers
    }
    
    
    func urlStrWith(appendExt: String = "") -> String {
        if !appendExt.isEmpty {
            return "\(self.urlString)\(appendExt)"
        }
        return self.urlString
    }
    
    var reqMethod : RequestMethodType {
        if JRCashbackManager.shared.shouldMock { return .get }
        switch self {
        case .pathFetchCashbackLandingSF,
             .pathFetchUserTransAnalytics,
             .pathSelectOfferV4,
             .pathActivateGameV4,
             .pathPostTxnStoreFrontUrl,
             .pathCBMerchantActivateOfferV2,
             .pathCBMerchantActivateGame,
             .referrallink,
             .saveShortURL:
            return .post
            
        case .pathUpdateScratchCard:
            return .put
        default:
            return .get
        }
    }
}



// jarvis_network_ios
// MARK: - JRCBApiType extension only for consumer
extension JRCBApiType {
    var dataType: JRDataType {
        switch self {
        case .pathVoucherList, .pathMyVouchersDetailV3Url, .pathMyVoucherFilterV1Url : return .CodableModel
        default: return .Json
        }
    }
    
    var timeoutInterval: Double? { return 60 }
    var path: String? { return "" }
}
