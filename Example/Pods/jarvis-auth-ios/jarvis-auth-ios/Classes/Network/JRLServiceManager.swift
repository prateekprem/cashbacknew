//
//  JRNLoginManager.swift
//  Login
//
//  Created by Parmod on 07/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_network_ios
import jarvis_utility_ios

public enum TokenGrantType: String {
    case refreshToken = "refresh_token"
    case oauthCode = "authorization_code"
}

public class JRLServiceManager: NSObject {
    
    private static func getRSAHeader(requestInfo: URLRequest, param: [String: Any], header: [String:String] = [:], requirePublicKey: Bool = false) -> [String:String]{
        
        // Check if public cryptography flow is enabled
        if !JRLoginUI.sharedInstance().isCryptoEnabled(){
            return [:]
        }
        
        //get request info
        let urlString = requestInfo.url?.absoluteString ?? ""
        let requestMethod = requestInfo.httpMethod ?? ""
        let paramString = JRAuthUtility.serializedString(from: param)
        
        //Get all the headers logic
        var headers = [String: String]()
        headers = header
        headers[KEY_AUTHORIZATION] = LoginAuth.sharedInstance().getAuthorizationCode()
        headers[KEY_DEVICE_MANUFACTURER] = "Apple"
        headers[KEY_DEVICE_NAME] = JRUtility.platformString
        headers[KEY_CLIENT_SIGNATURE] = ""
        headers[KEY_DEVICE_IDENTIFIER] = (LoginAuth.sharedInstance().getDefaultParameters()?["deviceIdentifier"] as? String) ?? ""
        headers[KEY_EPOCH] = Date().timeIntervalSince1970.roundToInt().description
        headers[KEY_PUBLIC_KEY] = AuthRSAGenerator.shared.getPublicKeyBase64String()
        let obj = JROAuthSeedGenerator()
        let rsaHeader = obj.addClientSignatureInHeaders(url: urlString, httpMethod: requestMethod, headers: headers, requestBody: paramString)
        
        return rsaHeader
    }
    
    private static func getLoginApiRequest(route: JRRouter<LoginApi>, request: LoginApi) -> URLRequest{
        return try! route.getRequestInfo(request)
    }
    
    private static func getAuthApiRequest(route: JRRouter<AuthApi>, request: AuthApi) -> URLRequest{
        return try! route.getRequestInfo(request)
    }
    
    public static func initiateLogin(_ params: [String: String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .login([:], [:]))

        var isPublicKeyRequired = true
        if let loginID = params["loginId"] {
            isPublicKeyRequired = AuthRSAGenerator.shared.isKeyPairRecentlyGenerated(for: loginID)
        }
        
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, requirePublicKey: isPublicKeyRequired)

        loginAPIRouter.request(type: JRDataType.self, .login(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func validatePassword(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .validatePassword([:], [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params)
        
        if let pwdStr = params["password"], pwdStr.length < LoginAuth.sharedInstance().getMinPasswordLength() || pwdStr.length > LoginAuth.sharedInstance().getMaxPasswordLength() {
            let passwordError = NSError(domain: "", code: 0, userInfo: [NSLocalizedDescriptionKey : "jr_login_valid_password_error".localized])
            completionHandler(nil, passwordError)
            return
        }
        
        loginAPIRouter.request(type: JRDataType.self, .validatePassword(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                if let pwdStr = params["password"] {
                    JRLServiceManager.setStrengthOfPassword(pwdStr: pwdStr)
                }
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func verifyInitDIY(_ params: [String:String], completionHandler: @escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        let  headers: [String : String] = [KEY_DEVICE_IDENTIFIER : (LoginAuth.sharedInstance().getDefaultParameters()?["deviceIdentifier"] as? String) ?? ""]
        
        loginAPIRouter.request(type: JRDataType.self, .verifierInitV2(params, headers)) { (data, response, error) in            
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func setStrengthOfPassword(pwdStr: String) {
        let (strength, _)  = JRLPasswordUtils.strengthForPassword(password: pwdStr)
        var strengthStr: String?
        switch strength {
        case .weak:
            strengthStr = "jr_login_weak".localized
        case .average:
            strengthStr = "jr_login_average".localized
        case .strong:
            strengthStr = "jr_login_strong".localized
        }
        if let str = strengthStr {
            LoginAuth.sharedInstance().setPasswordStrength(strength: str)
        }
    }
    
    public static func validateOTP(_ params:[String:String],completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .validateOtp([:], [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params)

        loginAPIRouter.request(type: JRDataType.self, .validateOtp(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func resendOTP(_ params:[String:String],completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .resendOtp([:], [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params)

        loginAPIRouter.request(type: JRDataType.self, .resendOtp(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func initiateClaimAccount(_ params:[String : String], completionHandler: @escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .claimAccount([:], [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params)

        loginAPIRouter.request(type: JRDataType.self, .claimAccount(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func signOut(completionHandler:@escaping ((_ isSuccess: Bool?, _ error: Error?) -> Void )) {
        LoginAuth.sharedInstance().logoutSessionToken(completionHandler: { (data, response, error) in
            if error != nil {
                completionHandler(false, error)
            }
            LoginAuth.sharedInstance().resetUserDetails()
            completionHandler(true, nil)
        })
    }
    
    internal static func getV2UserInfo(_ urlparams: [String: String], completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        guard let ssoToken = LoginAuth.sharedInstance().getSsoToken() else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
            completionHandler(nil, nil, error)
            return
        }
        
        let router = JRRouter<AuthApi>()
        let headers: [String: String] = [
            "verification_type": "oauth_token",
            "data" : ssoToken,
            "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()
        ]
        let v2InfoRequest = AuthApi.v2userInfo(headers, urlparams)
        router.request(type: JRDataType.self, v2InfoRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    internal static func setUserPassword(_ password: String, _ confirmPassword: String, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        guard let ssoToken = LoginAuth.sharedInstance().getSsoToken() else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
            completionHandler(nil, nil, error)
            return
        }
        let router = JRRouter<AuthApi>()
        let headers: [String: String] = [
            "session_token" : ssoToken,
            "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode(),
            "Content-Type": "application/json"
        ]
        
        let bodyParams = ["password" : password, "confirmPassword": confirmPassword]
        
        let setPasswordRequest = AuthApi.setPassword(headers, bodyParams)
        router.request(type: JRDataType.self, setPasswordRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    internal static func getV2UserPhone(_ phone: String, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        guard let ssoToken = LoginAuth.sharedInstance().getSsoToken() else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
            completionHandler(nil, nil, error)
            return
        }
        let router = JRRouter<AuthApi>()
        let params: [String: String] = [
            "session_token" : ssoToken
        ]
        
        let v2InfoRequest = AuthApi.v2userPhone(params, ["phone" : phone])
        router.request(type: JRDataType.self, v2InfoRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    internal static func isLoggedOut(_ urlStr: String?, extractedToken : String? = nil, _ preResponse :HTTPURLResponse?, completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        let token : String? = extractedToken ?? LoginAuth.sharedInstance().getSsoToken()
        guard let ssoToken = token else {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
            completionHandler(nil, nil, error)
            return
        }
        let router = JRRouter<AuthApi>()
        var headers = ["token" : ssoToken, "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()]
        if let urlStr = urlStr {
            headers["X-CONSUMER-SOURCE"] = urlStr
        }
        
        if let response = preResponse {
            let statusCode = response.statusCode
            let errMsg = "iosapp error code = \(statusCode)"
            headers["X-CONSUMER-MESSAGE"] = errMsg
        }
        
        let isLoggedOutRequest = AuthApi.isLoggedOut(headers)
        router.request(type: JRDataType.self, isLoggedOutRequest) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    internal static func logoutSessionToken(completionHandler:@escaping ((_ data: Any?, _ response: Any?, _ error: Error?) -> Void)) {
        let router = JRRouter<AuthApi>()
        let requestInfo = JRLServiceManager.getAuthApiRequest(route: router, request: .logoutSessionToken([:], [:]))
        var rsaHeaders: [String: String] = [String: String]()
        
        if !JRLoginUI.sharedInstance().isCryptoEnabled(){
            rsaHeaders = ["Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()]
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken() {
                rsaHeaders["access_token"] = ssoToken
            }
        }
        else{
            var lheader: [String:String] = [String:String]()
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken() {
                lheader["session_token"] = ssoToken
            }
            rsaHeaders = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: [:], header: lheader)
        }
        
        router.request(type: JRDataType.self, .logoutSessionToken(rsaHeaders, [:])) { (data, response, error) in
            completionHandler(data, response, error)
        }
    }
    
    public static func setAccessToken(code:String, grantType: TokenGrantType = .oauthCode, loginId: String = "", retryCount: Int = 0, completionHandler: @escaping ((_ success:Bool?, _ error:Error?) -> Void)) {
        
        let router = JRRouter<AuthApi>()
        
        var headers: [String: String] = [:]
        var bodyParamsDict: [String: String] = [:]
        
        if !JRLoginUI.sharedInstance().isCryptoEnabled(){
            headers = ["Content-Type": "application/x-www-form-urlencoded", "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()]

            bodyParamsDict["code"] = code
            bodyParamsDict["client_id"] = LoginAuth.sharedInstance().getClientID()
            bodyParamsDict["client_secret"] = LoginAuth.sharedInstance().getClientSecret()
            bodyParamsDict["scope"] = "paytm"
            bodyParamsDict["grant_type"] = "authorization_code"
        }
        else{
            let lheaders = ["Content-Type": "application/json",
                       "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()
            ]
            
            switch grantType {
            case .oauthCode:
                bodyParamsDict[LOGINWSKeys.kCode] = code
            case .refreshToken:
                bodyParamsDict[LOGINWSKeys.kRefreshToken] = code
            }
            bodyParamsDict[LOGINWSKeys.kGrantMode] = grantType.rawValue
            bodyParamsDict[LOGINWSKeys.kDeviceId] = (LoginAuth.sharedInstance().getDefaultParameters()?["deviceIdentifier"] as? String) ?? ""
            
            let requestInfo = JRLServiceManager.getAuthApiRequest(route: router, request: .getAccessToken([:], [:]))
            headers = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: bodyParamsDict, header: lheaders)

        }
        
        let accessTokenAPI = AuthApi.getAccessToken(headers, bodyParamsDict)
        router.request(type: JRDataType.self, accessTokenAPI) { (data, response, error) in
            if let responseDict = getDictionary(from: data) {
                
                if !JRLoginUI.sharedInstance().isCryptoEnabled() {
                    if let _ = responseDict["error"] {
                        if let errMsg = responseDict["error_description"] as? String {
                            let error = NSError(domain: "", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: errMsg])
                            completionHandler(false, error)
                        } else {
                            completionHandler(false, nil)
                        }
                        return
                    }

                    if let accessToken = responseDict["access_token"] as? String, let userId = responseDict["resourceOwnerId"] as? String {
                        LoginAuth.sharedInstance().setuserID(userId)
                        LoginAuth.sharedInstance().setSsoToken(accessToken)
                        JRLServiceManager.getEncryptedSSOToken { (data, response, error) in }
                        completionHandler(true, nil)
                    } else {
                        completionHandler(false, nil)
                    }
                } else if let httpResponse = response as? HTTPURLResponse {
                    
                    let genericMsg = JRLoginConstants.generic_error_message
                    switch httpResponse.statusCode {
                        
                    case 200:
                        var areTokensUpdated: Bool = false

                        if let ltokens = responseDict["tokens"] as? [[String: String]], !ltokens.isEmpty {
                            for ltoken in ltokens {
                                if let scope = ltoken["scope"] {
                                    if scope == "paytm" {
                                        let paytmTokenDict: [String: String] = ltoken
                                        LoginAuth.sharedInstance().setPaytmTokenDict(paytmTokenDict)
                                        areTokensUpdated = true
                                    }
                                    if  scope == "wallet" {
                                        let walletTokenDict: [String: String] = ltoken
                                        LoginAuth.sharedInstance().setWalletTokenDict(walletTokenDict)
                                        areTokensUpdated = true
                                    }
                                }
                            }
                        }
                        if areTokensUpdated {
                            AuthRSAGenerator.shared.refreshRecentlyGeneratedPublicKey(for: loginId)
                            completionHandler(true,nil)
                        } else {
                            completionHandler(false, nil)
                        }
                        
                    case 407:
                        // Public rsa key not found, retrying or keeping existing keys NOT RECOMMENDED
                        AuthRSAGenerator.shared.removeAllSavedKeyPair()
                        //fallthrough
                        switch grantType {
                        case .oauthCode:
                            let lerr = NSError(domain: "Auth", code: JRReloginErrorCode, userInfo: [NSLocalizedDescriptionKey: genericMsg])
                            completionHandler(false, lerr)
                        case .refreshToken:
                            let lerr = NSError(domain: "Auth", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: genericMsg])
                            completionHandler(false, lerr)
                        }
                        
                    case 410, 422, 427:
                        // Do not retry in these cases as retry will not be fruitful as it might produce different error code on retry
                        // but retried to match android's behaviour
                        fallthrough
                        
                    case 400, 401, 403, 404, 452, 500:
                        // Retry once then show generic error, worth retrying in cases we just show error
                        fallthrough
                        
                    case 420, 429:
                        // Do not retry as these case are for excessive retries
                        // but retried to match android's behaviour
                        if retryCount < 1 {
                            let updatedRetryCount = (retryCount + 1)
                            setAccessToken(code: code, grantType: grantType, loginId: loginId, retryCount: updatedRetryCount, completionHandler: completionHandler)
                        } else {
                            let error = NSError(domain: "", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: genericMsg])
                            completionHandler(false, error)
                        }
                        
                    default:
                        // Show error in any other case without retrying
                        var errorMsg = genericMsg
                        if let errMsg = responseDict["error_description"] as? String {
                            errorMsg = errMsg
                        } else if let errMsg = responseDict["errorDescription"] as? String {
                            errorMsg = errMsg
                        }
                        let error = NSError(domain: "", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        completionHandler(false, error)
                    }
                }
            } else if let error = error {
                
                let errorCode = (error as NSError).code
                let errorMsg = JRLoginConstants.generic_error_message
                
                if errorCode == 404 {
                    // No purpose of retrying when resource is not found
                    let error = NSError(domain: "", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                    completionHandler(false, error)
                    
                } else if errorCode == 311 {
                    // This error code is received when http status code is 407, did same handling as above
                    AuthRSAGenerator.shared.removeAllSavedKeyPair()
                    switch grantType {
                    case .oauthCode:
                        let lerr = NSError(domain: "Auth", code: JRReloginErrorCode, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        completionHandler(false, lerr)
                    case .refreshToken:
                        let lerr = NSError(domain: "Auth", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: JRLoginConstants.generic_error_message])
                        completionHandler(false, lerr)
                    }
                } else {
                    completionHandler(false, error)
                }
                
            } else {
                let errorMsg = JRLoginConstants.generic_error_message
                let error = NSError(domain: "", code: JRUISessionError, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                completionHandler(false, error)
            }
        }
    }
    
    public static func getAllActiveTokens(withCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = AuthApi.urlGetAllTokens
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<AuthApi>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }

    //MARK:- Change Password
    public static func changePassword( _ params: [String:Any], completionHandler:@escaping (_: [String:Any]?,_ response: URLResponse?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .changePassword([:], [:]))
        var headers: [String:String] = [:]
        if let lheaders = requestInfo.allHTTPHeaderFields{
            headers = lheaders
        }
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)
        loginAPIRouter.request(type: JRDataType.self, .changePassword(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, response, error)
            } else {
                completionHandler(nil, response, error)
            }
        }
    }
    
    //MARK:- Forgot Password
    public static func invokeForgotPwd(forMobileNumber mobileNumber:String, _ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .forgotPasswordInit([:], [:]))
        var headers: [String:String] = [:]
        
        if let lheaders = requestInfo.allHTTPHeaderFields{ headers = lheaders }
        headers["loginId"] = mobileNumber
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)
        loginAPIRouter.request(type: JRDataType.self, .forgotPasswordInit(params, rsaHeaders) ) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func setNewPassword(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .resetForgotPassword([:], [:]))
        var headers: [String:String] = [:]
        if let lheaders = requestInfo.allHTTPHeaderFields{ headers = lheaders }
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)
        loginAPIRouter.request(type: JRDataType.self, .resetForgotPassword(params, rsaHeaders) ) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func getEncryptedSSOToken(withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        if let ssoToken = LoginAuth.sharedInstance().getSsoToken(){
            let router = JRRouter<AuthApi>()
            let headers = ["token" : ssoToken]
            let isLoggedOutRequest = AuthApi.urlGetEncryptedSSOToken(headers)
            router.request(type: JRDataType.self, isLoggedOutRequest) { (data, response, error) in
                if let responseDict = getDictionary(from: data) {
                    if let status = responseDict["status"] as? String, status == "success", let encSSOToken = responseDict["sso_token_enc"] as? String {
                        LoginAuth.sharedInstance().setEncSsoToken(encSSOToken)
                    }
                }
            }
        }
    }
    //MARK:-  new apis
    public static func sendEmailOTP(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .sendEmailOTP(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func reSendEmailOTP(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .reSendEmailOTP(params, [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: [:])
        
        loginAPIRouter.request(type: JRDataType.self, .reSendEmailOTP(params, rsaHeaders)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func validateEmailOTP(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .validateEmailOTP([:], [:]))
        var headers: [String:String] = [:]
        if let lheaders = requestInfo.allHTTPHeaderFields{ headers = lheaders }
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)
        loginAPIRouter.request(type: JRDataType.self, .validateEmailOTP(params, rsaHeaders)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func setNewPhoneNo(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .setNewPhoneNo(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func validateNewPhoneOTP(_ params: [String: String], isFromEmailUpdate: Bool, completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        let api: LoginApi
        
        if isFromEmailUpdate {
            var lheader: [String: String] = [String: String]()
            if let ssoToken = LoginAuth.sharedInstance().getSsoToken() {
                lheader["session_token"] = ssoToken
            } else {
                LoginAuth.getSSOTokenWith { (success, _, _) in
                    if success {
                        validateNewPhoneOTP(params, isFromEmailUpdate: isFromEmailUpdate, completionHandler: completionHandler)
                    } else {
                        let errorMsg = JRLoginConstants.generic_error_message
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errorMsg])
                        completionHandler(nil, error)
                    }
                }
            }
            let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .validateNewPhoneOTPForEmailUpdate([:], [:]))
            let rsaHeaders = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: lheader)
            api = .validateNewPhoneOTPForEmailUpdate(params, rsaHeaders)
            
        } else {
            api = .validateNewPhoneOTP(params)
        }
        
        loginAPIRouter.request(type: JRDataType.self, api) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func verifyUpdatedEmailOTP(_ params: [String: String], completionHandler: @escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .verifyEmailOTP(params, [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: [:])
        
        loginAPIRouter.request(type: JRDataType.self, .verifyEmailOTP(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    internal static func upgradeDevice(_ walletToken: String, completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        guard let defaultParameters = LoginAuth.sharedInstance().getDefaultParameters(),
            let deviceId = defaultParameters["deviceIdentifier"] as? String else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
                completionHandler(nil, error)
                return
        }
        
        let headers: [String: String] = [
            "session_token" : walletToken,
            "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()
        ]
        let params: [String: String] = [
            "deviceId" : deviceId,
            "publicKey" : AuthRSAGenerator.shared.getPublicKeyBase64String()
        ]

        let router = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: router, request: .upgradeDevice(params, headers))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)

        router.request(type: JRDataType.self, .upgradeDevice(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    internal static func upgradeAuthToken(_ walletToken: String, completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        
        guard let defaultParameters = LoginAuth.sharedInstance().getDefaultParameters(),
            let deviceId = defaultParameters["deviceIdentifier"] as? String else {
                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_session_token_not_found".localized])
                completionHandler(nil, error)
                return
        }
        
        let headers: [String: String] = [
            "Authorization" : LoginAuth.sharedInstance().getAuthorizationCode()
        ]
        let params: [String: String] = [
            "grantType" : "upgrade_token",
            "accessToken" : walletToken,
            "deviceId" : deviceId
        ]

        let router = JRRouter<AuthApi>()
        let requestInfo = JRLServiceManager.getAuthApiRequest(route: router, request: .upgradeAuthToken(headers, params))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: headers)

        router.request(type: JRDataType.self, .upgradeAuthToken(rsaHeaders, params)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK:-  phone update via profile
    public static func updatePhoneOTPViaProfile(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .updatePhoneOTPViaProfile(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    internal static func updateEmail(_ params: [String:String], completionHandler: @escaping (_: [String: Any]?, _: Error?) -> Void) {
        
        let loginAPIRouter = JRRouter<LoginApi>()
        let requestInfo = JRLServiceManager.getLoginApiRequest(route: loginAPIRouter, request: .updateEmail(params, [:]))
        let rsaHeaders: [String: String] = JRLServiceManager.getRSAHeader(requestInfo: requestInfo, param: params, header: [:])
        
        loginAPIRouter.request(type: JRDataType.self, .updateEmail(params, rsaHeaders)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    //MARK:- saved cards
    public static func verifierInit(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .verifierInit(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func verifierInitV2(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        let headers: [String: String]
        if let deviceIdentifier = LoginAuth.sharedInstance().getDefaultParameters()?["deviceIdentifier"] as? String {
            headers = [KEY_DEVICE_IDENTIFIER: deviceIdentifier]
        } else {
            headers = [:]
        }
        loginAPIRouter.request(type: JRDataType.self, .verifierInitV2(params, headers)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func doView(_ params: [String:Any],isLoginFlow: Bool = true, completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .doView(params, isLogin: isLoginFlow)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func doVerify(_ params: [String:Any],isLoginFlow: Bool = true, completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .doVerify(params, isLogin: isLoginFlow)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func cardDetails(_ params: [String:Any], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .cardDetails(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func fulfill(_ params: [String:String], completionHandler:@escaping (_: [String:Any]?, _: Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .fulfill(params)){ (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    public static func updateAccountStatus(_ params: [String: String], completionHandler:@escaping ([String: Any]?, Error?) -> Void) {
        let loginAPIRouter = JRRouter<LoginApi>()
        loginAPIRouter.request(type: JRDataType.self, .accountStatus(params)) { (data, response, error) in
            if let data = getDictionary(from: data) {
                completionHandler(data, error)
            } else {
                completionHandler(nil, error)
            }
        }
    }
    
    private static func getDictionary(from data: Any?) -> [String: Any]? {
        if data == nil {
            return nil
        }
        if let dictionary = data as? [String: Any] {
            return dictionary
        }
        do {
            let jsonObject = try JSONSerialization.jsonObject(with: (data as! Data), options: [.allowFragments, .mutableContainers])
            return jsonObject as? [String: Any]
        } catch {
            return nil
        }
    }
}
