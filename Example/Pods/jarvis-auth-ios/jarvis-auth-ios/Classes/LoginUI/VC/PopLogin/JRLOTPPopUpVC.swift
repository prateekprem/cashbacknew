// JRLOTPPopUpVC.swift
// Login
//
//  Created by Parmod on 31/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios


class JRLOTPPopUpVC: JRAuthBaseVC {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var enterOTPTextField: JRLFloatingTextField!
    @IBOutlet weak var confirButton: UIButton!
    @IBOutlet weak var otpViewBottomConstraint: NSLayoutConstraint!
    
    //TODO:PARMOD....build the view model for this controller
    var mobileNumber: String?
    var state: String?
    var completion: JRQuickLoginCompletion?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialSetUp()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }

    static func controller() -> JRAuthBaseVC {
        return UIStoryboard(name: "JRLFPopUp", bundle:JRLBundle).instantiateViewController(withIdentifier: "JRLOTPPopUpVC") as! JRAuthBaseVC
    }
    
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            otpViewBottomConstraint.constant = keyboardSize.height - safeAreaBottomInset
        }
    }
    
    private func initialSetUp() {
        if let mobileNumber = mobileNumber {
            titleLabel.text = "jr_login_verify_91".localized + mobileNumber
        }
        self.enterOTPTextField.delegate = self
        self.enterOTPTextField.keyboardType = .numberPad
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.hideKeyboard))
        view.addGestureRecognizer(tapGesture)
        let swipeDown = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeDown.direction = .down
        self.view.addGestureRecognizer(swipeDown)
        JRUtility.enableUserInteractionWithUIControl()
    }
    
    @objc func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case .down:
                view.endEditing(true)
            default: break
            }
        }
    }
    
    @objc func hideKeyboard() {
        view.endEditing(true)
    }

    @objc private func proceedButtonTapped() {
        guard let otp = enterOTPTextField.text, !otp.isEmpty, let stateToken = state else {
            return
        }
        
        let params: [String: String] = [LOGINWSKeys.kOTP: otp, LOGINWSKeys.kStateToken: stateToken]
        verifyOTP(params)
        
    }
    
    func verifyOTP(_ params: [String: String], retryCount: Int = 0) {
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        JRLServiceManager.validateOTP(params) {[weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                if let error = error {
                    if (error as NSError).code == 311 {
                        if retryCount < 2 {
                            let updateRetryCount = (retryCount + 1)
                            weakSelf.verifyOTP(params, retryCount: updateRetryCount)
                        } else {
                            weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                        }
                    } else if !error.localizedDescription.isEmpty {
                        weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    } else {
                        weakSelf.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                    }
                    return
                }
                
                guard let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else {
                    weakSelf.navigationController?.popViewController(animated: false)
                    return
                }
                if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String, !stateToken.isEmpty {
                    weakSelf.state = stateToken
                }
                
                switch responseCode {
                case LOGINRCkeys.invalidOTP:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        weakSelf.view.showToast(toastMessage: (message), duration: 3.0)
                    }
                case LOGINRCkeys.success:
                    if let oauthCode = responseData[LOGINWSKeys.kOauthCode] as? String {
                        
                        var loginId = ""
                        if let lId = weakSelf.mobileNumber{
                            loginId = lId
                        }
                        
                        JRLServiceManager.setAccessToken(code: oauthCode,loginId: loginId, completionHandler: { (isSuccess, error) in
                            
                            DispatchQueue.main.async {
                                
                                if let err = error as NSError?, err.code == JRReloginErrorCode {
                                    weakSelf.moveToSignInController()
                                    return
                                } else if let completion = weakSelf.completion {
                                    weakSelf.dismiss(animated: false, completion: {
                                        completion(isSuccess, error, true)
                                    })
                                } else {
                                    weakSelf.dismiss(animated: false, completion: nil)
                                }
                            }
                        })
                    } else {
                        weakSelf.dismiss(animated: true, completion: nil)
                    }
                    
                case LOGINRCkeys.invalidPublicKey:
                    if retryCount > 2 {
                        let updateRetryCount = (retryCount + 1)
                        weakSelf.verifyOTP(params, retryCount: updateRetryCount)
                    } else {
                        fallthrough
                    }
                    
                case LOGINRCkeys.badRequest,
                     LOGINRCkeys.issueProcessingRequest,
                     LOGINRCkeys.signatureTimeExpired,
                     LOGINRCkeys.invalidSignature,
                     LOGINRCkeys.authorizationMissing,
                     LOGINRCkeys.BEInvalidToken,
                     LOGINRCkeys.clientPermissionNotFound,
                     LOGINRCkeys.missingMandatoryHeaders,
                     LOGINRCkeys.invalidAuthCode,
                     LOGINRCkeys.invalidRefreshToken,
                     LOGINRCkeys.scopeNotRefreshable,
                     LOGINRCkeys.internalServerErr,
                     LOGINRCkeys.authErr:
                    let message = JRLoginConstants.generic_error_message
                    weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                    
                case LOGINRCkeys.unprocessableEntity,
                     LOGINRCkeys.accountBlocked,
                     LOGINRCkeys.otpLimitReach:
                    fallthrough
                    //JRAuthSessionExpiryMgr.openLogin()
                    
                default:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        weakSelf.view.showToast(toastMessage: (message), duration: 3.0)
                    } else {
                        let message = JRLoginConstants.generic_error_message
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                    }
                }
            }
        }
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
    
    @objc override func keyboardWillHide(notification:Notification) {
        otpViewBottomConstraint.constant = 0
    }
    
    @IBAction func loginToDifferentAccountAction(_ sender: Any) {
        loginToDifferentAccount()
    }
    
    @IBAction func confirmButtonTapped(_ sender: Any) {
        proceedButtonTapped()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        enterOTPTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    @IBAction func resendOTPTapped(_ sender: Any) {
        resendOTPApi()
    }
    
    private func resendOTPApi(retryCount: Int = 0) {
        guard let stateToken = state else {
            return
        }
        view.endEditing(true)
        view.isUserInteractionEnabled = false
        JRLServiceManager.resendOTP([LOGINWSKeys.kStateToken: stateToken]) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.view.isUserInteractionEnabled = true
                if let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String,
                    let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    
                    if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                        weakSelf.state = stateToken
                    }
                    switch responseCode {
                    case LOGINRCkeys.success:
                        weakSelf.enterOTPTextField.text = nil
                            
                    case LOGINRCkeys.invalidPublicKey:
                        if retryCount > 2 {
                            let updateRetryCount = (retryCount + 1)
                            weakSelf.resendOTPApi(retryCount: updateRetryCount)
                        } else {
                            fallthrough
                        }
                        
                    case LOGINRCkeys.badRequest,
                         LOGINRCkeys.issueProcessingRequest,
                         LOGINRCkeys.signatureTimeExpired,
                         LOGINRCkeys.invalidSignature,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.BEInvalidToken,
                         LOGINRCkeys.clientPermissionNotFound,
                         LOGINRCkeys.missingMandatoryHeaders,
                         LOGINRCkeys.invalidAuthCode,
                         LOGINRCkeys.invalidRefreshToken,
                         LOGINRCkeys.scopeNotRefreshable,
                         LOGINRCkeys.internalServerErr,
                         LOGINRCkeys.authErr:
                        weakSelf.showToast(with: JRLoginConstants.generic_error_message)
                        
                    case LOGINRCkeys.unprocessableEntity,
                         LOGINRCkeys.accountBlocked,
                         LOGINRCkeys.otpLimitReach:
                        fallthrough
                        //JRAuthSessionExpiryMgr.openLogin()
                        
                    default:
                        let message: String
                        if let msg = responseData[LOGINWSKeys.kMesssage] as? String {
                            message = msg
                        } else {
                            message = JRLoginConstants.generic_error_message
                        }
                        weakSelf.showToast(with: message)
                    }
                } else if let error = error {
                    if (error as NSError).code == 311 {
                        if retryCount < 2 {
                            let updateRetryCount = (retryCount + 1)
                            weakSelf.resendOTPApi(retryCount: updateRetryCount)
                        } else {
                            weakSelf.showToast(with: JRLoginConstants.generic_error_message)
                        }
                    } else {
                        weakSelf.showToast(with: error.localizedDescription)
                    }
                } else {
                    weakSelf.showToast(with: JRLoginConstants.generic_error_message)
                }
            }
        }
    }
    
    private func showToast(with message: String?) {
        let msg = (message ?? JRLoginConstants.generic_error_message)
        if let navCont = navigationController,
            let vc = navCont.topViewController {
            vc.view.showToast(toastMessage: msg, duration: 3.0)
        }
    }
}

extension JRLOTPPopUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Validate mobile number while editing
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: .mobileNumber, text: changedString)
        if isValid {
            return true
        }
        return false
    }
}
