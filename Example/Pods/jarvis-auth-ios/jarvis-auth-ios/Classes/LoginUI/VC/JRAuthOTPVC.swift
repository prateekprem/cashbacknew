//
//  JRAuthOTPVC.swift
//  Login
//
//  Created by Parmod on 18/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

protocol JRLOTPVCDelegate: class {
    func updateStateToken(_ stateToken: String)
}

enum ResendSMSState {
    case resendEnabled
    case cooldownTime
    case responseAwaited
}

class JRAuthOTPVC: JRAuthBaseVC {
    
    //MARK:- Properties
    @IBOutlet weak var userNameLbl: UILabel!
    @IBOutlet weak var otpTextFieldView: JRLOTPTextFieldView!
    @IBOutlet weak var resendOTPLabel: UILabel!
    @IBOutlet weak var progressView: JRChatOnboardingSpinnerView!
    @IBOutlet weak var resendSmsButton: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var resendOtpTopConst: NSLayoutConstraint!
    @IBOutlet weak var resendOtpBottomConst: NSLayoutConstraint!
    @IBOutlet weak var otpOptionsView: UIView!
    @IBOutlet weak var otpButton: UIButton!
    @IBOutlet weak var otpOptionsPopup: UIView!
    @IBOutlet weak var loginOnSmsBtn: UIButton!
    @IBOutlet weak var loginOnCallBtn: UIButton!
    @IBOutlet weak var resendOtpLbl: UILabel!
    @IBOutlet weak var otherIssuesBtn: UIButton!
    
    private var vModel: JRAuthOTPVM = JRAuthOTPVM()
    weak var delegate: JRLOTPVCDelegate?
    private var enteredOTP: String?
    private var messageView = UIView()
    private var label = UILabel()
    var otpLimitReachedMessage = ""
    var countdownTimer: Timer!
    var isConfirmTappable: Bool = false
    private var gaEl_pwdOtp: String = LOGINGAKeys.kLabelPwdOtp
    internal var gaEl_otp: String = LOGINGAKeys.kOtp
    
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRAuthOTPVC {
        let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRAuthOTPVC") as! JRAuthOTPVC
        vc.vModel.model = dataModel
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
        configureMessageView()
        updateView(forState: .cooldownTime)
        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationStack()
        JRLoginGACall.otpScreenLoaded(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        if let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount  {
            otpTextFieldView.setUpUI(count: otpTextCount, borderStyle: UITextField.BorderStyle.none, isSecureTextEntry: true)
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
        }
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.loadingIndicatorView?.isHidden = true
    }
    
    deinit {
        endTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func backButtonTapped() {
        endTimer()
        JRLoginGACall.otpScreenBackBtnClicked( LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: JRAuthSignInVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
}

// MARK:- IBActions
extension JRAuthOTPVC{
    @IBAction func confirmBtnTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        guard isConfirmTappable else { return }
        guard let dataModel = vModel.model, let stateToken = dataModel.stateToken, let otpTextCount = dataModel.otpTextCount else {
            return
        }
        if let otp = enteredOTP, otp.length == otpTextCount {
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }
            view.endEditing(true)
            let params: [String: String] = [LOGINWSKeys.kOTP: otp, LOGINWSKeys.kStateToken: stateToken]
            verifyOTP(params)
        } else {
            let msg = "jr_login_please_enter_valid_otp".localized
            JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType, gaEl_otp, msg, LOGINGAKeys.kLabelApp, "")
            view.showToast(toastMessage: msg, duration: 3.0)
        }
    }
    
    @IBAction func resendOTPAction(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.otpScreenResendOtpClicked(isSignUp: LoginAuth.sharedInstance().isNewUserLoggedIn)
        setResignFirstResponder()
        if otpLimitReachedMessage.length > 0  {
            self.updateView(forState : .resendEnabled)
            self.view.showToast(toastMessage: otpLimitReachedMessage, duration: 3.0)
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
            return
        }
        otpOptionsView.isHidden = false
        JRLoginGACall.otpScreenResendOtpPopUpLoaded(isSignUp: LoginAuth.sharedInstance().isNewUserLoggedIn)
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        backButtonTapped()
    }
    
    @IBAction func onDismissOTPButtonTouch(_ sender: UIButton) {
        otpOptionsView.isHidden = true
        otpTextFieldView.setTextFieldFirstResponder(index: 0)
        otpTextFieldView.resetUI()
        enteredOTP = nil
    }
    
    @IBAction func onLoginSmsBtnTouched(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.otpScreenResendOtpSmsClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        otpOptionsView.isHidden = true
        vModel.otpMethod = .SMS
        resendOTP()
    }
    
    @IBAction func onLoginCallBtnTouched(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.otpScreenResendOtpCallClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, screenType, loginFlowType)
        otpOptionsView.isHidden = true
        vModel.otpMethod = .OBD
        resendOTP()
    }
    
    @IBAction func otherIssuesBtnCliked(_ sender: UIButton) {
        JRLoginGACall.otpScreenLoginIssuesClicked(LoginAuth.sharedInstance().isNewUserLoggedIn)
        if let dataModel = vModel.model, let stateToken = dataModel.stateToken{
            let dm = JRLOtpPsdVerifyModel(loginId: dataModel.loginId, stateToken: stateToken, otpTextCount: 6, loginType: dataModel.loginType)
            let vc = JRLIssuesSelectionVC.controller(dm)
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

// MARK:- Private Methods
private extension JRAuthOTPVC{
    
    private func setupUI(){
        self.showMessageView(withAnimation: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideMessageView(withAnimation: true)
        }
        otpOptionsView.isHidden = true
        loginOnSmsBtn.layer.borderColor = LOGINCOLOR.cyan.cgColor
        loginOnCallBtn.layer.borderColor = LOGINCOLOR.cyan.cgColor
    }
    
    private func updateView(forState state : ResendSMSState){
        resendSmsButton.isHidden = true
        resendOTPLabel.isHidden = true
        progressView.isHidden = true
        switch state {
        case .resendEnabled:
            progressView.stopSpinner()
            resendSmsButton.isHidden = false
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
    
    @objc private func updateTime() {
        
        if vModel.totalTime < 2{
            resendOTPLabel.text =  String(format:"jr_login_otp_resend_sec".localized, vModel.totalTime)
        }else{
            resendOTPLabel.text =  String(format:"jr_login_otp_resend_secs".localized, vModel.totalTime)
        }
        
        if vModel.totalTime > 0 {
            vModel.updateTotalTimeW(with: vModel.totalTime - 1)
        } else {
            vModel.updateTotalTimeW(with: 0)
            endTimer()
            updateView(forState : .resendEnabled)
        }
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
        vModel.resendOtp(stateToken: stateToken) { [weak self] (success, message, responseCode, stateToken) in
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                
                if success {
                    if let token = stateToken{
                        weakSelf.delegate?.updateStateToken(token)
                    }
                    weakSelf.resetUIViews(withState: .cooldownTime)
                    weakSelf.showMessageView(withAnimation: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        weakSelf.hideMessageView(withAnimation: true)
                    }
                    weakSelf.setMessage(message:message ?? "")
                } else {
                    guard responseCode != LOGINRCkeys.otpLimitReach else {
                        weakSelf.moveToSignInController()
                        return
                    }
                    weakSelf.resetUIViews(withState: .resendEnabled)
                    weakSelf.otpTextFieldView.setTextFieldFirstResponder(index: 0)
                    weakSelf.enteredOTP = nil
                    
                    if let _ = stateToken {
                        
                    } else if let msg = message {
                        weakSelf.otpLimitReachedMessage = msg
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    }
                }
            }
        }
    }
    
    private func resetUIViews(withState state: ResendSMSState) {
        self.updateView(forState : state)
        self.otpTextFieldView.resetUI()
    }
    
    private func initilize() {
        self.screenType = .fullScreen
        self.view.dismissKeyboardOnTap()
        confirmBtn.alpha = 0.5
        
        if let loginType = vModel.model?.loginType, loginType != .email, let mobileNumber = vModel.model?.loginId {
            let verifyStr = "jr_login_verify_mobile".localized + " " + mobileNumber
            userNameLbl.attributedText = JRLHelper.getUnderlineAttributedString(verifyStr, [mobileNumber])
        }
        
        //Small Device handling
        if self.deviceHeight < 667.0 {
            resendOtpTopConst.constant = 10.0
            resendOtpBottomConst.constant = 15.0
        }
        otpTextFieldView.delegate = self
        loadingIndicatorView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(setFirstResponder), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        guard let dataModel = vModel.model else {
            return
        }
        if dataModel.loginType == .mobile && dataModel.isFromPassword{
            otherIssuesBtn.isHidden = false
        }
    }
    
    private func configureMessageView(){
        messageView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 32)
        messageView.backgroundColor = LOGINCOLOR.green
        self.view.addSubview(messageView)
        label.frame = CGRect.init(x: 0, y: 0, width: messageView.frame.size.width, height: messageView.frame.size.height)
        label.font = UIFont.systemFont(ofSize: 14)
        label.textAlignment = .center
        label.textColor = UIColor.white
        messageView.addSubview(label)
        setMessage(message:"jr_login_otp_sent_successfully".localized)
    }
    
    private func showMessageView(withAnimation:Bool){
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.messageView.frame = CGRect.init(x: 0, y: self.vModel.statusBarHeight, width: self.view.frame.size.width, height: 32)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: self.vModel.statusBarHeight, width: self.view.frame.size.width, height: 32)
        }
    }
    
    private func hideMessageView(withAnimation:Bool){
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        () -> Void in
                        self.messageView.frame = CGRect.init(x: 0, y: -32, width: self.view.frame.size.width, height: 32)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: -32, width: self.view.frame.size.width, height: 32)
        }
    }
    
    private func setMessage(message: String){
        label.text = message
    }
    
    private func updateNavigationStack() {
        guard var viewControllers: [UIViewController] = navigationController?.viewControllers else { return }
        
        for passwordVC in viewControllers {
            if passwordVC.isKind(of: JRAuthPasswordVC.self) {
                viewControllers.removeObject(passwordVC)
            }
        }
        
        navigationController?.viewControllers = viewControllers
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
    
    func resetUI(){
        confirmBtn.alpha = 0.5
        isConfirmTappable = false
        otpTextFieldView.resetUI()
        enteredOTP = nil
        loadingIndicatorView?.isHidden = true
    }
    
    private func verifyOTP(_ params: [String: String], retryCount: Int = 0) {
        view.isUserInteractionEnabled = false
        
        vModel.verifyOTP(params, completion: { [weak self] (success, message, responseCode, ouathCode) in
            
            guard let weakSelf = self else {
                return
            }
            
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
                        weakSelf.resetUI()
                    })
                    return
                }
                
                if let stateToken = weakSelf.vModel.model?.stateToken{
                    weakSelf.delegate?.updateStateToken(stateToken)
                }
                
                switch responseCode {
                case LOGINRCkeys.accountClaimable:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp)
                    weakSelf.loadingIndicatorView?.isHidden = true
                    let vc = JRAuthAccountExistVC.newInstance
                    vc.dataModel = self?.vModel.model
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                    
                case LOGINRCkeys.invalidOTP:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp, message ?? "", LOGINGAKeys.kLabelAPI, LOGINRCkeys.invalidOTP)
                    weakSelf.showToastResettingUI(with: message)
                    
                case LOGINRCkeys.success:
                    JRLoginGACall.otpScreenProceedClicked(LoginAuth.sharedInstance().isNewUserLoggedIn, weakSelf.screenType, weakSelf.loginFlowType, weakSelf.gaEl_otp)
                    weakSelf.vModel.model?.otpTextCount = nil
                    if let ouathCode = ouathCode, !ouathCode.isEmpty {
                        
                        var loginId = ""
                        if let dataModel = self?.vModel.model, let lId = dataModel.loginId{
                            loginId = lId
                        }
                        
                        JRLServiceManager.setAccessToken(code: ouathCode, loginId: loginId, completionHandler: { (isSuccess, error) in
                            
                            DispatchQueue.main.async {
                                weakSelf.loadingIndicatorView?.isHidden = true
                            }
                            
                            if let dataModel = self?.vModel.model, let isSuccess = isSuccess, isSuccess {
                                if dataModel.loginType == .mobile || dataModel.loginType == .email {
                                    weakSelf.signInCompleted(isSuccess: isSuccess, error: error)
                                    return
                                } else if dataModel.loginType == .newAccount {
                                    weakSelf.signUpCompleted(isSuccess: isSuccess, error: error, allowUPI: dataModel.allowUPI)
                                    return
                                }
                            }
                            
                            if let err = error as NSError?, err.code == JRReloginErrorCode {
                                DispatchQueue.main.async {
                                    weakSelf.moveToSignInController()
                                }
                            } else {
                                weakSelf.signInCompleted(isSuccess: isSuccess, error: error)
                            }
                        })
                    } else {
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
        })
    }
    
    private func moveToSignInController() {
        guard let navCont = navigationController else { return }
        for controller in navCont.viewControllers {
            if controller is JRAuthSignInVC {
                navCont.popToViewController(controller, animated: true)
            }
        }
    }
    
    @objc private func setFirstResponder() {
        guard let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount, let enteredOTP = enteredOTP else { return }
        
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
internal extension JRAuthOTPVC{
    func getLoginSuccEl1() -> String{
        return LoginAuth.sharedInstance().isLoginViaOtp ? gaEl_otp : gaEl_pwdOtp
    }
}

// MARK:- UITextFieldDelegate & Helpers
extension JRAuthOTPVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
        if let dataModel = vModel.model, let otpTextCount = dataModel.otpTextCount, otp.count ==  otpTextCount{
            confirmBtn.alpha = 1.0
            isConfirmTappable = true
            JRLoginGACall.otpScreenOtpEntered(isSignUp: LoginAuth.sharedInstance().isNewUserLoggedIn)
        }
        else{
            confirmBtn.alpha = 0.5
            isConfirmTappable = false
        }
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
        
    }
}

