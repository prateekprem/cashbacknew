//
//  JRLSetPasswordVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 20/06/19.
//

import Foundation
import jarvis_utility_ios

class JRLSetPasswordVC: JRAuthBaseVC {
    
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var baseViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var enterPwdField: JRLFloatingTextField!
    @IBOutlet weak var reenterPwdField: JRLFloatingTextField!
    @IBOutlet weak var separatorView: UIView!
    
    @IBOutlet weak var strengthView: UIView!
    @IBOutlet weak var pwdStrengthLbl: UILabel!
    @IBOutlet weak var pwdStrengthResulLbl: UILabel!
    @IBOutlet weak var fiveChImgView: UIImageView!
    @IBOutlet weak var fiveChLbl: UILabel!
    @IBOutlet weak var specialChImgView: UIImageView!
    @IBOutlet weak var specialChLbl: UILabel!
    @IBOutlet weak var numberImgView: UIImageView!
    @IBOutlet weak var numberLbl: UILabel!
    @IBOutlet weak var numericImgView: UIImageView!
    @IBOutlet weak var numericLbl: UILabel!
    @IBOutlet weak var strengthViewHeightConstraint: NSLayoutConstraint!
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var proceedBtn: UIButton!
    @IBOutlet weak var loginToDiffAccBtn: UIButton!
    @IBOutlet weak var loginToDiffAccHeightLayoutConstraint: NSLayoutConstraint!
    @IBOutlet weak var showPwdBtn: UIButton!
    @IBOutlet weak var confirmBtn: UIButton!
    
    // MARK: - Properties
    var showCrossButton:Bool = false
    var showLoginWithDiffMobile:Bool = true
    let greenColor = LOGINCOLOR.lightGreen
    let lightGreyColor = LOGINCOLOR.lightGray2
    let weakPwdColor = LOGINCOLOR.pastelRed
    let averagePwdColor = LOGINCOLOR.pastelDarkYellow
    let strongPwdColor = LOGINCOLOR.green
    let greyColor = LOGINCOLOR.darkGray2
    let greyImage  = UIImage(named: "icGreyTick", in: nil, compatibleWith: nil)
    let greenImage = UIImage(named: "icGreenTick", in: nil, compatibleWith: nil)
    
    static func controller() -> JRLSetPasswordVC?{
        return UIStoryboard(name: "JRLFPopUp", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRLSetPasswordVC") as?
        JRLSetPasswordVC
    }
    
    // MARK: - Life cycle methods
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
    }
    
    // MARK: - Keyboard events
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            baseViewBottomConstraint.constant = -(keyboardSize.height * (showLoginWithDiffMobile ? 0.5 : 0.6))
            proceedBtn.alpha = 0.0
            confirmBtn.alpha = 0.0
        }
    }
    
    @objc override func keyboardWillHide(notification:Notification){
        baseViewBottomConstraint.constant = 0
        if !proceedBtn.isHidden {
            proceedBtn.alpha = 1.0
        }else{
            confirmBtn.alpha = 1.0
        }
    }
    
    // MARK: - IBActions
    @IBAction func onCrossBtnTouched(_ sender: UIButton) {
        enterPwdField.endEditing(true)
        reenterPwdField.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func onProceedBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.pwdStrengthProceedClicked()
        proceedButtonAction()
    }
    
    @IBAction func onLoginToDiffAccBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.createPsdLoginToDiffAccountClicked()
        loginToDifferentAccount()
    }
    
    @IBAction func onShowPwdBtnTouched(_ sender: UIButton) {
//        JRLoginGACall.createPsdShowPasswordClicked()
        if showPwdBtn.isSelected {
            showPwdBtn.isSelected = false
            enterPwdField.isSecureTextEntry = false
        }else {
            showPwdBtn.isSelected = true
            enterPwdField.isSecureTextEntry = true
        }
    }
    
    @IBAction func onConfirmBtnTouched(_ sender: UIButton) {
        confirmButtonAction()
    }

    // MARK: - private helper methods
    private func initialSetUp() {
//        JRLoginGACall.pwdStrengthPopupLoaded()
        enterPwdField.delegate = self
        reenterPwdField.delegate = self
        enterPwdField.keyboardType = .default
        setUpProceedButton()
        setUpConfirmButton()
        setUpTextField()
//        JRLoginGACall.createPsdPageLoader()
        JRUtility.enableUserInteractionWithUIControl()

        loginToDiffAccBtn.isHidden = !showLoginWithDiffMobile
        loginToDiffAccHeightLayoutConstraint.constant = showLoginWithDiffMobile ? 30 : 0
        //closeBtnWidth.constant = showCrossButton ? 48 : 0
        crossBtn.isHidden = !showCrossButton
        
        confirmBtn.isHidden = true
        reenterPwdField.isHidden = true
        pwdStrengthResulLbl.textColor = greyColor
        pwdStrengthResulLbl.text = "-"
        
        fiveChImgView.backgroundColor = lightGreyColor
        fiveChImgView.image = greyImage
        
        specialChImgView.backgroundColor = lightGreyColor
        specialChImgView.image = greyImage
        
        numberImgView.backgroundColor = lightGreyColor
        numberImgView.image = greyImage
        
        numericImgView.backgroundColor = lightGreyColor
        numericImgView.image = greyImage
    }
    
    private func setUpProceedButton() {
        let proceedButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 55))
        proceedButton.backgroundColor = LOGINCOLOR.blue
        proceedButton.setTitle("jr_login_proceed".localized, for: .normal)
        proceedButton.addTarget(self, action:#selector(self.proceedButtonAction), for: .touchUpInside)
        enterPwdField.inputAccessoryView = proceedButton
    }
    
    private func setUpConfirmButton() {
        let confirmButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 55))
        confirmButton.backgroundColor = LOGINCOLOR.blue
        confirmButton.setTitle("jr_login_confirm".localized, for: .normal)
        confirmButton.addTarget(self, action:#selector(self.confirmButtonAction), for: .touchUpInside)
        reenterPwdField.inputAccessoryView = confirmButton
    }
    
    @objc private func proceedButtonAction(){
        guard let password = enterPwdField.text, password.length > 0 else {
//            JRLoginGACall.pwdStrengthProceedError()
            view.showToast(toastMessage: "jr_login_please_enter_password".localized, duration: 3.0)
            return
        }
        
        //check for password length from 5-15 charcaters
        if password.length < LoginAuth.sharedInstance().getMinPasswordLength() || password.length > LoginAuth.sharedInstance().getMaxPasswordLength() {
            view.showToast(toastMessage: "jr_login_password_length".localized, duration: 3.0)
            return
        }
        
        let _ = enterPwdField.resignFirstResponder()
        enterPwdField.isHidden = true
        strengthView.isHidden = true
        showPwdBtn.isHidden = true
        proceedBtn.isHidden = true
        strengthViewHeightConstraint.constant = 0
        confirmBtn.isHidden = false
        confirmBtn.alpha = 1.0
        reenterPwdField.isHidden = false
        let _ = reenterPwdField.becomeFirstResponder()
    }
    
    @objc private func confirmButtonAction(){
//        JRLoginGACall.signUpConfirmClicked()
        guard let password = enterPwdField.text, password.length > 0 else {
            return//impossible, btw password is used below
        }
        guard let confirmPassword = reenterPwdField.text, confirmPassword.length > 0 else {
            view.showToast(toastMessage: "jr_ac_enter_confirm_password".localized, duration: 3.0)
            return
        }
        if let password = enterPwdField.text, password.length > 0, password != confirmPassword{
            view.showToast(toastMessage: "jr_login_password_does_not_match".localized, duration: 3.0)
            return
        }
//        JRLoginGACall.pwdStrengthConfirmClicked()
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        LoginAuth.sharedInstance().setUserPassword(password, confirmPassword) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                if error != nil, let message = error?.localizedDescription {
                    self?.view.showToast(toastMessage: (message), duration: 3.0)
//                    JRLoginGACall.pwdStrengthConfirmError()
                    return
                }
                
                if let data = data as? [String: Any], let responseCode = data["responseCode"] as? String {
                    switch responseCode {
                    case "869":
                        LoginAuth.sharedInstance().setPasswordCreated(true)
                        JRLServiceManager.setStrengthOfPassword(pwdStr: password)
                        self?.dismiss(animated: true, completion: {
                            NotificationCenter.default.post(name:NSNotification.Name(rawValue:"JRUserDidCreatedPasswordNotification"), object: nil)
                            if let message = data["message"] as? String {
                                self?.view.showToast(toastMessage: (message), duration: 3.0)
                            }
                        })
                    default:
                        if let message = data["message"] as? String {
                            self?.view.showToast(toastMessage: (message), duration: 3.0)
                        }
                    }
                }
            }
        }
    }
    
    private func setUpTextField() {
        enterPwdField.isSecureTextEntry = true
        showPwdBtn.isSelected = true
    }
    
    private func updateViewForStrength(strength:JRLPasswordStrength, replacementString: String){
        if replacementString.isEmpty{
            pwdStrengthResulLbl.textColor = greyColor
            pwdStrengthResulLbl.text = "-"
            return
        }
        switch strength {
        case .weak:
            pwdStrengthResulLbl.textColor = weakPwdColor
            pwdStrengthResulLbl.text = "jr_login_weak".localized
        case .average:
            pwdStrengthResulLbl.textColor = averagePwdColor
            pwdStrengthResulLbl.text = "jr_login_average".localized
        case .strong:
            pwdStrengthResulLbl.textColor = strongPwdColor
            pwdStrengthResulLbl.text = "jr_login_strong".localized
        }
    }
    
    private func updateViewForPasswordCharacterChecks(checks : JRLPasswordCharacterChecks){
        if checks.isMoreThan5Characters{
            fiveChImgView.backgroundColor = greenColor
            fiveChImgView.image = greenImage
        }else{
            fiveChImgView.backgroundColor = lightGreyColor
            fiveChImgView.image = greyImage
        }
        
        if checks.containsSpecialCharacter{
            specialChImgView.backgroundColor = greenColor
            specialChImgView.image = greenImage
        }else{
            specialChImgView.backgroundColor = lightGreyColor
            specialChImgView.image = greyImage
        }
        
        if checks.containsAlphabet{
            numberImgView.backgroundColor = greenColor
            numberImgView.image = greenImage
        }else{
            numberImgView.backgroundColor = lightGreyColor
            numberImgView.image = greyImage
        }
        
        if checks.containsNumber{
            numericImgView.backgroundColor = greenColor
            numericImgView.image = greenImage
        }else{
            numericImgView.backgroundColor = lightGreyColor
            numericImgView.image = greyImage
        }
    }
}

extension JRLSetPasswordVC : UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{
            return false
        }
        
        if textField == enterPwdField{
            let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            if changedString.length > LoginAuth.sharedInstance().getMaxPasswordLength() {
                return false
            }
            let (strength, pwdChChecks)  = JRLPasswordUtils.strengthForPassword(password: changedString)
            updateViewForStrength(strength: strength, replacementString: changedString)
            updateViewForPasswordCharacterChecks(checks: pwdChChecks)
        }
        return true
    }
    
//    func textFieldDidBeginEditing(_ textField: UITextField) {
//        JRLoginGACall
//    }

//    func textFieldDidEndEditing(_ textField: UITextField) {
//        JRLoginGACall
//    }
}
