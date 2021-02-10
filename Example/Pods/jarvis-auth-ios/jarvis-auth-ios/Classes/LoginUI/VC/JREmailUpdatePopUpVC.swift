//
//  JREmailUpdatePopUpVC.swift
//  jarvis-auth-ios
//
//  Created by Alok Chaturvedi on 06/04/20.
//

import UIKit
import jarvis_utility_ios

public protocol JREmailUpdateDelegate: class {
    func updateEmailDidClicked(_ email: String)
}


class JREmailUpdatePopUpVC: JRAuthBaseVC {
    
    @IBOutlet weak var updateHeaderLabel: UILabel!
    @IBOutlet weak var updateSubHeaderLabel: UILabel!
    @IBOutlet weak var updateEmailTextField: UITextField!
    @IBOutlet weak var updateEmailButton: UIButton!
    @IBOutlet weak var emailViewBottomConstraint: NSLayoutConstraint!
    
    var headerText: String?
    var subHeaderText: String?
    var ctaBtnText: String?
    weak var delegate: JREmailUpdateDelegate?
    
    //MARK:- Instance
    class func newInstance(header: String?, subHeader: String?, btnText: String?, delegate: JREmailUpdateDelegate?) -> JREmailUpdatePopUpVC {
        let vc = JRAuthManager.kEmailUpdateStoryboard.instantiateViewController(withIdentifier: "JREmailUpdatePopUpVC") as! JREmailUpdatePopUpVC
        vc.headerText = header
        vc.subHeaderText = subHeader
        vc.ctaBtnText = btnText
        vc.delegate = delegate
        return vc
    }
    
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
       
    @objc override func keyboardWillShow(notification:Notification){
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue {
            var safeAreaBottomInset: CGFloat = 0;
            if #available(iOS 11.0, *) {
                safeAreaBottomInset = view.safeAreaInsets.bottom
            }
            emailViewBottomConstraint.constant = keyboardSize.height - safeAreaBottomInset
        }
    }
    
    private func initialSetUp() {
        
        let btnTitle: String
        if let email = LoginAuth.sharedInstance().getEmail(), !email.isEmpty {
            updateHeaderLabel.text = (headerText ?? "jr_email_update_header".localized)
            updateSubHeaderLabel.text = (subHeaderText ?? "jr_email_update_sub_header".localized)
            btnTitle = (ctaBtnText ?? "jr_email_update_button".localized)
            
        } else {
            updateHeaderLabel.text = (headerText ?? "jr_email_add_header".localized)
            updateSubHeaderLabel.text = (subHeaderText ?? "jr_email_add_sub_header".localized)
            btnTitle = (ctaBtnText ?? "jr_email_add_button".localized)
        }
        
        let buttonStates: [UIControl.State] = [.normal, .highlighted, .selected, .disabled]
        buttonStates.forEach { state in
            updateEmailButton.setTitle(btnTitle, for: state)
        }
        
        self.updateEmailTextField.delegate = self
        self.updateEmailTextField.keyboardType = .emailAddress
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
        guard let email = updateEmailTextField.text, !email.isEmpty, email.isValidEmail() else {
            showError(text: "Please enter valid email")
            return
        }
        if isNetworkReachable() {
            self.dismiss(animated: true) { [weak self] in
                if let weakSelf = self, let delegate = weakSelf.delegate {
                    delegate.updateEmailDidClicked(email)
                }
                else{
                    if (email == LoginAuth.sharedInstance().getEmail()) {
                        let msg = "jr_login_email_already_linked".localized
                        
                        if let topVC = UIApplication.topViewController(){
                            DispatchQueue.main.async {
                                let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                                    JRLoginUI.sharedInstance().updateEmailAddress(delegate: nil)
                                }
                                alert.addAction(okAction)
                                topVC.present(alert, animated: true, completion: nil)
                            }
                        }
                    } else {
                        let nav: UINavigationController! = UIApplication.topVC()?.navigationController
                            JRLoginUI.sharedInstance().openEmailUpdateFlow(for: email, on: nav) { [weak self] (success, errorMsg) in
                                if !success, let msg = errorMsg, let topVC = UIApplication.topViewController(){
                                    DispatchQueue.main.async {
                                        let alert = UIAlertController(title: "", message: msg, preferredStyle: .alert)
                                        let okAction = UIAlertAction(title: "jr_login_ok".localized.uppercased(), style: .default) { _ in
                                            JRLoginUI.sharedInstance().updateEmailAddress(delegate: nil)
                                        }
                                        alert.addAction(okAction)
                                        topVC.present(alert, animated: true, completion: nil)
                                    }
                                }
                            }
                    }
                }
            }
        }
    }
    
    
    @objc override func keyboardWillHide(notification:Notification) {
        emailViewBottomConstraint.constant = 0
        
    }
    
    @IBAction func emailUpdateButtonTapped(_ sender: Any) {
        proceedButtonTapped()
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        updateEmailTextField.endEditing(true)
        self.dismiss(animated: true, completion: nil)
    }
    
}

extension JREmailUpdatePopUpVC:UITextFieldDelegate{
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Validate mobile number while editing
        let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
        let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: .emailAddress, text: changedString)
        if isValid {
            return true
        }
        return false
    }
}

