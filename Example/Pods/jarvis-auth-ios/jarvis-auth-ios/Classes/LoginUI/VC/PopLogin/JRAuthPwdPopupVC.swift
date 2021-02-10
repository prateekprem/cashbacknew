//
//  JRAuthPwdPopupVC.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 05/02/20.
//

import UIKit
typealias JRQuickLoginCompletion = (_ success: Bool?, _ error: Error?, _ needCompletionHandler: Bool) -> Void

class JRAuthPwdPopupVC: JRAuthBaseVC {
    
    //MARK:- Outlets & Properties
    @IBOutlet weak private var passwordTxtF : UITextField!
    @IBOutlet weak private var showPassBtn  : UIButton!
    @IBOutlet weak var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak var submitBtn: UIButton!
    @IBOutlet weak var viewBottomConst: NSLayoutConstraint!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var pwdSubTitleLbl: UILabel!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var submitBtmHeightConst: NSLayoutConstraint!
    @IBOutlet weak var forgotPwdBottomConst: NSLayoutConstraint!
    @IBOutlet weak var submitBtnBottomConst: NSLayoutConstraint!
    @IBOutlet weak var containerVwHeightConst: NSLayoutConstraint!
    
    var dataModel: JRLOtpPsdVerifyModel?
    var completion: JRQuickLoginCompletion? //Session Expiry case
    static func controller(_ dataModel: JRLOtpPsdVerifyModel, loginFlowType: JarvisLoginFlowType = .login) -> JRAuthPwdPopupVC {
        let vc = JRAuthManager.kAuthPopupStoryboard.instantiateViewController(withIdentifier: "JRAuthPwdPopupVC") as! JRAuthPwdPopupVC
        vc.dataModel = dataModel
        vc.loginFlowType = loginFlowType
        return vc
    }
    
    // MARK:- Life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        initilize()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        JRLoginGACall.passwordScreenLoaded(screenType, loginFlowType)
        passwordTxtF.becomeFirstResponder()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.loadingIndicatorView.isHidden = true
    }
}

// MARK: - IBActions
extension JRAuthPwdPopupVC{
    @IBAction func forgotPasswordButtonTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        var mobileNumber = ""
        if let loginType = dataModel?.loginType, loginType == .mobile, let loginId = dataModel?.loginId {
            mobileNumber = loginId
        }
        JRLoginGACall.passwordScreenForgotPwdClicked(screenType, loginFlowType)
        JRLoginUI.sharedInstance().initiateForgotPwdFlowV2(withMobileNumber: mobileNumber)
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
            showPassBtn.isSelected = false
            passwordTxtF.isSecureTextEntry = false
        } else {
            showPassBtn.isSelected = true
            passwordTxtF.isSecureTextEntry = true
        }
        
    }
    
    @IBAction func closeBtnTapped(_ sender: Any) {
        JRLoginGACall.passwordScreenBackBtnClicked(screenType, loginFlowType)
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
    
    @IBAction func loginWithDiffAcountTapped(_ sender: Any) {
        JRLoginGACall.passwordScreenLoginWithDiffAcc(loginFlowType)
        self.dismiss(animated: true) {
            if let vc = UIApplication.topViewController(){
                let tVc = JRAuthSignInPopupVC.newInstance
                tVc.loginFlowType = self.loginFlowType
                tVc.completion = self.completion
                let nav = UINavigationController.init(rootViewController: tVc)
                nav.navigationBar.isHidden = true
                nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
                vc.present(nav, animated: true, completion: nil)
            }
        }
    }
    
    @IBAction func submitBtnTapped(_ sender: Any) {
        guard self.isNetworkReachable() else { return }
        guard let len = passwordTxtF.text?.count, len > 4 else { return }
        
        guard let psd = passwordTxtF.text, !psd.isEmpty else {
            view.showToast(toastMessage: "jr_login_enter_paytm_password".localized, duration: 3.0)
            return
        }
        
        if loginFlowType == .login{
            guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let loginId =  dataModel.loginId else { return }
            
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }

            JRAuthPasswordVM.validate(password: psd, stateToken: stateToken, loginId: loginId, loginType: dataModel.loginType) {[weak self] (success, responseCode, message, model, signinSuccess, signInError) in
                
                guard let weakSelf = self else{ return }
                
                DispatchQueue.main.async {
                    self?.loadingIndicatorView.isHidden = true
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
                            weakSelf.loadingIndicatorView.isHidden = true
                            guard let lmodel = model else{
                                return
                            }
                            let vc = JRAuthOTPPopupVC.newInstance(lmodel, loginFlowType: weakSelf.loginFlowType)
                            vc.delegate = weakSelf
                            weakSelf.dataModel?.setState(token: stateToken)
                            weakSelf.navigationController?.pushViewController(vc, animated: false)
                            
                        case LOGINRCkeys.success:
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType)
                            weakSelf.loadingIndicatorView.isHidden = true
                            weakSelf.signInCompleted(isSuccess: signinSuccess, error: signInError)
                            
                        /* Control will not reach here
                        case LOGINRCkeys.unprocessableEntity,
                             LOGINRCkeys.otpLimitReach,
                             LOGINRCkeys.accountBlocked:
                            JRAuthSessionExpiryMgr.openLogin()
                        */
                            
                        default:
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: responseCode)
                            weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message , duration: 3.0)
                        }
                    }
                }
            }
        }
        else{
            UIView.animate(withDuration: 0.1) {
                self.loadingIndicatorView.isHidden = false
                self.loadingIndicatorView.showLoadingView()
            }
            let stateToken = dataModel?.stateToken ?? ""
            JRAuthPasswordVM.validatePassword(psd, stateToken: stateToken, sessionExpiryCompletion: completion) { [weak self] (isSuccess, error) in
                guard let weakSelf = self else{ return }
                DispatchQueue.main.async {
                    weakSelf.loadingIndicatorView.isHidden = true
                    if let isSuccess = isSuccess, isSuccess {
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType)
                        weakSelf.dismiss(animated: true, completion: {
                            if let lcompletionBlock = weakSelf.completion{
                                lcompletionBlock(isSuccess, error, true)
                            }
                        })
                    } else if let error = error as NSError?, error.code == JRReloginErrorCode {
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: "", el3: LOGINGAKeys.kLabelAPI, el4: String(error.code))
                        weakSelf.moveToSignInController()
                    } else if let error = error as NSError?{
                        let message = error.localizedDescription
                        if !message.isEmpty{
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: message, el3: LOGINGAKeys.kLabelAPI, el4: String(error.code))
                            weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                        }
                        else{
                            JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: String(error.code))
                            weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                        }
                    } else {
                        JRLoginGACall.passwordScreenProceedClicked(weakSelf.screenType, weakSelf.loginFlowType, el2: JRLoginConstants.generic_error_message, el3: LOGINGAKeys.kLabelAPI, el4: "")
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                    }
                }
            }
        }
    }
}

// MARK: - Private methods
private extension JRAuthPwdPopupVC{
    private func initilize() {
        self.screenType = .popup
        containerView.dismissKeyboardOnTap()
        let id = dataModel?.loginId ?? ""
        pwdSubTitleLbl.text = String.init(format: "jr_login_verify_your_acc".localized, id)
        
        //Small Device handling
        if self.deviceHeight < 667.0 {
            titleLbl.font = UIFont.boldSystemFont(ofSize: 20)
            forgotPwdBottomConst.constant = 20.0
            submitBtmHeightConst.constant = 32.0
            submitBtnBottomConst.constant = 15.0
            containerVwHeightConst.constant = 305.0
            
        }
        else{
            containerVwHeightConst.constant = 372.0
        }
        
        
        setUpProceedButton()
        setUpTextField()
    }
    
    private func setUpTextField() {
        passwordTxtF.isSecureTextEntry = true
        showPassBtn.isSelected = true
    }
    
    private func setUpProceedButton() {
        submitBtn.alpha = 0.5
        loadingIndicatorView.isHidden = true
    }
    
    private func moveToSignInController() {
        guard let navCont = navigationController else {
            return
        }
        for controller in navCont.viewControllers {
            if controller is JRAuthSignInPopupVC {
                navCont.popToViewController(controller, animated: true)
            }
        }
    }
}

// MARK: - UITextFieldDelegate, JRLOTPVCDelegate
extension JRAuthPwdPopupVC: UITextFieldDelegate, JRLOTPVCDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool { return false }
    
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
extension JRAuthPwdPopupVC{
    func updateStateToken(_ stateToken: String) {
        dataModel?.setState(token: stateToken)
    }
}

//MARK:- Keyboard notification delegates
extension JRAuthPwdPopupVC{
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

