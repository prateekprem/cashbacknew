//
//  JRPUEmailOtpVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 03/04/20.
//

import UIKit

class JRPUEmailOtpVC: JRAuthBaseVC {
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var otpTextField: JRLOTPTextFieldView!
    @IBOutlet var resendSmsButton: UIButton!
    @IBOutlet var resendOTPLabel: UILabel!
    @IBOutlet var progressView: JRChatOnboardingSpinnerView!
    
    private var enteredOTP: String?
    
    private var countdownTimer: Timer!
    private var messageView = UIView()
    private var label = UILabel()
    
    var message : String?
    //var mobileNo : String = ""
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    private var totalTime : Int = 30
    private var smsOTPTime : Int = 20
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var proceeedBtn: UIButton!
    
    var email : String = ""
    @IBOutlet weak var indicatorConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewConstarint: NSLayoutConstraint!
    
    //MARK:-Instance
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRPUEmailOtpVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRPUEmailOtpVC") as! JRPUEmailOtpVC
        vc.dataModel = dataModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let digitText: String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("authOtpTimer"), let val = Int(digitText) {
            smsOTPTime = val
        }
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingIndicatorView.isHidden = true
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dataModel = dataModel, let otpTextCount = dataModel.otpTextCount {
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
            indicatorConstraint.constant = 5.0
            buttonConstraint.constant = 5.0
            viewConstarint.constant = 20.0
        } else {
            indicatorConstraint.constant = 30.0
            buttonConstraint.constant = 30.0
            viewConstarint.constant = 35.0
        }
        
        if let _ = dataModel?.loginType, var mobileNumber = dataModel?.loginId {
            if mobileNumber.count > 5 {
                mobileNumber = mobileNumber.insert(seperator: " ", interval: 5)
            }
            titleLbl.text = String.init(format: "jr_login_verify_otp_sent_on_email_id".localized, mobileNumber)
        }
        otpTextField.delegate = self
        titleLbl.text = String.init(format: "jr_login_verify_otp_sent_on_email_id".localized, email)
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
    
    private func showMessageView(withAnimation: Bool) {
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.messageView.frame = CGRect.init(x: 0, y: self.statusBarHeight, width: self.view.frame.size.width, height: 32)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: self.statusBarHeight, width: self.view.frame.size.width, height: 32)
        }
    }
    
    private func hideMessageView(withAnimation: Bool) {
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
    
    private func setMessage(message: String) {
        label.text = message
    }
    
    private func popAccordingToFlow() {
        if let dataModel = dataModel, dataModel.isFromUpdateEmail {
            navigationController?.popViewController(animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onResendSMSBtnTouch(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }

        resendOTP()
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }

        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let otpTextCount = dataModel.otpTextCount else {
            return
        }
        
        if let otp = enteredOTP, otp.length == otpTextCount {
            let params: [String: String] = [LOGINWSKeys.kOTP: otp, "state_token": stateToken]
            if dataModel.isFromUpdateEmail {
                verifyUpdatedEmailOTP(params)
            } else {
                verifyOTP(params)
            }
        } else {
            view.showToast(toastMessage: "jr_login_please_enter_valid_otp".localized, duration: 3.0)
        }
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
    
    func resendOTP() {
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken else {
            otpTextField.setTextFieldFirstResponder(index: 0)
            otpTextField.resetUI()
            enteredOTP = nil
            return
        }
        
//        if dataModel.loginType == .mobile || dataModel.loginType == .email {
//            JRLoginGACall.loginResendOTPClicked()
//        } else if dataModel.loginType == .newAccount {
//            JRLoginGACall.signupResendOTPClicked()
//        }
        
        updateView(forState : .responseAwaited)
        view.isUserInteractionEnabled = false
        
        JRLServiceManager.reSendEmailOTP(["state_token": stateToken]) { [weak self] (data, error) in
            
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.isUserInteractionEnabled = true
                
                if let responseData = data,
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
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.showMoveBackErrorAlert(with: msg)
                        
                    case LOGINRCkeys.otpLimitReach:
                        if let messsage = responseData[LOGINWSKeys.kMesssage] as? String{
                            weakSelf.updateView(forState : .resendEnabled)
                            weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                            weakSelf.otpTextField.resetUI()
                            weakSelf.enteredOTP = nil
                        }
                        
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
                    weakSelf.updateView(forState : .resendEnabled)
                    weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    
                } else {
                    let msg = JRLoginConstants.generic_error_message
                    weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    weakSelf.updateView(forState : .resendEnabled)
                }
            }
        }
    }
    
    func verifyOTP(_ params: [String: String]) {
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        JRLServiceManager.validateEmailOTP(params) {[weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                self?.loadingIndicatorView.isHidden = true
                self?.view.isUserInteractionEnabled = true
                if error != nil {
                    if let message = error?.localizedDescription {
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                    } else {
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                    }
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                    })
                    return
                }
                
                guard let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else {
                    return
                }
                if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String, !stateToken.isEmpty {
                    self?.dataModel?.stateToken = stateToken
                    //self?.delegate?.updateStateToken(stateToken)
                }
                switch responseCode {
                case "403":
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                            weakSelf.otpTextField.resetUI()
                            weakSelf.enteredOTP = nil
                        }
                    })
                case LOGINRCkeys.success:
                    weakSelf.dataModel?.otpTextCount = nil
                    if let state = responseData["state"] as? String, let dataModel = weakSelf.dataModel {
                        let dataModel = dataModel
                        dataModel.stateToken = state
                        dataModel.otpTextCount = 6
                        let vc = JRLNewMobileNoVC.controller(dataModel)
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                        return
                    }
                case LOGINRCkeys.unprocessableEntity:
                        weakSelf.navigationController!.popToRootViewController(animated: true)
                    break
                default:
                    DispatchQueue.main.async {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                            if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                                weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                                weakSelf.otpTextField.resetUI()
                                weakSelf.enteredOTP = nil
                            }
                        })
                    }
                }
            }
        }
    }
    
    private func verifyUpdatedEmailOTP(_ params: [String: String]) {
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        JRLServiceManager.verifyUpdatedEmailOTP(params) { [weak self] (data, error) in
            
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                
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
                    weakSelf.otpTextField.resetUI()
                    weakSelf.enteredOTP = nil
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
                    //weakSelf.delegate?.updateStateToken(stateToken)
                }
                switch responseCode {
                case LOGINRCkeys.success:
                    weakSelf.dataModel?.otpTextCount = nil
                    weakSelf.showEmailUpdatedAlert()
                    NotificationCenter.default.post(name: NSNotification.Name(rawValue: "refresh_home_widgets"), object: nil)
                    
                case LOGINRCkeys.invalidPublicKey:
                    if let model = weakSelf.dataModel, let phoneNumber = model.loginId {
                        AuthRSAGenerator.shared.removeSavedKeyPair(for: phoneNumber)
                    } else {
                        AuthRSAGenerator.shared.removeAllSavedKeyPair()
                    }
                    let msg = JRLoginConstants.generic_error_message
                    weakSelf.showMoveBackErrorAlert(with: msg)
                    
                case LOGINRCkeys.badRequest:
                    let msg = JRLoginConstants.generic_error_message
                    weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    weakSelf.otpTextField.resetUI()
                    weakSelf.enteredOTP = nil
                    
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
                    if let dataModel = weakSelf.dataModel, dataModel.isFromUpdateEmail {
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.showMoveBackErrorAlert(with: msg)
                    } else {
                        weakSelf.navigationController?.popViewController(animated: true)
                    }
                    
                case LOGINRCkeys.otpLimitReach:
                    if let messsage = responseData[LOGINWSKeys.kMesssage] as? String {
                        if let dataModel = weakSelf.dataModel, dataModel.isFromUpdateEmail {
                            weakSelf.showMoveBackErrorAlert(with: messsage)
                        } else {
                            weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                        }
                    } else {
                        let msg = JRLoginConstants.generic_error_message
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    }
                    
                default:
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
    
    private func showEmailUpdatedAlert() {
        let messsage: String
        if let email = LoginAuth.sharedInstance().getEmail(), !email.isEmpty {
            messsage = "jr_login_email_updated".localized
        } else {
            messsage = "jr_login_email_added".localized
        }
        let alert = UIAlertController(title: "", message: messsage, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_ac_OK".localized, style: .default) { [weak self] _ in
            if let weakSelf = self {
                LoginAuth.sharedInstance().setEmail(weakSelf.email)
                NotificationCenter.default.post(name: NSNotification.Name.JRDidUserProfileUpdate, object: nil)
                weakSelf.navigationController?.popViewController(animated: true)
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func showMoveBackErrorAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_ac_OK".localized, style: .default) { [weak self] _ in
            self?.popAccordingToFlow()
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
        totalTime = smsOTPTime
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

extension JRPUEmailOtpVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
    }
}
