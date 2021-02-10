//
//  JRAuthSignInPopupVC.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 05/02/20.
//

import UIKit
import CoreLocation

class JRAuthSignInPopupVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak private var countryCodeLbl : UILabel!
    @IBOutlet weak private var mobileFld      : UITextField!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var closeBtn: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var containerView: PopupContainerView!
    @IBOutlet weak var submitBtnTopConst: NSLayoutConstraint!
    @IBOutlet weak var containerViewHeightConst: NSLayoutConstraint!
    
    let vModel = JRAuthSignInVM(screenType: .popup)
    var completion: JRQuickLoginCompletion? //Session Expiry case
    var gaEventLabel: String = LOGINGAKeys.kLabelLoginMobile
    
    //MARK:- Instance
    class var newInstance: JRAuthSignInPopupVC {
        let vc = JRAuthManager.kAuthPopupStoryboard.instantiateViewController(withIdentifier: "JRAuthSignInPopupVC") as! JRAuthSignInPopupVC
        return vc
    }
    
    func setAuth(type: JarvisLoginType) {
        vModel.setAuth(type: type)
    }
    
    //MARK:- Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JRLoginGACall.loginScreenLoaded(screenType, loginFlowType)
        self.navigationController?.navigationBar.isHidden = true
        self.vModel.checkCache()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.loadingIndicatorView.isHidden = true
    }
}

// MARK: - IBActions
private extension JRAuthSignInPopupVC {
    @IBAction func forgotPassClicked(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        JRLoginUI.sharedInstance().delegate?.openLoginIssues(getMob(), self)
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        JRLoginGACall.loginPopupDiscarded(loginFlowType, mob: "mobile_number")
        self.mobileFld.endEditing(true)
        
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
    
    @IBAction func proceedClicked(_ sender: UIButton) {
        guard self.isNetworkReachable() else { return }
        guard let len = mobileFld.text?.count, len > 10 else { return }
        
        let tuple = self.vModel.isInputValid(text: getNumberWithoutSpace(self.mobileFld.text))
        if tuple.valid {
            self.getProceed()
        } else {
            JRLoginGACall.loginProceedClicked(screenType, loginFlowType, el1: gaEventLabel, el2: tuple.errorMsg ?? "", el3: LOGINGAKeys.kLabelApp)
            self.showError(text: tuple.errorMsg)
        }
    }
    
    @IBAction func numberTextChanged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if let text = sender.text, !text.isEmpty{
                self.countryCodeLbl.font = UIFont.boldSystemFont(ofSize: 20)
            } else {
                self.countryCodeLbl.font = UIFont.systemFont(ofSize: 20)
            }
        }
    }
}

// MARK:- UITextFieldDelegate & Helpers
extension JRAuthSignInPopupVC: UITextFieldDelegate, UITextViewDelegate {
    
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
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    private func getNumberWithoutSpace(_ numberString: String?) -> String{
        guard let text = numberString else { return ""}
        return text.replacingOccurrences(of: " ", with: "")
    }

    private func getMob() -> String{
        var mob = getNumberWithoutSpace(self.mobileFld.text)
        if mob.isEmpty{
            mob = vModel.preFilledLoginId
        }
        return mob
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        self.proceedBtn.alpha = 0.5
        return true
    }
}

//MARK:- Private methods
private extension JRAuthSignInPopupVC {
    
    private func getProceed() {
        guard self.isNetworkReachable() else { return }
        navigationController?.popToRootViewController(animated: true)
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        let mobileNumber = getNumberWithoutSpace(self.mobileFld.text)
        if let navControler = navigationController{
            vModel.verifyMobileNumber(mobileNumber, navigationController: navControler,loginFlowType: self.loginFlowType, sessionExpiryCompletion: completion, GAEventLabel: gaEventLabel)  {[weak self] (success, message) in
                if let weakSelf = self, !success{
                    DispatchQueue.main.async {
                        weakSelf.loadingIndicatorView.isHidden = true
                        weakSelf.showError(text: message)
                    }
                }
            }
        }
    }
    
    private func setupUI(){
        containerView.dismissKeyboardOnTap()
        if vModel.preFilledLoginId.count > 5{
            self.mobileFld.text = vModel.preFilledLoginId.insert(" ", ind: 5)
        }
        
        mobileFld.attributedPlaceholder = NSAttributedString(string: "jr_login_mobile_number".localized, attributes: [
            .foregroundColor: LOGINCOLOR.textGray,
            .font: UIFont.systemFont(ofSize: 20.0)
        ])

        //Setup Loader
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = LOGINCOLOR.lightBlueBG
        
        if let text = mobileFld.text, text.isEmpty{
            self.countryCodeLbl.font = UIFont.systemFont(ofSize: 20)
            proceedBtn.alpha = 0.5
        }
        else{
            self.countryCodeLbl.font = UIFont.boldSystemFont(ofSize: 20)
            proceedBtn.alpha = 1.0
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
            submitBtnTopConst.constant = 20.0
            containerViewHeightConst.constant = 305.0
        }
        else{
            submitBtnTopConst.constant = 36.0
            containerViewHeightConst.constant = 340.0
        }
    }
}

//MARK:- Keyboard notification delegates
extension JRAuthSignInPopupVC{
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

