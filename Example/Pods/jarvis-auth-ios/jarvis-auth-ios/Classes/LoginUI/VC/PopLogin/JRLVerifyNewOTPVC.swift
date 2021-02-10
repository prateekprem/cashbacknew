//
//  JRLVerifyNewOTPVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 20/01/20.
//

import UIKit

class JRLVerifyNewOTPVC: JRAuthBaseVC {
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var otpTextField: JRLOTPTextFieldView!
    @IBOutlet var resendSmsButton: UIButton!
    @IBOutlet var resendOTPLabel: UILabel!
    @IBOutlet var progressView: JRChatOnboardingSpinnerView!
    @IBOutlet var proceedButton: UIButton!
    
    @IBOutlet var otpViewTopConstraint: NSLayoutConstraint!
    @IBOutlet var proceedBtnTopConstraint: NSLayoutConstraint!
    
    private var enteredOTP: String?
    
    private var countdownTimer: Timer!
    private var messageView = UIView()
    private var label = UILabel()
    
    var message : String?
    var mobileNo : String = ""
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    private var totalTime : Int = 30
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    //MARK:-Instance
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLVerifyNewOTPVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRLVerifyNewOTPVC") as! JRLVerifyNewOTPVC
        vc.dataModel = dataModel
        return vc
    }
    
    @IBAction func onBackBtnTouch(_ sender: UIButton) {
        
        if self.dataModel?.isLoginFlow == true {
            self.navigationController?.popToRootViewController(animated: true)
            return
        }
        
        if let dataModel = dataModel, !dataModel.isFromUpdateEmail {
            let loginType = dataModel.loginType
            switch loginType {
            case .mobile, .email:
//                JRLoginGACall.loginBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            case .newAccount:
//                JRLoginGACall.signUpBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else if controller.isKind(of: JRAuthSignInVC.self){
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    @IBAction func onResendSMSBtnTouch(_ sender: UIButton) {
        resendOTP()
    }
    
    //MARK:-Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initilize()
        configureMessageView()
        if let message = message{
            setMessage(message:message)
        }
        self.showMessageView(withAnimation: true)
        updateView(forState: .cooldownTime)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // your code here
            self.hideMessageView(withAnimation: true)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        updateNavigationStack()
        if let dataModel = dataModel, let otpTextCount = dataModel.otpTextCount  {
            otpTextField.setUpUI(count: otpTextCount, borderStyle: .none, isSecureTextEntry: true)
            otpTextField.setTextFieldFirstResponder(index: 0)
            otpTextField.resetUI()
            enteredOTP = nil
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.deviceHeight < 667.0 {
            setResignFirstResponder()
        }
    }
    
    deinit {
        endTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initilize() {
        if self.deviceHeight < 667.0 {
            proceedBtnTopConstraint.constant = 0.0
            otpViewTopConstraint.constant = 20.0
        } else {
            proceedBtnTopConstraint.constant = 30.0
            otpViewTopConstraint.constant = 35.0
        }
        if let dataModel = dataModel, dataModel.isFromUpdateEmail {
            titleLbl.text = "jr_login_verify_mobile".localized
            messageLbl.text = String(format: "jr_login_enter_otp_sent_on".localized, mobileNo)
        } else {
            titleLbl.text = "jr_login_otp_verification_new_number".localized
            messageLbl.text = String(format: "jr_login_enter_otp_sent_on_new_number".localized, mobileNo)
        }
        otpTextField.delegate = self
        proceedButton.layer.cornerRadius = 4.0
        NotificationCenter.default.addObserver(self, selector: #selector(setFirstResponder), name: UIApplication.didBecomeActiveNotification, object: nil)
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
                        self.messageView.frame = CGRect.init(x: 0, y: self.statusBarHeight, width: self.view.frame.size.width, height: 32)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: self.statusBarHeight, width: self.view.frame.size.width, height: 32)
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
    
    @objc private func setFirstResponder() {
        guard let dataModel = dataModel, let otpTextCount = dataModel.otpTextCount, let enteredOTP = enteredOTP else {
            return
        }
        
        var index = enteredOTP.count
        if enteredOTP.count == otpTextCount {
            index = enteredOTP.count - 1
        }
        
        otpTextField.setTextFieldFirstResponder(index: index)
    }
    
    @objc private func setResignFirstResponder() {
        self.view.endEditing(true)
    }
    
    @IBAction private func proceedButtonTapped(_ sender: UIButton) {
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let otpTextCount = dataModel.otpTextCount else {
            return
        }
        
        if let otp = enteredOTP, otp.length == otpTextCount {
            if let vc = JRLVerifyVC.controller("jr_login_verifying_your_details".localized) {
                view.endEditing(true)
                navigationController?.pushViewController(vc, animated: true)
                let params: [String: String] = [LOGINWSKeys.kOTP: otp, "state_token": stateToken]
                verifyOTP(params, isFromEmailUpdate: dataModel.isFromUpdateEmail)
            }
        } else {
            view.showToast(toastMessage: "jr_login_please_enter_valid_otp".localized, duration: 3.0)
        }
    }
    
    func verifyOTP(_ params: [String: String], isFromEmailUpdate: Bool) {
        JRLServiceManager.validateNewPhoneOTP(params, isFromEmailUpdate: isFromEmailUpdate) {[weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.navigationController?.popViewController(animated: false)
                if let error = error {
                    if (error as NSError).code == 311 {
                        if let model = weakSelf.dataModel, let phoneNumber = model.loginId {
                            AuthRSAGenerator.shared.removeSavedKeyPair(for: phoneNumber)
                        } else {
                            AuthRSAGenerator.shared.removeAllSavedKeyPair()
                        }
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.showMoveBackErrorAlert(with: msg)
                        
                    } else {
                        weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                    }
                    return
                }
                
                guard let responseData = data,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else {
                    
                    weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                    weakSelf.otpTextField.resetUI()
                    weakSelf.enteredOTP = nil
                    return
                }
                if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String, !stateToken.isEmpty {
                    weakSelf.dataModel?.stateToken = stateToken
                }
                switch responseCode {
                case LOGINRCkeys.success:
                    UserDefaults.standard.set(weakSelf.mobileNo, forKey: "prefilledLoginId")
                    weakSelf.dataModel?.otpTextCount = nil
                    
                    if weakSelf.dataModel?.isFromUpdateEmail == true {
                        let stateToken = responseData.getStringKey("state")
                        if !stateToken.isEmpty {
                            weakSelf.dataModel?.stateToken = stateToken
                            if let emailToUpdate = weakSelf.dataModel?.emailToUpdate {
                                weakSelf.updateEmail(emailToUpdate)
                            } else {
                                weakSelf.moveToUpdateEmail()
                            }
                        }
                        
                    } else if weakSelf.dataModel?.isLoginFlow == true {
                        let vc = JRPUResultVC.controller()
                        vc.isFromLogin = true
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                        
                    } else {
                        let vc = JRPUResultVC.controller()
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                    }
                    
                case LOGINRCkeys.invalidPublicKey:
                    if let model = weakSelf.dataModel, let phoneNumber = model.loginId {
                        AuthRSAGenerator.shared.removeSavedKeyPair(for: phoneNumber)
                    } else {
                        AuthRSAGenerator.shared.removeAllSavedKeyPair()
                    }
                    let msg = JRLoginConstants.generic_error_message
                    weakSelf.showMoveBackErrorAlert(with: msg)
                    
                case LOGINRCkeys.badRequest,
                     LOGINRCkeys.tokenAndStateClientIdMismatch:
                    let msg = JRLoginConstants.generic_error_message
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                    }
                    
                case LOGINRCkeys.unprocessableEntity,
                     LOGINRCkeys.stateTokenMethodNotSupported,
                     LOGINRCkeys.authorizationAndStateClientIdMismatch,
                     //LOGINRCkeys.signatureTimeExpired,
                     LOGINRCkeys.invalidSignature,
                     LOGINRCkeys.authorizationMissing,
                     LOGINRCkeys.invalidAuthCode,
                     LOGINRCkeys.clientPermissionNotFound,
                     LOGINRCkeys.missingMandatoryHeaders,
                     LOGINRCkeys.invalidTokenBE,
                     LOGINRCkeys.invalidRefreshToken,
                     LOGINRCkeys.scopeNotRefreshable,
                     LOGINRCkeys.tokenAndStateUserIdMismatch:
                    
                    if weakSelf.dataModel?.isLoginFlow == true {
                       weakSelf.navigationController?.popToRootViewController(animated: true)
                    } else if weakSelf.dataModel?.isFromUpdateEmail == true {
                       let msg = JRLoginConstants.generic_error_message
                       weakSelf.showMoveBackErrorAlert(with: msg)
                    } else {
                        for controller in weakSelf.navigationController!.viewControllers as Array {
                            if controller.isKind(of: JRAuthSignInVC.self) {
                                weakSelf.navigationController!.popToViewController(controller, animated: true)
                                break
                            }
                        }
                    }
                    break
                    
                case LOGINRCkeys.otpLimitReach:
                    if let messsage = responseData[LOGINWSKeys.kMesssage] as? String {
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextField.setTextFieldFirstResponder(index: 0)
                        
                        if let dataModel = weakSelf.dataModel, dataModel.isFromUpdateEmail {
                            weakSelf.showMoveBackErrorAlert(with: messsage)
                        } else {
                            weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                        }
                    } else {
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    }
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                    }
                    
                default:
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        let msg: String
                        if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                            msg = message
                        } else {
                            msg = JRLoginConstants.generic_error_message
                        }
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                    }
                }
            }
        }
    }
    
    private func updateEmail(_ email: String) {
        guard let model = dataModel, let token = model.stateToken, !token.isEmpty else {
            return
        }
        let params = ["email": email, "state_token": token]
        
        JRLServiceManager.updateEmail(params) { [weak self] (response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                let genericMessage = JRLoginConstants.generic_error_message
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode"),
                    let message = response.getOptionalStringForKey("message") {
                    
                    switch responseCode {
                    case LOGINRCkeys.successBE:
                        let stateToken = response.getStringKey("state")
                        weakSelf.moveToVerifyEmailOTP(with: stateToken, email: email)
                        
                    case LOGINRCkeys.unprocessableEntity,
                         LOGINRCkeys.emptyStateToken,
                         LOGINRCkeys.invalidStateToken,
                         LOGINRCkeys.stateTokenMethodNotSupported,
                         LOGINRCkeys.stateTokenMethodNotSupportedBE,
                         LOGINRCkeys.authorizationAndClientIdMismatch,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.invalidAuthCode,
                         LOGINRCkeys.clientPermissionNotFound,
                         LOGINRCkeys.missingMandatoryHeaders:
                        weakSelf.showMoveBackErrorAlert(with: genericMessage)
                        
                    case LOGINRCkeys.noChangesDone,
                         LOGINRCkeys.otpLimitReachedBE,
                         LOGINRCkeys.emailCannotBeChanged:
                        weakSelf.showMoveBackErrorAlert(with: message)
                        
                    case LOGINRCkeys.invalidEmail,
                         LOGINRCkeys.emailAlreadyLinked:
                        weakSelf.showProceedToEmailAlert(with: message)
                        
                    default:
                        weakSelf.showMoveBackErrorAlert(with: message)
                    }
                    
                } else if let error = error {
                    weakSelf.showMoveBackErrorAlert(with: error.localizedDescription)
                } else {
                    weakSelf.showMoveBackErrorAlert(with: genericMessage)
                }
            }
        }
    }
    
    private func moveToVerifyEmailOTP(with stateToken: String, email: String) {
        if let model = dataModel {
            model.stateToken = stateToken
            model.otpTextCount = 6
            let emailOtpScene = JRPUEmailOtpVC.controller(model)
            emailOtpScene.email = email
            pushUpdatingNavigationStack(viewController: emailOtpScene)
        }
    }
    
    private func moveToUpdateEmail() {
        let updateEmailScene = JRLNewEmailVC.newInstance
        updateEmailScene.dataModel = dataModel
        pushUpdatingNavigationStack(viewController: updateEmailScene)
    }
    
    private func pushUpdatingNavigationStack(viewController: UIViewController) {
        guard let navCont = navigationController else {
            return
        }
        var viewControllers = [UIViewController]()
        for controller in navCont.viewControllers {
            if controller != self {
                viewControllers.append(controller)
            } else {
                break
            }
        }
        viewControllers.append(viewController)
        navCont.setViewControllers(viewControllers, animated: true)
    }
    
    func resendOTP() {
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken else {
            otpTextField.setTextFieldFirstResponder(index: 0)
            otpTextField.resetUI()
            enteredOTP = nil
            return
        }
        
        if dataModel.loginType == .mobile || dataModel.loginType == .email {
            //JRLoginGACall.loginResendOTPClicked()
        } else if dataModel.loginType == .newAccount {
            //JRLoginGACall.signupResendOTPClicked()
        }
        
        updateView(forState : .responseAwaited)
        view.isUserInteractionEnabled = false
        view.endEditing(true)
        
        JRLServiceManager.reSendEmailOTP(["state_token": stateToken]) { [weak self] (data, error) in
            
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.isUserInteractionEnabled = true
                
                if let responseData = data,
                    let _ = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    switch responseCode {
                        
                    case LOGINRCkeys.success:
                        weakSelf.updateView(forState : .cooldownTime)
                        weakSelf.otpTextField.resetUI()
                        //weakSelf.delegate?.updateStateToken(stateToken)
                        //weakSelf.view.showToast(toastMessage: "jr_login_otp_send_successfully".localized, duration: 3.0)
                        weakSelf.setMessage(message:"jr_login_otp_sent_successfully".localized)
                        weakSelf.showMessageView(withAnimation: true)
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            weakSelf.hideMessageView(withAnimation: true)
                        }
                        
                    case LOGINRCkeys.unprocessableEntity,
                         LOGINRCkeys.stateTokenMethodNotSupported,
                         LOGINRCkeys.authorizationAndStateClientIdMismatch,
                         //LOGINRCkeys.signatureTimeExpired,
                         LOGINRCkeys.invalidSignature,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.invalidAuthCode,
                         LOGINRCkeys.clientPermissionNotFound,
                         LOGINRCkeys.missingMandatoryHeaders,
                         LOGINRCkeys.invalidTokenBE,
                         LOGINRCkeys.invalidRefreshToken,
                         LOGINRCkeys.scopeNotRefreshable:
                        weakSelf.updateView(forState : .resendEnabled)
                        
                        if dataModel.isFromUpdateEmail {
                            let msg = JRLoginConstants.generic_error_message
                            weakSelf.showMoveBackErrorAlert(with: msg)
                            
                        } else if let navCont = weakSelf.navigationController {
                            for controller in navCont.viewControllers {
                                if controller.isKind(of: JRAuthSignInVC.self) {
                                    navCont.popToViewController(controller, animated: true)
                                    break
                                }
                            }
                        }
                        
                    case LOGINRCkeys.otpLimitReach:
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                        
                        let message: String
                        if let msg = responseData[LOGINWSKeys.kMesssage] as? String {
                            message = msg
                        } else {
                            message = JRLoginConstants.generic_error_message
                        }
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        
                    case LOGINRCkeys.invalidPublicKey:
                        if let model = weakSelf.dataModel, let phoneNumber = model.loginId {
                            AuthRSAGenerator.shared.removeSavedKeyPair(for: phoneNumber)
                        } else {
                            AuthRSAGenerator.shared.removeAllSavedKeyPair()
                        }
                        weakSelf.updateView(forState : .resendEnabled)
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.showMoveBackErrorAlert(with: msg)
                        
                    case LOGINRCkeys.badRequest:
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                        
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                        
                    default:
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                        
                        if let messsage = responseData[LOGINWSKeys.kMesssage] as? String {
                            weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                        } else {
                            let msg = JRLoginConstants.generic_error_message
                            weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                        }
                    }
                    
                } else if let error = error {
                    if (error as NSError).code == 311 {
                        if let model = weakSelf.dataModel, let phoneNumber = model.loginId {
                            AuthRSAGenerator.shared.removeSavedKeyPair(for: phoneNumber)
                        } else {
                            AuthRSAGenerator.shared.removeAllSavedKeyPair()
                        }
                        weakSelf.updateView(forState : .resendEnabled)
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.showMoveBackErrorAlert(with: msg)
                        
                    } else {
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    }
                    
                } else {
                    weakSelf.updateView(forState : .resendEnabled)
                    let msg = JRLoginConstants.generic_error_message
                    weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                }
            }
        }
    }
    
    private func showMoveBackErrorAlert(with message: String) {
        setResignFirstResponder()
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showProceedToEmailAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { [weak self] _ in
            self?.moveToUpdateEmail()
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
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
        totalTime = 30
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
        if totalTime < 2{
            resendOTPLabel.text =  String(format:"jr_login_otp_resend_sec".localized, totalTime)
        }else{
            resendOTPLabel.text =  String(format:"jr_login_otp_resend_secs".localized, totalTime)
        }
        
        if totalTime > 0 {
            totalTime -= 1
        } else {
            totalTime = 0
            endTimer()
            updateView(forState : .resendEnabled)
        }
    }
}

extension JRLVerifyNewOTPVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
        //        if otpErrorLbl != nil {
        //            otpErrorLbl.isHidden = isHidden
        //        }
    }
}
