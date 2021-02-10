//
//  JRAuthSignInVM.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 04/05/20.
//

typealias SignInResponseHandler = (_ success:Bool,_ error : String? ) -> Void

class JRAuthSignInVM {
    
    private(set) var authType: JarvisLoginType = .mobile
    var isNumberUpdated : Bool = false
    var isPasswordUpdated : Bool = false
    var preFilledLoginId : String = ""
    var goToHomeOnSkip : Bool = false
    var screenType: JarvisLoginScreenType
    let MAX_API_TRY: Int = 2
    var apiAttempt: Int = 0
    
    init(screenType:JarvisLoginScreenType = .fullScreen) {
        JRApplockHelper.sharedInstance.setIsLoginFromFullScreen(to: screenType == .fullScreen)
        self.screenType = screenType
    }
    
    func setAuth(type: JarvisLoginType) {
        self.authType = type
    }
    
    func isInputValid(text: String?) -> (valid: Bool, errorMsg: String?) {
        guard let eText = text else { return (false, nil)}
        
        if eText.isEmpty {
            return (false, "jr_login_mobile_number_cannot_be_empty".localized)
        }
        
        // empty check
        if self.authType == .mobile {
            if !eText.isValidMobileNumber() {
                return (false, "jr_kyc_please_enter_valid_mobile_number".localized)
            }
            
        } else {
            if !eText.isValidEmail() {
                return (false, "jr_kyc_please_enter_valid_mobile_number".localized) // change the message
            }
        }
        
        return (true, nil)
    }
    
    func verifyMobileNumber(_ mobileNumber: String, navigationController: UINavigationController, loginFlowType: JarvisLoginFlowType = .login, sessionExpiryCompletion: JRQuickLoginCompletion? = nil, GAEventLabel: String = "", completion: @escaping SignInResponseHandler) {
        
        //Create new keys
        if JRLoginUI.sharedInstance().isCryptoEnabled() {
            try? AuthRSAGenerator.shared.createKeyPair(for: mobileNumber)
        }
        
        //reset new user for orchestration before device binding
        LoginAuth.sharedInstance().isNewUserLoggedIn = false
        LoginAuth.sharedInstance().isLoginViaOtp = false
        
        var params = ["loginId": mobileNumber]
        if !JRLoginUI.sharedInstance().isCryptoEnabled(){
            params[LOGINWSKeys.kFlow] = LOGINACKeys.kSignup
        }
        JRLServiceManager.initiateLogin(params) {[weak self]  (data, error) in
            guard let weakSelf = self else {
                return
            }
            
            if let error = error {
                if (error as NSError).code == 311 {
                    AuthRSAGenerator.shared.removeSavedKeyPair(for: mobileNumber)
                    if weakSelf.apiAttempt < weakSelf.MAX_API_TRY {
                        weakSelf.verifyMobileNumber(mobileNumber, navigationController: navigationController, loginFlowType: loginFlowType, sessionExpiryCompletion: sessionExpiryCompletion, completion: completion)
                        weakSelf.apiAttempt += 1
                    } else {
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: "311")
                        }
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                } else if !error.localizedDescription.isEmpty {
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: error.localizedDescription, el3: LOGINGAKeys.kLabelAPI, el4: "")
                    }
                    completion(false, error.localizedDescription)
                } else {
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI)
                    }
                    completion(false, JRLoginConstants.generic_error_message)
                }
                return
            }
            
            DispatchQueue.main.async {
                guard let responseData = data,
                    let _ = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else{
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI)
                        }
                        completion(false, JRLoginConstants.generic_error_message)
                        return
                }
                
                let stateToken = responseData[LOGINWSKeys.kStateToken] as? String
                let loginid = params[LOGINWSKeys.kLoginId]
                JRApplockHelper.sharedInstance.setOnboardingStatus(to: .none)
                switch responseCode {
                case LOGINRCkeys.loginPassword : //3001
                    JRApplockHelper.sharedInstance.setOnboardingStatus(to: .login)
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel)                    }
                    let dataModel = JRLOtpPsdVerifyModel(loginId: loginid, stateToken: stateToken, otpTextCount: nil, loginType: weakSelf.authType)
                    if weakSelf.screenType == .fullScreen{
                        let vc = JRAuthPasswordVC.controller(dataModel)
                        navigationController.pushViewController(vc, animated: true)
                    }
                    else{
                        let vc = JRAuthPwdPopupVC.controller(dataModel, loginFlowType: loginFlowType)
                        vc.completion = sessionExpiryCompletion
                        navigationController.pushViewController(vc, animated: false)
                    }
                case LOGINRCkeys.loginOTP: //3000
                    LoginAuth.sharedInstance().isLoginViaOtp = true
                    JRApplockHelper.sharedInstance.setOnboardingStatus(to: .login)
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel)
                    }
                    let dataModel = JRLOtpPsdVerifyModel(loginId: loginid, stateToken: stateToken, otpTextCount: 6, loginType: weakSelf.authType)
                    if weakSelf.screenType == .fullScreen{
                        let vc = JRAuthOTPVC.controller(dataModel)
                        navigationController.pushViewController(vc, animated: true)
                    }
                    else{
                        let vc = JRAuthOTPPopupVC.newInstance(dataModel, loginFlowType: loginFlowType)
                        vc.completion = sessionExpiryCompletion
                        navigationController.pushViewController(vc, animated: false)
                    }
                    
                case LOGINRCkeys.signUpOTP: //3004
                    LoginAuth.sharedInstance().isNewUserLoggedIn = true
                    JRApplockHelper.sharedInstance.setOnboardingStatus(to: .login)
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel)
                    }
                    let dataModel = JRLOtpPsdVerifyModel(loginId: loginid, stateToken: stateToken, otpTextCount: 6, loginType: .newAccount)
                    if weakSelf.screenType == .fullScreen{
                        let vc = JRAuthOTPVC.controller(dataModel)
                        dataModel.allowUPI = true
                        navigationController.pushViewController(vc, animated: true)
                    }
                    else{
                        let vc = JRAuthOTPPopupVC.newInstance(dataModel,  loginFlowType: loginFlowType)
                        vc.completion = sessionExpiryCompletion
                        dataModel.allowUPI = true
                        navigationController.pushViewController(vc, animated: false)
                    }
                case LOGINRCkeys.otpLimitReach: //708
                    
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: message, el3: LOGINGAKeys.kLabelAPI, el4: LOGINRCkeys.otpLimitReach)
                        }
                        let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_dabu_OTP_Limit_Reached".localized,
                                                                      subtitle: message,
                                                                      confirmText: "jr_login_ok".localized,
                                                                      cancelText: nil)
                        JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) {_ in
                            completion(false, nil)
                        }
                    } else {
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                    
                case LOGINRCkeys.authRiskError, LOGINRCkeys.accountClosure:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: message, el3: LOGINGAKeys.kLabelAPI, el4: LOGINRCkeys.otpLimitReach)
                        }
                        let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_dabu_security_alert".localized,
                                                                      subtitle: message,
                                                                      confirmText: "jr_login_ok".localized,
                                                                      cancelText: nil)
                        JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) {_ in
                            completion(false, nil)
                        }
                    } else {
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                    
                case LOGINRCkeys.invalidPublicKey,
                     LOGINRCkeys.invalidSignature: //BE1423001, BE1423003
                    AuthRSAGenerator.shared.removeSavedKeyPair(for: mobileNumber)
                    if weakSelf.apiAttempt < weakSelf.MAX_API_TRY {
                        weakSelf.verifyMobileNumber(mobileNumber, navigationController: navigationController, loginFlowType: loginFlowType, sessionExpiryCompletion: sessionExpiryCompletion, completion: completion)
                        weakSelf.apiAttempt += 1
                    } else {
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                        }
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                    
                case LOGINRCkeys.badRequest,
                     LOGINRCkeys.invalidLogin,
                     LOGINRCkeys.scopeNotRefreshable,
                     LOGINRCkeys.signatureTimeExpired,
                     LOGINRCkeys.authorizationMissing,
                     LOGINRCkeys.invalidAuthCode,
                     LOGINRCkeys.clientPermissionNotFound,
                     LOGINRCkeys.missingMandatoryHeaders,
                     LOGINRCkeys.issueProcessingRequest:
                    if !GAEventLabel.isEmpty{
                        JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                    }
                    completion(false, JRLoginConstants.generic_error_message)
                    
                case LOGINRCkeys.DIYAccountBlocked:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        
                        let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_account_blocked".localized,
                                                                      subtitle: message,
                                                                      confirmText: "jr_login_unblock_account".localized,
                                                                      cancelText: "jr_login_cancel".localized)
                        
                        JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) { success in
                            guard let vc = UIApplication.topViewController(), success else {
                                completion(false, nil)
                                if !GAEventLabel.isEmpty{
                                    JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                                }
                                return
                            }
                            if !GAEventLabel.isEmpty{
                                JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: message, el3: LOGINGAKeys.kLabelAPI)
                            }
                            JRLoginUI.sharedInstance().delegate?.openLoginIssues(mobileNumber, vc)
                        }
                    } else {
                        if !GAEventLabel.isEmpty{
                            JRLoginGACall.loginProceedClicked(weakSelf.screenType, loginFlowType, el1: GAEventLabel, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                        }
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                    
                default:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        completion(false, message)
                    } else {
                        completion(false, JRLoginConstants.generic_error_message)
                    }
                }
            }
        }
    }
    
    func checkCache(){
        if LoginAuth.sharedInstance().isLoggedIn(){
            JRLoginUI.sharedInstance().delegate?.clearCacheIfRequired()
        }
    }
}
