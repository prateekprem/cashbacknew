//
//  LoginApi.swift
//  LoginAuth
//
//  Created by Parmod on 31/10/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation
import jarvis_network_ios
import jarvis_utility_ios

enum LoginApi {
    //Login Flow
    case login(_ param: [String : Any], _ header: [String: String])
    case validatePassword(_ param: [String : Any], _ header: [String: String])
    case validateOtp(_ param: [String : Any], _ header: [String: String])
    case resendOtp(_ param: [String : Any], _ header: [String: String])
    case claimAccount(_ param: [String : Any], _ header: [String: String])
    case upgradeDevice(_ param: [String : Any], _ header: [String: String])
    //Others
    case sendEmailOTP(_ param: [String : Any])
    case reSendEmailOTP(_ param: [String : Any], _ header: [String: String])
    case setNewPhoneNo(_ param: [String : Any])
    case validateNewPhoneOTP(_ param: [String : Any])
    case validateNewPhoneOTPForEmailUpdate(_ param: [String : Any], _ header: [String: String])
    case updateEmail(_ param: [String: Any], _ header: [String: String])
    case verifyEmailOTP(_ param: [String: Any], _ header: [String: String])
    case updatePhoneOTPViaProfile(_ param: [String : Any])
    case accountStatus(_ param: [String : Any])
    //saved cards
    case verifierInit(_ param: [String : Any])
    case verifierInitV2(_ param: [String : Any], _ header: [String: String])
    case doView(_ param: [String : Any], isLogin: Bool)
    case doVerify(_ param: [String : Any], isLogin: Bool)
    case cardDetails(_ param: [String : Any])
    case fulfill(_ param: [String : Any])
    //Chnage Password
    case changePassword (_ param: [String : Any], _ header: [String: String])
    //Forgot Password
    case forgotPasswordInit(_ param: [String : Any], _ header: [String: String])
    case resetForgotPassword(_ param: [String : Any], _ header: [String: String])
    case validateEmailOTP(_ param: [String : Any], _ header: [String: String])
}

extension LoginApi: JRRequest {
    var baseURL: String? {
        switch self {
        case .login:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthLoginInitSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .validatePassword:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthValidatePwdSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .validateOtp:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthValidateOtpSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .resendOtp:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSimpleResendOtpSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .claimAccount:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSimpleClaimSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .upgradeDevice:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthDeviceUpgradeSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .validateNewPhoneOTPForEmailUpdate:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthValidateOTPV4SV1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
                
        case .verifyEmailOTP:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthUserValidateOTPSV1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
                    
        case .updateEmail:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthsendOTPUserEmailV4SV1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .reSendEmailOTP:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthResendOTPSV1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .forgotPasswordInit, .sendEmailOTP, .validateEmailOTP, .setNewPhoneNo, .validateNewPhoneOTP, .resetForgotPassword, .updatePhoneOTPViaProfile, .verifierInit, .cardDetails, .fulfill, .changePassword:
            if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL"), baseURL.length > 0 {
                return baseURL
            }
            return "https://accounts.paytm.com"
            
        case .accountStatus:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthAccountStatus"), !url.isEmpty {
                return url
            } else if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL"), baseURL.length > 0 {
                return baseURL
            }
            return "https://accounts.paytm.com"
            
        case .verifierInitV2:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("verifierInitV2"), !url.isEmpty {
                return nil
            } else if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL"), baseURL.length > 0 {
                return baseURL
            }
            return "https://accounts.paytm.com"
            
        case .doView(_, let isLogin):
            if isLogin {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("restDoViewLogin"), baseURL.length > 0 {
                    return baseURL
                }
                return "https://accounts.paytm.com/risk/identify/doView"
            }
            else {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthDoView"), !url.isEmpty {
                    return url
                } else {
                    if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                        return baseURL
                    }
                    return "https://accounts.paytm.com"
                }
            }
            
        case .doVerify(_, let isLogin):
            if isLogin {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("restDoVerifyLogin"), baseURL.length > 0 {
                    return baseURL
                }
                return "https://accounts.paytm.com/risk/identify/doVerify"
            }
            else {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthDoVerify"), !url.isEmpty {
                    return url
                } else {
                    if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                        return baseURL
                    }
                    return "https://accounts.paytm.com"
                }
            }
        }
    }
    
    var timeoutInterval: JRTimeout? {
        return .ninety
    }

    var exculdeErrorCodes: Set<Int> {
        switch self {
        case .login, .validatePassword, .validateOtp, .resendOtp, .claimAccount, .upgradeDevice, .updatePhoneOTPViaProfile, .reSendEmailOTP, .updateEmail, .verifyEmailOTP, .validateNewPhoneOTPForEmailUpdate, .accountStatus, .verifierInitV2, .changePassword, .resetForgotPassword, .forgotPasswordInit,.validateEmailOTP:
            return [401, 403, 410]
        case .sendEmailOTP, .setNewPhoneNo, .validateNewPhoneOTP, .verifierInit, .doView, .cardDetails, .fulfill, .doVerify:
            return []
        }
    }
    
    var path: String? {
        switch self {
        case .login:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthLoginInitSv1"), !url.isEmpty {
                    return url
                }
                return "/v2/simple/login/init/sv1"
            }
            return "/simple/login/init"
            
        case .validatePassword:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthValidatePwdSv1"), !url.isEmpty {
                    return url
                }
                return "/v2/simple/login/validate/password/sv1"
            }
            return "/simple/login/validate/password"
            
        case .validateOtp:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthValidateOtpSv1"), !url.isEmpty {
                    return url
                }
                return "/v2/simple/login/validate/otp/sv1"
            }
            return "/simple/login/validate/otp"
            
        case .resendOtp:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSimpleResendOtpSv1"), !url.isEmpty {
                    return url
                }
                return "/v2/simple/login/resend/otp/sv1"
            }
            return "/simple/login/resend/otp"
            
        case .claimAccount:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSimpleClaimSv1"), !url.isEmpty {
                    return url
                }
                return "/v2/simple/claim/sv1"
            }
            return "/simple/claim"
                
        case .upgradeDevice:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthDeviceUpgradeSv1"), !url.isEmpty {
                return url
            }
            return "/device/upgrade/sv1"
            
        case .forgotPasswordInit:
            return "/forgetpassword/sv1"
            
        case .sendEmailOTP:
            return "/v4/api/send/otp"
            
        case .reSendEmailOTP:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthResendOTPSV1"), !url.isEmpty {
                    return url
                }
                return "/resend/otp/sv1"
            }
            return "/resend/otp"
            
        case .validateEmailOTP:
            return "/v4/api/validate/otp/sv1"
            
        case .updateEmail:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthsendOTPUserEmailV4SV1"), !url.isEmpty {
                return url
            }
            return "/v4/user/email/sv1"
            
        case .verifyEmailOTP:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthUserValidateOTPSV1"), !url.isEmpty {
                return url
            }
            return "/v4/user/validate/otp/sv1"
            
        case .setNewPhoneNo:
            return "/v4/user/phone"
            
        case .validateNewPhoneOTP:
            return "/v4/user/validate/otp"
            
        case .validateNewPhoneOTPForEmailUpdate:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("OauthValidateOTPV4SV1"), !url.isEmpty {
                return url
            }
            return "/v4/api/validate/otp/sv1"
            
        case .resetForgotPassword:
            return "/forgetpassword/sv1"
            
        case .updatePhoneOTPViaProfile:
            return "/v3/api/sendOtp?fetch_strategy=basic"
            
        case .verifierInit:
            return "/user/verification/init"
            
        case .verifierInitV2:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("verifierInitV2"), !url.isEmpty {
                return url
            }
            return "/v2/user/verification/init"
            
        case .doView, .doVerify, .accountStatus:
            return ""
            
        case .cardDetails:
            return "/user/asset/verify/cardDetails"
            
        case .fulfill:
            return "/user/verification/fulfill"
        case .changePassword:
            return "/v2/api/changePassword/sv1"
        }
    }
    
    var httpMethod: JRHTTPMethod {
        switch self {
        case .login, .validatePassword, .validateOtp, .resendOtp, .claimAccount, .upgradeDevice, .sendEmailOTP, .reSendEmailOTP, .validateEmailOTP, .verifyEmailOTP, .validateNewPhoneOTP, .validateNewPhoneOTPForEmailUpdate, .resetForgotPassword, .updatePhoneOTPViaProfile, .verifierInit, .doView, .cardDetails, .fulfill, .accountStatus, .verifierInitV2, .doVerify, .changePassword:
            return .post
        case .forgotPasswordInit, .setNewPhoneNo, .updateEmail:
            return .put
        }
    }
    
    var verticle: JRVertical {
        return .auth
    }
    
    var dataType: JRDataType {
        switch self {
        case .login, .validatePassword, .validateOtp, .resendOtp, .claimAccount, .upgradeDevice, .forgotPasswordInit, .sendEmailOTP, .reSendEmailOTP, .validateEmailOTP, .updateEmail, .verifyEmailOTP, .setNewPhoneNo, .validateNewPhoneOTP, .validateNewPhoneOTPForEmailUpdate, .resetForgotPassword, .updatePhoneOTPViaProfile, .verifierInit, .doView, .cardDetails, .fulfill, .accountStatus, .verifierInitV2, .doVerify, .changePassword:
            return .Json
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .sendEmailOTP(let bodyParams),
             .validateNewPhoneOTP(let bodyParams),
             .setNewPhoneNo(let bodyParams),
             .updatePhoneOTPViaProfile(let bodyParams),
             .verifierInit(let bodyParams),
             .doView(let bodyParams, _),
             .cardDetails(let bodyParams),
             .fulfill(let bodyParams),
             .accountStatus(let bodyParams),
             .verifierInitV2(let bodyParams, _),
             .doVerify(let bodyParams, _):
            return .requestParameters(
                bodyParameters: bodyParams,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded) ,
                urlParameters: LoginAuth.sharedInstance().getDefaultParameters())
            
        case .login(let bodyParams, _),
             .validatePassword(let bodyParams, _),
             .validateOtp(let bodyParams, _),
             .resendOtp(let bodyParams, _),
             .claimAccount(let bodyParams, _),
             .reSendEmailOTP(let bodyParams, _),
             .resetForgotPassword(let bodyParams, _),
             .validateEmailOTP(let bodyParams, _),
             .upgradeDevice(let bodyParams, _),
             .validateNewPhoneOTPForEmailUpdate(let bodyParams, _),
             .verifyEmailOTP(let bodyParams, _),
             .updateEmail(let bodyParams, _),
             .changePassword(let bodyParams, _):
            if #available(iOS 11.0, *) {
                return .requestParameters(
                    bodyParameters: bodyParams,
                    bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncodedWithOptions(options: .sortedKeys)) ,
                    urlParameters: LoginAuth.sharedInstance().getDefaultParameters())
            } else {
                return .requestParameters(
                    bodyParameters: bodyParams,
                    bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded) ,
                    urlParameters: LoginAuth.sharedInstance().getDefaultParameters())
            }
        case .forgotPasswordInit:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding ,
                urlParameters: LoginAuth.sharedInstance().getDefaultParameters())
        }
    }
    
    var headers: JRHTTPHeaders? {
        switch self {
        case .login(_, let headers),
             .validatePassword(_, let headers),
             .validateOtp(_, let headers),
             .resendOtp(_, let headers),
             .claimAccount(_, let headers),
             .reSendEmailOTP(_, let headers),
             .upgradeDevice(_, let headers),
             .validateNewPhoneOTPForEmailUpdate(_, let headers),
             .verifyEmailOTP(_, let headers),
             .updateEmail(_, let headers),
             .verifierInitV2(_, let headers):
            var lheaders = ["Authorization": LoginAuth.sharedInstance().getAuthorizationCode(),
                            "Content-Type": "application/json"]
            lheaders.merge(headers){(_, new) in new}
            return lheaders
            
        case .changePassword(_, let headers),
             .validateEmailOTP(_, let headers),
             .resetForgotPassword(_, let headers):
            var lheaders = ["Authorization": LoginAuth.sharedInstance().getAuthorizationCode(),
                            "Content-Type": "application/json"]
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken(){
                lheaders["session_token"] = ssoToken
            }
            lheaders.merge(headers){(_, new) in new}
            return lheaders
            
        case .validateNewPhoneOTP,
             .setNewPhoneNo,
             .updatePhoneOTPViaProfile,
             .fulfill,
             .cardDetails,
             .accountStatus:
            return ["Authorization": LoginAuth.sharedInstance().getAuthorizationCode(),
                    "Content-Type": "application/json"]
            
        case .sendEmailOTP,
             .verifierInit,
             .doView,
             .doVerify:
            var headers = ["Authorization": LoginAuth.sharedInstance().getAuthorizationCode(),
                           "Content-Type": "application/json"]
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken(){
                headers["session_token"] = ssoToken
            }
            return headers
            
        case .forgotPasswordInit(_, let headers):
            var lheaders = ["Authorization": LoginAuth.sharedInstance().getAuthorizationCode(),
                            "verificationType" : "OTP",
                            "Content-Type": "application/json"]
            lheaders.merge(headers){(_, new) in new}
            return lheaders
        }
    }
    
    var defautlURLParams: JRParameters? {
        switch self {
        case .login, .validatePassword, .validateOtp, .resendOtp, .claimAccount,
             .upgradeDevice,
             .sendEmailOTP,
             .reSendEmailOTP,
             .validateEmailOTP,
             .updateEmail,
             .verifyEmailOTP,
             .validateNewPhoneOTP,
             .validateNewPhoneOTPForEmailUpdate,
             .resetForgotPassword,
             .updatePhoneOTPViaProfile,
             .verifierInit,
             .doView,
             .doVerify,
             .cardDetails,
             .fulfill,
             .accountStatus,
             .verifierInitV2,
             .changePassword:
            return nil
        case .forgotPasswordInit, .setNewPhoneNo:
            return LoginAuth.sharedInstance().getDefaultParameters()
        }
    }
    
    var printDebugLogs: Bool {
        return true
    }
}
