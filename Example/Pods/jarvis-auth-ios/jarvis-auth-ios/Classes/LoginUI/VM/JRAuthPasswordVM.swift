//
//  JRAuthPasswordVM.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 05/05/20.
//

typealias PasswordResponseHandler = (_ success:Bool, _ responseCode: String, _ error : String?, _ model: JRLOtpPsdVerifyModel? , _ signinSuccess: Bool?, _ signInError: Error?) -> Void


class JRAuthPasswordVM {
    
    static func validate(password: String, stateToken: String, loginId: String, loginFlowType: JarvisLoginFlowType = .login, loginType: JarvisLoginType, retryCount: Int = 0, sessionExpiryCompletion: JRQuickLoginCompletion? = nil, completion: @escaping PasswordResponseHandler) {
        
        let params =  [LOGINWSKeys.kPassword: password, LOGINWSKeys.kStateToken: stateToken]
        JRLServiceManager.validatePassword(params) {(data, error) in
            
            let genericMessage = JRLoginConstants.generic_error_message
            
            if let error = error {
                if (error as NSError).code == 311 {
                    if retryCount < 2 {
                        let updatedRetryCount = (retryCount + 1)
                        validate(password: password, stateToken: stateToken, loginId: loginId, loginFlowType: loginFlowType, loginType: loginType, retryCount: updatedRetryCount, sessionExpiryCompletion: sessionExpiryCompletion, completion: completion)
                    } else {
                        completion(false, "", genericMessage, nil, nil, nil)
                    }
                } else if !error.localizedDescription.isEmpty {
                    completion(false, "", error.localizedDescription, nil, nil, nil)
                } else {
                    completion(false, "", genericMessage, nil, nil,nil)
                }
                return
            }
            
            guard let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else{
                completion(false, "", genericMessage, nil, nil, nil)
                return
            }
            
            switch responseCode {
            case LOGINRCkeys.loginOTP:
                if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                    let dataModel = JRLOtpPsdVerifyModel(loginId: loginId, stateToken: stateToken, otpTextCount: 6, loginType: loginType)
                    dataModel.isFromPassword = true
                    completion(true, LOGINRCkeys.loginOTP, nil, dataModel, nil, nil)
                }
            case LOGINRCkeys.success:
                if let oauthCode = responseData[LOGINWSKeys.kOauthCode] as? String {
                    if let passwordViolation = responseData[LOGINWSKeys.kpasswordViolation] as? Bool{
                        LoginAuth.sharedInstance().setPasswordVoilation(passwordViolation) 
                    }
                    JRLServiceManager.setAccessToken(code: oauthCode,loginId: loginId, completionHandler: { (isSuccess, error) in
                        if let isSuccess = isSuccess, isSuccess {
                            completion(true, LOGINRCkeys.success, nil, nil, isSuccess, error)
                        } else {
                            completion(false, "", genericMessage, nil, nil, error)
                        }
                    })
                }
                
            case LOGINRCkeys.invalidPublicKey:
                if retryCount < 2 {
                    let updatedRetryCount = (retryCount + 1)
                    validate(password: password, stateToken: stateToken, loginId: loginId, loginFlowType: loginFlowType, loginType: loginType, retryCount: updatedRetryCount, sessionExpiryCompletion: sessionExpiryCompletion, completion: completion)
                } else {
                    completion(false, responseCode, genericMessage, nil, nil, nil)
                }
                
            case LOGINRCkeys.badRequest,
                 LOGINRCkeys.issueProcessingRequest,
                 LOGINRCkeys.signatureTimeExpired,
                 LOGINRCkeys.invalidSignature,
                 LOGINRCkeys.authorizationMissing,
                 LOGINRCkeys.BEInvalidToken,
                 LOGINRCkeys.clientPermissionNotFound,
                 LOGINRCkeys.missingMandatoryHeaders,
                 LOGINRCkeys.invalidAuthCode,
                 LOGINRCkeys.invalidRefreshToken,
                 LOGINRCkeys.scopeNotRefreshable,
                 LOGINRCkeys.internalServerErr,
                 LOGINRCkeys.authErr:
                completion(false, responseCode, genericMessage, nil, nil, nil)
                
            case LOGINRCkeys.unprocessableEntity:
                if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                    completion(false, responseCode, message, nil, nil, nil)
                } else {
                    completion(false, responseCode, genericMessage, nil, nil, nil)
                }
                
            case LOGINRCkeys.otpLimitReach:
                let message = responseData[LOGINWSKeys.kMesssage] as? String
                let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_dabu_OTP_Limit_Reached".localized,
                                                              subtitle: message ?? "",
                                                              confirmText: "jr_login_ok".localized,
                                                              cancelText: nil)
                showPSSPopup(message, responseCode, genericMessage, model, completion)
            case LOGINRCkeys.accountBlocked:
                let message = responseData[LOGINWSKeys.kMesssage] as? String
                let model = JRDIYAccountUnblockPopupViewModel(title: "Password Limit Reached",
                                                              subtitle: message ?? "",
                                                              confirmText: "jr_login_ok".localized,
                                                              cancelText: nil)
                showPSSPopup(message, responseCode, genericMessage, model, completion)
            default:
                if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                    completion(false, responseCode, message, nil, nil, nil)
                } else {
                    completion(false, responseCode, genericMessage, nil, nil, nil)
                }
            }
        }
    }
    
    private static func showPSSPopup(_ message: String?, _ responseCode: String, _ genericMessage: String, _ model: JRDIYAccountUnblockPopupViewModel, _ completion: @escaping PasswordResponseHandler) {
        guard message != nil else {
            completion(false, responseCode, genericMessage, nil, nil, nil)
            return
        }
        JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) {_ in
            completion(false, responseCode, nil, nil, nil, NSError(domain: "Auth",
                                                                   code: JRReloginErrorCode,
                                                                   userInfo: nil))
        }
    }
    
    static func validatePassword(_ password: String, stateToken: String, retryCount: Int = 0, sessionExpiryCompletion: JRQuickLoginCompletion? = nil , _ completion:@escaping ((_ success: Bool?, _ error: Error?) -> Void)) {
        let params =  [LOGINWSKeys.kPassword: password, LOGINWSKeys.kStateToken: stateToken]
        JRLServiceManager.validatePassword(params) {(data, error) in
            var defaultError = NSError(domain:"", code: -1, userInfo: [ NSLocalizedDescriptionKey: JRLoginConstants.generic_error_message])
            if let error = error {
                if (error as NSError).code == 311 {
                    if retryCount < 2 {
                        let updatedRetryCount = (retryCount + 1)
                        validatePassword(password, stateToken: stateToken, retryCount: updatedRetryCount, sessionExpiryCompletion: sessionExpiryCompletion, completion)
                    } else {
                        completion(false, defaultError)
                    }
                } else {
                    completion(false, error)
                }
            } else if let responseData = data, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                switch responseCode {
                case LOGINRCkeys.loginOTP:
                    DispatchQueue.main.async {
                        if let topVC = UIApplication.topViewController(){
                            if let pwdVC = topVC as? JRAuthPwdPopupVC{
                                JRLoginGACall.passwordScreenProceedClicked(pwdVC.screenType, pwdVC.loginFlowType)
                                let loadingIndicatorView = pwdVC.loadingIndicatorView
                                loadingIndicatorView?.isHidden = true
                                if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                                    var loginId: String = ""
                                    if let lloginId = pwdVC.dataModel?.loginId{
                                        loginId = lloginId
                                    }
                                    let dataModel = JRLOtpPsdVerifyModel(loginId: loginId, stateToken: stateToken, otpTextCount: 6, loginType: .mobile)
                                    let vc = JRAuthOTPPopupVC.newInstance(dataModel, loginFlowType: .sessionExpiry)
                                    vc.completion = sessionExpiryCompletion
                                    vc.delegate = pwdVC
                                    pwdVC.dataModel?.setState(token: stateToken)
                                    pwdVC.navigationController?.pushViewController(vc, animated: false)
                                }
                            }
                            
                        }
                    }
                case LOGINRCkeys.success:
                    DispatchQueue.main.async {
                        if let oauthCode = responseData[LOGINWSKeys.kOauthCode] as? String {
                            if let passwordViolation = responseData[LOGINWSKeys.kpasswordViolation] as? Bool{
                                LoginAuth.sharedInstance().setPasswordVoilation(passwordViolation)
                            }
                            var loginId: String = ""
                            if let topVC = UIApplication.topViewController(), let pwdVC = topVC as? JRAuthPwdPopupVC{
                                JRLoginGACall.passwordScreenProceedClicked(pwdVC.screenType, pwdVC.loginFlowType)
                                if let lloginId = pwdVC.dataModel?.loginId{
                                    loginId = lloginId
                                }
                            }
                            JRLServiceManager.setAccessToken(code: oauthCode,loginId: loginId, completionHandler: { (isSuccess, error) in
                                completion(isSuccess, error)
                            })
                        } else {
                            completion(false, defaultError)
                        }
                    }
                case LOGINRCkeys.invalidPublicKey:
                    if retryCount < 2 {
                        let updatedRetryCount = (retryCount + 1)
                        validatePassword(password, stateToken: stateToken, retryCount: updatedRetryCount, sessionExpiryCompletion: sessionExpiryCompletion, completion)
                    } else {
                        fallthrough
                    }
                    
                case LOGINRCkeys.badRequest,
                     LOGINRCkeys.issueProcessingRequest,
                     LOGINRCkeys.signatureTimeExpired,
                     LOGINRCkeys.invalidSignature,
                     LOGINRCkeys.authorizationMissing,
                     LOGINRCkeys.BEInvalidToken,
                     LOGINRCkeys.clientPermissionNotFound,
                     LOGINRCkeys.missingMandatoryHeaders,
                     LOGINRCkeys.invalidAuthCode,
                     LOGINRCkeys.invalidRefreshToken,
                     LOGINRCkeys.scopeNotRefreshable,
                     LOGINRCkeys.internalServerErr,
                     LOGINRCkeys.authErr:
                    completion(false, defaultError)
                    
                case LOGINRCkeys.unprocessableEntity, LOGINRCkeys.otpLimitReach, LOGINRCkeys.accountBlocked:
                    fallthrough
                    //JRAuthSessionExpiryMgr.openLogin()
                    
                default:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        defaultError = NSError(domain:"", code: Int(responseCode) ?? -1, userInfo: [ NSLocalizedDescriptionKey: message])
                    }
                    completion(false, defaultError)
                }
            } else {
                completion(false, defaultError)
            }
        }
    }
    
}
