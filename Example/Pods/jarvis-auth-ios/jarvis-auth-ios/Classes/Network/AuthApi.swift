//
//  AuthApi.swift
//  LoginAuth
//
//  Created by Parmod on 31/10/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation
import jarvis_network_ios

enum AuthApi {
    case v2userInfo(_ headers: [String : String], _ urlParam: [String : String])
    case getAccessToken(_ headers: [String : String], _ bodyParams: [String: Any])
    case upgradeAuthToken(_ headers: [String : String], _ bodyParams: [String: Any])
    case v2userPhone(_ headers: [String : String], _ bodyParams: [String: String])
    case isLoggedOut(_ headers: [String : String])
    case logoutSessionToken(_ headers: [String : String], _ bodyParams: [String: String])
    case setPassword(_ headers: [String: String], _ bodyParams: [String: String])
    case urlGetAllTokens
    case urlGetEncryptedSSOToken(_ headers: [String : String])
}

extension AuthApi: JRRequest {
    var baseURL: String? {
        switch self {
        case .urlGetAllTokens:
            if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("getalltokens"), !baseURL.isEmpty {
                return baseURL
            }
            if LoginAuth.sharedInstance().getEnvironment() == JRLPaytmEnvironment.staging{
                return "https://accounts-staging.paytm.in/oauth2/usertokens"
            }
            return "https://accounts.paytm.com/oauth2/usertokens"
        case .urlGetEncryptedSSOToken:
            if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("encryptedTokenUrl"), baseURL.count > 0 {
                return baseURL
            }
            if LoginAuth.sharedInstance().getEnvironment() == JRLPaytmEnvironment.staging{
                return "https://staging.paytm.com/v1/user/token/enc/generate"
            }
            return "https://paytm.com/v1/user/token/enc/generate"
            
        case .getAccessToken:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenV3"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        case .upgradeAuthToken:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenUpgradeSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
                
        case .logoutSessionToken:
            if JRLoginUI.sharedInstance().isCryptoEnabled(),
                let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenSv1"), !url.isEmpty {
                return nil
            } else {
                if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                    return baseURL
                }
                return "https://accounts.paytm.com"
            }
            
        default:
            if let baseURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("accountsPaytmBaseURL") {
                return baseURL
            }
            return nil
        }
    }
    
    var timeoutInterval: JRTimeout? {
        return .ninety
    }

    var exculdeErrorCodes: Set<Int> {
        switch self {
        case .logoutSessionToken:
            return [401]
        case .upgradeAuthToken, .getAccessToken:
            return [401, 403, 410]
        case .v2userInfo, .v2userPhone, .isLoggedOut, .setPassword, .urlGetAllTokens, .urlGetEncryptedSSOToken:
            return []
        }
    }
    
    var path: String? {
        switch self {
        case .v2userInfo:
            return "/v2/user"
        case .getAccessToken:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenV3"), !url.isEmpty {
                    return url
                }
                return "/oauth2/v3/token/sv1"
            }
            return "/oauth2/token"
        case .upgradeAuthToken:
            if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenUpgradeSv1"), !url.isEmpty {
                return url
            }
            return "/oauth2/token/upgrade/sv1"
        case .v2userPhone:
            return "/v2/user/phone"
        case .isLoggedOut:
            return "/oauth2/logoutIfRequired"
        case .logoutSessionToken:
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                if let url: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthTokenSv1"), !url.isEmpty {
                    return url
                }
                return "/oauth2/token/sv1"
            }
            return "/oauth2/accessToken/"
        case .setPassword:
            return "/password"
        case .urlGetAllTokens:
            return ""
        case .urlGetEncryptedSSOToken:
            return ""
        }
    }
    
    var httpMethod: JRHTTPMethod {
        switch self {
        case .v2userInfo:
            return .get
        case .getAccessToken, .upgradeAuthToken, .isLoggedOut:
            return .post
        case .v2userPhone, .setPassword:
            return .put
        case .logoutSessionToken:
            return .delete
        case .urlGetAllTokens:
            return .get
        case .urlGetEncryptedSSOToken:
            return .get
        }
    }
    
    var verticle: JRVertical {
        return .auth
    }
    
    var dataType: JRDataType {
        switch self {
        case .v2userInfo, .getAccessToken, .upgradeAuthToken, .v2userPhone, .isLoggedOut, .setPassword, .urlGetAllTokens, .urlGetEncryptedSSOToken:
            return .Json
        case  .logoutSessionToken:
            return .Data
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .getAccessToken(_, let bodyParams):
            if JRLoginUI.sharedInstance().isCryptoEnabled(){
                return .requestParameters(
                    bodyParameters: bodyParams,
                    bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded) ,
                    urlParameters: nil)
            }
            return .requestParameters(
                bodyParameters: bodyParams,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .stringEncoded) ,
                urlParameters: nil)
        case .upgradeAuthToken(_, let bodyParams):
            return .requestParameters(
                bodyParameters: bodyParams,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded) ,
                urlParameters: nil)
        case .v2userInfo(_, let urlParams):
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlEncoding ,
                urlParameters: urlParams)
        case .v2userPhone(_, let bodyParams), .setPassword(_, let bodyParams):
            return .requestParameters(
                bodyParameters: bodyParams,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded) ,
                urlParameters: nil)
        case .isLoggedOut, .logoutSessionToken:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded),
                urlParameters: nil)
        case .urlGetAllTokens:
            return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: AuthApi.defaultParamsWithSiteID(for: "\(self.baseURL ?? "")\(self.path ?? "")"))
        case .urlGetEncryptedSSOToken:
            return .requestParameters(
                bodyParameters: nil,
                bodyEncoding: .urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded),
                urlParameters: nil)
        }
    }
    
    var headers: JRHTTPHeaders? {
        switch self {
        case .getAccessToken(let headers, _), .upgradeAuthToken(let headers, _), .v2userInfo(let headers, _), .v2userPhone(let headers, _), .isLoggedOut(let headers), .setPassword(let headers, _), .logoutSessionToken(let headers, _):
            return headers
        case .urlGetAllTokens:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/x-www-form-urlencoded"]
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken(){
                headers["access_token"] = ssoToken
                headers["Authorization"] = LoginAuth.sharedInstance().getAuthorizationCode()
            }
            return headers
        case .urlGetEncryptedSSOToken:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/x-www-form-urlencoded"]
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken(){
                headers["sso_token"] = ssoToken
            }
            return headers
        }
    }
    
    var defautlURLParams: JRParameters? {
        return LoginAuth.sharedInstance().getDefaultParameters()
    }
    var defautlJsonParams: JRParameters? {
        return [:]
    }
    var defautlHeaderParams: JRHTTPHeaders? {
        return [:]
    }
    
    var printDebugLogs: Bool {
        return true
    }
    
    private static func defaultParamsWithSiteID(for url:String) -> [String:String] {
        
        var castedDic = [String: String]()
        if let siteIDParams = LoginAuth.sharedInstance().delegate?.defaultParamsWithSiteIDs(forUrl: url) {
            //Convert to [String:String]
            siteIDParams.forEach { castedDic["\($0.0)"] = "\($0.1)" }
        }
        return castedDic
    }

}
