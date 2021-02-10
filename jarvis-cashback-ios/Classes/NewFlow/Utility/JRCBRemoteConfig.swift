//
//  JRCBRemoteConfig.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 03/01/20.
//

import UIKit

enum JRCBRemoteConfig : String {
    case kCBLandingAmountFromDate = "cbLandingAmountFromDate"
    case kCBLandingAmountToDate   = "cbLandingAmountToDate"
    case kCBBreakUpDeepLink       = "cbBreakUpDeepLink"
    case kCBScratchOnLanding      = "cashbackIsScratchSectionEnable"
    case kCBScratchAppUpdateMsg   = "cbScratchAppUpdateMsg"
    case kCBPostTransRetryList    = "cbPostTransRetryList"
    
    case kCBGridHeaderVoucherURL   = "cbGridHeaderVoucherURL"
    case kCBGridHeaderCashbackURL  = "cbGridHeaderCashbackURL"
    case kCBGridHeaderPointURL     = "cbGridHeaderPointURL"
    case kCBWebCashbackEnable      = "cbWebCashbackEnable"
    
    case kCBShareCashbackLinkKey   = "cbShareCashbackLinkKey" // 8.9.0
    case kCBSharePointLinkKey      = "cbSharePointLinkKey"
    case kCBLandingLinkKey         = "cbLandingLinkKey"
    case kCBGridPointsDeeplinkKey  = "cbPointPassbookDeeplinkKey"
    case kCBRedeemPointsDeeplinkKey = "cbRedeemPointDeeplinkKey"

    
    case kCashbackHeaderText        = "cashbackHeaderText"
    case kCBMerchantActiveIOS       = "enableMerchantCashback"
    
    case cashbackFeature            = "cashbackFeatureEnabled"
    case cashbackPostTxnOfferIds    = "cashbackPostTxnEnabledOfferIds"
    case kCBMerchantPointsDeeplink  = "merchant_points_deeplink"
    case kCBMerchantPointsHidden    = "merchant_points_hidden"
    case kCBViewAllStickerDeeplink  = "cbViewAllStickerDeeplink"
    case kCBScratchCardExpiryLimitHour  = "cbScratchCardExpiryLimitHour"
    
    var strValue : String {
        guard let value = JRCBCommonBridge.remoteStringFor(key: self.rawValue), value != "" else {
            return self.defaultStr
        }
        return value
    }
    
    var boolVal: Bool {
        return self.value() ?? false
    }
    
    var intValue: Int64 { // be careful while using since the default value is 0
        guard let mVal: Int64 = self.value() else {
            switch self {
            case .kCBScratchCardExpiryLimitHour: return 72
            default: return 0
            }
        }
        return mVal
    }
    
    func value<T>() -> T? {
        return JRCBCommonBridge.remoteValueFor(key: self.rawValue)
    }
    
    
    func boolValue(defaultVal: Bool = false) -> Bool {
        let val: Bool = self.value() ?? defaultVal
        return val
    }
    
    static var isScratchOnLanding: Bool {
        get {
            return JRCBRemoteConfig.kCBScratchOnLanding.value() ?? true
        }
    }
    
    static var postTransRetryList: [Int] {
        return JRCBRemoteConfig.kCBPostTransRetryList.value() ?? [1, 2, 1]
    }
    
    static var postTxtOfferIds: [Int]? {
        var offerIds: [Int]? = nil
        let jsonString  = JRCBRemoteConfig.cashbackPostTxnOfferIds.strValue
        if !jsonString.isEmpty, let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                offerIds = jsonDict as? [Int]
            } catch {}
        }
        return offerIds
    }
}


private extension JRCBRemoteConfig {
    
    var defaultStr: String {
        get {
            switch self {
            case .kCBLandingAmountFromDate: return "2019-01-01 00:00:00"
            case .kCBLandingAmountToDate:   return "2019-12-31 23:59:59"
            case .kCBBreakUpDeepLink :
               return "paytmmp://embed?url=https://paytm.com/recall/cashbacks-detail?digitalcredit"
            case .kCBScratchAppUpdateMsg: return "Please update your app to be eligible for this offer"
            case .kCBGridHeaderVoucherURL:
                return "https://assetscdn1.paytm.com/images/promo-engine/prod/header-vouchers.png"
            case .kCBGridHeaderCashbackURL:
                return "https://assetscdn1.paytm.com/images/promo-engine/prod/header-cashback.png"
            case .kCBGridHeaderPointURL:
                return "https://assetscdn1.paytm.com/images/promo-engine/prod/header-points.png"
            case .kCBShareCashbackLinkKey : return "https://m.p-y.tm/cashbacksum"
            case .kCBSharePointLinkKey : return "https://m.p-y.tm/pointssum"
            case .kCBLandingLinkKey : return "https://m.p-y.tm/cashbackhome" //"paytmmp://cash_wallet?featuretype=vip&screen=homescreen"
            case .kCBGridPointsDeeplinkKey : return "paytmmp://paytmcoins"
            case .kCBRedeemPointsDeeplinkKey : return "paytmmp://redeemcoins"
            case .kCashbackHeaderText : return "Earn upto ₹5,000 cashback this month!"
            case .kCBMerchantPointsDeeplink:
                if JRCashbackManager.shared.config.cbVarient == .merchantApp {
                    if JRCashbackManager.shared.config.cbEnvironment == .staging {
                        return "paytmba://business-app/ump-web?url=https://ump-staging2.paytm.com/app?redirectUrl=rewards-passbook?src=p4b&channel=p4b"
                    } else {
                        return "paytmba://business-app/ump-web?url=https://dashboard.paytm.com/app?redirectUrl=rewards-passbook?src=p4b&channel=p4b"
                    }
                } else {
                    if JRCashbackManager.shared.config.cbEnvironment == .staging {
                        return "paytmmp://business-app/ump-web?url=https://ump-staging2.paytm.com/app?redirectUrl=rewards-passbook?src=p4b&channel=consumer_app"
                    } else {
                        return "paytmmp://business-app/ump-web?url=https://dashboard.paytm.com/app?redirectUrl=rewards-passbook?src=p4b&channel=consumer_app"
                    }
                }
                
            case .kCBViewAllStickerDeeplink: return "paytmmp://mini-app?aId=49ceea953d7c10bb1e13cd0723746ceeae159ca7&data=eyJwYXJhbXMiOiAiP3RhZz1teV9zdGlja2VycyIsInNwYXJhbXMiOnsiY2FuUHVsbERvd24iOmZhbHNlLCJwdWxsUmVmcmVzaCI6ZmFsc2UsInNob3dUaXRsZUJhciI6ZmFsc2V9fQ==&url=https://webappsstatic.paytm.com/h5stickers/v1/index.html"
            default: return ""
            }
        }
    }
}
