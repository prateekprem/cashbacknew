//
//  JRChangePasswordVC.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 21/12/20.
//

import UIKit
import jarvis_utility_ios


class JRChangePasswordVC: JRAuthBaseVC, UIGestureRecognizerDelegate {
    @IBOutlet weak var currentPwdTextField: JVFloatLabeledTextField!
    @IBOutlet weak var newPwdTextField: JVFloatLabeledTextField!
    @IBOutlet weak var reenterPwdTextField: JVFloatLabeledTextField!
    @IBOutlet weak var strengthView: UIView!
    @IBOutlet weak var strengthResultLbl: UILabel!
    @IBOutlet weak var fiveChImageView: UIImageView!
    @IBOutlet weak var specialChImageView: UIImageView!
    @IBOutlet weak var upperCaseChImageView: UIImageView!
    @IBOutlet weak var numericImgView: UIImageView!
    @IBOutlet weak var strengthViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicatorV: UIActivityIndicatorView!
    @IBOutlet weak var forgotPwdBtn: UIButton!
    @IBOutlet weak var updatePwdHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var tncImg: UIImageView!
    @IBOutlet weak var updateBtn: JRBlueButton!
    
    var vm: JRChangePwdVM = JRChangePwdVM()
    
    class var newInstance : JRChangePasswordVC {
        let vc = JRAuthManager.kEmailUpdateStoryboard.instantiateViewController(withIdentifier: "JRChangePasswordVC") as! JRChangePasswordVC
        return vc
    }
    // MARK: - Life Cycle methods
    override func viewDidLoad() { super.viewDidLoad() }
    override func viewWillAppear(_ animated: Bool) { setupUI() }
    override func viewWillDisappear(_ animated: Bool) { vm.viewUnloaded() }
    // MARK: - IBActions
    @IBAction func onCurrentPwdBtnTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        currentPwdTextField.isSecureTextEntry.toggle()
        currentPwdTextField.becomeFirstResponder()
    }
    @IBAction func onNewPwdBtnTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        newPwdTextField.isSecureTextEntry.toggle()
        newPwdTextField.becomeFirstResponder()
    }
    @IBAction func onReenterNewPwdBtnTouched(_ sender: UIButton) {
        sender.isSelected.toggle()
        reenterPwdTextField.isSecureTextEntry.toggle()
        reenterPwdTextField.becomeFirstResponder()
    }
    @IBAction func onSaveBtnTouched(_ sender: UIButton) {
        vm.ctaTapped(currentPwdTextField.text, newPwdTextField.text, reenterPwdTextField.text)
    }
    @IBAction func onForgotPwdBtnTouched(_ sender: Any) {
        vm.forgotPwdClicked()
    }
    @IBAction func tncBtnTapped(_ sender: Any) {
        tncImg.image = vm.tncSelected ? setAuthImage("unchecked") : setAuthImage("checked")
        vm.tncSelected.toggle()
    }
}
// MARK: - Private Helpers
private extension JRChangePasswordVC{
    func updateViewForStrength(strength:JRLPasswordStrength, replacementString: String){
        vm.currentStrength = strength
        if replacementString.isEmpty{
            strengthResultLbl.textColor = LOGINCOLOR.darkGray2
            strengthResultLbl.text = "-"
            return
        }
        switch strength {
        case .weak:
            strengthResultLbl.textColor = LOGINCOLOR.pastelRed
            strengthResultLbl.text = "jr_login_weak".localized
        case .average:
            strengthResultLbl.textColor = LOGINCOLOR.pastelDarkYellow
            strengthResultLbl.text = "jr_login_average".localized
        case .strong:
            strengthResultLbl.textColor = LOGINCOLOR.green
            strengthResultLbl.text = "jr_login_strong".localized
        }
    }
    func updateViewForPasswordCharacterChecks(checks : JRLPasswordCharacterChecks){
        fiveChImageView.backgroundColor = checks.bgcolor(checks.isMoreThan5Characters)
        fiveChImageView.image = checks.img(checks.isMoreThan5Characters)
        specialChImageView.backgroundColor = checks.bgcolor(checks.containsSpecialCharacter)
        specialChImageView.image = checks.img(checks.containsSpecialCharacter)
        upperCaseChImageView.backgroundColor = checks.bgcolor(checks.containsAlphabet)
        upperCaseChImageView.image = checks.img(checks.containsAlphabet)
        numericImgView.backgroundColor = checks.bgcolor(checks.containsNumber)
        numericImgView.image = checks.img(checks.containsNumber)
    }
    func presentAlertViewWithMessage(_ message: String) {
        showAlert(message)
    }
    func setupUI(){
        forgotPwdBtn.updateTextColor()
        title = "jr_bank_changePaytmPassword".localized
        tncImg.image = setAuthImage("checked")
        currentPwdTextField.becomeFirstResponder()
        strengthResultLbl.textColor = LOGINCOLOR.darkGray2
        strengthResultLbl.text = "-"
        strengthViewHeightConstraint.constant = 0
        strengthView.isHidden = true
        view.dismissKeyboardOnTap()
        if UIScreen.main.bounds.height < 667.0{
            updatePwdHeightConstraint.constant = 8.0
        }
        setupCallbacks()
        vm.viewLoaded()
        disableAutoFill()
    }
    func disableAutoFill() {
        var contentType: UITextContentType = .init(rawValue: "")
        if #available(iOS 12.0, *) {
            contentType = .oneTimeCode
        }
        newPwdTextField.textContentType = contentType
        reenterPwdTextField.textContentType = contentType
    }

    func setupCallbacks(){
        vm.showLoader = { [unowned self] in
            DispatchQueue.main.async {
                self.activityIndicatorV.isHidden = false
                self.activityIndicatorV.startAnimating()
            }
        }
        
        vm.hideLoader = { [unowned self] in
            DispatchQueue.main.async {
                self.activityIndicatorV.isHidden = true
            }
        }
        
        vm.showErrorAlert = { [unowned self] (msg) in
            DispatchQueue.main.async {
                self.presentAlertViewWithMessage(msg)
            }
        }
        
        vm.showToast = { [unowned self] (msg) in
            DispatchQueue.main.async {
                self.view.showToast(toastMessage: msg, duration: 3.0, yPosition: self.updateBtn.frame.maxY)
            }
        }
        
        vm.showSuccessAlert = { [unowned self] (msg) in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                    self.vm.successAlertCompletion()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
                        NotificationCenter.default.post(name: NSNotification.Name.JRPasswordChanged, object: nil)
                    }
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        vm.dismiss = { [unowned self] (redirectToLogin, loginId) in
            DispatchQueue.main.async {
                self.navigationController?.popToRootViewController(animated: true)
                if redirectToLogin{
                    JRLoginUI.sharedInstance().signIn(.mobile, loginId, screenType: .fullScreen)
                }
            }
        }
    }
}

//MARK: - Text Field Delegates
extension JRChangePasswordVC: UITextFieldDelegate{
    @IBAction func textFieldEditingChanged(_ sender: UITextField) {
        changeTextFieldSize(sender, onEditBegin: !(sender.text?.count == 0))
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField == self.newPwdTextField{
            self.strengthViewHeightConstraint.constant = 115
            self.strengthView.isHidden = false
        }
    }
    public func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason){
        if textField == newPwdTextField{
            strengthViewHeightConstraint.constant = 0
            strengthView.isHidden = true
        }
        
        guard LoginAuth.sharedInstance().isUserPasswordVoilated() else { return }
        if textField == currentPwdTextField{
            JRLoginGACall.upgradePwdTxtEntered("current_password_entered")
        }
        else if textField == newPwdTextField{
            JRLoginGACall.upgradePwdTxtEntered("new_password_entered")
        }
        else if textField == reenterPwdTextField{
            JRLoginGACall.upgradePwdTxtEntered("confirm_password_entered")
        }
    }
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    public func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == newPwdTextField{
            let (strength, pwdChChecks)  = JRLPasswordUtils.strengthForPassword(password: "")
            updateViewForStrength(strength: strength, replacementString: "")
            updateViewForPasswordCharacterChecks(checks: pwdChChecks)
        }
        return true
    }
    public func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{
            return false
        }
        if textField == newPwdTextField{
            let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let (strength, pwdChChecks)  = JRLPasswordUtils.strengthForPassword(password: changedString)
            updateViewForStrength(strength: strength, replacementString: changedString)
            updateViewForPasswordCharacterChecks(checks: pwdChChecks)
        }
        return true
    }
}
//MARK:- View Model ------------------
class JRChangePwdVM{
    var tncSelected: Bool = true
    var currentStrength: JRLPasswordStrength = .weak
    
    var showToast: ((String)->Void)?
    var showLoader: (()->Void)?
    var hideLoader: (()->Void)?
    var showErrorAlert: ((String)->Void)?
    var showSuccessAlert: ((String)->Void)?
    var dismiss: ((Bool,String)->Void)?
    
    func viewLoaded(){ JRLoginGACall.changePwdLoaded() }
    func viewUnloaded() {
        if LoginAuth.sharedInstance().isUserPasswordVoilated(){
            JRLoginGACall.upgradePwdBackTapped()
        }
        else{
            JRLoginGACall.changePwdBckBtnClicked()
        }
    }
    func forgotPwdClicked() {
        JRLoginGACall.changePwdFPClicked()
        JRLoginUI.sharedInstance().initiateForgotPwdFlowV2()
    }
    func ctaTapped(_ curPwd: String?, _ newPwd: String?, _ rePwd: String?){
        if validateInput(curPwd, newPwd, rePwd){
            showLoader?()
            let params = getPwdInfo(curPwd, newPwd, rePwd)
            invokeChangePwd(params)
        }
        else{
            hideLoader?()
        }
    }
    func successAlertCompletion(){
        if tncSelected{
            JRLoginUI.sharedInstance().signOut()
            LoginAuth.sharedInstance().resetRSAKeys()
            var existingId = ""
            if let id = UserDefaults.standard.string(forKey: "prefilledLoginId") {
                existingId = id
            }
            dismiss?(true, existingId)
        }
        else{
            dismiss?(false, "")
        }
    }
    func validateInput(_ curPwd: String?, _ newPwd: String?, _ rePwd: String?) -> Bool{
        var rVal = true
        var errMsg = ""
        if let t = curPwd, t.isBlank(){
            errMsg = "jr_ac_please_enter_current_password".localized
            rVal = false
        }
        
        if let t = newPwd, t.isBlank(){
            errMsg = "jr_ac_please_enter_new_password".localized
            rVal = false
        }
        
        if let t = rePwd, t.isBlank(){
            errMsg = "jr_ac_enter_confirm_password".localized
            rVal = false
        }
        
        if rePwd != newPwd {
            errMsg = "jr_ac_new_password_does_not_match".localized
            rVal = false
        }
        if curPwd == newPwd {
            errMsg = "jr_ac_new_and_old_password_match".localized
            rVal = false
        }
        if !errMsg.isEmpty{
            showErrorAlert?(errMsg)
        }
        if !rVal{
            gaForSaveClicked(currentStrength.rawValue, errMsg, "app", "")
        }
        return rVal
    }
    func getPwdInfo(_ curPwd: String?, _ newPwd: String?, _ rePwd: String?) -> [String: Any]{
        var passwordInformation = [String: Any]()
        passwordInformation["oldPassword"] = curPwd
        passwordInformation["newPassword"] = newPwd
        passwordInformation["confirmPassword"] = rePwd
        passwordInformation["passwordUpgrade"] = LoginAuth.sharedInstance().isUserPasswordVoilated()
        passwordInformation["userLogoutConsent"] = tncSelected ? "LOGOUT_FROM_ALL_DEVICES" : "LOGOUT_FROM_NONE"
        return passwordInformation
    }
    func invokeChangePwd(_ param: [String: Any]){
        let key = AuthRSAGenerator.shared.getPublicKeyBase64String()
        if key.isEmpty, let loginId = UserDefaults.standard.string(forKey: "prefilledLoginId"){
            try? AuthRSAGenerator.shared.createKeyPair(for: loginId)
        }
        JRLServiceManager.changePassword(param) {[weak self] (data, response, error) in
            guard let weakSelf = self else { return }
            if let errVal = error?.getMsgWithCode() {
                weakSelf.gaForSaveClicked(weakSelf.currentStrength.rawValue,  errVal.0, "api", errVal.1)
                weakSelf.showToast?(errVal.0)
            }
            else if let resultDict = data,
                    let resCode = resultDict["responseCode"] as? String{

                let genericMsg = "jr_login_changePassword_api_failure_msg".localized
                var msg = genericMsg
                if let m = resultDict["message"] as? String{ msg = m }
                switch resCode {
                case LOGINRCkeys.success:
                    if LoginAuth.sharedInstance().isUserPasswordVoilated(){
                        JRLoginGACall.upgradePwdSuccess(weakSelf.tncSelected ? "logout_all" : "logout_none")
                    }
                    else{
                        JRLoginGACall.changePwdSuccess(weakSelf.tncSelected ? "logout_all" : "logout_none")
                    }
                    weakSelf.gaForSaveClicked(weakSelf.currentStrength.rawValue, "", "", "")
                    weakSelf.showSuccessAlert?(msg)
                case "425","410","421","870","422","427":
                    weakSelf.gaForSaveClicked(weakSelf.currentStrength.rawValue, msg, "api", resCode)
                    weakSelf.showErrorAlert?(msg)

                default:
                    msg = JRLoginConstants.generic_error_message
                    weakSelf.gaForSaveClicked(weakSelf.currentStrength.rawValue, genericMsg, "api", resCode)
                    weakSelf.showErrorAlert?(msg)
                }
            }
            weakSelf.hideLoader?()
        }
    }
    
    private func gaForSaveClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        if LoginAuth.sharedInstance().isUserPasswordVoilated(){
            JRLoginGACall.upgradePwdSaveClicked(el1, el2, el3, el4)
        }
        else{
            JRLoginGACall.changePwdSaveClicked(el1, el2, el3, el4)
        }
    }
}
