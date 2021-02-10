//
//  JRLForgotPwdOTPVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 17/02/20.
//

import UIKit

struct JRLUnblockModel {
    var verifyId: String
    var method: String?
    var stateToken: String
    var phoneNumber: String
    var fallbackVC: UIViewController?
}

class JRLForgotPwdOTPVC: JRAuthBaseVC {
    
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var otpPlaceholderLbl: UILabel!
    @IBOutlet weak var otpTextFieldView: JRLOTPTextFieldView!
    
    @IBOutlet weak var otpTimerLbl: UILabel!
    @IBOutlet weak var loader: JRChatOnboardingSpinnerView!
    @IBOutlet weak var resendOtpBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    
    
    var dataModel: JRLOtpPsdVerifyModel?
    private var enteredOTP: String?
    weak var delegate: JRLOTPVCDelegate?
    private var countdownTimer: Timer!
    private var totalTime : Int = 20
    private var smsOTPTime : Int = 20
    private var messageView = UIView()
    private var label = UILabel()
    private let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    var otpLimitReachedMessage = ""
    
    // DIY Unblock
    var unblockModel: JRLUnblockModel?
    
    //view
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var resetPwdOnCallLbl: UILabel!
    @IBOutlet weak var callMessageLbl: UILabel!
    @IBOutlet weak var importantLbl: UILabel!
    @IBOutlet weak var messageLbl: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var titleLabelTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var subtitleLblTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otpTextFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var otpMsgLblTopConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var otpLimitImgView: UIImageView!
    @IBOutlet weak var otpLimitMsgLbl: UILabel!
    
    @IBOutlet weak var otpLimitView: UIView!
    @IBOutlet weak var otpLimitLbl: UILabel!
    @IBOutlet weak var otpCallView: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var resetPwdOnCalLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    
    
    @IBAction func onCallBtnTouched(_ sender: UIButton) {
        bringView(true)
    }
    //actions
    @IBAction func onBackBtnTouched(_ sender: UIButton) {
        endTimer()
        guard unblockModel == nil else {
            handleBackBtnUnblock()
            return
        }
        for controller in self.navigationController!.viewControllers as Array {
            if controller.isKind(of: JRLForgotPwdVC.self) {
                self.navigationController!.popToViewController(controller, animated: true)
                break
            }
        }
    }
    
    @IBAction func onResendOTPBtnTouched(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        setResignFirstResponder()
        JRLoginGACall.forgotPwdResendOtp()
        if otpLimitReachedMessage.length > 0  {
            self.updateView(forState : .resendEnabled)
            self.view.showToast(toastMessage: otpLimitReachedMessage, duration: 3.0)
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
            return
        }
        resendOTP()
    }
    
    private func updateView(forState state : ResendSMSState){
        resendOtpBtn.isHidden = true
        otpTimerLbl.isHidden = true
        loadingIndicatorView.isHidden = true
        switch state {
        case .resendEnabled:
            loader.stopSpinner()
            resendOtpBtn.isHidden = false
            break
        case .responseAwaited:
            //loadingIndicatorView.isHidden = false
            loader.startSpinner()
            break
        case .cooldownTime:
            loader.stopSpinner()
            startTimer()
            otpTimerLbl.isHidden = false
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
    
    @objc private func updateTime() {
        if totalTime < 2{
            otpTimerLbl.text =  String(format:"jr_login_otp_resend_sec".localized, totalTime)
        }else{
            otpTimerLbl.text =  String(format:"jr_login_otp_resend_secs".localized, totalTime)
        }
        
        if totalTime > 0 {
            totalTime -= 1
        } else {
            totalTime = 0
            endTimer()
            updateView(forState : .resendEnabled)
        }
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        guard unblockModel == nil else {
            invokeDoVerifyAPI()
            return
        }
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let otpTextCount = dataModel.otpTextCount else {
            return
        }
        
        if let otp = enteredOTP, otp.length == otpTextCount {
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }
            let params: [String: String] = [LOGINWSKeys.kOTP: otp, "state_token": stateToken]
            verifyOTP(params)
        } else {
            let msg = "jr_login_please_enter_valid_otp".localized
            JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, msg, LOGINGAKeys.kLabelApp, "")
            view.showToast(toastMessage: msg, duration: 3.0)
        }
    }
    
    func verifyOTP(_ params: [String: String]) {
    JRLServiceManager.validateEmailOTP(params) {[weak self] (data, error) in
        guard let weakSelf = self else {
            return
        }
        DispatchQueue.main.async {
            weakSelf.loadingIndicatorView.isHidden = true
            
            if let errVal = error?.getMsgWithCode(){
                JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, errVal.0, LOGINGAKeys.kLabelAPI, errVal.1)
                JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, errVal.0, LOGINGAKeys.kLabelAPI, errVal.1)
                weakSelf.view.showToast(toastMessage: errVal.0, duration: 3.0)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    weakSelf.otpTextFieldView.resetUI()
                    weakSelf.enteredOTP = nil
                })
                return
            }
            
            guard let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else {
                return
            }
            if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String, !stateToken.isEmpty {
                self?.dataModel?.stateToken = stateToken
                self?.delegate?.updateStateToken(stateToken)
            }
            switch responseCode {
            case "403":
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, message, LOGINGAKeys.kLabelAPI, "403")
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                    }
                })
            case LOGINRCkeys.success:
                weakSelf.dataModel?.otpTextCount = nil
                if let state = responseData["state"] as? String, let loginType = weakSelf.dataModel?.loginType {
                    if let mobileNumber = weakSelf.dataModel?.loginId{
                        JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, "", "", "")
                        let dataModel = JRLOtpPsdVerifyModel(loginId: mobileNumber, stateToken: state, otpTextCount: 6, loginType: loginType)
                        let vc = JRLSetForgotPwdVC.controller(dataModel)
                        weakSelf.navigationController?.pushViewController(vc, animated: true)
                    }
                    return
                }
            case LOGINRCkeys.unprocessableEntity:
                for controller in weakSelf.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRLForgotPwdVC.self) {
                        JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, "", LOGINGAKeys.kLabelAPI, LOGINRCkeys.unprocessableEntity)
                        weakSelf.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
                break
            default:
                DispatchQueue.main.async {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
                        let msg = JRLoginConstants.generic_error_message
                        JRLoginGACall.forgotPwdOTPClicked(LOGINGAKeys.kOtp, msg, LOGINGAKeys.kLabelAPI, responseCode)
                        weakSelf.view.showToast(toastMessage: msg, duration: 3.0)
                    })
                }
            }
        }
        }
    }
    
    //view actions
    @IBAction func onActionBtnTouched(_ sender: UIButton) {
        var callNumber = ""
        if let value : String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("key_forgot_password_ivr") {
            callNumber = value
        }
        let trimmedNumber = callNumber.components(separatedBy: .whitespaces).joined()
        if let phoneCallURL:URL = URL(string: "tel://\(trimmedNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
//                JRLoginGACall.forgotPwdCCNumberClicked()
                application.open(phoneCallURL, options: [:], completionHandler: nil)
            }
        }
    }
    
    @IBAction func onCloseBtnTouched(_ sender: UIButton) {
        hideView(true)
    }
    
    func showOTPLimitReachedView(_ flag: Bool){
        otpLimitImgView.isHidden = !flag
        otpLimitMsgLbl.isHidden = !flag
        otpLimitView.isHidden = !flag
    }
    
    func hideResendOTPViews(_ flag: Bool){
        otpTimerLbl.isHidden = flag
        loader.isHidden = flag
        resendOtpBtn.isHidden = flag
        loadingIndicatorView.isHidden = flag
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    class var newInstance: JRLForgotPwdOTPVC {
        let vc = UIStoryboard.init(name: "JRLForgotPwdStory", bundle: JRAuthManager.kAuthBundle).instantiateViewController(withIdentifier: "JRLForgotPwdOTPVC") as! JRLForgotPwdOTPVC
        return vc
    }
    
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLForgotPwdOTPVC {
        let vc = UIStoryboard.init(name: "JRLForgotPwdStory", bundle: JRAuthManager.kAuthBundle).instantiateViewController(withIdentifier: "JRLForgotPwdOTPVC") as! JRLForgotPwdOTPVC
        vc.dataModel = dataModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if let digitText:String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("authOtpTimer"), let val = Int(digitText) {
            smsOTPTime = val
        }
        initilize()
        configureMessageView()
        updateView(forState: .cooldownTime)
        self.showMessageView(withAnimation: true)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.hideMessageView(withAnimation: true)
        }
        JRLoginGACall.forgotPwdOtpLoaded()
        var callNumber = ""
        if let value : String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("key_forgot_password_ivr") {
            callNumber = value
            callNumber = callNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
            callNumber = callNumber.insert(seperator: " ", interval: 4)
        }
        actionBtn.setTitle("Call " + callNumber, for: .normal)
    }
    
    private func initilize() {
        self.view.dismissKeyboardOnTap()
        if let _ = dataModel?.loginType, var mobileNumber = dataModel?.loginId {
            if mobileNumber.count > 5{
                mobileNumber = mobileNumber.insert(seperator: " ", interval: 5)
            }
            if let model = unblockModel {
                subtitleLbl.text = "Verify OTP sent to " + model.phoneNumber
                confirmBtn.setTitle("Proceed", for: .normal)
            } else {
                let verifyStr = String.init(format: "jr_login_verify_your_new_mobile_no_to_set_new_password".localized, mobileNumber)
                subtitleLbl.text = verifyStr
                confirmBtn.setTitle("jr_login_confirm".localized, for: .normal)
            }
        }
        
        otpTextFieldView.delegate = self
        loadingIndicatorView.isHidden = true
        NotificationCenter.default.addObserver(self, selector: #selector(setFirstResponder), name: UIApplication.didBecomeActiveNotification, object: nil)
        
        //Small Device handling
        if self.deviceHeight < 667.0 {
            titleLabelTopConstraint.constant = 1.0
            subtitleLblTopConstraint.constant = 1.0
            otpTextFieldTopConstraint.constant = 24.0
            otpMsgLblTopConstraint.constant = 5.0
        }
        else{
            titleLabelTopConstraint.constant = 19.0
            subtitleLblTopConstraint.constant = 7.0
            otpTextFieldTopConstraint.constant = 64.0
            otpMsgLblTopConstraint.constant = 45.0
        }
        showOTPLimitReachedView(false)
        let maskPath = UIBezierPath(roundedRect: subView.bounds,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        subView.layer.mask = shape
        hideView(false)
    }
    
    private func configureMessageView(){
        messageView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.width, height: 32)
        messageView.backgroundColor = UIColor(red: 33/255.0, green: 193/255.0, blue: 122/255.0, alpha: 1.0)
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let dataModel = dataModel, let otpTextCount = dataModel.otpTextCount  {
            otpTextFieldView.setUpUI(count: otpTextCount, borderStyle: UITextField.BorderStyle.none, isSecureTextEntry: true)
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
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
        
        otpTextFieldView.setTextFieldFirstResponder(index: index)
    }
    
    @objc private func setResignFirstResponder() {
        //self.otpTextFieldView.endEditing(true)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.loadingIndicatorView?.isHidden = true
    }
    
    deinit {
        endTimer()
        NotificationCenter.default.removeObserver(self)
    }
    
    private func endTimer() {
        if countdownTimer != nil {
            countdownTimer.invalidate()
            countdownTimer = nil
        }
    }
    
    // view methods
    private func bringView(_ animated:Bool){
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.baseView.backgroundColor = UIColor.clear
        self.baseView.frame.origin.y = self.baseView.frame.size.height
        self.baseView.isHidden = false
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.baseView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
            self.baseView.backgroundColor = UIColor.clear
            self.baseView.frame.origin.y = 0
        }, completion: { _ in
            self.baseView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
            self.baseView.frame.origin.y = 0
        })
    }
    
    private func hideView(_ animated:Bool){
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.baseView.frame.origin.y = 0
        self.baseView.backgroundColor = UIColor.clear
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.baseView.frame.origin.y = self.baseView.frame.size.height
        }, completion: { _ in
            self.baseView.frame.origin.y = self.baseView.frame.size.height
            self.baseView.isHidden = true
        })
    }
    
    func resendOTP(){
        guard let dataModel = dataModel, let _ = dataModel.stateToken else {
            otpTextFieldView.setTextFieldFirstResponder(index: 0)
            otpTextFieldView.resetUI()
            enteredOTP = nil
            return
        }
        
        updateView(forState : .responseAwaited)
        
        guard unblockModel == nil else {
            invokeDoViewAPIResend()
            return
        }
        
        view.isUserInteractionEnabled = false
        
        
        if let mobileNumber = dataModel.loginId{
            JRLServiceManager.invokeForgotPwd(forMobileNumber: mobileNumber , [:]) { [weak self] (data, error) in
                guard let weakSelf = self else {
                    return
                }
                DispatchQueue.main.async {
                    weakSelf.view.isUserInteractionEnabled = true
                    if error != nil {
                        if let message = error?.localizedDescription {
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        } else {
                            weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                        }
                        return
                    }
                    
                    if let responseData = data, let status = responseData["status"] as? String, status == "SUCCESS", let responseCode = responseData["responseCode"] as? String, responseCode == "01", let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                        weakSelf.updateView(forState : .cooldownTime)
                        weakSelf.dataModel?.stateToken = stateToken
                        weakSelf.delegate?.updateStateToken(stateToken)
                        weakSelf.otpTextFieldView.resetUI()
                        //weakSelf.view.showToast(toastMessage: "jr_login_otp_send_successfully".localized, duration: 3.0)
                        weakSelf.showMessageView(withAnimation: true)
                        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                            // your code here
                            weakSelf.hideMessageView(withAnimation: true)
                        }
                        self?.setMessage(message:"jr_login_otp_sent_successfully".localized)
                    }else if let responseData = data, let status = responseData["status"] as? String, status == "FAILURE", let responseCode = responseData["responseCode"] as? String, responseCode == "708", let _ = responseData[LOGINWSKeys.kMesssage] as? String{
                        /*
                        weakSelf.otpLimitReachedMessage = messsage
                        weakSelf.updateView(forState : .resendEnabled).¯¯
                        weakSelf.view.showToast(toastMessage: messsage, duration: 3.0)
                        weakSelf.otpTextFieldView.setTextFieldFirstResponder(index: 0)
                        weakSelf.otpTextFieldView.resetUI()
                        weakSelf.enteredOTP = nil
 */
                        weakSelf.showOTPLimitReachedView(true)
                        weakSelf.hideResendOTPViews(true)
                    }
                    else if let responseData = data, let status = responseData["status"] as? String, status == "FAILURE", let responseCode = responseData["responseCode"] as? String, responseCode == "FP_115"{
                        weakSelf.bringView(true)
                    }
                    else {
                        weakSelf.updateView(forState : .resendEnabled)
                        weakSelf.otpTextFieldView.setTextFieldFirstResponder(index: 0)
                        weakSelf.otpTextFieldView.resetUI()
                        weakSelf.enteredOTP = nil
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)

                    }
                }
            }
        }
    }
}

extension JRLForgotPwdOTPVC: JRLOTPTextFieldViewDelegate {
    func didEnterOTP(otp: String) {
        enteredOTP = otp
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
        
    }
}

extension JRLForgotPwdOTPVC {
    private func handleBackBtnUnblock() {
        if let fallbackVC = unblockModel?.fallbackVC {
            navigationController?.popToViewController(fallbackVC, animated: true)
        } else {
            navigationController?.popToRootViewController(animated: true)
        }
    }
    
    private func invokeDoViewAPIResend() {
        guard let model = unblockModel else { return }
        
        view.isUserInteractionEnabled = false
        let params: [String:String] = [
            "verifyId" : model.verifyId,
            "method" : "OTP_SMS"
        ]
        
        dataModel?.invokeDoViewOTP(params, completion: { [weak self] (success, error, responseCode, oauthCode, verifyId, method) in
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                switch responseCode {
                case "SUCCESS":
                    weakSelf.unblockModel = JRLUnblockModel(verifyId: verifyId ?? "",
                                                      method: method ?? "",
                                                      stateToken: model.stateToken,
                                                      phoneNumber: model.phoneNumber,
                                                      fallbackVC: model.fallbackVC)
                    
                    weakSelf.updateView(forState : .cooldownTime)
                    weakSelf.otpTextFieldView.resetUI()
                    weakSelf.showMessageView(withAnimation: true)
                    DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                        weakSelf.hideMessageView(withAnimation: true)
                    }
                    self?.setMessage(message:"jr_login_otp_sent_successfully".localized)
                default:
                    weakSelf.showErrorPage()
                }
            }
        })
    }
    
    private func invokeDoViewAPI() {
        guard let model = unblockModel else { return }
        
        view.isUserInteractionEnabled = false
        let params: [String:String] = [
            "verifyId" : model.verifyId,
            "method" : "SAVED_CARD"
        ]
        
        dataModel?.invokeDoViewSMS(params) { [weak self] (success, error, responseCode, oauthCode, verifyId, cardNumber) in
            guard let weakSelf = self, let cardNumber = cardNumber else { return }
            
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                switch responseCode {
                case "SUCCESS":
                    let vc = JRSavedCardVC()
                    vc.unblockModel = JRLUnblockModel(verifyId: verifyId ?? "",
                                                      method: nil,
                                                      stateToken: model.stateToken,
                                                      phoneNumber: model.phoneNumber,
                                                      fallbackVC: model.fallbackVC)
                    vc.cardNumber = cardNumber
                    weakSelf.navigationController?.pushViewController(vc, animated: true)
                default:
                    weakSelf.showErrorPage()
                }
            }
        }
    }
    
    private func invokeDoVerifyAPI() {
        guard let model = unblockModel else { return }
        
        view.isUserInteractionEnabled = false
        let params: [String : Any] = [
            "verifyId" : model.verifyId,
            "method" : model.method ?? "",
            "validateData": "{\"data\":\"\(enteredOTP ?? "")\"}"
        ]
        
        dataModel?.invokeDoVerify(params) { [weak self] (success, error, responseCode, oauthCode) in
            self?.dataModel?.otpTextCount = nil
            guard let weakSelf = self else { return }
            
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                guard success else {
                    weakSelf.showErrorPage()
                    return
                }
                weakSelf.invokeDoViewAPI()
            }
        }
    }
    
    private func showErrorPage(type errorState: JRBlockUnblockState = .unblockError) {
        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: errorState, message: "")
        navigationController?.pushViewController(terminalScene, animated: true)
    }
}
