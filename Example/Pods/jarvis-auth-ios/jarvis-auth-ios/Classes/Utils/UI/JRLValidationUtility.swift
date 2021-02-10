//
//  JRLValidationUtility.swift
//  Login
//
//  Created by Parmod on 26/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation
import jarvis_locale_ios

public enum LoginTextField {
    case none
    case mobileNumber
    case emailAddress
}

class JRLoginTextFieldValidation: NSObject {
    
    class func validateEditTextForTextFieldType(textFieldType: LoginTextField, text: String) -> (Bool, String?) {
        let regexStr = JRLoginTextFieldValidation.regexForTextFieldTypeWhileEditing(textFieldtype: textFieldType)
        return (JRLoginTextFieldValidation.validateText(text, regex: regexStr), nil)
    }
    
    class func validateTextForTextFieldType(textFieldType: LoginTextField, text: String?) -> (Bool, String?) {
        var isValid: Bool = false
        let regexStr = JRLoginTextFieldValidation.regexForTextFieldType(textFieldtype: textFieldType)
        switch textFieldType {
        case .mobileNumber:
            guard let text = text else {
                return(false, "jr_kyc_enter_mobile_number".localized)
            }
            isValid = JRLoginTextFieldValidation.validateText(text, regex: regexStr)
            if isValid {
                return(true, nil)
            } else {
                return(false, "jr_kyc_please_enter_valid_mobile_number".localized)
            }
        case .emailAddress:
            guard let text = text else {
                return(false, "jr_login_enter_email_address".localized)
            }
            isValid = JRLoginTextFieldValidation.validateText(text, regex: regexStr)
            if isValid {
                return(true, nil)
            }else {
                return(false, "jr_login_enter_valid_email_address".localized)
            }
        case .none:
            return (true, nil)
        }
    }
    
    class func regexForTextFieldTypeWhileEditing(textFieldtype: LoginTextField) -> String {
        switch textFieldtype {
        case .mobileNumber:
            return "[0-9]{0,10}"
        case .emailAddress:
            return "[_A-Za-z0-9@.]{0,60}"
        case .none:
            return ""
        }
    }
    
    class func regexForTextFieldType(textFieldtype: LoginTextField) -> String {
        switch textFieldtype {
        case .mobileNumber:
            return "[0-9]{10}"
        case .emailAddress:
            return "^[_A-Za-z0-9-\\+]+(\\.[_A-Za-z0-9-]+)*(\\+[_A-Za-z0-9-]+){0,1}@[A-Za-z0-9-]+(\\.[A-Za-z0-9]+)*(\\.[A-Za-z]{2,})$"
        case .none:
            return ""
        }
    }
    
    class func validateText(_ text:String?, regex:String?) -> Bool {
        var validated = false
        var textToValidate = ""
        if let textString = text {
            textToValidate = textString
        }
        if let regularExpression = regex {
            let documentComponentPredicate = NSPredicate(format:"SELF MATCHES %@", regularExpression);
            validated = documentComponentPredicate.evaluate(with: textToValidate)
        }
        return validated
    }
}


class JRChatOnboardingSpinnerView: UIView {
    
    fileprivate(set) var spinning = false
    private var counter = 0
    let progressBarColorLight = LOGINCOLOR.blue
    let progressBarColorDark = LOGINCOLOR.navyBlue
    var currentColor: UIColor?
    var nextColor: UIColor?
    
    func startSpinner() {
        guard false == spinning else {
            return
        }
        
        spinning = true
        isHidden = false
        for i in 0...4 {
            if let findView = viewWithTag(i) {
                findView.layer.cornerRadius = findView.frame.size.width/2.0
                findView.backgroundColor = progressBarColorLight
                currentColor = progressBarColorLight
                nextColor = progressBarColorDark
            }
        }
        
        perform(#selector(updateCounter), with: nil, afterDelay: 0.2)
    }
    
    func stopSpinner() {
        guard true == spinning else {
            return
        }
        spinning = false
        isHidden = true
    }
    
    @objc func updateCounter() {
        counter += 1
        for i in 0...4 {
            if let findView = viewWithTag(i) {
                if i < counter {
                    findView.backgroundColor = nextColor
                } else {
                    findView.backgroundColor = currentColor
                }
            }
        }
        if counter == 5 {
            let swapColor = nextColor
            nextColor = currentColor
            currentColor = swapColor
            counter = 0
        }
        
        if spinning {
            self.perform(#selector(updateCounter), with: nil, afterDelay: 0.2)
        }
    }
}
