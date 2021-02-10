//
//  JRAuthOTPPopupVC.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 05/02/20.
//

import UIKit

class JRAuthOTPPopupVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var resendOTPLabel: UILabel!
    @IBOutlet weak var otpTextFieldView: JRLOTPTextFieldView!
    @IBOutlet weak var progressView: JRChatOnboardingSpinnerView!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var messageView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var resendOtpOnCallBtn: UIButton!
    @IBOutlet weak var messageViewBtn: UIButton!
    
    @IBOutlet weak var containerViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var otpViewHeightConst: NSLayoutConstraint!
    @IBOutlet weak var resendBottomConst: NSLayoutConstraint!
    @IBOutlet weak var submitBottomConst: NSLayoutConstraint!
    @IBOutlet weak var resendTopConst: NSLayoutConstraint!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var messageViewTopConst: NSLayoutConstraint!
    
    private var vModel: JRAuthOTPVM = JRAuthOTPVM()
    weak var delegate: JRLOTPVCDelegate?
    private var enteredOTP: String?
    var otpLimitReachedMessage = ""
    var countdownTimer: Timer!
    var canDismissMsgVw: Bool = false
    var isConfirmTappable: Bool = false
    var completion: JRQuickLoginCompletion? //Session Expiry case
    var gaEl_pwdOtp: String = LOGINGAKeys.kLabelPwdOtp
    var gaEl_otp: String = LOGINGAKeys.kOtp
    
    //MARK:- Instance
    static func newInstance(_ dataModel: JRLOtpPsdVerifyModel, loginFlowType: JarvisLoginFlowType = .login) -> JRAuthOTPPopupVC {
        let vc = JRAuthManager.kAuthPopupStoryboard.instantiateViewController(withIdentifier: "JRAuthOTPPopupVC") as! JRAuthOTPPopupVC
        vc.vModel.model = dataModel
        vc.loginFlowType = loginFlowType
        vc.screenType = .fullScreen
        return vc
    }
    
    //MARK:-Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        if let digitText:String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("authOtpTimer"), let val = Int(digitText) {
            vModel.updateSmsOTPTime(with: val)
        }
        
        if let digitText:String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("authOtpCallTimer"), let val = Int(digitText) {
            vModel.updateCallOTPTime(with: val)
        }
        
        initilize()
        updateView(forState: .cooldownTime)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JRLoginGACall.otpScreenLoaded(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        updateNavigationStack()
        if let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount  {
            otpTextFieldView.setUpUI(count: otpTextCount, borderStyle: UITextField.BorderStyle.none, isSecureTextEntry: true)
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
        }
        
        messageView.isHidden = false
        self.showMessageView(withAnimation: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideMessageView(withAnimation: true)
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.view.endEditing(true)
        self.loadingIndicatorView?.isHidden = true
    }
    
    override var prefersStatusBarHidden: Bool { return true }

    deinit {
        endTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func closeButtonTapped() {
        self.view.endEditing(true)
        JRLoginGACall.otpScreenBackBtnClicked( LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        guard let completion = self.completion else {
            handleCloseBtn() //Login Case
            return
        }
        //Session Expiry case
        dismiss(animated: true) {
            JRLoginUI.sharedInstance().delegate?.signInUserDenied()
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_user_denied".localized])
            completion(false, error, false)
        }
    }
}

// MARK: - IBActions
extension JRAuthOTPPopupVC{
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        guard isConfirmTappable else { return }
        guard let dataModel = vModel.model,
            let stateToken = dataModel.stateToken,
            let otpTextCount = dataModel.otpTextCount else { return }
        if let otp = enteredOTP, otp.length == otpTextCount {
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }
            view.endEditing(true)
            let params: [String: String] = [LOGINWSKeys.kOTP: otp, LOGINWSKeys.kStateToken: stateToken]
            verifyOTP(params)
            
        } else {
            let errMsg = "jr_login_please_enter_valid_otp".localized
            JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType, gaEl_otp, errMsg, LOGINGAKeys.kLabelApp, "")
            view.showToast(toastMessage: errMsg, duration: 3.0)
        }
    }
    
    @IBAction func resendOTPAction(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.otpScreenResendOtpSmsClicked( LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        vModel.otpMethod = .SMS
        resendOTP()
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        closeButtonTapped()
    }
    
    @IBAction func otpOnCallTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.otpScreenResendOtpCallClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        vModel.otpMethod = .OBD
        resendOTP()
    }
    
    @IBAction func messageDismissTapped(_ sender: Any) {
        self.hideMessageView(withAnimation: true)
    }
    
    @IBAction func loginWithDiffAccTapped(_ sender: Any) {
        JRLoginGACall.otpScreenLoginWithDiffAcc(LoginAuth.sharedInstance().isNewUserLoggedIn ,loginFlowType)
        self.dismiss(animated: true) {
            if let vc = UIApplication.topViewController(){
                let tVc = JRAuthSignInPopupVC.newInstance
                tVc.loginFlowType = self.loginFlowType
                tVc.completion = self.completion
                let nav = UINavigationController.init(rootViewController: tVc)
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
                vc.present(nav, animated: true, completion: nil)
            }
        }
    }
}

//MARK:- Private methods
extension JRAuthOTPPopupVC{
    
    private func initilize() {
        self.screenType = .popup
        containerView.dismissKeyboardOnTap()
        confirmBtn.alpha = 0.5
        if let loginType = vModel.model?.loginType, loginType != .email, let mobileNumber = vModel.model?.loginId {
            let verifyStr = "jr_login_verify_mobile".localized + " " + mobileNumber
            userNameLbl.attributedText = JRLHelper.getUnderlineAttributedString(verifyStr, [mobileNumber])
        }
        otpTextFieldView.delegate = self
        loadingIndicatorView.isHidden = true
        messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
        messageViewBtn.layer.borderColor = UIColor.white.cgColor
        messageViewBtn.layer.borderWidth = 1.0
        messageView.isHidden = true
        
        //Small Device handling
        if self.deviceHeight < 667.0 {
            submitBottomConst.constant = 10.0
            resendTopConst.constant = 8.0
            resendBottomConst.constant = 7.0
            otpViewHeightConst.constant = 123.0
            containerViewHeightConst.constant = 305.0
        }
        NotificationCenter.default.addObserver(self, selector: #selector(setFirstResponder), name: UIApplication.didBecomeActiveNotification, object: nil)
    }
    
    private func showMessageView(withAnimation:Bool){
        var topSafeArea: CGFloat = 0.0
        if #available(iOS 11.0, *) {
            topSafeArea = view.safeAreaInsets.top
        }
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.messageView.frame = CGRect.init(x: 0, y: topSafeArea, width: self.view.frame.size.width, height: 60)
                        self.messageViewTopConst.constant = topSafeArea
        }) {
            (finished) -> Void in
            self.canDismissMsgVw = true
            self.messageView.frame = CGRect.init(x: 0, y: topSafeArea, width: self.view.frame.size.width, height: 60)
            self.messageViewTopConst.constant = topSafeArea
        }
    }
    
    private func hideMessageView(withAnimation:Bool){
        if canDismissMsgVw{
            UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                           options: .curveEaseIn,
                           animations: {
                            () -> Void in
                            self.messageViewTopConst.constant = -60
                            self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
            }){
                (finished) -> Void in
                self.canDismissMsgVw = false
                self.messageViewTopConst.constant = -60
                self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
            }
        }
    }
    
    private func setMessage(message: String){
        messageLbl.text = message
    }
    
    private func showToastResettingUI(with message: String?) {
        let messageToShow: String
        if let msg = message, !msg.isEmpty {
            messageToShow = msg
        } else {
            messageToShow = JRLoginConstants.generic_error_message
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: { [weak self] in
            if let weakSelf = self {
                weakSelf.view.showToast(toastMessage: messageToShow, duration: 3.0)
                weakSelf.resetUI()
            }
        })
    }
    
    private func resetUI(){
        confirmBtn.alpha = 0.5
        isConfirmTappable = false
        otpTextFieldView.resetUI()
        enteredOTP = nil
        loadingIndicatorView?.isHidden = true
    }
    
    private func verifyOTP(_ params: [String: String], retryCount: Int = 0) {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        
        vModel.verifyOTP(params) { [weak self] (success, message, responseCode, ouathCode) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                guard success else{
                    if let msg = message, msg.isEmpty{
                        JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, "", LOGINGAKeys.kLabelAPI, "")
                        weakSelf.navigationController?.popViewController(animated: false)
                    }
                    else if let msg = message{
                        JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, msg, LOGINGAKeys.kLabelAPI, "")
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        weakSelf.otpTextFieldView.resetUI()
                        weakSelf.enteredOTP = nil
                        weakSelf.loadingIndicatorView?.isHidden = true
                    })
                    return
                }
                
                if let stateToken = weakSelf.vModel.model?.stateToken, weakSelf.loginFlowType == .login {
                    weakSelf.delegate?.updateStateToken(stateToken)
                }
                
                switch responseCode {
                case LOGINRCkeys.accountClaimable:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp)
                    weakSelf.loadingIndicatorView?.isHidden = true
                    let vc = JRAuthAccountExistVC.newInstance
                    vc.dataModel = self?.vModel.model
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                    
                case LOGINRCkeys.success:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp)
                    weakSelf.vModel.model?.otpTextCount = nil
                    if let ouathCode = ouathCode, !ouathCode.isEmpty {
                        
                        var loginId = ""
                        if let dataModel = self?.vModel.model, let lId = dataModel.loginId{
                            loginId = lId
                        }
                        
                        JRLServiceManager.setAccessToken(code: ouathCode,loginId: loginId, completionHandler: { (isSuccess, error) in
                            DispatchQueue.main.async {
                                weakSelf.loadingIndicatorView?.isHidden = true
                                
                                if weakSelf.loginFlowType == .login{
                                    if let dataModel = self?.vModel.model, let isSuccess = isSuccess, isSuccess {
                                        if dataModel.loginType == .mobile || dataModel.loginType == .email {
//                                            JRLoginGACall.loginSuccess()
                                            weakSelf.signInCompleted(isSuccess: isSuccess, error: error)
                                            return
                                        } else if dataModel.loginType == .newAccount {
//                                            JRLoginGACall.signupSuccess()
                                            weakSelf.signUpCompleted(isSuccess: isSuccess, error: error, allowUPI: dataModel.allowUPI)
                                            return
                                        }
                                    }
                                    
                                    if let err = error as NSError?, err.code == JRReloginErrorCode {
                                        weakSelf.moveToSignInController()
                                    } else {
                                        weakSelf.signInCompleted(isSuccess: isSuccess, error: error)
                                    }
                                }
                                else{ // SESSION EXPIRY CASE
                                    guard let completion = weakSelf.completion else {
                                        weakSelf.dismiss(animated: false, completion: nil)
                                        return
                                    }
                                    weakSelf.dismiss(animated: false, completion: {
                                        completion(isSuccess, error, true)
                                    })
                                }
                            }
                        })
                    }
                    else{
                        weakSelf.loadingIndicatorView?.isHidden = true
                        weakSelf.dismiss(animated: true, completion: nil)
                    }
                    
                case LOGINRCkeys.invalidPublicKey:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, JRLoginConstants.generic_error_message, LOGINGAKeys.kLabelAPI, LOGINRCkeys.invalidPublicKey)
                    if retryCount < 2 {
                        let updateRetryCount = (retryCount + 1)
                        weakSelf.verifyOTP(params, retryCount: updateRetryCount)
                    } else {
                        let message = JRLoginConstants.generic_error_message
                        weakSelf.showToastResettingUI(with: message)
                    }
                        
                case LOGINRCkeys.unprocessableEntity:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, message ?? JRLoginConstants.generic_error_message, LOGINGAKeys.kLabelAPI, LOGINRCkeys.unprocessableEntity)
                    weakSelf.showToastResettingUI(with: message)
                    //JRAuthSessionExpiryMgr.openLogin()
                
                case LOGINRCkeys.otpLimitReach, LOGINRCkeys.OTPVerificationLimitReached:
                    let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_dabu_OTP_Limit_Reached".localized,
                                                                  subtitle: message ?? "",
                                                                  confirmText: "jr_login_ok".localized,
                                                                  cancelText: nil)
                    JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) {_ in
                        weakSelf.moveToSignInController()
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
                    let message = JRLoginConstants.generic_error_message
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, JRLoginConstants.generic_error_message, LOGINGAKeys.kLabelAPI, responseCode ?? "")
                    weakSelf.showToastResettingUI(with: message)
                    
                default:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, message ?? JRLoginConstants.generic_error_message, LOGINGAKeys.kLabelAPI, responseCode ?? "")
                    weakSelf.showToastResettingUI(with: message)
                }
            }
            return
        }
    }
    
    private func moveToSignInController() {
        guard let navCont = navigationController else {
            return
        }
        for controller in navCont.viewControllers {
            if controller is JRAuthSignInPopupVC {
                navCont.popToViewController(controller, animated: true)
            }
        }
    }
    
    private func updateNavigationStack() {
        guard var viewControllers: [UIViewController] = navigationController?.viewControllers else {
            return
        }
        
        for passwordVC in viewControllers {
            if passwordVC.isKind(of: JRAuthPasswordVC.self) {
                viewControllers.removeObject(passwordVC)
            }
        }
        
        navigationController?.viewControllers = viewControllers
    }
    
    private func updateView(forState state : ResendSMSState){
        resendOTPLabel.isHidden = true
        resendOtpBtn.isHidden = true
        resendOtpOnCallBtn.isHidden = true
        progressView.isHidden = true
        switch state {
        case .resendEnabled:
            progressView.stopSpinner()
            resendOtpBtn.isHidden = false
            resendOtpOnCallBtn.isHidden = false
            break
        case .responseAwaited:
            progressView.isHidden = false
            progressView.startSpinner()
            break
        case .cooldownTime:
            progressView.stopSpinner()
            startTimer()
            resendOTPLabel.isHidden = false
            break
        }
    }
    
    private func startTimer() {
        vModel.setTimerValues()
        updateTime()
        endTimer()
        countdownTimer = Timer.scheduledTimer(timeInterval: 1,
                                              target: self,
                                              selector: #selector(updateTime),
                                              userInfo: nil,
                                              repeats: true)
    }
    
    private func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    
    private func resetUIViews(withState state: ResendSMSState){
        self.updateView(forState : state)
        self.otpTextFieldView.resetUI()
    }
    
    private func resendOTP(){
        guard let dataModel = vModel.model, let stateToken = dataModel.stateToken else {
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
            return
        }
        updateView(forState : .responseAwaited)
        view.isUserInteractionEnabled = false
        vModel.resendOtp(stateToken: stateToken, screenType: .popup) { [weak self] (success, message, responseCode, stateToken) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                if success {
                    if let token = stateToken {
                        weakSelf.delegate?.updateStateToken(token)
                    }
                    weakSelf.resetUIViews(withState: .cooldownTime)
                    weakSelf.showMessageView(withAnimation: true)
                    weakSelf.hideMessageView(withAnimation: true)
                    weakSelf.setMessage(message:message ?? "")
                } else {
                    guard responseCode != LOGINRCkeys.otpLimitReach else {
                        weakSelf.moveToSignInController()
                        return
                    }
                    weakSelf.resetUIViews(withState: .resendEnabled)
                    weakSelf.otpTextFieldView.setTextFieldFirstResponder(index: 0)
                    weakSelf.enteredOTP = nil
                    
                    if let _ = stateToken {}
                    else if let msg = message {
                        weakSelf.otpLimitReachedMessage = msg
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    }
                }
            }
        }
    }
    
    @objc private func updateTime() {
        if vModel.totalTime < 10{
            resendOTPLabel.text =  String(format:"jr_login_request_another_otp_in_00_0sec".localized, vModel.totalTime)
        }
        else{
            resendOTPLabel.text =  String(format:"jr_login_request_another_otp_in_00_sec".localized, vModel.totalTime)
        }
        
        if vModel.totalTime > 0 {
            vModel.updateTotalTimeW(with: vModel.totalTime - 1)
        } else {
            vModel.updateTotalTimeW(with: 0)
            endTimer()
            updateView(forState : .resendEnabled)
        }
    }
    
    @objc private func setFirstResponder() {
        guard let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount, let enteredOTP = enteredOTP else {
            return
        }
        
        var index = enteredOTP.count
        if enteredOTP.count == otpTextCount {
            index = enteredOTP.count - 1
        }
        
        otpTextFieldView.setTextFieldFirstResponder(index: index)
    }
    
    @objc private func setResignFirstResponder() {
        self.view.endEditing(true)
    }
}

//MARK:- Internal Func
internal extension JRAuthOTPPopupVC{
    func getLoginSuccEl1() -> String{
        return LoginAuth.sharedInstance().isLoginViaOtp ? gaEl_otp : gaEl_pwdOtp
    }
}

// MARK:- UITextFieldDelegate & Helpers
extension JRAuthOTPPopupVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
        if let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount, otp.count ==  otpTextCount{
            confirmBtn.alpha = 1.0
            isConfirmTappable = true
        }
        else{
            confirmBtn.alpha = 0.5
            isConfirmTappable = false
        }
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
        
    }
}

//MARK:- Keyboard notification delegates
extension JRAuthOTPPopupVC{
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            viewBottomConst.constant = keyboardSize.height - safeAreaBottomInset
        }
    }
    
    @objc override func keyboardWillHide(notification:Notification){
        viewBottomConst.constant = 0
    }
}



