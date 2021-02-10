//
//  JRLNewMobileNoVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 20/01/20.
//

import UIKit

class JRLNewMobileNoVC: JRAuthBaseVC {

    @IBOutlet var titleLbl: UILabel!
    @IBOutlet var countryCodeLbl: UILabel!
    @IBOutlet var textField: UITextField!
    @IBOutlet var errorMsgLbl: UILabel!
    @IBOutlet var backBtn: UIButton!
    
    var dataModel: JRLOtpPsdVerifyModel?
    
    @IBAction func onBackBtnTouch(_ sender: UIButton) {
        if dataModel?.isLoginFlow == true{
            navigationController?.popToRootViewController(animated: true)
        }
        else if let dataModel = dataModel{
            let loginType = dataModel.loginType
            switch loginType
            {
            case .mobile, .email:
//                JRLoginGACall.loginBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            case .newAccount:
//                JRLoginGACall.signUpBackBtnClicked()
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }else if controller.isKind(of: JRAuthSignInVC.self){
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
        }
        else{
            navigationController?.popViewController(animated: true)
        }
    }
    
    //MARK:-Instance
    static func controller(_ dataModel: JRLOtpPsdVerifyModel) -> JRLNewMobileNoVC {
        let vc = UIStoryboard.init(name: "JRLOTPViaEmail", bundle: JRLBundle).instantiateViewController(withIdentifier: "JRLNewMobileNoVC") as! JRLNewMobileNoVC
        vc.dataModel = dataModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpProceedButton()
        errorMsgLbl.isHidden = true
        textField.keyboardType = .numberPad
        textField.delegate = self
        // Do any additional setup after loading the view.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        textField.becomeFirstResponder()
    }
    
    private func setUpProceedButton() {
        let proceedButton:UIButton = UIButton(frame: CGRect(x: 0, y: 0, width: 1, height: 55))
        proceedButton.backgroundColor = LOGINCOLOR.blue
        proceedButton.setTitle("jr_login_proceed_securely".localized, for: .normal)
        proceedButton.setImage(UIImage(named: "lock"), for: .normal)
        proceedButton.imageEdgeInsets = UIEdgeInsets(top: -4, left: -13, bottom: 0, right: 0)
        proceedButton.addTarget(self, action:#selector(self.proceedButtonTapped), for: .touchUpInside)
        textField.inputAccessoryView = proceedButton
    }
    
    @objc private func proceedButtonTapped() {
            self.view.endEditing(true)
            if let jarvisLoginType = self.dataModel?.loginType {
                let (isValid, errorMessage) = JRLoginTextFieldValidation.validateTextForTextFieldType(textFieldType: JRLViewModel.txtFieldType(jarvisLoginType), text: textField.text)
                if isValid, let _ =  textField.text {
                    switch jarvisLoginType {
                    case .email, .mobile:
                        if self.dataModel?.loginType == .mobile{
                            if let number = textField.text{
                                if number.isEmpty{
                                    self.view.showToast(toastMessage: "jr_login_mobile_number_cannot_be_empty".localized, duration: 3.0)
                                    return
                                }
                                else if !isValidMobileNumber(number){
                                    self.view.showToast(toastMessage: "jr_kyc_please_enter_valid_mobile_number".localized, duration: 3.0)
                                    return
                                }else{
                                    sendUserPhoneNumber()
                                }
                            }
                        }
                    default:
                        break
                    }
                }
                else {
                    if var errorMsg = errorMessage {
                        if self.dataModel?.loginType == .mobile{
                            if let number = textField.text, number.isEmpty{
                                errorMsg = "jr_login_mobile_number_cannot_be_empty".localized
                            }
                        }
                        self.view.showToast(toastMessage: errorMsg, duration: 3.0)
                    }
                }
            } else {
                //TODO:PARMOD
            }
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */
    
    private func isValidMobileNumber(_  number: String) -> Bool{
        //"^[7-9][0-9]{9}$"
        //MOB_NO_REG_EX = "^([6,7,8,9]{1}+[0-9]{9})$";
        //Please enter valid Mobile Number
        let mobileNumberRegx = "[56789][0-9]{9}"
        let mobileNumberPredicate = NSPredicate(format:"SELF MATCHES %@", mobileNumberRegx)
        let isValidMobileNumber =  mobileNumberPredicate.evaluate(with: number)
        return isValidMobileNumber
    }
    
    //OTP via Email Related changes
    func sendUserPhoneNumber() {
        guard let dataModel = dataModel, let stateToken = dataModel.stateToken, let phoneNumber = textField.text  else {
            return
        }
        if let vc = JRLVerifyVC.controller("jr_login_verifying_your_details".localized) {
            navigationController?.pushViewController(vc, animated: true)
        }
        let params: [String: String] = ["phone_number": phoneNumber, "state_token": stateToken]
        JRLServiceManager.setNewPhoneNo(params) { [weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            DispatchQueue.main.async {
                weakSelf.navigationController?.popViewController(animated: false)
                if error != nil {
                    if let message = error?.localizedDescription {
                        weakSelf.showSettingsAlert(message)
                    } else {
                        weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                    }
                    return
                }
                if let responseData = data, let status = responseData[LOGINWSKeys.kStatus] as? String,let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                    if let state = responseData["state"] as? String, status == "SUCCESS", responseCode == "03" {
                        if let dataModel = weakSelf.dataModel{
                            let dataModel = dataModel
                            dataModel.stateToken = state
                            dataModel.otpTextCount = 6
                            let vc = JRLVerifyNewOTPVC.controller(dataModel)
                            if let message = responseData["message"] as? String{
                                vc.message = message
                            }
                            vc.mobileNo = phoneNumber
                            weakSelf.navigationController?.pushViewController(vc, animated: true)
                        }
                    } else if status == "FAILURE", let _ = responseData[LOGINWSKeys.kMesssage] as? String{
                        switch responseCode {
                        case "3006":
                            // reinitate from the beginning
                            
                            if weakSelf.dataModel?.isLoginFlow == true {
                                weakSelf.navigationController?.popToRootViewController(animated: true)
                            }
                            else {
                                for controller in weakSelf.navigationController!.viewControllers as Array {
                                    if controller.isKind(of: JRAuthSignInVC.self) {
                                        weakSelf.navigationController!.popToViewController(controller, animated: true)
                                        break
                                    }
                                }
                            }
                            
                            break
                        default:
                            if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                                weakSelf.showSettingsAlert(message)
                            } else {
                                weakSelf.showSettingsAlert(JRLoginConstants.generic_error_message)
                            }
                        }
                    }
                }
                else {
                    weakSelf.view.showToast(toastMessage: "jr_login_server_error".localized, duration: 3.0)
                }
            }
        }
    }
    
    private func showSettingsAlert(_ message : String){
        
        let alert = UIAlertController(title: "", message: message, preferredStyle: UIAlertController.Style.alert)
        alert.addAction(UIAlertAction(title: "jr_login_ok".localized, style: UIAlertAction.Style.default, handler: { action in
            
            if self.dataModel?.isLoginFlow == true {
                self.navigationController?.popToRootViewController(animated: true)
            }
            else{
                for controller in self.navigationController!.viewControllers as Array {
                    if controller.isKind(of: JRAuthSignInVC.self) {
                        self.navigationController!.popToViewController(controller, animated: true)
                        break
                    }
                }
            }
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
}

extension JRLNewMobileNoVC: UITextFieldDelegate, UITextViewDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        countryCodeLbl.textColor = LOGINCOLOR.darkGray
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        //Validate mobile number while editing
        if let jarvisLoginType = dataModel?.loginType {
            let changedString = (textField.text! as NSString).replacingCharacters(in: range, with: string)
            let (isValid, _) = JRLoginTextFieldValidation.validateEditTextForTextFieldType(textFieldType: JRLViewModel.txtFieldType(jarvisLoginType), text: changedString)
            if isValid {
                return true
            }
        }
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        if let text = textField.text, !text.isEmpty {
            countryCodeLbl.textColor = LOGINCOLOR.darkGray
        } else {
            countryCodeLbl.textColor = LOGINCOLOR.lightGray
        }
        
        if let jarvisLoginType = dataModel?.loginType{
            let (isValid, _) = JRLoginTextFieldValidation.validateTextForTextFieldType(textFieldType: JRLViewModel.txtFieldType(jarvisLoginType), text: textField.text)
            if isValid{
                switch jarvisLoginType{
                case .mobile:
                    break;
                case .email:
                    break;
                case .newAccount:
                    break;
                }
            }
        }
    }
}
