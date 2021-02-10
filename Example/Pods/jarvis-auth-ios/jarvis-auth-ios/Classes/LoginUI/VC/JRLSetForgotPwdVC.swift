//
//  JRLSetForgotPwdVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 17/02/20.
//

import UIKit

class JRLSetForgotPwdVC: JRAuthBaseVC{
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var subTitleLbl: UILabel!
    @IBOutlet weak var backBtn: UIButton!
    @IBOutlet weak var pwdTextField: UITextField!
    @IBOutlet weak var showPwdBtn: UIButton!
    @IBOutlet weak var separatorView1: UIView!
    @IBOutlet weak var strengthLbl: UILabel!
    @IBOutlet weak var strengthResultLbl: UILabel!
    @IBOutlet weak var fiveChImageView: UIImageView!
    @IBOutlet weak var fiveChLbl: UILabel!
    @IBOutlet weak var specialChImageView: UIImageView!
    @IBOutlet weak var specialChLbl: UILabel!
    @IBOutlet weak var upperCaseChImageView: UIImageView!
    @IBOutlet weak var upperCaseLbl: UILabel!
    @IBOutlet weak var numericImgView: UIImageView!
    @IBOutlet weak var numericLbl: UILabel!
    @IBOutlet weak var confirmPwdTextField: UITextField!
    @IBOutlet weak var confirmPwdShowBtn: UIButton!
    @IBOutlet weak var separtorView2: UIView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var baseView: UIView!
    @IBOutlet weak var newPwdPalceholder: UILabel!
    @IBOutlet weak var enetrNewPwdPlaceholder: UILabel!
    @IBOutlet weak var tncImg: UIImageView!
    
    var tableViewInitialContentOffsetY:CGFloat = 0
    private var vm:JRLSetForgotPwdVM!
    
    //MARK:- Instance Methods
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLSetForgotPwdVC {
        let vc = UIStoryboard.init(name: "JRLForgotPwdStory", bundle: JRAuthManager.kAuthBundle).instantiateViewController(withIdentifier: "JRLSetForgotPwdVC") as! JRLSetForgotPwdVC
        vc.vm = JRLSetForgotPwdVM(dataModel)
        
        return vc
    }
    
    //MARK:- Instance Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setupCallbacks()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        registerKeyboardNotification()
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        unregisterKeyboardNotification()
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        setupForDisappear()
    }
    
    //MARK:- Action Methods
    @IBAction func onBackBtnTouched(_ sender: Any) {
        guard let nav = navigationController else { return }
        for vc in nav.viewControllers as Array {
            if vc.isKind(of: JRLForgotPwdVC.self) {
                nav.popToViewController(vc, animated: true)
                break
            }
        }
    }
    @IBAction func onShowPwdBtnTouched(_ sender: Any) {
        showPwdBtn.isHidden.toggle()
        pwdTextField.isSecureTextEntry.toggle()
        pwdTextField.becomeFirstResponder()
    }
    @IBAction func onConfirmShowPwdBtnTouched(_ sender: Any) {
        confirmPwdShowBtn.isSelected.toggle()
        confirmPwdTextField.isSecureTextEntry.toggle()
        confirmPwdTextField.becomeFirstResponder()
    }
    @IBAction func onConfirmBtnTouched(_ sender: Any) {
        vm.ctaTapped(pwdTextField.text, confirmPwdTextField.text)
    }
    @IBAction func onEnterPwdTextFieldChanged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if let text = sender.text, !text.isEmpty{
                self.newPwdPalceholder.alpha = 1.0
                self.pwdTextField.textColor = LOGINCOLOR.darkGray
            } else {
                self.newPwdPalceholder.alpha = 0.0
                self.pwdTextField.textColor = LOGINCOLOR.textGray
            }
        }
    }
    @IBAction func onReEnterPwdFieldChnaged(_ sender: UITextField) {
        UIView.animate(withDuration: 0.2) {
            if let text = sender.text, !text.isEmpty{
                self.enetrNewPwdPlaceholder.alpha = 1.0
                self.confirmPwdTextField.textColor = LOGINCOLOR.darkGray
            } else {
                self.enetrNewPwdPlaceholder.alpha = 0.0
                self.confirmPwdTextField.textColor = LOGINCOLOR.textGray
            }
        }
    }
    @IBAction func tncBtnTapped(_ sender: Any) {
        tncImg.image = vm.tncSelected ? setAuthImage("unchecked") : setAuthImage("checked")
        vm.tncSelected.toggle()
    }
    
    // MARK:- Keyboard Observers
    private func registerKeyboardNotification(){
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    private func unregisterKeyboardNotification(){
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    //MARK:- Selectors
    @objc internal override func keyboardWillShow(notification:Notification){
        let yOffset : CGFloat = deviceHeight < 667.0 ? 120.0 : 20.0
        if let _ = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            tableView.contentOffset =
                CGPoint(x: tableView.contentOffset.x, y: tableViewInitialContentOffsetY + yOffset)
        }
    }
    @objc internal override func keyboardWillHide(notification:Notification){
        tableView.contentOffset =
        CGPoint(x: tableView.contentOffset.x, y: tableViewInitialContentOffsetY)
    }
}

//MARK:- Private Helper
private extension JRLSetForgotPwdVC{
    func setup(){
        self.view.dismissKeyboardOnTap()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.isScrollEnabled = false
        pwdTextField.delegate = self
        confirmPwdTextField.delegate = self
        tableViewInitialContentOffsetY = tableView.contentOffset.y
        newPwdPalceholder.alpha = pwdTextField.isEmpty() ? 0.0 : 1.0
        enetrNewPwdPlaceholder.alpha = confirmPwdTextField.isEmpty() ? 0.0 : 1.0
        loadingIndicatorView.isHidden = true
        loadingIndicatorView.backgroundColor = LOGINCOLOR.lightBlueBG
        JRLoginGACall.setForgotPwdLoaded()
        let mob = vm.getMob()
        subTitleLbl.text = String(format: "jr_login_for_account_linked_to_mobile_number".localized, mob)
    }
    func setupCallbacks(){
        vm.showLoader = { [unowned self] in
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.1) {
                    self.loadingIndicatorView.show()
                }
            }
        }
        
        vm.hideLoader = { [unowned self] in
            DispatchQueue.main.async {
                self.loadingIndicatorView.isHidden = true
            }
        }
        
        vm.showToast = { [unowned self] (msg) in
            DispatchQueue.main.async {
                self.view.showToast(toastMessage: msg, duration: 3.0, yPosition: self.confirmButton.frame.maxY)
            }
        }
        
        vm.resignResponder = {[unowned self] in
            DispatchQueue.main.async {
                self.pwdTextField.resignFirstResponder()
                self.confirmPwdTextField.resignFirstResponder()
            }
        }
        
        vm.showAlert = {[unowned self] in
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "", message: "jr_login_pasword_change_success".localized, preferredStyle: .alert)
                let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                    //handle UI
                    self.vm.alertSelected()
                }
                alert.addAction(okAction)
                self.present(alert, animated: true, completion: nil)
            }
        }
        
        vm.startFPAgain = {[unowned self] in
            DispatchQueue.main.async {
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRLForgotPwdVC.self) {
                        self.navigationController?.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        
        vm.dismissSelf = {[weak self] (presentLogin) in
            guard let weakSelf = self else { return }
            DispatchQueue.main.async {
                weakSelf.dismiss(animated: false, completion: {
                    if presentLogin{
                    weakSelf.vm.handleDismiss()
                    }
                })
            }
        }
    }
    private func setupForDisappear(){
        loadingIndicatorView.isHidden = true
    }
    private func updateViewForStrength(strength:JRLPasswordStrength, replacementString: String){
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
    private func updateViewForPasswordCharacterChecks(checks : JRLPasswordCharacterChecks){
        fiveChImageView.backgroundColor = checks.bgcolor(checks.isMoreThan5Characters)
        fiveChImageView.image = checks.img(checks.isMoreThan5Characters)
        specialChImageView.backgroundColor = checks.bgcolor(checks.containsSpecialCharacter)
        specialChImageView.image = checks.img(checks.containsSpecialCharacter)
        upperCaseChImageView.backgroundColor = checks.bgcolor(checks.containsAlphabet)
        upperCaseChImageView.image = checks.img(checks.containsAlphabet)
        numericImgView.backgroundColor = checks.bgcolor(checks.containsNumber)
        numericImgView.image = checks.img(checks.containsNumber)
    }
}

//MARK:- Table View
extension JRLSetForgotPwdVC: UITableViewDelegate, UITableViewDataSource{
    func numberOfSections(in tableView: UITableView) -> Int { return 0 }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 0 }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell { return UITableViewCell() }
}

//MARK:- UI Textfield delegates
extension JRLSetForgotPwdVC:  UITextFieldDelegate {
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        if textField == pwdTextField{
            let (strength, pwdChChecks)  = JRLPasswordUtils.strengthForPassword(password: "")
            updateViewForStrength(strength: strength, replacementString: "")
            updateViewForPasswordCharacterChecks(checks: pwdChChecks)
        }
        return true
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if string == " "{ return false }
        if textField == pwdTextField{
            let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let (strength, pwdChChecks)  = JRLPasswordUtils.strengthForPassword(password: changedString)
            updateViewForStrength(strength: strength, replacementString: changedString)
            updateViewForPasswordCharacterChecks(checks: pwdChChecks)
        }
        return true
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool { return true }
    func textFieldDidBeginEditing(_ textField: UITextField) { }
    func textFieldDidEndEditing(_ textField: UITextField) { }
}

//MARK:- View Model --------------------------------
class JRLSetForgotPwdVM{
    private var dm: JRLOtpPsdVerifyModel
    var tncSelected: Bool = true
    
    var showLoader: (()->Void)?
    var hideLoader: (()->Void)?
    var showToast: ((String)->Void)?
    var resignResponder: (() -> Void)?
    var showAlert: (()-> Void)?
    var startFPAgain: (()->Void)?
    var dismissSelf: ((Bool)->Void)?

    init(_ dataModel:JRLOtpPsdVerifyModel) {
        self.dm = dataModel
    }
    
    private func getConsentText() -> String{
        return tncSelected ? "LOGOUT_FROM_ALL_DEVICES" : "LOGOUT_FROM_NONE"
    }
    
    private func getGAEL1() -> String{
        return tncSelected ? "logout_all" : "logout_none"
    }
    
    func ctaTapped(_ newPwd: String?, _ ConfPwd: String?){
        guard let stateToken = dm.stateToken else { return }
        if let password = newPwd,
           let confirmNewPwd = ConfPwd{
            let params: [String: String] = ["stateToken": stateToken, "newPassword": password,
                                            "confirmNewPassword": confirmNewPwd, "userLogoutConsent" : getConsentText()]
            showLoader?()
            if validateInput(newPwd, ConfPwd){
                forgotPassword(params)
            }
            else{
                hideLoader?()
            }
        }
    }
    
    func getMob() -> String{
        return dm.getMob().convertMobForTxtFld()
    }
    
    private func validateInput(_ newPwd: String?, _ confPwd: String?) -> Bool{
        var r:Bool = true
        var msg = ""
        if let t = newPwd, t.isBlank(){
            msg = "jr_ac_please_enter_new_password".localized
            r = false
        }
        if let t = confPwd, t.isBlank(){
            msg = "jr_ac_enter_confirm_password".localized
            r = false
        }
        if !msg.isEmpty{
            JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, msg, LOGINGAKeys.kLabelApp, "")
            showToast?(msg)
        }
        return r
    }
    
    func alertSelected(){
        if tncSelected{
            JRLoginUI.sharedInstance().delegate?.signOut(success: true, error: nil)
            LoginAuth.sharedInstance().resetRSAKeys()
            dismissSelf?(true)
        }
        else{
            if LoginAuth.sharedInstance().isLoggedIn(){
                JRLoginUI.sharedInstance().delegate?.pushHomeView(true, false)
            }
            else{
                dismissSelf?(false)
            }
        }
    }
    
    func handleDismiss(){
        JRLoginUI.sharedInstance().delegate?.signOutUserAndPresentLogin()
    }

    //MARK:- API Call
    private func forgotPassword(_ params: [String: String]) {
        resignResponder?()
        JRLServiceManager.setNewPassword(params) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            weakSelf.hideLoader?()
            if let errVal = error?.getMsgWithCode(){
                JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, errVal.0, LOGINGAKeys.kLabelAPI, errVal.1)
                weakSelf.showToast?(errVal.0)
                return
            }
            let mob = weakSelf.dm.getMob()
            
            if let resData = data, let resCode = resData["responseCode"] as? String{
                switch resCode {
                case LOGINRCkeys.success:
                    JRLoginGACall.setForgotPwdSuccess(weakSelf.getGAEL1())
                    JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, "", "", "")
                    LoginAuth.sharedInstance().isFromFP = (true,mob)
                    if !mob.isEmpty{ UserDefaults.standard.set(mob, forKey: "prefilledLoginId") }
                    weakSelf.showAlert?()
                case LOGINRCkeys.unprocessableEntity:
                    JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, "", LOGINGAKeys.kLabelAPI, resCode)
                    weakSelf.startFPAgain?()
                case LOGINRCkeys.invalidSignature:
                    AuthRSAGenerator.shared.removeSavedKeyPair(for: mob)
                    let _ = try? AuthRSAGenerator.shared.createKeyPair(for: mob)
                    JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, "", LOGINGAKeys.kLabelAPI, resCode)
                    weakSelf.startFPAgain?()
                default:
                    var msg = JRLoginConstants.generic_error_message
                    if let lmsg = resData["message"] as? String{ msg = lmsg }
                    JRLoginGACall.setForgotPwdSavedClicked(LOGINGAKeys.kPassword, msg, LOGINGAKeys.kLabelAPI, resCode)
                    weakSelf.showToast?(msg)
                }
            }
        }
    }
}
