// JRLMobilePopUpVC.swift
// Login
//
//  Created by Parmod on 31/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_utility_ios

class JRLMobilePopUpVC: JRAuthBaseVC {
    
    @IBOutlet weak var mobileNumberTextField: JRLFloatingTextField!
    @IBOutlet weak var addMobileViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    
    static func controller() -> JRAuthBaseVC? {
        let vc = UIStoryboard(name: "JRLFPopUp", bundle:JRLBundle).instantiateViewController(withIdentifier: "JRLMobilePopUpVC") as? JRLMobilePopUpVC
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetUp()
//        JRLoginGACall.signUpAddMobileNumberPopupLoaded()
    }
    
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            addMobileViewBottomConstraint.constant = keyboardSize.height - safeAreaBottomInset
        }
    }

    private func initialSetUp() {
        closeButton.isHidden = true
        self.mobileNumberTextField.text = nil
        self.mobileNumberTextField.delegate = self
        self.mobileNumberTextField.keyboardType = .numberPad
        self.mobileNumberTextField.isSecureTextEntry = false
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
    
    @objc private func proceedButtonAction() {
        view.endEditing(true)

        guard let mobileNumber = mobileNumberTextField.text, !mobileNumber.isEmpty else {
            view.showToast(toastMessage: "jr_kyc_enter_mobile_number".localized, duration: 3.0)
            return
        }
        
        let (isValid, errorMsg) = JRLoginTextFieldValidation.validateTextForTextFieldType(textFieldType: .mobileNumber, text: mobileNumber)
        guard isValid else {
            if let errorMsg = errorMsg {
                view.showToast(toastMessage: errorMsg, duration: 3.0)
            }
            return
        }
        
        view.isUserInteractionEnabled = false
        LoginAuth.sharedInstance().getV2UserPhone(mobileNumber) { [weak self] (data, response, error) in
            DispatchQueue.main.async {
                self?.view.isUserInteractionEnabled = true
                if let error = error {
                    self?.dismiss(animated: true, completion: {
                        self?.view.showToast(toastMessage: error.localizedDescription, duration: 3.0)
                    })
                    return
                }
                
                guard let data = data as? [String: Any], let status = data[LOGINWSKeys.kStatus] as? String else {
                    self?.dismiss(animated: true, completion: nil)
                    return
                }
                
                if status.uppercased() == "SUCCESS", let responseCode = data[LOGINWSKeys.kResponseCode] as? String {
                    switch responseCode {
                    case "03", "04":
                        self?.dismiss(animated: false, completion: {
                            if let vc = JRLOTPPopUpVC.controller() as? JRLOTPPopUpVC {
                                vc.state = data["state"] as? String
                                vc.mobileNumber = self?.mobileNumberTextField.text
                                vc.modalPresentationStyle = .overFullScreen
                                UIApplication.topViewController()?.present(vc, animated: true, completion: nil)
                            }
                        })
                    case "826":
                        self?.dismiss(animated: true, completion: {
                            if let message = data[LOGINWSKeys.kMesssage] as? String {
                                self?.view.showToast(toastMessage: message, duration: 3.0)
                            }
                        })
                    default: break
                    }
                } else if status.uppercased() == "FAILURE" {
                    if let message = data[LOGINWSKeys.kMesssage] as? String {
                        self?.view.showToast(toastMessage: message, duration: 3.0)
                    }
                } else {
                    self?.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                }
            }
        }

//        if let vc = JRLAddMobPassDataModel.getControllerFor(viewModel.nextAction) {
//            self.present(vc, animated: true, completion: nil)
//        }
    }
    
    @objc override func keyboardWillHide(notification:Notification){
        addMobileViewBottomConstraint.constant = 0
    }
    
    @IBAction func loginToDifferentAccountAction(_ sender: Any) {
        loginToDifferentAccount()
    }

    @IBAction func closeButtonTapped(_ sender: Any) {
//        JRLoginGACall.signUpCrossBtnClicked()
        mobileNumberTextField.endEditing(true)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func proceedButtonTapped(_ sender: Any) {
        proceedButtonAction()
    }
}

extension JRLMobilePopUpVC:UITextFieldDelegate{
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
