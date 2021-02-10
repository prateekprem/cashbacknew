//
//  JRPaytmCoinsAPI.swift
//  Jarvis
//
//  Created by Pankaj Singh on 06/01/20.
//

import Foundation
import jarvis_network_ios

// MARK: - Enum ---- all paytm coins api

enum JRPaytmCoinsAPI {
    case fetchBalance(url: String, bodyParam: [String: Any])
    case getTransactionList(url: String, bodyParam: [String: Any])
    case getRewardsList(url: String, bodyParam: [String: Any])
    case checkout(url: String, bodyParam: [String: Any])
    case payment(url: String, bodyParam: [String: Any])
}

extension JRPaytmCoinsAPI: JRRequest {
    
    var printDebugLogs: Bool {
        return true
    }
    
    var baseURL: String? {
        switch self {
        case .fetchBalance(let url, _), .getTransactionList(let url, _), .getRewardsList(let url, _), .payment(let url, _):
           return JRCashbackManager.shared.cbEnvDelegate.cbUrlByAppendingDefaultParam(urlStr: url)
        case .checkout(let url, _):
            if var urlStr = JRCashbackManager.shared.cbEnvDelegate.cbUrlByAppendingDefaultParam(urlStr: url),let ssoToken = JRCOAuthWrapper.ssoToken {
                urlStr = urlStr + "&sso_token=\(ssoToken)"
                return urlStr
            }
            else {
                return JRCashbackManager.shared.cbEnvDelegate.cbUrlByAppendingDefaultParam(urlStr: url)
            }
        }
    }
    
    var path: String? {
        return ""
    }
    
    var httpMethod: JRHTTPMethod {
        switch self {
        case .getRewardsList:
            return .get
        default:
            return .post
        }
    }
    
    var dataType: JRDataType {
        switch self {
        case .checkout, .payment:
            return .Json
        default:
            return .Data
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .fetchBalance(_, let bodyParams), .getTransactionList(_, let bodyParams), .getRewardsList(_, let bodyParams), .checkout(_, let bodyParams), .payment(_, let bodyParams):
            return .requestParameters(bodyParameters: bodyParams, bodyEncoding: JRParameterEncoding.urlAndJsonEncoding(bodyEncodingStyle: .jsonEncoded), urlParameters: nil)
        }
    }
    
    var headers: JRHTTPHeaders? {
        switch self {
        case .fetchBalance, .getTransactionList:
            var requestHeaders: [String: String] = ["Content-Type": "application/json"]
            if let ssoToken = JRCOAuthWrapper.ssoToken {
                if JRCashbackManager.shared.config.cbVarient == .merchantApp || JRCBManager.userMode == .Merchant {
                    if let mid = JRCBManager.shareInstance.mid {
                        requestHeaders["x-user-mid"] = mid
                    }
                    else {
                        requestHeaders["x-user-mid"] = JRCOAuthWrapper.merchantID
                    }
                    requestHeaders["x-user-token"] = ssoToken
                    requestHeaders["x-auth-ump"] = JRCOAuthWrapper.authUMP
                }
                else{
                    requestHeaders["ssotoken"] = ssoToken
                }
            }
            return requestHeaders
        default:
            var requestHeaders: [String: String] = ["Content-Type": "application/json"]
            if let ssoToken = JRCOAuthWrapper.ssoToken {
                requestHeaders["sso_token"] = ssoToken
            }
            requestHeaders["x-user-id"] = JRCOAuthWrapper.usrIdEitherBlank
            if JRCashbackManager.shared.config.cbVarient == .merchantApp || JRCBManager.userMode == .Merchant {
                if let mid = JRCBManager.shareInstance.mid {
                    requestHeaders["X-USER-PGMID"] = mid
                }
                else {
                    requestHeaders["X-USER-PGMID"] = JRCOAuthWrapper.merchantID
                }
            }
            return requestHeaders
        }
    }
    
    var verticle: JRVertical {
        return JRVertical.cashback
    }
    
    var isUserFacing: JRUserFacing {
        return .userFacing
    }
    
}



