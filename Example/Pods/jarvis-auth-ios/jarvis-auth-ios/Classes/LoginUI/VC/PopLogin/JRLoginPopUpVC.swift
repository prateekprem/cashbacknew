//
//  JRLoginPopUpVC.swift
//  Jarvis
//
//  Created by Sanjay Mohnani on 6/4/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation
import UIKit
import jarvis_utility_ios

class JRLoginPopUpVC: JRAuthBaseVC {
    
    @IBOutlet weak var loginId: UILabel!
    @IBOutlet weak var passwordTxtField: JRLFloatingTextField!
    @IBOutlet weak var loginPopUpBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var showPasswordBtn: UIButton!
    
    var viewModel: JRLOtpPsdVerifyModel?
    var completion: JRQuickLoginCompletion?
    
    //MARK: - instance creation
    @objc class func newInstance() -> JRLoginPopUpVC {
        let storyboard = UIStoryboard(name: "JRLFPopUp", bundle: JRLBundle)
        return storyboard.instantiateViewController(withIdentifier: "JRLoginPopUpVC") as! JRLoginPopUpVC
    }
    
    override func viewDidLoad(){
        super.viewDidLoad()
        initilize()
    }
    
    private func initilize() {
        loginId.text = viewModel?.loginId
        setUpTextField()
        JRUtility.enableUserInteractionWithUIControl()
    }
    
    func setUpTextField() {
        passwordTxtField.delegate = self
        passwordTxtField.isSecureTextEntry = true
        showPasswordBtn.isSelected = true
    }
    
    @IBAction func closeBtnAction(_ sender: Any) {
        guard let completion = self.completion else {
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true) {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_login_user_denied".localized])
            completion(false, error, false)
        }
    }
    
    @IBAction func loginSecurelyBtnAction(_ sender: Any) {
//        JRLoginGACall.signUpVerifyClicked()
        view.isUserInteractionEnabled = false
        activityIndicator.startAnimating()
        activityIndicator.isHidden = false
        guard let password = passwordTxtField.text, let viewModel = viewModel, let stateToken = viewModel.stateToken, let completion = self.completion else {
            dismiss(animated: true, completion: nil)
            return
        }
        
        JRAuthPasswordVM.validatePassword(password, stateToken: stateToken) { [weak self] (isSuccess, error) in
            DispatchQueue.main.async {
                self?.activityIndicator.startAnimating()
                self?.activityIndicator.isHidden = true
                self?.view.isUserInteractionEnabled = true
                
                if let isSuccess = isSuccess, isSuccess {
                    self?.view.endEditing(true)
                    self?.dismiss(animated: true, completion: {
                        completion(isSuccess, error, true)
                    })
                } else if let message = error?.localizedDescription, !message.isEmpty {
                    self?.view.showToast(toastMessage: message, duration: 3.0)
                } else {
                    self?.view.showToast(toastMessage: JRLoginConstants.generic_error_message, duration: 3.0)
                }
            }
        }
    }
    
    @IBAction func showBtnAction(_ sender: Any) {
        if showPasswordBtn.isSelected {
            showPasswordBtn.isSelected = false
            passwordTxtField.isSecureTextEntry = false
        }else {
            showPasswordBtn.isSelected = true
            passwordTxtField.isSecureTextEntry = true
        }
    }
    
    @IBAction func forgotPasswordBtnAction(_ sender: Any) {
        guard let loginId = viewModel?.loginId else {
            return
        }
        JRLoginUI.sharedInstance().initiateForgotPwdFlowV2(withMobileNumber: loginId)
    }
    
    @IBAction func loginToDifferentAccAction(_ sender: Any) {
        guard let completion = self.completion else {
            dismiss(animated: true, completion: nil)
            return
        }
        dismiss(animated: true) {
            let error = NSError(domain: "", code: -1, userInfo: [NSLocalizedDescriptionKey: "jr_ac_loginToADiffActBtnTitle".localized])
            completion(false, error, false)
        }
    }
    
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue{
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            loginPopUpBottomConstraint.constant = keyboardSize.height - safeAreaBottomInset
        }
    }

    @objc override func keyboardWillHide(notification:Notification) {
        loginPopUpBottomConstraint.constant = 0
    }

}

extension JRLoginPopUpVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if(textField == passwordTxtField) && string == " " { return false}
        return true
    }
}
