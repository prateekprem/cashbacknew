//
//  JRAuthBaseVC.swift
//  jarvis-auth-ios
//
//  Created by Prakash Jha on 06/12/19.
//

import UIKit
import jarvis_network_ios
import CoreLocation

class JRAuthBaseVC: UIViewController {
    
    //MARK:- Outlets & Properties
    let deviceHeight = UIScreen.main.bounds.height
    var loginFlowType: JarvisLoginFlowType = .login
    var screenType: JarvisLoginScreenType = .popup
    var isApplockInitiated: Bool = false

    //MARK:- Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        hideNavBar(true)
        registerKeyboardNotification()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        hideNavBar(false)
        unregisterKeyboardNotification()
    }
    
    private func invokeApplockIfNecessary() {
        if !isApplockInitiated && JRApplockHelper.sharedInstance.applockFeatureGTM() {
            JRApplockHelper.sharedInstance.perform(.activation, completion: nil)
        }
    }
    
    func loginToDifferentAccount() {
        dismiss(animated: true) {
            JRLoginUI.sharedInstance().delegate?.signOut(completionHandler: { (success, error) in
                if let error = error {
                    self.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    return
                }
                
                if let success = success, success {
                    let loginVC = JRAuthSignInVC.newInstance
                    let navVC = UINavigationController.init(rootViewController: loginVC)
                    navVC.modalPresentationStyle = .fullScreen
                    UIApplication.topViewController()?.present(navVC, animated: true)
                }
            })
        }
    }
}

//MARK:- Internal Methods
extension JRAuthBaseVC {
    internal func handleBackbtn(pushToHome : Bool = false) {
        if navigationController?.viewControllers.first == self {
            JRAuthManager.setApp(launched: true)
            
            if let _ = presentingViewController {
                self.dismiss(animated: true, completion: {
                    self.handleBackDelegate(pushToHome)
                })
            }
            else {
                handleBackDelegate(pushToHome)
            }
        } else if let lnavigationController = navigationController{
            lnavigationController.popToRootViewController(animated: true)
        }
        else{
            self.dismiss(animated: true, completion: nil)
        }
    }
    
    internal func handleCloseBtn(){
        JRAuthManager.setApp(launched: true)
        self.dismiss(animated: true) {
            JRLoginUI.sharedInstance().delegate?.signInUserDenied()
        }
    }
    
    internal func signInCompleted(isSuccess: Bool?, error: Error?) {
        invokeOnboardingOrchestration(isSuccess, error, LoginAuth.sharedInstance().isNewUserLoggedIn ? .signup : .login)
    }
    
    internal func signUpCompleted(isSuccess: Bool?, error: Error?, allowUPI: Bool = false) {
        invokeOnboardingOrchestration(isSuccess, error, LoginAuth.sharedInstance().isNewUserLoggedIn ? .signup : .login)
    }

    internal func showError(text: String?) {
        if let eMsg = text {
            self.view.showToast(toastMessage: eMsg, duration: 3.0)
        }
    }
    
    internal func isNetworkReachable() -> Bool{
        guard (JRNetworkUtility.isNetworkReachable()) else{
            self.showError(text: JRLoginConstants.no_internet_error_message)
            return false
        }
        return true
    }
    
    internal func hideNavBar(_ isHidden: Bool) {
        self.navigationController?.navigationBar.isHidden = isHidden
    }
    
    func setAuthImage(_ imgStr: String) -> UIImage?{
        return  UIImage(named: imgStr, in: JRAuthManager.kAuthBundle, compatibleWith: nil)
    }
}

//MARK:- Private Methods
extension JRAuthBaseVC {
    private func handleBackDelegate(_ pushToHome: Bool) {
        if pushToHome {
            JRLoginUI.sharedInstance().delegate?.pushHomeView(false, false)
        }else{
            JRLoginUI.sharedInstance().delegate?.signInUserDenied()
        }
    }
    
    private func invokeCoMs(){
        //invoke Contact SDK
        JRLoginUI.sharedInstance().delegate?.invokeContactSDK()
    }
    
    private func invokeOnboardingOrchestration(_ isSuccess: Bool?, _ error: Error?, _ flow:JarvisOauthFlowType){
        let urlParams = ["fetch_strategy" : "DEFAULT,USER_TYPE,USERID,USER_ATTRIBUTE,password_status,kyc_state"]
        if self.screenType == .popup{
            if let isSuccess =  isSuccess, isSuccess {
                LoginAuth.sharedInstance().updateV2userInfo(urlParams) { [weak self] (isSuccess, error) in
                    self?.invokeCoMs()
                    self?.invokeLoginSuccessGA()
                    self?.signInCallBack(isSuccess, error)
                }
            }
        }
        else{
            if let isSuccess =  isSuccess, isSuccess {
                LoginAuth.sharedInstance().updateV2userInfo(urlParams) { [weak self] (isSuccess, error) in
                    self?.invokeCoMs()
                    self?.invokeLoginSuccessGA()
                    self?.invokeUPIOnboarding(isSuccess, error, flow)
                }
            } else {
                self.invokeLoginSuccessGA()
                self.invokeUPIOnboarding(isSuccess, error, flow)
            }
        }
    }
    
    private func invokePasswordUpgrade(){
        guard LoginAuth.sharedInstance().isPasswordUpgradationRequired() else { return }
        DispatchQueue.main.async {
            guard let navController = self.navigationController else{ return }
            JRLoginUI.sharedInstance().invokeChangePassword(using: navController)
        }
    }
    
    private func invokeLoginSuccessGA(){
        if self is JRAuthPasswordVC || self is JRAuthPwdPopupVC{
            let custId = LoginAuth.sharedInstance().getUserID()
            JRLoginGACall.passwordScreenSuccess(screenType, loginFlowType, custId: custId ?? "")
        }
        else if let lself = self as? JRAuthOTPVC{
            let custId = LoginAuth.sharedInstance().getUserID()
            JRLoginGACall.otpScreenSuccess(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType, custId: custId ?? "", el1_signup: lself.gaEl_otp, el1_signin: lself.getLoginSuccEl1())
        }
        else if let lself = self as? JRAuthOTPPopupVC{
            let custId = LoginAuth.sharedInstance().getUserID()
            JRLoginGACall.otpScreenSuccess(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType, custId: custId ?? "", el1_signup: lself.gaEl_otp, el1_signin: lself.getLoginSuccEl1())
        }
        
        if LoginAuth.sharedInstance().isFromFP.0{
            if let loginId = LoginAuth.sharedInstance().getMobileNumber(), loginId == LoginAuth.sharedInstance().isFromFP.1{
                JRLoginGACall.setForgotPwdLoginSuccess()
            }
            LoginAuth.sharedInstance().isFromFP = (false,"")
        }
    }
    
    private func invokeUPIOnboarding(_ isSuccess: Bool?, _ error: Error?, _ flow:JarvisOauthFlowType) {
        DispatchQueue.main.async {
            if let vc = JRLVerifyVC.controller("jr_login_verifying_your_details".localized) {
                self.navigationController?.pushViewController(vc, animated: true)
            }
        }
        switch flow {
        case .login:
            if JRLoginUI.sharedInstance().isUPIOnboardingEnabledForLogin(){
                //invoke UPI Onboading
                DispatchQueue.main.async {
                    JRLoginUI.sharedInstance().delegate?.invokeUPIFlow(using: self.navigationController) { (status, data) in
                        self.invokeMinKYCOnboarding(isSuccess, error, flow)
                    }
                }
            }
            else{
                //check for MinKYC
                invokeMinKYCOnboarding(isSuccess, error, flow)
            }
            
        case .signup:
            if JRLoginUI.sharedInstance().isUPIOnboardingEnabledForSignup(){
                //invoke UPI Onboading
                DispatchQueue.main.async {
                    JRLoginUI.sharedInstance().delegate?.invokeUPIFlow(using: self.navigationController) { (status, data) in
                        self.invokeMinKYCOnboarding(isSuccess, error, flow)
                    }
                }
            }
            else{
                //check for MinKYC
                invokeMinKYCOnboarding(isSuccess, error, flow)
            }
        }
    }
    
    private func invokeMinKYCOnboarding(_ isSuccess: Bool?, _ error: Error?, _ flow:JarvisOauthFlowType) {
        switch flow {
        case .login:
            if JRLoginUI.sharedInstance().isMinKYCOnboardingEnabledForLogin(){
                //invoke MinKYC Onboading
                JRLoginUI.sharedInstance().delegate?.invokeMKYCFlow(using: !LoginAuth.sharedInstance().isMinKyc(), navigationController: self.navigationController, callback: { (success, data) in
                    self.invokeAppLockOnboarding(isSuccess, error, flow)
                })
            }
            else{
                //check for AppLock
                invokeAppLockOnboarding(isSuccess, error, flow)
            }
            
        case .signup:
            if JRLoginUI.sharedInstance().isMinKYCOnboardingEnabledForSignup(){
                //invoke MinKYC Onboading
                JRLoginUI.sharedInstance().delegate?.invokeMKYCFlow(using: !LoginAuth.sharedInstance().isMinKyc(), navigationController: self.navigationController, callback: { (success, data) in
                    self.invokeAppLockOnboarding(isSuccess, error, flow)
                })
            }
            else{
                //check for AppLock
                invokeAppLockOnboarding(isSuccess, error, flow)
            }
        }
    }
    
    private func invokeAppLockOnboarding(_ isSuccess: Bool?, _ error: Error?, _ flow:JarvisOauthFlowType) {
        switch flow {
        case .login:
            if JRLoginUI.sharedInstance().isAppLockOnboardingEnabledForLogin() && JRApplockHelper.sharedInstance.applockFeatureGTM() {
                performAppLock(isSuccess,error)
            }
            else {
                self.signInCallBack(isSuccess, error)
                
            }
            
        case .signup:
            if JRLoginUI.sharedInstance().isAppLockOnboardingEnabledForSignup() && JRApplockHelper.sharedInstance.applockFeatureGTM() {
                performAppLock(isSuccess,error)
            }
            else {
                self.signInCallBack(isSuccess, error)
                
            }
        }
    }
    
    private func performAppLock(_ isSuccess: Bool?, _ error: Error?){
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isApplockInitiated = true
            JRApplockHelper.sharedInstance.perform(.activation, navigationController: self.navigationController) { (success, error, message) in
                if success {
                    self.signInCallBack(isSuccess, error)
                } else {
                    self.signInCallBack(isSuccess, error)
                }
            }
        }
    }
    
    private func signInCallBack(_ isSuccess: Bool?, _ error: Error?) {
        DispatchQueue.main.async {
            JRAuthManager.setApp(launched: true)
            self.view.endEditing(true)
            if let isSuccess = isSuccess,
                isSuccess == true ,
                !LoginAuth.sharedInstance().isUserV2InfoDisabled{
                NotificationCenter.default.post(name: NSNotification.Name(rawValue: "DidUserProfileUpdateNotification"), object: nil)
                if let _ = self.presentingViewController {
                    self.dismiss(animated: true, completion: {
                        self.updateSigninInfo()
                        self.invokeApplockIfNecessary()
                        JRLoginUI.sharedInstance().delegate?.signIn(isSuccess: isSuccess, error: error)
                    })
                }
                else {
                    self.updateSigninInfo()
                    self.invokeApplockIfNecessary()
                    JRLoginUI.sharedInstance().delegate?.signIn(isSuccess: isSuccess, error: error)
                }
            } else {
                self.dismiss(animated: true , completion: {
                    self.invokeApplockIfNecessary()
                    JRLoginUI.sharedInstance().delegate?.signIn(isSuccess: isSuccess, error: error)
                })
            }
        }
    }
    
    private func updateSigninInfo() {
        if LoginAuth.sharedInstance().getMobileNumber() == nil {
            JRLoginUI.sharedInstance().addMobile()
        } else if false == LoginAuth.sharedInstance().isPasswordCreated() {
            if let setPasswordGTMKey:Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("isSetPasswordMandatory"), setPasswordGTMKey {
                JRLoginUI.sharedInstance().setPassword()
            } else if LoginAuth.sharedInstance().isMinKyc() {
                JRLoginUI.sharedInstance().setPassword()
            }
        }
    }
}

//MARK:- TnC
extension JRAuthBaseVC{
    func tNCPrivacyPolicyTapped(_ loginType: JarvisLoginType?, sender: UITapGestureRecognizer, messageLabel: UILabel) {
        let termsAndConditionsLink = "jr_login_terms_conditions".localized
        let privacyPolicyLink = "jr_login_privacy_policy".localized
        guard let labelText = messageLabel.text else {
            return
        }
        let termsAndConditionsTextRange: NSRange = (labelText as NSString).range(of: termsAndConditionsLink)
        let privacyPolicyTextRange: NSRange = (labelText as NSString).range(of: privacyPolicyLink)
        if sender.didTapAttributedTextInLabel(label: messageLabel, inRange: termsAndConditionsTextRange) {
            if let tncLink: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("termsAndConditionsUrl"), let link = URL(string: tncLink) {
                UIApplication.shared.open(link)
            }
        } else if sender.didTapAttributedTextInLabel(label: messageLabel, inRange: privacyPolicyTextRange) {
            if let privacyPolicyLink: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("privacyPolicyUrl"), let link = URL(string: privacyPolicyLink) {
                UIApplication.shared.open(link)
            }
        }
    }
    
    func getTermsAndConditionText() -> (String, [String]){
        let userConsent: Bool = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthComsTermsConditions_iOS") ?? true
        let messageStr = userConsent ? "jr_login_signin_tnc".localized : "jr_login_signin_tnc_consent_not_allowed".localized
        let links = ["jr_login_terms_conditions".localized , "jr_login_privacy_policy".localized]
        return (messageStr, links)
    }
}

//MARK:- Static Methods
extension JRAuthBaseVC {
    static func signInRefreshToken(_ fetchStrategy: String, completionHandler:@escaping ((_ success:Bool?) -> Void)) {
        let urlParams = ["fetch_strategy" : fetchStrategy]
        LoginAuth.sharedInstance().updateV2userInfo(urlParams, completionHandler: { (isSuccess, error) in
            let custId = LoginAuth.sharedInstance().getUserID() ?? ""
            let el2 = LoginAuth.sharedInstance().isLoginViaOtp ? LOGINGAKeys.kOtp : LOGINGAKeys.kLabelPwdOtp
            JRLoginGACall.otpScreenSuccess(LoginAuth.sharedInstance().isNewUserLoggedIn, .popup, .sessionExpiry, custId: custId, el1_signup: LOGINGAKeys.kOtp, el1_signin: el2)
            LoginAuth.getWalletTokenWith{ (isSuccess, token, tokenDict) in
                if let walletToken = LoginAuth.sharedInstance().getWalletToken(), !walletToken.isEmpty { //LoginAuth.sharedInstance().delegate?.getWalletTokenFromJRAccount(), walletToken.count > 0{
                    DispatchQueue.main.async {
                        JRLoginUI.sharedInstance().delegate?.signIn(isSuccess: true, error: nil)
                        completionHandler(true)
                    }
                }else{
                    DispatchQueue.main.async {
                        JRLoginUI.sharedInstance().delegate?.signIn(isSuccess: false, error: NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey : "jr_ac_facingTechnicalIssue".localized]))
                        completionHandler(false)
                    }
                }
            }
        })
    }
}

//MARK:- Keyboard Notifications
extension JRAuthBaseVC{
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    private func unregisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(notification:Notification){}
    
    @objc func keyboardWillHide(notification:Notification){}
}

//MARK:-JRLVerifyVC
class JRLVerifyVC: JRAuthBaseVC {
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    //MARK:- Instance
    class func controller(_ description: String = "") -> JRLVerifyVC? {
        let vc = JRLVerifyVC(nibName: "JRLVerifyVC", bundle: JRLBundle)
        return vc
    }
    //MARK:- Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadingIndicatorView.showLoadingView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        UIView.animate(withDuration: 0.1, delay: 0.0, options: [.curveEaseOut], animations: {
        }, completion: { _ in
            UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut], animations: {
                }, completion: nil)
            })
        })
    }
}

//MARK:- PopupContainerView
class PopupContainerView: UIView {
    override func layoutSubviews() {
        super.layoutSubviews()
        self.roundCorners([.topLeft, .topRight], radius: 12)
    }
}
