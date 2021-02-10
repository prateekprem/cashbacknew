//
//  JRGetHelpWithAccountVC.swift
//  jarvis-auth-ios
//
//  Created by Aakash Srivastava on 27/10/20.
//

import UIKit

class JRGetHelpWithAccountVC: JRAuthPopupVC {

    @IBOutlet weak private var numberTextField: UITextField!
    @IBOutlet weak private var highlightingIndicatorView: UIView!
    @IBOutlet weak private var proceedBtn: UIButton!
    @IBOutlet weak private var proceedContainerView: UIView!
    @IBOutlet weak private var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak private var viewBottomConstraint: NSLayoutConstraint!
    
    private var prefilledPhoneNumber: String?
    private var shouldAutoInitiateVerification = false
    private let bottomConstraintDefaultValue: CGFloat = 16.0
    
    class func getController(for number: String?) -> JRGetHelpWithAccountVC? {
        if let controller = JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRGetHelpWithAccountVC") as? JRGetHelpWithAccountVC {
            controller.prefilledPhoneNumber = number
            controller.modalPresentationStyle = .overCurrentContext
            return controller
        }
        return nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        if let phoneNumber = prefilledPhoneNumber, !phoneNumber.isEmpty {
            numberTextField.text = phoneNumber//.phoneNumberFromatter
            shouldAutoInitiateVerification = true
        } else {
            setProceedBtn(enabled: false)
        }
        numberTextField.delegate = self
        numberTextField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        proceedContainerView.makeRoundedBorder(withCornerRadius: 6.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if shouldAutoInitiateVerification,
            let phoneNumber = prefilledPhoneNumber, !phoneNumber.isEmpty {
            shouldAutoInitiateVerification = false
            initiateVerification(for: phoneNumber)
        }
    }
    
    override func didShowPopup() {
        numberTextField.becomeFirstResponder()
    }
    
    @objc override func keyboardWillShow(notification: Notification) {
        if let userInfo = notification.userInfo,
            let endFrame = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let actualFrame = proceedContainerView.convert(proceedContainerView.bounds, to: view)
            let padding: CGFloat = 8.0
            let projectedBottom = (actualFrame.maxY - endFrame.cgRectValue.minY + bottomConstraintDefaultValue + padding)
            viewBottomConstraint.constant = max(bottomConstraintDefaultValue, projectedBottom)
        }
    }
    
    @objc override func keyboardWillHide(notification: Notification) {
        viewBottomConstraint.constant = bottomConstraintDefaultValue
    }
}

private extension JRGetHelpWithAccountVC {
    
    @IBAction func closeBtnTapped(_ sender: UIButton) {
        hidePopup { [weak self] in
            if let weakSelf = self {
                weakSelf.dismiss(animated: false, completion: nil)
            }
        }
    }
    
    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        if let text = numberTextField.text, !text.isEmpty {
            let phoneNumber = text.digits
            if phoneNumber.isValidIndianPhoneNumber {
                initiateVerification(for: phoneNumber)
            } else {
                showError(text: "jr_ac_validMobileNumber".localized)
            }
        } else {
            showError(text: "jr_login_enter_mobile_number".localized)
        }
        /*
        let verifyPasscodeScene = JRVerifyPasscodeVC.getController(number: "number", stateCode: "stateCode", verifierId: "verifierId", encryptionKey: "encryptionKey", encryptionSalt: "encryptionSalt")
        moveTo(controller: verifyPasscodeScene)
        */
    }
    
    @objc func textFieldDidChange(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            textField.text = text//.phoneNumberFromatter
            let phoneNumber = text.digits
            setProceedBtn(enabled: phoneNumber.isValidIndianPhoneNumber)
        } else {
            setProceedBtn(enabled: false)
        }
    }
    
    func setProceedBtn(enabled: Bool) {
        proceedBtn.isEnabled = enabled
        proceedBtn.alpha = (enabled ? 1.0 : 0.5)
    }
    
    func initiateVerification(for number: String) {
        
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        
        let params = ["bizFlow": "ACCOUNT_BLOCK_VERIFY",
                      "anchor": number,
                      "anchorType": "MOBILE_NO"]
        
        JRLServiceManager.verifierInitV2(params) { (response, error) in
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else {
                    return
                }
                
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode"),
                    let message = response.getOptionalStringForKey("message") {
                    
                    switch responseCode {
                        
                    case LOGINRCkeys.internalServerError2AB,
                         LOGINRCkeys.authorizationMissing,
                         LOGINRCkeys.deviceAlreadyUpgraded:
                        let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                        weakSelf.showError(text: message)
                        weakSelf.loadingIndicatorView.isHidden = true
                        weakSelf.view.isUserInteractionEnabled = true
                        
                    case LOGINRCkeys.successBE:
                        if let stateCode = response.getOptionalStringForKey("stateCode"),
                            //let verificationMethods = response.getArrayKey("stateCode") as? [String],
                            let verifierId = response.getOptionalStringForKey("verifierId") {
                            
                            //let methods = verificationMethods.compactMap { JRBlockUnblockVerificationMethod(rawValue: $0) }
                            weakSelf.doViewApi(number: number, stateCode: stateCode, verifierId: verifierId)
                        } else {
                            fallthrough
                        }
                        
                    case LOGINRCkeys.verificationCannotBeFulfilled,
                         LOGINRCkeys.userDoesNotExist,
                         LOGINRCkeys.userAlreadyBlocked,
                         LOGINRCkeys.limitReachedForDevice,
                         LOGINRCkeys.limitReachedForIP:
                        //weakSelf.showTerminalAlert(with: message)
                        let state: JRBlockUnblockState
                        if responseCode == LOGINRCkeys.userAlreadyBlocked {
                            state = .alreadyBlocked
                        } else if (responseCode == LOGINRCkeys.limitReachedForDevice) || (responseCode == LOGINRCkeys.limitReachedForIP) {
                            state = .blockLimitReached
                        } else {
                            state = .blockError
                        }
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: state, message: message)
                        weakSelf.moveTo(controller: terminalScene)
                        weakSelf.loadingIndicatorView.isHidden = true
                        weakSelf.view.isUserInteractionEnabled = true
                        
                    default:
                        weakSelf.showError(text: message)
                        weakSelf.loadingIndicatorView.isHidden = true
                        weakSelf.view.isUserInteractionEnabled = true
                    }
                    
                } else if let error = error {
                    weakSelf.showError(text: error.localizedDescription)
                    weakSelf.loadingIndicatorView.isHidden = true
                    weakSelf.view.isUserInteractionEnabled = true
                    
                } else {
                    let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                    weakSelf.showError(text: message)
                    weakSelf.loadingIndicatorView.isHidden = true
                    weakSelf.view.isUserInteractionEnabled = true
                }
            }
        }
    }
    
    func doViewApi(number: String, stateCode: String, verifierId: String) {
        
        let params = ["verifyId": verifierId,
                      "method": "PASSCODE"]
        
        JRLServiceManager.doView(params, isLoginFlow: false) { (response, error) in
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else {
                    return
                }
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                
                if let response = response,
                    let httpStatus = response.getOptionalStringForKey("httpStatus"),
                    let resultInfo = response.getOptionalDictionaryKey("resultInfo"),
                    let message = resultInfo.getOptionalStringForKey("resultMsg") {
                    
                    if (httpStatus == LOGINRCkeys.success200),
                        let resultStatus = resultInfo.getOptionalStringForKey("resultStatus"),
                        resultStatus == "S",
                        let renderData = response.getOptionalDictionaryKey("renderData"),
                        let encryptionKey = renderData.getOptionalStringForKey("account_encrypt_pubkey"),
                        let encryptionSalt = renderData.getOptionalStringForKey("account_encrypt_salt") {
                        
                        let verifyPasscodeScene = JRVerifyPasscodeVC.getController(number: number, stateCode: stateCode, verifierId: verifierId, encryptionKey: encryptionKey, encryptionSalt: encryptionSalt)
                        weakSelf.moveTo(controller: verifyPasscodeScene)
                        
                    } else {
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .blockError, message: message)
                        weakSelf.moveTo(controller: terminalScene)
                    }
                    
                } else if let error = error {
                    weakSelf.showError(text: error.localizedDescription)
                    
                } else {
                    let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                    weakSelf.showError(text: message)
                }
            }
        }
    }
    
    func moveTo(controller: UIViewController) {
        hidePopup { [weak self] in
            if let weakSelf = self,
                let navCont = weakSelf.presentingViewController as? UINavigationController {
                weakSelf.dismiss(animated: false, completion: nil)
                navCont.pushViewController(controller, animated: true)
            }
        }
    }
}

extension JRGetHelpWithAccountVC: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let prevText = textField.text,
           let textRange = Range(range, in: prevText) {
           let updatedText = prevText.replacingCharacters(in: textRange, with: string)
            return (updatedText.digits.count <= 10)
        }
        return true
    }
}
