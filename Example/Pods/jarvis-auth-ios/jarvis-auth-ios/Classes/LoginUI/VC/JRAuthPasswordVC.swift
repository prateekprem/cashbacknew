//
//  JRAuthPasswordVC.swift
//  jarvis-auth-ios
//
//  Created by Prakash Jha on 11/12/19.
//

import UIKit

class JRAuthPasswordVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak private var passwordTxtF : UITextField!
    @IBOutlet weak private var showPassBtn  : UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var forgotPwdBottomConst: NSLayoutConstraint!
    @IBOutlet weak var forgotPwdTopConst: NSLayoutConstraint!
    @IBOutlet weak var clientPwdSubMsg: UILabel!
    
    var dataModel: JRLOtpPsdVerifyModel?
    var messageYPos: CGFloat = 0.0
    
    //MARK:- Instance
    class var newInstance: JRAuthPasswordVC {
        let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRAuthPasswordVC") as! JRAuthPasswordVC
        vc.screenType = .fullScreen
        return vc
    }
    
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRAuthPasswordVC {
        let vc = JRAuthPasswordVC.newInstance
        vc.dataModel = dataModel
        return vc
    }
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initilize()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        passwordTxtF.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        JRLoginGACall.passwordScreenLoaded(screenType, loginFlowType)
        if let submitBtnOrigin = self.submitBtn.superview?.convert(submitBtn.frame.origin, to: nil){
            messageYPos = submitBtnOrigin.y + submitBtn.frame.size.height + 15
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        self.loadingIndicatorView.isHidden = true
    }
}

//MARK:- IBAction
extension JRAuthPasswordVC{
    @IBAction func backBtnAction(_ sender: Any) {
        JRLoginGACall.passwordScreenBackBtnClicked(screenType, loginFlowType)
        self.handleBackbtn()
    }
    
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        JRLoginGACall.passwordScreenForgotPwdClicked(screenType, loginFlowType)
        if let loginId = dataModel?.loginId{
            JRLoginUI.sharedInstance().initiateForgotPwdFlowV2(withMobileNumber: loginId)
        }
    }
    
    @IBAction func passwordTextChanged(_ sender: UITextField) {
        if let text = sender.text, !text.isEmpty{
            self.submitBtn.isUserInteractionEnabled = true
        }
        else{
            self.submitBtn.isUserInteractionEnabled = false
        }
    }
    
    @IBAction func showPasswordTapped(_ sender: Any) {
        if showPassBtn.isSelected {
            JRLoginGACall.passwordShowHideClicked(action: LOGINGAKeys.kShowPwd)
            showPassBtn.isSelected = false
            passwordTxtF.isSecureTextEntry = false
        } else {
            JRLoginGACall.passwordShowHideClicked(action: LOGINGAKeys.kHidePwd)
            showPassBtn.isSelected = true
            passwordTxtF.isSecureTextEntry = true
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        guard let len = passwordTxtF.text?.count, len > 4 else { return }
        guard let psd = passwordTxtF.text, !psd.isEmpty else {
            let pos = submitBtn.frame.origin.x + submitBtn.frame.size.height + 20
            view.showToast(toastMessage: "jr_login_enter_paytm_password".localized, duration: 3.0, yPosition: pos)
            return
        }
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let loginId =  dataModel.loginId else { return }
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        self.view.endEditing(true)
        JRAuthPasswordVM.validate(password: psd, stateToken: stateToken, loginId: loginId, loginType: dataModel.loginType) {[weak self] (success, responseCode, message, model, signinSuccess, signInError) in
            
            guard let weakSelf = self else{
                return
            }
            
            DispatchQueue.main.async {
                weakSelf.loadingIndicatorView.isHidden = true
                
                if !success {
                    if let error = signInError as NSError?, error.code == JRReloginErrorCode {
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: "", el3: LOGINGAKeys.kLabelAPI, el4: String(JRReloginErrorCode))
                        weakSelf.moveToSignInController()
                    } else {
                        if let error = signInError as NSError?{
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: message ?? JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: String(error.code))
                        }
                        else{
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: message ?? JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                        }
                        weakSelf.view.showToast(toastMessage: message ?? JRLoginConstants.generic_error_message , duration: 3.0)
                    }
                } else {
                    switch responseCode {
                    case LOGINRCkeys.loginOTP:
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType)
                        if let lmodel = model{
                            DispatchQueue.main.async {
                                let vc = JRAuthOTPVC.controller(lmodel)
                                vc.delegate = weakSelf
                                weakSelf.dataModel?.setState(token: stateToken)
                                weakSelf.navigationController?.pushViewController(vc, animated: false)
                            }
                        }
                    case LOGINRCkeys.success:
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType)
                        weakSelf.signInCompleted(isSuccess: signinSuccess, error: signInError)

                    default:
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message , duration: 3.0)
                    }
                }
            }
        }
    }
}

//MARK:- Private methods
extension JRAuthPasswordVC{
    private func initilize() {
        self.screenType = .fullScreen
        self.view.dismissKeyboardOnTap()
        setUpProceedButton()
        setUpTextField()
        setupSmallDevices()
        setupClientUI()
    }
    
    private func setUpTextField() {
        passwordTxtF.isSecureTextEntry = true
        showPassBtn.isSelected = true
    }
    
    private func setupClientUI(){
        let pwdScreenSubMsg = LoginAuth.sharedInstance().isPwdScreenSubMsg
        if pwdScreenSubMsg.isRequired{
            clientPwdSubMsg.isHidden = false
            clientPwdSubMsg.text = pwdScreenSubMsg.message
            forgotPwdTopConst.constant = 25.0
        }
        else{
            clientPwdSubMsg.isHidden = true
        }
    }
    
    private func setUpProceedButton() {
        submitBtn.alpha = 0.5
        loadingIndicatorView.isHidden = true
    }
    
    private func setupSmallDevices(){
        if self.deviceHeight < 667.0 {
            forgotPwdBottomConst.constant = 7.0
        }
    }
    
    @objc private func proceedButtonTapped() {
        
    }
    
    private func moveToSignInController() {
        guard let navCont = navigationController else {
            return
        }
        for controller in navCont.viewControllers {
            if controller is JRAuthSignInVC {
                navCont.popToViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - UITextFieldDelegate, JRLOTPVCDelegate
extension JRAuthPasswordVC: UITextFieldDelegate, JRLOTPVCDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        view.endEditing(true)
        return false
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        if(textField == passwordTxtF) && string == " " { return false}
        
        // restrict user to enter the password more then 15 charecters
        let currentString: NSString = textField.text! as NSString
        let newString: NSString =
            currentString.replacingCharacters(in: range, with: string) as NSString
        self.submitBtn.alpha = newString.length > 4 ? 1.0 : 0.5
        return (newString.length <= LoginAuth.sharedInstance().getMaxPasswordLength() || string == "")
    }
}

//MARK:- JRLOTPVCDelegate
extension JRAuthPasswordVC{
    func updateStateToken(_ stateToken: String) {
        dataModel?.setState(token: stateToken)
    }
}

