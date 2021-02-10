//
//  JRLForgotPwdVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 17/02/20.
//

import UIKit
import CoreTelephony

class JRLForgotPwdVC: JRAuthBaseVC, UITextFieldDelegate, UITextViewDelegate {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var forgotPwdLbl: UILabel!
    @IBOutlet weak var subtitleLbl: UILabel!
    @IBOutlet weak var mobileNoPlaceholder: UILabel!
    @IBOutlet weak var countryCodeLbl: UILabel!
    @IBOutlet weak var mobileNumberTxtField: UITextField!
    @IBOutlet weak var separatorView: UIView!
    @IBOutlet weak var proceedSecurelyBtn: UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var messageLbl: UILabel!
    //view
    @IBOutlet weak var baseView1: UIView!
    @IBOutlet weak var subView: UIView!
    @IBOutlet weak var resetPwdOnCallLbl: UILabel!
    @IBOutlet weak var callMessageLbl: UILabel!
    @IBOutlet weak var importantLbl: UILabel!
    @IBOutlet weak var messageLbl1: UILabel!
    @IBOutlet weak var actionBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    
    @IBOutlet weak var otpLimitView: UIView!
    @IBOutlet weak var otpLimitLbl: UILabel!
    @IBOutlet weak var otpCallView: UIView!
    @IBOutlet weak var phoneIcon: UIImageView!
    @IBOutlet weak var resetPwdOnCalLbl: UILabel!
    @IBOutlet weak var callBtn: UIButton!
    
    @IBOutlet weak var otpLimitImgView: UIImageView!
    @IBOutlet weak var otpLimitMsgLbl: UILabel!
    
    private let vModel = JRAuthSignInVM()
    
    var prefilledMobileNo = ""
    var isNewNumber: Bool = false
    
    @IBAction func onCallBtnTouched(_ sender: UIButton) {
        bringView(true)
    }
    
    @IBAction func onCallActionBtnTouched(_ sender: UIButton) {
        var callNumber = ""
        if let value : String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("key_forgot_password_ivr") {
            callNumber = value
        }
        let trimmedNumber = callNumber.components(separatedBy: .whitespaces).joined()
        if let phoneCallURL:URL = URL(string: "tel://\(trimmedNumber)") {
            let application:UIApplication = UIApplication.shared
            if (application.canOpenURL(phoneCallURL)) {
                JRLoginGACall.forgotPwdIVRTapped(carrier: carrierName())
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
    
    class var newInstance: JRLForgotPwdVC {
        let vc = UIStoryboard.init(name: "JRLForgotPwdStory", bundle: JRAuthManager.kAuthBundle).instantiateViewController(withIdentifier: "JRLForgotPwdVC") as! JRLForgotPwdVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTermsAndConditionTextView()
        
        var callNumber = ""
        if let value : String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("key_forgot_password_ivr") {
            callNumber = value
            callNumber = callNumber.replacingOccurrences(of: "-", with: "", options: NSString.CompareOptions.literal, range:nil)
            callNumber = callNumber.insert(seperator: " ", interval: 4)

        }
        actionBtn.setTitle("Call " + callNumber, for: .normal)
        JRLoginGACall.forgotPwdLoaded()
    }
    
    private func setupUI() {
        self.view.dismissKeyboardOnTap()
        mobileNumberTxtField.attributedPlaceholder = NSAttributedString(string: "jr_login_mobile_number".localized,
        attributes: [NSAttributedString.Key.foregroundColor: UIColor(red: 139/255.0, green: 166/255.0, blue: 193/255.0, alpha: 1.0)])
        //Setup Loader
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = UIColor(red: 241/255.0, green: 252/255.0, blue: 255/255.0, alpha: 1.0)
        
        if prefilledMobileNo.count > 5{
            self.mobileNumberTxtField.text = prefilledMobileNo.insert(" ", ind: 5)
        }else if let loginId = UserDefaults.standard.string(forKey: "prefilledLoginId"), loginId.count > 5 {
            self.mobileNumberTxtField.text = loginId.insert(" ", ind: 5)
        }
        
        if let text = mobileNumberTxtField.text, text.isEmpty{
            self.countryCodeLbl.textColor = UIColor(red: 139/255.0, green: 166/255.0, blue: 193/255.0, alpha: 1.0)
            self.mobileNoPlaceholder.alpha = 0.0
            proceedSecurelyBtn.alpha = 0.5
        }
        else{
            self.countryCodeLbl.textColor = LOGINCOLOR.darkGray
            self.mobileNoPlaceholder.alpha = 1.0
            proceedSecurelyBtn.alpha = 1.0
        }
        let rect = CGRect.init(x: subView.bounds.origin.x, y: subView.bounds.origin.y, width: self.view.frame.size.width, height: subView.bounds.size.height)
        let maskPath = UIBezierPath(roundedRect: rect,
                                    byRoundingCorners: [.topLeft, .topRight],
                                    cornerRadii: CGSize(width: 12.0, height: 12.0))
        let shape = CAShapeLayer()
        shape.path = maskPath.cgPath
        subView.layer.mask = shape
        showOTPLimitReachedView(false)
        hideView(false)
        
        if self.deviceHeight < 667.0 {
            callMessageLbl.font = UIFont.init(name: callMessageLbl.font.fontName, size: 12)
            subtitleLbl.font = UIFont.init(name: callMessageLbl.font.fontName, size: 12)
        }else{
            
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingIndicatorView.isHidden = true
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
    }
    
    // view methods
    private func bringView(_ animated:Bool){
        JRLoginGACall.forgotPwdIVRLoaded()
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.baseView1.backgroundColor = UIColor.clear
        self.baseView1.frame.origin.y = self.baseView1.frame.size.height
        self.baseView1.isHidden = false
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.baseView1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
            self.baseView1.backgroundColor = UIColor.clear
            self.baseView1.frame.origin.y = 0
        }, completion: { _ in
            self.baseView1.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
            self.baseView1.frame.origin.y = 0
        })
    }
    
    private func hideView(_ animated:Bool){
        var duration = 0.0
        if animated{
            duration = 0.3
        }
        self.baseView1.frame.origin.y = 0
        self.baseView1.backgroundColor = UIColor.clear
        UIView.animate(withDuration: duration, delay: 0.0, options: [.curveEaseOut], animations: {
            self.baseView1.frame.origin.y = self.baseView1.frame.size.height
        }, completion: { _ in
            self.baseView1.isHidden = true
            self.baseView1.frame.origin.y = self.baseView1.frame.size.height
        })
    }
    
    func setAuth(type: JarvisLoginType) {
        vModel.setAuth(type: type)
    }
    
    private func configureTermsAndConditionTextView() {
        let param = self.getTermsAndConditionText()
        self.messageLbl.attributedText = JRLHelper.getAttributedString(param.0, param.1)
        self.messageLbl.adjustsFontSizeToFitWidth = true
    }
    
    @IBAction func onBackBtnTouch(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onProceedSecurleyBtnTouched(_ sender: UIButton) {
        //Handle empty Text Field Condition
        if let text = mobileNumberTxtField.text, text.isEmpty{
            let animation = CABasicAnimation(keyPath: "position")
            animation.duration = 0.07
            animation.repeatCount = 2
            animation.autoreverses = true
            animation.fromValue = NSValue(cgPoint: CGPoint(x: self.mobileNumberTxtField.center.x - 5, y: self.mobileNumberTxtField.center.y))
            animation.toValue = NSValue(cgPoint: CGPoint(x: self.mobileNumberTxtField.center.x + 5, y: self.mobileNumberTxtField.center.y))
            self.mobileNumberTxtField.layer.add(animation, forKey: "position")
            return
        }
        let touple = self.vModel.isInputValid(text: getNumberWithoutSpace(self.mobileNumberTxtField.text))
        if touple.valid {
                self.getProceed()
        } else {
            JRLoginGACall.forgotPwdSaveClicked(mobStatus(), touple.errorMsg ?? "", LOGINGAKeys.kLabelApp, "")
            self.showError(text: touple.errorMsg)
        }
    }
    
    @IBAction func tncTapped(_ sender: UITapGestureRecognizer) {
        guard self.isNetworkReachable() else { return }
        tNCPrivacyPolicyTapped(self.vModel.authType, sender: sender, messageLabel: messageLbl)
    }
    @IBAction func onTextFieldChnage(_ sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if let text = sender.text, !text.isEmpty{
                self.proceedSecurelyBtn.alpha = 1.0
                self.mobileNoPlaceholder.alpha = 1.0
                self.countryCodeLbl.textColor = LOGINCOLOR.darkGray
                
            } else {
                self.proceedSecurelyBtn.alpha = 0.5
                self.mobileNoPlaceholder.alpha = 0.0
                self.countryCodeLbl.textColor = UIColor(red: 139/255.0, green: 166/255.0, blue: 193/255.0, alpha: 1.0)
            }
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if self.vModel.authType == .mobile {
        } else {
        }
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Validate mobile number while editing
        showOTPLimitReachedView(false)
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: self.vModel.authType.txtFldType, text: getNumberWithoutSpace(changedString))
        
        if !isValid {return false}
        
        if let ltext = textField.text , ltext.count == 7, string.isEmpty {
            textField.text = String(textField.text!.dropLast())
            return true
        }
        
        let text = NSString(string: textField.text ?? "").replacingCharacters(in: range, with: string).replacingOccurrences(of: " ", with: "")
        
        if text.count >= 5 && text.count <= 10 {
            var newString = ""
            for i in stride(from: 0, to: text.count, by: 5) {
                let upperBoundIndex = i + 5
                let lowerBound = String.Index.init(utf16Offset: i, in: text)
                let upperBound = String.Index.init(utf16Offset: upperBoundIndex, in: text)
                if upperBoundIndex <= text.count  {
                    newString += String(text[lowerBound..<upperBound]) + " "
                    if newString.count > 11 {
                        newString = String(newString.dropLast())
                    }
                }
                else if i <= text.count {
                    newString += String(text[lowerBound...])
                }
            }
            if string.isEmpty && text.count == 5 {
                textField.text = String(textField.text!.dropLast().dropLast())
            } else {
                textField.text = newString
            }
            return false
        }
        if text.count > 10 {
            return false
        }
        return true
    }
    
    private func getNumberWithoutSpace(_ numberString: String?) -> String{
        guard let text = numberString else { return ""}
        return text.replacingOccurrences(of: " ", with: "")
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        let (isValid, _) = JRLoginTextFieldValidation.validateTextForTextFieldType(textFieldType: self.vModel.authType.txtFldType, text: getNumberWithoutSpace(self.mobileNumberTxtField.text))
        if isValid {
            switch self.vModel.authType {
            case .mobile:
                break
            case .email, .newAccount:
                break
            }
        }
    }
    
    private func getProceed() {
        guard self.isNetworkReachable() else { return }
        self.view.endEditing(true)
        navigationController?.popToRootViewController(animated: true)
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        let mobileNumber = getNumberWithoutSpace(self.mobileNumberTxtField.text)
        isNewNumber = mobileNumber == prefilledMobileNo
        forgotPassword(forMobileNumber : mobileNumber, loginType: self.vModel.authType)
    }
    
    private func forgotPassword(forMobileNumber mobileNumber : String, loginType: JarvisLoginType) {
        JRLServiceManager.invokeForgotPwd(forMobileNumber: mobileNumber , [:]) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.loadingIndicatorView.isHidden = true
                if error != nil {
                    var msg = JRLoginConstants.generic_error_message
                    if let message = error?.localizedDescription {
                        msg = message
                    }
                    
                    var errCode = ""
                    if let eCode = (error as NSError?)?.code{
                        errCode = String(eCode)
                    }
                    JRLoginGACall.forgotPwdSaveClicked(weakSelf.mobStatus(), msg, LOGINGAKeys.kLabelAPI, errCode)
                    weakSelf.view.showToast(toastMessage: msg, duration: 3.0, yPosition: weakSelf.proceedSecurelyBtn.frame.maxY)
                    return
                }
                
                if let responseData = data, let status = responseData["status"] as? String, status == "SUCCESS", let responseCode = responseData["responseCode"] as? String, responseCode == "01", let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                    let dataModel = JRLOtpPsdVerifyModel(loginId: mobileNumber, stateToken: stateToken, otpTextCount: 6, loginType: .mobile)
                    let vc = JRLForgotPwdOTPVC.controller(dataModel)
                    JRLoginGACall.forgotPwdSaveClicked(weakSelf.mobStatus(), "", "", "")
                    weakSelf.navigationController?.pushViewController(vc, animated: false)
                }else if let responseData = data, let status = responseData["status"] as? String, status == "FAILURE", let responseCode = responseData["responseCode"] as? String, responseCode == "708"{
                    JRLoginGACall.forgotPwdSaveClicked(weakSelf.mobStatus(), "jr_login_reached_max_limit_for_requesting_otp".localized, LOGINGAKeys.kLabelAPI, "708")
                    weakSelf.showOTPLimitReachedView(true)
                }
                else if let responseData = data, let status = responseData["status"] as? String, status == "SUCCESS", let responseCode = responseData["responseCode"] as? String, responseCode == "FP_115"{
                    JRLoginGACall.forgotPwdSaveClicked(weakSelf.mobStatus(), "","", "")
                    weakSelf.bringView(true)
                }
                else {
                    var message = JRLoginConstants.generic_error_message
                    if let msg = data?["message"] as? String{
                        message = msg
                    }
                    var code = ""
                    if let responseData = data, let responseCode = responseData["responseCode"] as? String{
                        code = responseCode
                    }
                    
                    weakSelf.view.showToast(toastMessage: message, duration: 3.0, yPosition: weakSelf.proceedSecurelyBtn.frame.maxY)
                    JRLoginGACall.forgotPwdSaveClicked(weakSelf.mobStatus(), message,LOGINGAKeys.kLabelAPI, code)

                }
            }
        }
    }
    
    private func mobStatus() -> String{
        return isNewNumber ? LOGINGAKeys.ksameMobileNumber : LOGINGAKeys.kdiffMobileNumber
    }
    
    private func carrierName() -> String {
        let networkInfo: CTTelephonyNetworkInfo = CTTelephonyNetworkInfo()
        let carrier: CTCarrier? = networkInfo.subscriberCellularProvider
        return carrier?.carrierName ?? ""
    }
}
