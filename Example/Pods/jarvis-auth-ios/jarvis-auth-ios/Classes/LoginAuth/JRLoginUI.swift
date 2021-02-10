// JarvisLogin.swift
// Login
//
//  Created by Parmod on 30/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation
import jarvis_network_ios
import jarvis_utility_ios
import os

public typealias UPIOnBoardingCompletionHandler = (_ resultType: String, _ data: Any?) -> Void
public typealias MKYCOnBoardingCompletionHandler = (_ success: Bool, _ data: Any?) -> Void

//MARK:- JarvisLoginDelegate
public protocol JarvisLoginDelegate: class {
    func signIn(isSuccess: Bool?, error: Error?)
    func signUp(isSuccess: Bool?, error: Error?)
    func signOut(success: Bool?, error: Error?)
    func signOut(completionHandler:@escaping((_ success: Bool?, _ error: Error?) -> Void))
    func signInUserDenied()
    func pushLoginIssues(_ mobileNumber: String, _ fromViewController: UIViewController)
    func pushForgotPassword(_ loginId: String, _ fromViewController: UIViewController)
    func getGTMKeyValue<T>(_ gtmKey: String) -> T?
    func trackCustomEventforScreen(_ screenName:String?, eventName: String?, variables:[AnyHashable : Any]?)
    func pushHomeView(_ animated: Bool, _ isLoginRequired: Bool)
    func pushFacingOtherIssuesScreen(_ fromViewController: UIViewController)
    func invokeUPIFlow(using navigationController: UINavigationController?, callback: @escaping UPIOnBoardingCompletionHandler)
    func openLoginIssues(_ mobileNumber: String, _ fromViewController: UIViewController)
    func signOutUserAndPresentLogin()
    func sessionExpired()
    func invokeMKYCFlow(using isMinKyc: Bool, navigationController: UINavigationController?, callback: @escaping MKYCOnBoardingCompletionHandler)
    func signOutAfterUserBlock()
    func clearCacheIfRequired()
    func invokeContactSDK()
    func loginScreenDidAppear()
}

public extension JarvisLoginDelegate{
    func invokeUPIFlow(using navigationController: UINavigationController?, callback: @escaping UPIOnBoardingCompletionHandler){}
    
    func signUp(isSuccess: Bool?, error: Error?){}
    
    func trackOpenScreenEvent(forScreen screen: String){}
    
    func openLoginIssues(_ mobileNumber: String, _ fromViewController: UIViewController){}
    
    func signOutUserAndPresentLogin(){}
    
    func sessionExpired(){}
    
    func invokeMKYCFlow(using isMinKyc: Bool, navigationController: UINavigationController?, callback: @escaping MKYCOnBoardingCompletionHandler){}

    func signOutAfterUserBlock(){}
    
    func clearCacheIfRequired(){}
    
    func invokeContactSDK(){}
    
    func loginScreenDidAppear(){}
}

public class JRLoginUI: NSObject {
    
    public typealias JRSessionExpiryCompletion = ((_ success:Bool?, _ updatedSSOToken: String?, _ expiredSSOToken:String?, _ updatedWalletToken: String?, _ expiredWalletToken:String?, _ error:Error?) -> Void)
    
    public typealias JRWalletTokenExpiryCompletion = ((_: Bool, _: String?, _ : [String:Any]?) -> Void)
    
    //MARK:- Properties
    private static var instance: JRLoginUI = JRLoginUI()
    private var isRefreshTokenInProgress: Bool?
    weak public var delegate: JarvisLoginDelegate?
    
    private override init() {
        super.init()
        JRAuthHandler.shared.delegate  = self
    }
}

//MARK:- Public Methods
extension JRLoginUI {
    public class func sharedInstance() -> JRLoginUI {
        return instance
    }

    public func isCryptoEnabled() -> Bool{
        guard let isCryptoEnabled: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("enableOauthCryptography_iOS") else{
            return true
        }
        return isCryptoEnabled
    }
    
    internal func isUPIOnboardingEnabledForLogin() -> Bool{
        guard let isUPIOnboardingEnabledForLogin: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("upiLoginOnboarding_iOS") else{
            return true
        }
        return isUPIOnboardingEnabledForLogin
    }
    
    internal func isUPIOnboardingEnabledForSignup() -> Bool{
        guard let isUPIOnboardingEnabledForSignup: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("upiSignupOnboarding_iOS") else{
            return true
        }
        return isUPIOnboardingEnabledForSignup
    }
    
    internal func isMinKYCOnboardingEnabledForLogin() -> Bool{
        guard let isMinKYCOnboardingEnabledForLogin: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("mKycLoginOnboarding_iOS") else{
            return true
        }
        return isMinKYCOnboardingEnabledForLogin
    }
    
    internal func isMinKYCOnboardingEnabledForSignup() -> Bool{
        guard let isMinKYCOnboardingEnabledForSignup: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("mKycSignupOnboarding_iOS") else{
            return true
        }
        return isMinKYCOnboardingEnabledForSignup
    }
    
    internal func isAppLockOnboardingEnabledForLogin() -> Bool{
        guard let isAppLockOnboardingEnabledForLogin: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("applockLoginOnboarding_iOS") else{
            return true
        }
        return isAppLockOnboardingEnabledForLogin
    }
    
    internal func isAppLockOnboardingEnabledForSignup() -> Bool{
        guard let isAppLockOnboardingEnabledForSignup: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("applockSignupOnboarding_iOS") else{
            return true
        }
        return isAppLockOnboardingEnabledForSignup
    }
    
    public func signIn(_ loginType: JarvisLoginType = .mobile, _ loginId: String = "", _ viewController: UIViewController? = UIApplication.topViewController(), allowUPI: Bool = false, screenType: JarvisLoginScreenType = .popup, isPasswordUpdated: Bool = false) {
        if let viewController = viewController {
            guard JRAuthManager.isAppAlreadyLaunched else {
                showLaunchScreenOn(vc: viewController)
                return
            }
            switch loginType {
            case .mobile, .email:
                self.signIn(withMobileNumber: loginId, viewController: viewController, screenType: screenType, isPasswordUpdated: isPasswordUpdated )
            case .newAccount:
                self.signUp(withMobileNumber: loginId, viewController: viewController, allowUPI: allowUPI, screenType: screenType,  isPasswordUpdated: isPasswordUpdated)
            }
        }
    }
    
    public func invokeLoginFullScreen(_ loginId: String = "", _ isSkipBtnEnabled: Bool = true, _ isBackBtnEnabled: Bool = true) -> UINavigationController{
        let vc = JRAuthSignInVC.newInstance
        vc.vModel.preFilledLoginId = loginId
        vc.isBackBtnEnabled = isBackBtnEnabled
        vc.isSkipBtnEnabled = isSkipBtnEnabled
        vc.modalPresentationStyle = .fullScreen
        let navVC = UINavigationController(rootViewController: vc)
        navVC.modalPresentationStyle = .overFullScreen
        navVC.setNavigationBarHidden(true, animated: true)
        return navVC
    }
    
    public func pushSetPasswordPopupViaDeeplink() {
        guard !LoginAuth.sharedInstance().isPasswordCreated() else { return }
        setPassword(showCrossBtn: true, enableDiffLogin: true)
    }
    
    public func getAccountBlockLoginController() -> UIViewController? {
        return JRDIYAccountBlockReasonVC.getController()
    }
    
    public func getAccountBlockLogoutController(for deeplink: [AnyHashable: Any]) -> UIViewController? {
        let number = deeplink["number"] as? String
        return JRGetHelpWithAccountVC.getController(for: number)
    }
    
    public func getPhoneNumberController(for deeplink: [AnyHashable: Any]) -> UIViewController? {
        guard let number = deeplink["mobileNumber"] as? String else { return nil }
        return JRPhoneNumberVC(phoneNumber: number)
    }
    
    public func invokeLoginFullScreenVC(_ loginId: String = "", _ isSkipBtnEnabled: Bool = true, _ isBackBtnEnabled: Bool = true) -> UIViewController{
        let vc = JRAuthSignInVC.newInstance
        vc.vModel.preFilledLoginId = loginId
        vc.isBackBtnEnabled = isBackBtnEnabled
        vc.isSkipBtnEnabled = isSkipBtnEnabled
        vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    public func signOut(dueToSessionExpiry:Bool = false) {
        var userId = ""
        if let _userId = LoginAuth.sharedInstance().getUserID(){
            userId = _userId
        }
        LoginAuth.sharedInstance().setPreviousUserId(userId)
        if dueToSessionExpiry{
            LoginAuth.sharedInstance().setLastLogoutReason(LastLogoutReason.sessionExpiry)
        }else{
            LoginAuth.sharedInstance().setLastLogoutReason(LastLogoutReason.manual)
        }
        JRLServiceManager.signOut { (isSuccess, error) in
            if let success = isSuccess, success, !dueToSessionExpiry{
                LoginAuth.sharedInstance().resetSSOToken()
                LoginAuth.sharedInstance().resetTokens()
            }
            self.delegate?.signOut(success: isSuccess, error: error)
        }
    }
    
    public func addMobile(_ viewController:UIViewController? = UIApplication.topViewController()) {
        DispatchQueue.main.async {
            if let otpPopUp = JRLMobilePopUpVC.controller() {
                otpPopUp.modalPresentationStyle = .overFullScreen
                viewController?.present(otpPopUp, animated: true)
            }
        }
    }
    
    public func setPassword(_ viewController:UIViewController? = UIApplication.topViewController(), showCrossBtn:Bool = false, enableDiffLogin:Bool = true) {
        DispatchQueue.main.async {
            if let otpPopUp = JRLSetPasswordVC.controller() {
                otpPopUp.modalPresentationStyle = .overFullScreen
                otpPopUp.showCrossButton = showCrossBtn
                otpPopUp.showLoginWithDiffMobile = enableDiffLogin
                viewController?.present(otpPopUp, animated: true)
            }
        }
    }
    
    public func initiateSessionExpiryFlow(extractedSSOToken : String? = nil, extractedWalletToken : String? = nil, _ preResponse: HTTPURLResponse?, completionHandler:@escaping JRSessionExpiryCompletion) {
        
        JRLoginUI.sharedInstance().delegate?.signOut(completionHandler: { (isSuccess, error) in
            if error != nil {
                self.isRefreshTokenInProgress = false
                completionHandler(false, "", "", "", "", error)
                return
            }
            self.showSessionExpiredAlert(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completionHandler)
        })
    }
    
    private func initiateReloginFlow(extractedSSOToken: String? = nil, extractedWalletToken: String? = nil, completion: @escaping JRSessionExpiryCompletion) {
        
        JRLoginUI.updateSsoToken { (success, error, needCompletionHandler) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JRLoginConstants.kSessionExipiryUIDismiss), object: nil)
            self.isRefreshTokenInProgress = false
            guard needCompletionHandler else {
                defer {
                    JRLoginUI.sharedInstance().delegate?.pushHomeView(false, true)
                }
                return
            }
            
            if let success = success, success {
                let fetchStrategy: String = "DEFAULT,USER_TYPE,USERID,USER_ATTRIBUTE,password_status,kyc_state"
                JRAuthBaseVC.signInRefreshToken(fetchStrategy, completionHandler: { (_) in
                    completion(success, LoginAuth.sharedInstance().getSsoToken(), extractedSSOToken, LoginAuth.sharedInstance().getWalletToken(), extractedWalletToken, nil)
                })
            } else {
                completion(success, "", "", "", "", error)
            }
        }
    }
    
    private func showSessionExpiredAlert(extractedSSOToken: String? = nil, extractedWalletToken: String? = nil, completion: @escaping JRSessionExpiryCompletion) {
        if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "jr_login_session_expired".localized, message: "jr_login_relogin_to_continue".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                    self.initiateReloginFlow(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completion)
                }
                alert.addAction(okAction)
                topController.present(alert, animated: true, completion: nil)
            }
        } else {
            initiateReloginFlow(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completion)
        }
    }
        
    private func checkSSOToken(_ urlStr: String?,selectedSSOToken : String? = nil, extractedSSOToken : String? = nil, extractedWalletToken : String? = nil, _ preResponse: HTTPURLResponse?,isWalletTokenAlreadyValid: Bool = false, completionHandler:@escaping JRSessionExpiryCompletion) {
        
        LoginAuth.sharedInstance().isLoggedOut(urlStr,extractedToken: selectedSSOToken, preResponse) { (data, response, error) in
            
            if let data = data as? [String: Any], let responseCode = data["responseCode"] as? String , responseCode == "02"{
                self.isRefreshTokenInProgress = false
                if isWalletTokenAlreadyValid{
                    completionHandler(false, "", "", "", "", error)
                }
                else{
                    completionHandler(true, LoginAuth.sharedInstance().getSsoToken(), extractedSSOToken , LoginAuth.sharedInstance().getWalletToken(), extractedWalletToken, error)
                }
                
                return
            }
            else if let lssoTokenDict = LoginAuth.sharedInstance().getPaytmTokenDict(), let lrefreshToken = lssoTokenDict["refreshToken"]{
                
                JRLServiceManager.setAccessToken(code: lrefreshToken, grantType: .refreshToken) { (isSuccess, error) in

                    self.isRefreshTokenInProgress = false
                    if let lsuccess = isSuccess, lsuccess {
                        //4. Update the token and dict. Return the completion with updated value
                        completionHandler(isSuccess, LoginAuth.sharedInstance().getSsoToken(), extractedSSOToken, LoginAuth.sharedInstance().getWalletToken(), extractedWalletToken, nil)
                    } else {
                        self.initiateSessionExpiryFlow(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
                    }
                }
            } else {
                self.isRefreshTokenInProgress = false
                
                self.initiateSessionExpiryFlow( extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
            }
        }
    }

    public func refreshSessionToken(_ urlStr: String?,extractedSSOToken : String? = nil, extractedWalletToken : String? = nil, _ preResponse: HTTPURLResponse?, completionHandler:@escaping JRSessionExpiryCompletion) {
        
        if let isRefreshTokenInProgress = isRefreshTokenInProgress, isRefreshTokenInProgress {
            return
        }
        
        isRefreshTokenInProgress = true
           
        if JRLoginUI.sharedInstance().isCryptoEnabled(){
            //When crpto is enabled
            var lwalletToken = ""
            var lssoToken = ""
            
            if let lextractedWalletToken = extractedWalletToken{
                //isWalletTokenExistInRequest = true
                lwalletToken = lextractedWalletToken
            }
            else{
                lwalletToken = LoginAuth.sharedInstance().getWalletToken() ?? ""
            }
            
            if let lextractedSSOToken = extractedSSOToken{
                lssoToken = lextractedSSOToken
            }
            else{
                lssoToken = LoginAuth.sharedInstance().getSsoToken() ?? ""
            }
                        
            //Check the Wallet Token Existence -----------------
            LoginAuth.sharedInstance().isLoggedOut(urlStr,extractedToken: lwalletToken, preResponse) { (data, response, error) in
                
                if let data = data as? [String: Any], let responseCode = data["responseCode"] as? String , responseCode == "02"{
                    self.checkSSOToken(urlStr, selectedSSOToken: lssoToken, extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, isWalletTokenAlreadyValid: true , completionHandler: completionHandler)
                }
                else if let lwalletTokenDict = LoginAuth.sharedInstance().getWalletTokenDict(), let lrefreshToken = lwalletTokenDict["refreshToken"]{
                    
                    JRLServiceManager.setAccessToken(code: lrefreshToken, grantType: .refreshToken) { (isSuccess, error) in
                        
                        if let lsuccess = isSuccess, lsuccess {
                            self.checkSSOToken(urlStr, selectedSSOToken: lssoToken, extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
                        } else {
                            // API error handling
                            //Initiate Session Expiry UI flow
                            self.isRefreshTokenInProgress = false
                            self.initiateSessionExpiryFlow(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
                        }
                    }
                } else {
                    self.isRefreshTokenInProgress = false
                    self.initiateSessionExpiryFlow(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
                }
            }
        } else {
            //When Crpto is not enabaled // Rollback plan
            var expiredToken: String? = extractedSSOToken
            
            if let extractedWalletToken = extractedWalletToken {
                expiredToken = extractedWalletToken
            }
            
            guard let token = expiredToken, !token.isEmpty else {
                isRefreshTokenInProgress = false
                defer {
                    JRLoginUI.sharedInstance().delegate?.pushHomeView(false, true)
                }
                return
            }
                        
            LoginAuth.sharedInstance().isLoggedOut(urlStr,extractedToken: token, preResponse) { (data, response, error) in
                if error != nil {
                    self.isRefreshTokenInProgress = false
                    completionHandler(false, "", "", "", "", error)
                    return
                }
                
                if let data = data as? [String: Any], let loggedOut = data["loggedout"] as? Bool, loggedOut == false {
                    let error = NSError.init(domain: "Data display error", code:  99, userInfo: [NSLocalizedDescriptionKey: "jr_ac_tryReconnecting".localized])
                    self.isRefreshTokenInProgress = false
                    completionHandler(false, "", "", "", "", error)
                } else {
                    
                    self.initiateSessionExpiryFlow( extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, preResponse, completionHandler: completionHandler)
                }
            }
        }
    }
    
    public func initiatePhoneUpdateViaProfile(_ viewController: UIViewController? = UIApplication.topViewController()){
        DispatchQueue.main.async {
            if let vc = JRPUMessageVC.controller() as? JRPUMessageVC {
                let navVC = UINavigationController(rootViewController: vc)
                navVC.modalPresentationStyle = .fullScreen
                viewController?.present(navVC, animated: true)
                navVC.setNavigationBarHidden(true, animated: true)
            }
        }
    }
    
    public func initiateForgotPwdFlowV2(withMobileNumber mobileNumber: String = "", _ viewController: UIViewController? = UIApplication.topViewController()) {
        DispatchQueue.main.async {
            let vc = JRLForgotPwdVC.newInstance
            var mNumber = ""
            if !mobileNumber.isEmpty{
                mNumber = mobileNumber
            }
                // prefilledLoginId Userdefault will be moved in utility
            else if let mobileNumber = UserDefaults.standard.string(forKey: "prefilledLoginId"), !mobileNumber.isEmpty{
                mNumber = mobileNumber
            }
            vc.prefilledMobileNo = mNumber
            if let mVC = viewController {
                JRLoginUI.presentAuth(vc: vc, onVc: mVC)
            }
        }
    }
    
    public func initiateUpgradePwdFlowV2(using navController: UINavigationController){
        LoginAuth.sharedInstance().passwordUpgrade(isEnabled: true)
        LoginAuth.sharedInstance().setPasswordVoilation(true)
        DispatchQueue.main.async {
            JRLoginUI.sharedInstance().invokeChangePassword(using: navController)
        }
    }
    
    public func showSignUpPrompt(_ viewController: UIViewController? = UIApplication.topViewController()){
        if let singnUpPrompt = JRLSignUpPrompt.controller(){
            singnUpPrompt.modalPresentationStyle = .overFullScreen
            DispatchQueue.main.async {
                viewController?.present(singnUpPrompt, animated: true)
            }
        }
    }
    
    public func canShowSignUpPrompt() -> Bool{
        if UserDefaults.standard.value(forKey: kSignUpPromptIntervalListIndex) == nil{
            UserDefaults.standard.set(-1, forKey: kSignUpPromptIntervalListIndex)
            UserDefaults.standard.synchronize()
        }
        
        var intervalCSV = "1,3,5,7"
        if let intervalCSVValue: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("signUpPopUpIntervals"){
            intervalCSV = intervalCSVValue
        }
        let intervals = intervalCSV.components(separatedBy: ",")
        let savedIndex = UserDefaults.standard.integer(forKey: kSignUpPromptIntervalListIndex)
        let savedDate = UserDefaults.standard.object(forKey: kSignUpPromptSavedDate) as? Date
        let milliSecsInADay = 86400
        if intervals.count > ( savedIndex + 1 ){
            if savedDate == nil{
                UserDefaults.standard.set(Date(), forKey: kSignUpPromptSavedDate)
                UserDefaults.standard.synchronize()
                let interval = intervals[savedIndex + 1]
                if interval.intValue == 0{
                    updateSignUpPromptPrefrences()
                    return true
                }
            }else if let savedDate = savedDate{
                let interval = intervals[savedIndex + 1]
                let milliSecsForInterval:TimeInterval = TimeInterval(milliSecsInADay * interval.intValue)
                if Date().timeIntervalSince1970 - savedDate.timeIntervalSince1970 >= milliSecsForInterval {
                    updateSignUpPromptPrefrences()
                    return true
                }
            }
        }else {
            if intervals.count > 0, let lastInterval = intervals.last, let savedDate = savedDate{
                let milliSecsForInterval:TimeInterval = TimeInterval(milliSecsInADay * lastInterval.intValue)
                if Date().timeIntervalSince1970 - savedDate.timeIntervalSince1970 >= milliSecsForInterval {
                    UserDefaults.standard.set(Date(), forKey: kSignUpPromptSavedDate)
                    UserDefaults.standard.synchronize()
                    return true
                }
            }
        }
        return false
    }
    
    public func updateSignUpPromptPrefrences(){
        let savedIndex = UserDefaults.standard.integer(forKey: kSignUpPromptIntervalListIndex)
        UserDefaults.standard.set((savedIndex + 1), forKey: kSignUpPromptIntervalListIndex)
        UserDefaults.standard.set(Date(), forKey: kSignUpPromptSavedDate)
        UserDefaults.standard.synchronize()
    }
    
    public func isSessionExpiryInProgress() -> Bool{
        return isRefreshTokenInProgress ?? false
    }
    
    public func updateEmailAddress(header: String? = nil, subHeader: String? = nil, btnText: String? = nil, delegate: JREmailUpdateDelegate?) {
        if let vc = UIApplication.topViewController() {
            let tVc = JREmailUpdatePopUpVC.newInstance(header: header, subHeader: subHeader, btnText: btnText, delegate: delegate)
            let nav = UINavigationController(rootViewController: tVc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
            vc.present(nav, animated: true, completion: nil)
        }
    }
    
    public func openEmailUpdateFlow(for email: String? = nil, on navController: UINavigationController?, completionHandler: @escaping ((Bool, String?) -> Void)) {
        
        guard let mobileNumber = LoginAuth.sharedInstance().getMobileNumber() else {
            completionHandler(false, JRLoginConstants.generic_error_message)
            return
        }
        let params: [String: String] = ["loginId": mobileNumber, "actionType": "UPDATE_EMAIL"]
        JRLServiceManager.updatePhoneOTPViaProfile(params) { (data, error) in
            DispatchQueue.main.async {
                if let responseData = data,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    switch responseCode {
                    case LOGINRCkeys.success:
                        let state = responseData.getStringKey("state")
                        if JRLoginUI.sharedInstance().isCryptoEnabled() {
                            try? AuthRSAGenerator.shared.createKeyPair(for: mobileNumber)
                        }
                        let dataModel = JRLOtpPsdVerifyModel(loginId: mobileNumber, stateToken: state, otpTextCount: 6, loginType: .email)
                        dataModel.isFromUpdateEmail = true
                        dataModel.emailToUpdate = email
                        let controller = JRLVerifyNewOTPVC.controller(dataModel)
                        controller.mobileNo = mobileNumber
                        if let nav = navController{
                            nav.pushViewController(controller, animated: true)
                        }
                        else{
                            controller.modalPresentationStyle = .fullScreen
                            UIApplication.topVC()?.present(controller, animated: true, completion: nil)
                        }
                        completionHandler(true, nil)
                        
                    case LOGINRCkeys.badRequest,
                         LOGINRCkeys.invalidAuthorization,
                         LOGINRCkeys.emptyDeviceId,
                         LOGINRCkeys.clientFetchPermissionDenied,
                         LOGINRCkeys.invalidMobile:
                        completionHandler(false, JRLoginConstants.generic_error_message)
                        
                    default:
                        if let message = responseData.getOptionalStringForKey("message") {
                            completionHandler(false, message)
                        } else {
                            completionHandler(false, JRLoginConstants.generic_error_message)
                        }
                    }
                } else if let error = error {
                    completionHandler(false, error.localizedDescription)
                } else {
                    completionHandler(false, JRLoginConstants.generic_error_message)
                }
            }
        }
    }
    
    public func invokeChangePassword(using navigationController: UINavigationController){
        let vc = JRChangePasswordVC.newInstance
        navigationController.navigationBar.isHidden = false
        navigationController.isNavigationBarHidden = false
        let backBtn = UIBarButtonItem(image: UIImage(named: "back_default"),
                                      style: .plain,
                                      target: navigationController,
                                      action: #selector(UINavigationController.popViewController(animated:)))
        vc.navigationItem.leftBarButtonItem = backBtn
        navigationController.navigationBar.tintColor = UIColor.black
        navigationController.interactivePopGestureRecognizer?.delegate = vc
        navigationController.pushViewController(vc, animated: true)
    }
}

//MARK:- private Methods
extension JRLoginUI {
    private static func updateSsoToken(retryCount: Int = 0, completion:@escaping ((_ success: Bool?, _ error: Error?, _ needCompletionHandler: Bool) -> Void)) {
        
        var loginID: String = ""
        var loginType: JarvisLoginType = JarvisLoginType.mobile
        
        if let mobileNumber = LoginAuth.sharedInstance().getMobileNumber() {
            loginID = mobileNumber
            loginType = .mobile
        } else if let emailID = LoginAuth.sharedInstance().getEmail() {
            loginID = emailID
            loginType = .email
        } else if let mobileNumber = UserDefaults.standard.string(forKey: "prefilledLoginId") {
            loginID = mobileNumber
            loginType = .mobile
        }
        
        if !loginID.isEmpty {
            if JRLoginUI.sharedInstance().isCryptoEnabled() {
                try? AuthRSAGenerator.shared.createKeyPair(for: loginID)
            }
            
            var lparams = ["loginId": loginID]
            if !JRLoginUI.sharedInstance().isCryptoEnabled(){
                lparams[LOGINWSKeys.kFlow] = LOGINACKeys.kSignup
            }
            JRLServiceManager.initiateLogin(lparams) { (data, error) in
                DispatchQueue.main.async {
                    
                    LoginAuth.sharedInstance().isNewUserLoggedIn = false
                    LoginAuth.sharedInstance().isLoginViaOtp = false

                    var errMsg = JRLoginConstants.generic_error_message
                    
                    if let error = error {
                        if (error as NSError).code == 311 {
                            AuthRSAGenerator.shared.removeSavedKeyPair(for: loginID)
                            if retryCount < 1 {
                                let updatedRetry = (retryCount + 1)
                                updateSsoToken(retryCount: updatedRetry, completion: completion)
                            } else {
                                let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errMsg])
                                completion(false, error, true)
                            }
                        } else {
                            completion(false, error, true)
                        }
                        return
                    }
                    
                    guard let stateToken = data?[LOGINWSKeys.kStateToken] as? String, let responseCode = data?[LOGINWSKeys.kResponseCode] as? String else {
                        return
                    }
                    
                    if let msg = data?[LOGINWSKeys.kMesssage] as? String{
                        errMsg = msg
                    }
                    
                    switch responseCode {
                    case LOGINRCkeys.loginPassword://3001
                        let model = JRLOtpPsdVerifyModel(loginId: loginID, stateToken: stateToken, otpTextCount: 0, loginType: loginType)
                        JRAuthSessionExpiryMgr.openLoginPassword(model: model, completion: completion)
                    case LOGINRCkeys.loginOTP://3000
                        LoginAuth.sharedInstance().isLoginViaOtp = true
                        JRAuthSessionExpiryMgr.openLoginOTP(loginId: loginID, stateToken: stateToken, loginType: loginType, completion: completion)
                    case LOGINRCkeys.signUpOTP://3004
                        LoginAuth.sharedInstance().isNewUserLoggedIn = true
                        JRAuthSessionExpiryMgr.openLoginOTP(loginId: loginID, stateToken: stateToken, loginType: .newAccount, completion: completion)
                                                
                    case LOGINRCkeys.otpLimitReach: //708
                        if let vc = UIApplication.topViewController() {
                            vc.showAlert(errMsg)
                        }
                        completion(false, error, true)

                    case LOGINRCkeys.invalidPublicKey,
                         LOGINRCkeys.invalidSignature: //BE1423001, BE1423003
                        AuthRSAGenerator.shared.removeSavedKeyPair(for: loginID)
                        if retryCount < 1 {
                            let updatedRetry = (retryCount + 1)
                            updateSsoToken(retryCount: updatedRetry, completion: completion)
                        } else {
                            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errMsg])
                            completion(false, error, true)
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
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: JRLoginConstants.generic_error_message])
                        completion(false, error, true)
                        
                    default:
                        let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: errMsg])
                        completion(false, error, true)
                    }
                }
            }
        }
    }
    
    private func showLaunchScreenOn(vc: UIViewController) {
        JRApplockHelper.sharedInstance.setIsLoginFromFullScreen(to: true)
        let tVc = JRAuthSignInVC.newInstance
        tVc.modalPresentationStyle = .fullScreen
        JRLoginUI.presentAuth(vc: tVc, onVc: vc)
    }
    
    private func signIn(withMobileNumber mobileNumber: String?, viewController: UIViewController, screenType: JarvisLoginScreenType = .popup, isPasswordUpdated: Bool = false) {
        dismissPresentedViewControllers {
            if let vc = UIApplication.topViewController(){
                var mNumber : String?
                if let mobileNumber = mobileNumber, !mobileNumber.isEmpty{
                    mNumber = mobileNumber
                }
                else if let mobileNumber = UserDefaults.standard.string(forKey: "prefilledLoginId"), !mobileNumber.isEmpty{
                    mNumber = mobileNumber
                }
                self.openLoginWithScreenType(screenType, mNumber: mNumber, viewController: vc, isPasswordUpdated: isPasswordUpdated)
            }
        }
    }
    
    private func openLoginWithScreenType(_ screenType: JarvisLoginScreenType, mNumber: String? , viewController: UIViewController, isPasswordUpdated: Bool = false){
        switch screenType{
        case .popup:
            JRApplockHelper.sharedInstance.setIsLoginFromFullScreen(to: false)
            if let vc = UIApplication.topViewController() {
                let tVc = JRAuthSignInPopupVC.newInstance
                tVc.vModel.preFilledLoginId = mNumber ?? ""
                tVc.screenType = screenType
                let nav = UINavigationController.init(rootViewController: tVc)
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
                vc.present(nav, animated: true, completion: nil)
            }
            else{
                let loginVC = JRAuthSignInVC.newInstance
                loginVC.vModel.isPasswordUpdated = isPasswordUpdated
                loginVC.vModel.preFilledLoginId = mNumber ?? ""
                loginVC.screenType = screenType
                JRLoginUI.presentAuth(vc: loginVC, onVc: viewController)
            }
        case .fullScreen:
            JRApplockHelper.sharedInstance.setIsLoginFromFullScreen(to: true)
            let loginVC = JRAuthSignInVC.newInstance
            loginVC.screenType = screenType
            loginVC.vModel.preFilledLoginId = mNumber ?? ""
            JRLoginUI.presentAuth(vc: loginVC, onVc: viewController)
        }
    }
    
    private class func presentAuth(vc: UIViewController, onVc: UIViewController) {
        DispatchQueue.main.async {
            let navVC = UINavigationController(rootViewController: vc)
            navVC.modalPresentationStyle = .overFullScreen
            onVc.present(navVC, animated: true)
            navVC.setNavigationBarHidden(true, animated: true)
        }
    }
    
    private func signUp(withMobileNumber mobileNumber: String?, viewController: UIViewController, allowUPI: Bool = false, screenType: JarvisLoginScreenType = .popup, isPasswordUpdated: Bool = false) {
        openLoginWithScreenType(screenType, mNumber: mobileNumber, viewController: viewController, isPasswordUpdated: isPasswordUpdated)
    }
    
    private func dismissPresentedViewControllers(completion : @escaping ()->()) {
        if let vc = UIApplication.topViewController(){
            
            if let navController = vc.navigationController{
                if  navController.isBeingDismissed{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        completion()
                    }
                }else if let _ = navController.presentingViewController{
                    navController.dismiss(animated: true, completion: completion)
                }else{
                    completion()
                }
            }else{
                if vc.isBeingDismissed{
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        completion()
                    }
                }else if let _ = vc.presentingViewController{
                    vc.dismiss(animated: true, completion: completion)
                }else{
                    completion()
                }
            }
        }else{
            completion()
        }
    }
}

//MARK:- JRRefreshTokenProtocol
extension JRLoginUI: JRRefreshTokenProtocol {
    
    func checkIfWalletOrSsoToken(forStr str : String) -> (isWalletToken : Bool,isSsoToken : Bool){
        if let ssoToken = LoginAuth.sharedInstance().getSsoToken(), str.contain(subStr: ssoToken){
            return (false,true)
        }else if let walletToken = LoginAuth.sharedInstance().getWalletToken(), str.contain(subStr: walletToken){
            return (true,false)
        }
        return (false,false)
    }
    
    func shouldCheckHttpBodyForSessionExpire(forStr str : String?) -> Bool{
        guard let urlstr = str else {
            return false
        }
        return urlstr.contains("https://securegw.paytm.in/theia/api/v1/fetchQRPaymentDetails") || urlstr.contains("https://securegw.paytm.in/theia/api/v1/fetchPaymentOptions") || urlstr.contains("https://securegw.paytm.in/theia/HANDLER_IVR/CLW_APP_PAY/APP") || urlstr.contains("https://securegw.paytm.in/theia/api/v1/processTransaction")
    }
    
    func getSSOTokenFromHttpBody(httpBody:Data?)->String?{
        do {
            guard let body = httpBody, let json = try JSONSerialization.jsonObject(with: body, options: []) as? [String:Any], let head = json["head"] as? [String:Any], let ssoToken = head["token"] as? String else {
                return nil
            }
            return ssoToken
        } catch {
            return nil
        }
    }
    
    public func findTokenFromRequest(urlRequest : URLRequest?) -> (ssoToken: String?, walletToken: String?){
        var extractedSSOToken : String?
        var extractedWalletToken : String?

        //SSO token : header
        if extractedSSOToken == nil{
            if let headers : [String : String] = urlRequest?.allHTTPHeaderFields{
                for (_,value) in headers{
                    let tuple = checkIfWalletOrSsoToken(forStr: value)
                    if tuple.isSsoToken == true{
                        extractedSSOToken = LoginAuth.sharedInstance().getSsoToken()
                        break
                    }
                }
            }
        }
        
        //SSo token : url
        if extractedSSOToken == nil{
            if let url = urlRequest?.url?.absoluteString{
                let tuple = checkIfWalletOrSsoToken(forStr: url)
                if tuple.isSsoToken == true{
                    extractedSSOToken = LoginAuth.sharedInstance().getSsoToken()
                }
            }
        }
        
        //Wallet Token : Header
        if extractedWalletToken == nil{
            if let headers : [String : String] = urlRequest?.allHTTPHeaderFields{
                for (_,value) in headers{
                    let tuple = checkIfWalletOrSsoToken(forStr: value)
                    if tuple.isWalletToken == true{
                        extractedWalletToken = LoginAuth.sharedInstance().getWalletToken()
                        break
                    }
                }
            }
        }
        //Wallet token : url
        if extractedWalletToken == nil{
            if let url = urlRequest?.url?.absoluteString{
                let tuple = checkIfWalletOrSsoToken(forStr: url)
                if tuple.isWalletToken == true{
                    extractedWalletToken = LoginAuth.sharedInstance().getWalletToken()
                }
            }
        }
        
        //SSO Token : Payments
        if extractedWalletToken == nil && extractedSSOToken == nil && shouldCheckHttpBodyForSessionExpire(forStr:urlRequest?.url?.absoluteString){
            extractedSSOToken = getSSOTokenFromHttpBody(httpBody:urlRequest?.httpBody)
        }

        return (extractedSSOToken, extractedWalletToken)
    }
    
    public func refreshToken(urlRequest: URLRequest?, urlResponse: URLResponse?, completion: @escaping JRRefreshTokenCompletion) {
        let (extractedSSOToken, extractedWalletToken) = findTokenFromRequest(urlRequest: urlRequest)
        
        var errorToReturn: Error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "jr_ac_facingTechnicalIssue".localized])
        var successBool = false
        
        if extractedWalletToken != nil || extractedSSOToken != nil {
            self.refreshSessionToken(urlRequest?.url?.absoluteString,extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, urlResponse as? HTTPURLResponse) { (success, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, error) in
                
                if let error = error {
                    errorToReturn = error
                }
                if let success = success {
                    successBool = success
                    completion(urlRequest, urlResponse, successBool, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, nil)
                }else{
                    completion(urlRequest, urlResponse, successBool, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, errorToReturn)
                }
                
            }
        }
        else{
            completion(urlRequest, urlResponse, successBool, "", "", "", "",errorToReturn)
        }
    }
    
    public func isAuthError(data: Any?, urlRequest: URLRequest?, urlResponse: URLResponse?) -> (Bool) {
        guard let urlRequest =  urlRequest, let httpResponse = urlResponse as? HTTPURLResponse else {
            return false
        }
        
        let statusCode: Int = httpResponse.statusCode
        
        switch statusCode {
        case 400:
            if let requestUrl = urlRequest.url?.absoluteString , let getAllTokensURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("getalltokens"), requestUrl.range(of: getAllTokensURL) != nil {
                return true
            }
            return false
        case 200:
            if let requestUrl = urlRequest.url?.absoluteString , let getAllTokensURL: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("getalltokens"), requestUrl.range(of: getAllTokensURL) != nil {
                if let jsonData = data as? [String : Any], let tokens = jsonData["tokens"] as? [[String : Any]], tokens.count > 0 {
                    for dict in tokens {
                        if let scope = dict["scope"] as? String, scope == "wallet", let token = dict["access_token"] as? String, !token.isEmpty {
                            return false
                        }
                    }
                }
                return true
            }
            return false
        default:
            return false
        }
    }
}

//MARK:- Wallet Token Expiry handled
extension JRLoginUI{
    public func initiateSessionExpiryFlowForWalletToken(extractedSSOToken : String? = nil, extractedWalletToken : String? = nil, _ preResponse: HTTPURLResponse?, completionHandler:@escaping JRWalletTokenExpiryCompletion) {
        
        JRLoginUI.sharedInstance().delegate?.signOut(completionHandler: { (isSuccess, error) in
            if error != nil {
                self.isRefreshTokenInProgress = false
                completionHandler(false, LoginAuth.sharedInstance().getWalletToken(), LoginAuth.sharedInstance().getWalletTokenDict())

                return
            }
            self.showSessionExpiredAlertForWalletToken(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completionHandler)
        })
    }
    
    private func showSessionExpiredAlertForWalletToken(extractedSSOToken: String? = nil, extractedWalletToken: String? = nil, completion: @escaping JRWalletTokenExpiryCompletion) {
        if let topController = UIApplication.topViewController() {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "jr_login_session_expired".localized, message: "jr_login_relogin_to_continue".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                    self.initiateReloginFlowForWalletToken(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completion)
                }
                alert.addAction(okAction)
                topController.present(alert, animated: true, completion: nil)
            }
        } else {
            initiateReloginFlowForWalletToken(extractedSSOToken: extractedSSOToken, extractedWalletToken: extractedWalletToken, completion: completion)
        }
    }
    
    private func initiateReloginFlowForWalletToken(extractedSSOToken: String? = nil, extractedWalletToken: String? = nil, completion: @escaping JRWalletTokenExpiryCompletion) {
        
        JRLoginUI.updateSsoToken { (success, error, needCompletionHandler) in
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: JRLoginConstants.kSessionExipiryUIDismiss), object: nil)
            self.isRefreshTokenInProgress = false
            guard needCompletionHandler else {
                defer {
                    JRLoginUI.sharedInstance().delegate?.pushHomeView(false, true)
                }
                return
            }
            
            if let success = success, success {
                let fetchStrategy: String = "DEFAULT,USER_TYPE,USERID,USER_ATTRIBUTE,password_status,kyc_state"
                JRAuthBaseVC.signInRefreshToken(fetchStrategy, completionHandler: { (_) in
                    completion(success, LoginAuth.sharedInstance().getWalletToken(), LoginAuth.sharedInstance().getWalletTokenDict())
                    
                })
            } else {
                completion(success ?? false, LoginAuth.sharedInstance().getWalletToken(), LoginAuth.sharedInstance().getWalletTokenDict())
            }
        }
    }
    
}

//MARK:- Debug Methods
#if DEBUG
public extension JRLoginUI {
    func testGetInfoAPI() {
        let urlParams = ["fetch_strategy" : "DEFAULT,USER_TYPE,USERID,USER_ATTRIBUTE,password_status,kyc_state"]
        LoginAuth.sharedInstance().updateV2userInfo(urlParams) { (isSuccess, error) in
        }
    }
    
    func showPwdPopup(_ viewController: UIViewController? = UIApplication.topViewController()){
        if let vc = UIApplication.topViewController(){
            let dataModel = JRLOtpPsdVerifyModel(loginId: "", stateToken: "", otpTextCount: nil, loginType: .mobile)
            let locAccVC = JRAuthPwdPopupVC.controller(dataModel)
            JRLoginUI.presentAuth(vc: locAccVC, onVc: vc)
        }
    }
    
    func showOTPPopup(_ viewController: UIViewController? = UIApplication.topViewController()){
        if let vc = UIApplication.topViewController(){
            let dataModel = JRLOtpPsdVerifyModel(loginId: "", stateToken: "", otpTextCount: 6, loginType: .mobile)
            let locAccVC = JRAuthOTPPopupVC.newInstance(dataModel)
            JRLoginUI.presentAuth(vc: locAccVC, onVc: vc)
        }
    }
    
    func testAddOTP(_ viewController: UIViewController? = UIApplication.topViewController()) {
        DispatchQueue.main.async {
            if let vc = JRLOTPPopUpVC.controller() as? JRLOTPPopUpVC {
                vc.state = "64237658478463842489"
                vc.mobileNumber = "9813392606"
                vc.modalPresentationStyle = .overFullScreen
                viewController?.present(vc, animated: true, completion: nil)
            }
        }
    }
}
#endif
