//
//  JRAuthSignInVC.swift
//  jarvis-auth-ios
//
//  Created by Prakash Jha on 06/12/19.
//

import UIKit
import jarvis_locale_ios

class JRAuthSignInVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak private var miniTtlLbl: UILabel!
    @IBOutlet weak private var ttLLbl: UILabel!
    @IBOutlet weak private var countryCodeLbl: UILabel!
    @IBOutlet weak private var tncLbl: UILabel!
    @IBOutlet weak private var msgLbl: UILabel!
    @IBOutlet weak private var subMsgLbl: UILabel!
    @IBOutlet weak private var mobileFld: UITextField!
    @IBOutlet weak private var proceedBtn: UIButton!
    @IBOutlet weak private var backBtn: UIButton!
    @IBOutlet weak private var skipBtn: UIButton!
    @IBOutlet weak private var forgotPwdLoginIssuesBtn: UIButton!
    @IBOutlet weak private var okBtn: UIButton!
    @IBOutlet weak private var mobileLineV: UIView!
    @IBOutlet weak private var messageView: UIView!
    @IBOutlet weak private var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak private var proceedBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak private var okBtnTrailingConstraint: NSLayoutConstraint!
    @IBAction func onOkBtnTouched(_ sender: UIButton) {
        hideMessageView(withAnimation: true)
    }
    
    let vModel = JRAuthSignInVM(screenType: .fullScreen)
    var messageYPos: CGFloat = 0.0
    var isSkipBtnEnabled: Bool = true
    var isBackBtnEnabled: Bool = true
    var gaEventLabel: String = LOGINGAKeys.kLabelLoginMobile
    
    //FOR CREATE ACCOUNT
    private func showMessageView(withAnimation:Bool){
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        self.messageView.isHidden = false
                        self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: 20, width: self.view.frame.size.width, height: 60)
            self.messageView.isHidden = false
        }
    }
    
    private func hideMessageView(withAnimation:Bool){
        UIView.animate(withDuration: withAnimation ? 0.3 : 0.0, delay: 0,
                       options: .curveEaseIn,
                       animations: {
                        () -> Void in
                        self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
        }) {
            (finished) -> Void in
            self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
            self.messageView.isHidden = true
        }
    }
    
    //MARK:- Instance
    class var newInstance: JRAuthSignInVC {
        let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRAuthSignInVC") as! JRAuthSignInVC
        vc.screenType = .fullScreen
        return vc
    }
    
    // MARK: - Life Cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureTermsAndConditionTextView()
        NotificationCenter.default.addObserver(self, selector: #selector(languageChanged), name: Notification.Name.init(LANGUAGE_CHANGE_NOTIFICATION), object: nil)
        okBtn.layer.borderColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        okBtn.layer.cornerRadius = 16
        okBtn.layer.borderWidth = 1.0
        
        if self.deviceHeight < 667.0 {
            msgLbl.font = UIFont.init(name: msgLbl.font.fontName, size: 12)
            okBtnTrailingConstraint.constant = 3
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
        
        if vModel.isNumberUpdated{
            if let loginId = UserDefaults.standard.string(forKey: "prefilledLoginId"), loginId.count > 5 {
                self.mobileFld.text = loginId.insert(" ", ind: 5)
            }
            vModel.isNumberUpdated = false
        }
        
        self.messageView.frame = CGRect.init(x: 0, y: -60, width: self.view.frame.size.width, height: 60)
        self.messageView.isHidden = true
        if vModel.isPasswordUpdated{
            showMessageView(withAnimation:true)
            vModel.isPasswordUpdated = false
        }
        
        self.vModel.checkCache()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JRLoginGACall.loginScreenLoaded(screenType, loginFlowType)
        if let submitBtnOrigin = self.proceedBtn.superview?.convert(proceedBtn.frame.origin, to: nil){
            messageYPos = submitBtnOrigin.y + proceedBtn.frame.size.height + 15
        }
        JRLoginUI.sharedInstance().delegate?.loginScreenDidAppear()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        self.loadingIndicatorView.isHidden = true
    }
    
    func setAuth(type: JarvisLoginType) {
        vModel.setAuth(type: type)
    }
}

// MARK: - IBActions
private extension JRAuthSignInVC {
    @IBAction func tncTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        
        if let sender = sender as? UITapGestureRecognizer {
            tNCPrivacyPolicyTapped(self.vModel.authType, sender: sender, messageLabel: tncLbl )
        }
    }
    
    @IBAction func langBtnTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.loginChangeLangClicked()
        handleBackbtn(pushToHome: vModel.goToHomeOnSkip)
        LoginAuth.sharedInstance().delegate?.updateLanguage(navigationController: self.navigationController)
    }
    
    @IBAction func backClicked(_ sender: UIButton) {
        self.view.endEditing(true)
        handleBackbtn(pushToHome: vModel.goToHomeOnSkip)
    }
    
    @IBAction func skipClicked(_ sender: UIButton) {
        JRLoginGACall.loginSkipBtnClicked()
        JRApplockHelper.sharedInstance.setVersionUserDefaults()
        handleBackbtn(pushToHome: vModel.goToHomeOnSkip)
    }
    
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.loginHelpMeClicked()
        var mob = getNumberWithoutSpace(self.mobileFld.text)
        if mob.isEmpty{
            mob = vModel.preFilledLoginId
        }
        JRLoginUI.sharedInstance().delegate?.openLoginIssues(mob, self)
    }
    
    @IBAction func proceedClicked(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        guard let len = mobileFld.text?.count, len > 10 else { return }
        
        let touple = self.vModel.isInputValid(text: getNumberWithoutSpace(self.mobileFld.text))
        if touple.valid {
            self.getProceed()
        } else if let msg =  touple.errorMsg {
            JRLoginGACall.loginProceedClicked(screenType, loginFlowType, el1: gaEventLabel, el2: msg, el3: LOGINGAKeys.kLabelApp)
            self.view.endEditing(true)
            view.showToast(toastMessage: msg, duration: 3.0, yPosition: messageYPos)
        }
    }
    
    @IBAction func numberTxtChnaged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if let text = sender.text, !text.isEmpty{
                self.countryCodeLbl.font = UIFont.boldSystemFont(ofSize: 20)
            } else {
                self.countryCodeLbl.font = UIFont.systemFont(ofSize: 20)
            }
        }
    }
}

// MARK :- UITextFieldDelegate
extension JRAuthSignInVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Validate mobile number while editing
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        if changedString.count > 10{
            self.proceedBtn.alpha = 1.0
            gaEventLabel = LOGINGAKeys.kLabelLoginMobile
            if textField.text?.count != 11{
                JRLoginGACall.loginMobileNumberEntered( screenType, loginFlowType)
            }
        }
        else{
            self.proceedBtn.alpha = 0.5
        }
        
        let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: self.vModel.authType.txtFldType, text: getNumberWithoutSpace(changedString))
        
        if !isValid {return false}
        
        if let ltext = textField.text , ltext.count == 7, string.isEmpty {
            if range.location == 6 {
                textField.text = String(textField.text!.dropLast())
                return true
            } else {
                let newStr = (textField.text! as NSString).replacingCharacters(in: range, with: string)
                textField.text = newStr.replacingOccurrences(of: " ", with: "") + " "
                setCursorPosition(textField, to: range.location)
                return false
            }
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
                setCursorPosition(textField, to: string.isEmpty ? range.location : (range.location == 5) ? range.location + 2 : range.location + 1)
            }
            return false
        }
        if text.count > 10 {
            return false
        }
        return true
    }
    
    private func setCursorPosition(_ textField: UITextField, to offset: Int) {
        if let newPosition = textField.position(from: textField.beginningOfDocument, offset: offset) {
            textField.selectedTextRange = textField.textRange(from: newPosition, to: newPosition)
        }
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    private func getNumberWithoutSpace(_ numberString: String?) -> String{
        guard let text = numberString else { return ""}
        return text.replacingOccurrences(of: " ", with: "")
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.proceedBtn.alpha = 0.5
        return true
    }
}

//MARK:- Private Methods
extension JRAuthSignInVC {
    
    private func getProceed() {
        guard self.isNetworkReachable() else { return }        
        self.view.endEditing(true)
        navigationController?.popToRootViewController(animated: true)
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        let mobileNumber = getNumberWithoutSpace(self.mobileFld.text)
        verify(mobileNumber: mobileNumber)
        
    }
    
    private func verify(mobileNumber: String){
        if let navControler = navigationController{
            vModel.verifyMobileNumber(mobileNumber, navigationController: navControler, GAEventLabel: gaEventLabel) {[weak self] (success, message) in
                if let weakSelf = self, !success{
                    DispatchQueue.main.async {
                        weakSelf.loadingIndicatorView.isHidden = true
                        if let msg = message, !msg.isEmpty{
                            weakSelf.view.showToast(toastMessage: msg , duration: 3.0, yPosition: weakSelf.messageYPos)
                        }
                    }
                }
            }
        }
    }
    
    private func configureTermsAndConditionTextView() {
        let param = self.getTermsAndConditionText()
        self.tncLbl.attributedText = JRLHelper.getAttributedString(param.0, param.1)
        self.tncLbl.adjustsFontSizeToFitWidth = true
    }
    
    private func setupUI(){
        self.view.dismissKeyboardOnTap()
        
        if vModel.preFilledLoginId.count > 5{
            self.mobileFld.text = vModel.preFilledLoginId.insert(" ", ind: 5)
        }
        
        if LoginAuth.sharedInstance().isSkipHiddenOnLoginScreen{
            skipBtn.isHidden = true
        }
        
        if LoginAuth.sharedInstance().isForgotPwdHiddenOnLoginScreen{
            forgotPwdLoginIssuesBtn.isHidden = true
        }
        
        mobileFld.attributedPlaceholder = NSAttributedString(string: "jr_login_mobile_number".localized, attributes: [
            .foregroundColor: LOGINCOLOR.textGray,
            .font: UIFont.systemFont(ofSize: 20.0)
        ])
        //Setup Skip Button
        if !self.isSkipBtnEnabled{
            skipBtn.isHidden = true
        }
        
        //Setup Back Button
        if !self.isBackBtnEnabled{
            backBtn.isHidden = true
        }
        
        //Setup Loader
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = LOGINCOLOR.lightBlueBG
        
        if let text = mobileFld.text, text.isEmpty{
            self.countryCodeLbl.font = UIFont.systemFont(ofSize: 20)
        }
        else{
            self.countryCodeLbl.font = UIFont.boldSystemFont(ofSize: 20)
        }
        
        if let text = mobileFld.text, text.count == 11{
            self.proceedBtn.alpha = 1.0
            JRLoginGACall.loginMobileNumberEntered(screenType, loginFlowType)
            gaEventLabel = LOGINGAKeys.kLabelLoginCache
        } else {
            self.proceedBtn.alpha = 0.5
        }
        
        //Small Device handling
        if self.deviceHeight < 667.0 {
            proceedBtnTopConst.constant = 24.0
            msgLbl.font = UIFont.init(name: msgLbl.font.fontName, size: 12)
            okBtnTrailingConstraint.constant = 3
        }
        
        //OKAY button Handling
        okBtn.layer.borderColor = UIColor.init(red: 255/255, green: 255/255, blue: 255/255, alpha: 1.0).cgColor
        okBtn.layer.cornerRadius = 16
        okBtn.layer.borderWidth = 1.0
    }
    
    @objc private func languageChanged() {
        miniTtlLbl.text = "jr_login_screen_title".localized
        ttLLbl.text = "jr_login_enter_mob".localized
        skipBtn.titleLabel?.text = "jr_login_skip".localized
        mobileFld.placeholder = "jr_login_mobile_number".localized
        proceedBtn.imageEdgeInsets = UIEdgeInsets(top: -4, left: -13, bottom: 0, right: 0)
        configureTermsAndConditionTextView()
        for state: UIControl.State in [.normal, .highlighted, .selected, .focused] {
            forgotPwdLoginIssuesBtn.setTitle("jr_login_need_help".localized, for: state)
            proceedBtn.setTitle("jr_login_proceed_securely".localized, for: state)
            proceedBtn.setImage(UIImage(named: "lock"), for: state)
            skipBtn.setTitle("jr_login_skip".localized, for: state)
        }
    }
}
