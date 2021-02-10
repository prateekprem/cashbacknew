//
//  JRPUSmsOtpVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 03/04/20.
//

import UIKit

class JRPUSmsOtpVC: JRLIssuesSelectionVC {
    @IBOutlet var backBtn: UIButton!
    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var messageLbl: UILabel!
    @IBOutlet var otpTextField: JRLOTPTextFieldView!
    @IBOutlet var resendSmsButton: UIButton!
    @IBOutlet var resendOTPLabel: UILabel!
    @IBOutlet var progressView: JRChatOnboardingSpinnerView!
    @IBOutlet weak var proceedButton: UIButton!
    @IBOutlet weak var otpOnEmailBtn: UIButton!
    
    private var enteredOTP: String?
    
    private var countdownTimer: Timer!
    private var messageView = UIView()
    private var label = UILabel()
    
    var message : String?
    var mobileNo : String = ""
    
    
    private var totalTime : Int = 30
    private var smsOTPTime : Int = 20
    
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    @IBOutlet weak var emailLoadingIndicatorView: JRLoadingIndicatorView!
    
    @IBOutlet weak var indicatorContraint: NSLayoutConstraint!
    @IBOutlet weak var btnConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewConstraint: NSLayoutConstraint!
    
    //MARK:-Instance
    static func getJRPUSmsOtpVC(_ dataModel: JRLOtpPsdVerifyModel) -> JRPUSmsOtpVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRPUSmsOtpVC") as! JRPUSmsOtpVC
        vc.dataModel = dataModel
        return vc
    }
    
    override func viewDidLoad() {
        super.dataModel?.isLoginFlow = true
        super.viewDidLoad()
        if let digitText:String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("authOtpTimer"), let val = Int(digitText) {
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
        emailLoadingIndicatorView.isHidden = true
        otpOnEmailBtn.isHidden = false

    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dataModel = dataModel, let otpTextCount = dataModel.otpTextCount  {
            otpTextField.setUpUI(count: otpTextCount, borderStyle: UITextField.BorderStyle.none, isSecureTextEntry: true)
            otpTextField.setTextFieldFirstResponder(index: 0)
            otpTextField.resetUI()
            enteredOTP = nil
        }
    }
    
    deinit {
        endTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func initilize() {
        if self.deviceHeight < 667.0 {
            indicatorContraint.constant = 25.0
            btnConstraint.constant = 25.0
            viewConstraint.constant = 25.0
        } else{
            indicatorContraint.constant = 43.0
            btnConstraint.constant = 43.0
            viewConstraint.constant = 49.0
        }
        
        if let _ = dataModel?.loginType, var mobileNumber = dataModel?.loginId {
            if mobileNumber.count > 5{
                mobileNumber = mobileNumber.insert(seperator: " ", interval: 5)
            }
            titleLbl.text = String.init(format: "jr_login_verify_your_registered_mobile_number".localized, mobileNumber)
        }
        otpTextField.delegate = self
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
    
    @IBAction func backBtnAction(_ sender: Any) {
        navigationController?.popToRootViewController(animated: true)
    }
    
    @IBAction func onResendSMSBtnTouch(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }

        resendOTP()
    }
    
    @IBAction func onEmailBtnTouch(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        
        if let ldatamodel = dataModel{
            if ldatamodel.isLoginFlow{
                //Logged in
                if isEmailOTPLoginEnabled(), let _ = LoginAuth.sharedInstance().getEmail(){
                    sendEmailOTP()
                }
                else{
                    invokeVerifierAPI()
                }
            }else{
                //Logged out
                if isEmailOTPLogoutEnabled(){
                    sendEmailOTP()
                }
                else{
                    invokeVerifierAPI()
                }
            }
        }
        else{
            //Open CST
            var loginId = ""
            if let ldataModel = dataModel, let id = ldataModel.loginId{
                loginId = id
            }
            JRLoginUI.sharedInstance().delegate?.openLoginIssues(loginId, self)
        }
        
    }
    
    @IBAction func proceedButtonTapped() {
        guard self.isNetworkReachable() else { return }

        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let otpTextCount = dataModel.otpTextCount else {
            return
        }
        
        if let otp = enteredOTP, otp.length == otpTextCount {
            let params: [String: String] = [LOGINWSKeys.kOTP: otp, "state_token": stateToken]
            verifyOTP(params)
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
    
    func resendOTP(){
        guard let dataModel = dataModel, let loginId = dataModel.loginId else {
            otpTextField.setTextFieldFirstResponder(index: 0)
            otpTextField.resetUI()
            enteredOTP = nil
            return
        }
    
        updateView(forState : .responseAwaited)
        view.isUserInteractionEnabled = false
        let params: [String: String] = ["loginId": loginId, "actionType": "UPDATE_PHONE"]
        JRLServiceManager.updatePhoneOTPViaProfile(params) {[weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            
            DispatchQueue.main.async {
                self?.otpTextField.setTextFieldFirstResponder(index: 0)
                weakSelf.view.isUserInteractionEnabled = true
                if let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    switch responseCode {
                    case LOGINRCkeys.success:
                        weakSelf.updateView(forState : .cooldownTime)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.showMessageView(withAnimation: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            // your code here
                            weakSelf.hideMessageView(withAnimation: true)
                        }
                        self?.setMessage(message:"jr_login_otp_sent_successfully".localized)
                    case "3006":
                        weakSelf.navigationController?.popToRootViewController(animated: true)
                        break
                    case "708":
                        if let messsage = responseData[LOGINWSKeys.kMesssage] as? String{
                            weakSelf.updateView(forState : .resendEnabled)
                            weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                            weakSelf.otpTextField.setTextFieldFirstResponder(index: 0)
                            weakSelf.otpTextField.resetUI()
                            weakSelf.enteredOTP = nil
                        }
                        break
                    default:
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextField.setTextFieldFirstResponder(index: 0)
                        weakSelf.otpTextField.resetUI()
                        weakSelf.enteredOTP = nil
                        break
                    }
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

extension JRPUSmsOtpVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
    }
}
