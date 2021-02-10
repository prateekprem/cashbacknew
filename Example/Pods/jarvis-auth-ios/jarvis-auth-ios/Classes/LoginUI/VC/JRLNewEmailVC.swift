//
//  JRLNewEmailVC.swift
//  Branch
//
//  Created by Aakash Srivastava on 08/07/20.
//

import UIKit

class JRLNewEmailVC: JRAuthBaseVC {

    @IBOutlet var textField: JRLFloatingTextField!
    @IBOutlet var errorLabel: UILabel!
    @IBOutlet var proceedBtn: UIButton!
    
    @IBOutlet var textFieldTopConstraint: NSLayoutConstraint!
    @IBOutlet var proceedBtnTopConstraint: NSLayoutConstraint!
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    @objc class var newInstance: JRLNewEmailVC {
        let bundle = Bundle(for: JRLNewEmailVC.self)
        let stBrd: UIStoryboard = UIStoryboard(name: "JRLOTPViaEmail", bundle: bundle)
        return stBrd.instantiateViewController(withIdentifier: "JRLNewEmailVC") as! JRLNewEmailVC
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if self.deviceHeight < 667.0 {
            textFieldTopConstraint.constant = 25.0
            proceedBtnTopConstraint.constant = 5.0
        } else {
            textFieldTopConstraint.constant = 60.0
            proceedBtnTopConstraint.constant = 60.0
        }

        textField.placeholder = "jr_login_email_id".localized
        textField.keyboardType = .emailAddress
        textField.delegate = self
        proceedBtn.layer.cornerRadius = 4.0
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        _ = textField.becomeFirstResponder()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        if self.deviceHeight < 667.0 {
            setResignFirstResponder()
        }
    }
    
    private func setResignFirstResponder() {
        _ = textField.resignFirstResponder()
    }
    
    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        if let email = textField.text, !email.isEmpty {
            if (email == LoginAuth.sharedInstance().getEmail()) {
                let message = "\("jr_login_email_already_linked".localized)"
                showEmailLinkedAlert(with: message)
            } else {
                if email.isValidEmail() {
                    updateEmail(email)
                } else {
                    showError("jr_login_enter_valid_email_address".localized)
                }
            }
        } else {
            showError("jr_login_enter_email_address".localized)
        }
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
}

private extension JRLNewEmailVC {
    
    func showEmailLinkedAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_ac_OK".localized, style: .default) { [weak self] _ in
            if let weakSelf = self {
                weakSelf.textField.text = ""
                _ = weakSelf.textField.becomeFirstResponder()
            }
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func showError(_ message: String) {
        // CAI-31355: Remove inline messages
        //errorLabel.text = message
        //errorLabel.isHidden = false
        view.showToast(toastMessage: message, duration: 3.0)
    }
    
    func hideError() {
        // CAI-31355: Remove inline messages
        //errorLabel.text = nil
        //errorLabel.isHidden = true
    }
    
    func updateEmail(_ email: String) {
        guard let model = dataModel, let token = model.stateToken, !token.isEmpty else {
            return
        }
        let params = ["email": email, "state_token": token]
        view.isUserInteractionEnabled = false
        
        JRLServiceManager.updateEmail(params) { [weak self] (response, error) in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.view.isUserInteractionEnabled = true
                let genericMessage = JRLoginConstants.generic_error_message
                
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode"),
                    let message = response.getOptionalStringForKey("message") {
                    
                    switch responseCode {
                    case LOGINRCkeys.successBE:
                        let stateToken = response.getStringKey("state")
                        weakSelf.moveToVerifyEmailOTP(with: stateToken, email: email)
                        
                    case LOGINRCkeys.unprocessableEntity,
                         LOGINRCkeys.emptyStateToken,
                         LOGINRCkeys.invalidStateToken,
                         LOGINRCkeys.stateTokenMethodNotSupported,
                         LOGINRCkeys.stateTokenMethodNotSupportedBE,
                         LOGINRCkeys.authorizationAndClientIdMismatch,
                         //LOGINRCkeys.signatureTimeExpired,
                         LOGINRCkeys.invalidSignature,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.invalidAuthCode,
                         LOGINRCkeys.clientPermissionNotFound,
                         LOGINRCkeys.missingMandatoryHeaders,
                         LOGINRCkeys.invalidTokenBE,
                         LOGINRCkeys.invalidRefreshToken,
                         LOGINRCkeys.scopeNotRefreshable:
                        weakSelf.showMoveBackErrorAlert(with: genericMessage)
                        
                    case LOGINRCkeys.noChangesDone,
                         LOGINRCkeys.otpLimitReach,
                         LOGINRCkeys.otpLimitReachedBE,
                         LOGINRCkeys.emailCannotBeChanged:
                        weakSelf.showMoveBackErrorAlert(with: message)
                        
                    case LOGINRCkeys.emailAlreadyLinked:
                        weakSelf.showEmailLinkedAlert(with: message)
                        
                    case LOGINRCkeys.invalidEmail:
                        fallthrough
                        
                    default:
                        weakSelf.view.showToast(toastMessage: message, duration: 3.0)
                    }
                    
                } else if let error = error {
                    weakSelf.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                } else {
                    weakSelf.view.showToast(toastMessage: genericMessage, duration: 3.0)
                }
            }
        }
    }
    
    func moveToVerifyEmailOTP(with stateToken: String, email: String) {
        if let model = dataModel {
            model.stateToken = stateToken
            model.otpTextCount = 6
            let emailOtpScene = JRPUEmailOtpVC.controller(model)
            emailOtpScene.email = email
            pushUpdatingNavigationStack(viewController: emailOtpScene)
        }
    }
    
    func showMoveBackErrorAlert(with message: String) {
        let alert = UIAlertController(title: "", message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { [weak self] _ in
            self?.navigationController?.popViewController(animated: true)
        }
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func pushUpdatingNavigationStack(viewController: UIViewController) {
        guard let navCont = navigationController else {
            return
        }
        var viewControllers = [UIViewController]()
        for controller in navCont.viewControllers {
            if controller != self {
                viewControllers.append(controller)
            } else {
                break
            }
        }
        viewControllers.append(viewController)
        navCont.setViewControllers(viewControllers, animated: true)
    }
}

extension JRLNewEmailVC: UITextFieldDelegate {
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        hideError()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        hideError()
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: .emailAddress, text: changedString)
        if isValid {
            return true
        }
        return false
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
