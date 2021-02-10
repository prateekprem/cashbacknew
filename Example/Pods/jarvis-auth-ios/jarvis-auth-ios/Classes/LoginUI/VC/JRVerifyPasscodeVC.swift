//
//  JRVerifyPasscodeVC.swift
//  jarvis-auth-ios
//
//  Created by Aakash Srivastava on 27/10/20.
//

import jarvis_utility_ios

class JRVerifyPasscodeVC: JRAuthBaseVC {

    @IBOutlet weak private var otpTextField: JRLOTPTextFieldView!
    @IBOutlet weak private var proceedContainerView: UIView!
    @IBOutlet weak private var loadingIndicatorView: JRLoadingIndicatorView!
    @IBOutlet weak private var errorLabel: UILabel!
    
    private var number: String = ""
    private var stateCode: String = ""
    private var verifierId: String = ""
    private var encryptionKey: String = ""
    private var encryptionSalt: String = ""
    private var passcode: String = ""
    
    class func getController(number: String, stateCode: String, verifierId: String, encryptionKey: String, encryptionSalt: String) -> JRVerifyPasscodeVC {
        let controller = JRAuthManager.kDIYAccountBlockUnblockStoryboard.instantiateViewController(withIdentifier: "JRVerifyPasscodeVC") as! JRVerifyPasscodeVC
        controller.number = number
        controller.stateCode = stateCode
        controller.verifierId = verifierId
        controller.encryptionKey = encryptionKey
        controller.encryptionSalt = encryptionSalt
        return controller
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        otpTextField.delegate = self
        otpTextField.setUpUI(count: 4, borderStyle: .none, isSecureTextEntry: true)
        proceedContainerView.makeRoundedBorder(withCornerRadius: 6.0)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        setFirstResponder()
    }
}

private extension JRVerifyPasscodeVC {
    
    @IBAction func showHidePassccodeBtnTapped(_ sender: UIButton) {
        sender.isSelected.toggle()
        otpTextField.setUpUI(count: 4, borderStyle: .none, isSecureTextEntry: !sender.isSelected)
        setFirstResponder()
    }
    
    @IBAction func forgotPasscodeBtnTapped(_ sender: UIButton) {
        let header = "jr_login_dabu_forgot_passcode".localized
        let message = "jr_login_dabu_forgot_passcode_info_message".localized
        let controller = JRBlockUnblockMessageVC.getController(header: header, message: message)
        present(controller, animated: false)
    }
    
    @IBAction func backBtnTapped(_ sender: UIButton) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func proceedBtnTapped(_ sender: UIButton) {
        if passcode.isEmpty {
            showInlineError(text: "jr_login_dabu_enter_passcode_to_continue".localized)
        } else if (passcode.length < 4) {
            showInlineError(text: "jr_login_dabu_enter_valid_passcode_to_continue".localized)
        } else {
            doVerifyApi()
            hideInlineError()
        }
    }
    
    func setFirstResponder() {
        if passcode.count == 4 {
            otpTextField.setTextFieldFirstResponder(index: 3)
        } else {
            otpTextField.setTextFieldFirstResponder(index: passcode.count)
        }
    }
    
    func doVerifyApi() {
        
        guard let delegate = LoginAuth.sharedInstance().delegate,
            let encryptedPasscode = delegate.encryptDataWithRSAKey((passcode + encryptionSalt), encryptionKey) else {
                let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                showError(text: message)
                return
        }
        
        UIView.animate(withDuration: 0.1) {
            self.loadingIndicatorView.isHidden = false
            self.loadingIndicatorView.showLoadingView()
        }
        view.isUserInteractionEnabled = false
        
        let data = ["data": encryptedPasscode]
        let params = ["verifyId": verifierId,
                      "method": "PASSCODE",
                      "validateData": JRAuthUtility.serializedString(from: data)]
        
        JRLServiceManager.doVerify(params, isLoginFlow: false) { (response, error) in
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else {
                    return
                }
                
                if let response = response,
                   let resultInfo = response.getOptionalDictionaryKey("resultInfo"),
                   let message = resultInfo.getOptionalStringForKey("resultMsg"),
                   let resultStatus = resultInfo.getOptionalStringForKey("resultStatus") {
                    
                    if resultStatus == "S" {
                        weakSelf.fulfillApi()
                        
                    } else if resultStatus == "F",
                              response.booleanFor(key: "canRetry") {
                        
                        weakSelf.showInlineError(text: message)
                        weakSelf.loadingIndicatorView.isHidden = true
                        weakSelf.view.isUserInteractionEnabled = true
                        
                    } else {
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .blockError, message: message)
                        weakSelf.moveTo(controller: terminalScene)
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
    
    func fulfillApi() {
        
        let params = ["stateCode": stateCode]
        
        JRLServiceManager.fulfill(params) { (response, error) in
            DispatchQueue.main.async { [weak self] in
                
                guard let weakSelf = self else {
                    return
                }
                weakSelf.loadingIndicatorView.isHidden = true
                weakSelf.view.isUserInteractionEnabled = true
                
                if let response = response,
                    let responseCode = response.getOptionalStringForKey("responseCode"),
                    let message = response.getOptionalStringForKey("message") {
                    
                    switch responseCode {
                        
                    case LOGINRCkeys.internalServerError2AB,
                         LOGINRCkeys.deviceAlreadyUpgraded:
                        let message = "jr_login_something_went_wrong_please_try_after_sometime".localized
                        weakSelf.showError(text: message)
                        
                    case LOGINRCkeys.successBE:
                        if let code = response.getOptionalStringForKey("stateCode"),
                            let blockReason = JRDIYAccountBlockReasonVC.getController(verificationType: .stateCode(code, weakSelf.number)) {
                            weakSelf.moveTo(controller: blockReason)
                        } else {
                            fallthrough
                        }
                        
                    case LOGINRCkeys.invalidStateToken,
                         LOGINRCkeys.userVerificationFailed,
                         LOGINRCkeys.userVerificationPending,
                         LOGINRCkeys.invalidAuthorization:
                        //weakSelf.showTerminalAlert(with: message)
                        let terminalScene = JRDIYAccountBlockTerminalVC.getController(state: .blockError, message: message)
                        weakSelf.moveTo(controller: terminalScene)
                        
                    default:
                        weakSelf.showError(text: message)
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
        pushViewControllerByRemovingLast(controller, animated: true)
    }
    
    func showInlineError(text: String) {
        errorLabel.text = text
        errorLabel.isHidden = false
    }
    
    func hideInlineError() {
        errorLabel.isHidden = true
    }
}

extension JRVerifyPasscodeVC: JRLOTPTextFieldViewDelegate {
    
    func didEnterOTP(otp: String) {
        passcode = otp
        hideInlineError()
    }
    
    func showHideOTPErrorLbl(isHidden: Bool) {
        hideInlineError()
    }
}
