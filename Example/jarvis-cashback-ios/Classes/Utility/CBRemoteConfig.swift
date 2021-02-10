//
//  CBRemoteConfig.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 02/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import jarvis_auth_ios

class CBRemoteConfig {
    
    class func keyValue<T>(_ key: String) -> T? {
        let className = String(describing: T.self)
        let selectedEnvironment = UserDefaults.standard.integer(forKey: "keySelectedEnvironment")
        switch className {
        case String(describing: Bool.self):
            if selectedEnvironment == JRLPaytmEnvironment.staging.rawValue {
                return CBRemoteConfig.returnBoolForGTMKey(key) as? T
            } else {
                return CBRemoteConfig.returnBoolForGTMKey(key) as? T
            }
        case String(describing: String.self):
            if selectedEnvironment == JRLPaytmEnvironment.staging.rawValue {
                return CBRemoteConfig.returnStagingStringForGTMKey(key) as? T
            } else {
                return CBRemoteConfig.returnProductionStringForGTMKey(key) as? T
            }
        default:
            return  nil
        }
    }
    
    class func returnBoolForGTMKey(_ key: String) -> Bool {
        switch key {
        case "isSetPasswordMandatory":
            return false
        default:
            return false
        }
    }
    
   class func returnStagingStringForGTMKey(_ key: String) -> String {
        switch key {
        case "min_kyc_status_v3_url":
            return "https://kyc-ite.paytm.in/kyc/v3/status"
        case "kycFetchProfileInfoV2":
            return "https://kyc-ite.paytm.in/v2/profile/getInfo"
        case "accountsPaytmBaseURL":
            return "https://accounts-staging.paytm.in"
        case "getalltokens":
            return ""
        case "jr_login_fast_secure_payments":
            return "Fast & Secure\n Payments"
        case "jr_login_pay_bills_mobile_recharge" :
            return "Pay Bills or Mobile Recharge\n & Get Cashbacks";
        case "jr_login_pay_over_five_million_merchant_networks":
            return "Pay at over 5 millions Paytm\n merchant networks";
        case "jr_login_amazing_deals_travel_movies_shopping":
            return "Amazing deals on Travel,\n Movies & Shopping";
        default:
            return ""
        }
    }
    
   class func returnProductionStringForGTMKey(_ key: String) -> String {
        switch key {
        case "min_kyc_status_v3_url":
            return "https://kyc.paytm.com/kyc/v3/status"
        case "kycFetchProfileInfoV2":
            return "https://kyc.paytm.com/v2/profile/getInfo"
        case "accountsPaytmBaseURL":
            return "https://accounts.paytm.com/"
        case "getalltokens":
            return ""
        case "jr_login_fast_secure_payments":
            return "Fast & Secure\n Payments"
        case "jr_login_pay_bills_mobile_recharge" :
            return "Pay Bills or Mobile Recharge\n & Get Cashbacks";
        case "jr_login_pay_over_five_million_merchant_networks":
            return "Pay at over 5 millions Paytm\n merchant networks";
        case "jr_login_amazing_deals_travel_movies_shopping":
            return "Amazing deals on Travel,\n Movies & Shopping";
        default:
            return ""
        }
    }
    
    var createPassword : Bool {
        return true
    }
}
