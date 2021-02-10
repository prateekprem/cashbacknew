//
//  JRLViewModel.swift
//  Login
//
//  Created by Parmod on 17/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

typealias responseHandler = (_ success:Bool,_ error : String?, _ responseCode: String?, _ oauthCode: String? ) -> Void
typealias unblockResponseHandler = (_ success:Bool,_ error : String?, _ responseCode: String?, _ oauthCode: String?, _ verifyId: String?, _ method: String?) -> Void


public enum JarvisLoginType: Int { // must be ristricted to use
    case email
    case mobile
    case newAccount
    
    var txtFldType: LoginTextField {
        switch self {
        case .email : return .emailAddress
        case .mobile, .newAccount : return .mobileNumber
        }
    }
}

public enum JarvisLoginScreenType:Int{
    case popup
    case fullScreen
}

public enum JarvisLoginFlowType:Int{
    case login
    case sessionExpiry
}

public enum JarvisOauthFlowType: Int{
    case login
    case signup
}

class JRLViewModel: NSObject  {
    var jarvisLoginType: JarvisLoginType?
    var title: String?
    var txtFieldPlaceholder: String?
    var txtFieldKeyboardType: UIKeyboardType?
    var loginBtnTitle: String?
    var countryCodeLabelWidth:CGFloat?
    
    init(_ jarvisLoginType: JarvisLoginType) {
        super.init()
        self.jarvisLoginType = jarvisLoginType
        self.updateData()
    }
    
    func updateData() {
        guard let jarvisLoginType = jarvisLoginType else {
            return
        }
        switch jarvisLoginType {
        case .email:
            txtFieldKeyboardType = .emailAddress
            title = "jr_login_enter_registered_paytm_email_ID".localized
            txtFieldPlaceholder = ""
            loginBtnTitle = "jr_login_use_mobile_no".localized
            countryCodeLabelWidth = 0.0
        case .mobile:
            txtFieldKeyboardType = .numberPad
            title = "jr_login_enter_registered_paytm_mobile_number".localized
            txtFieldPlaceholder = ""
            loginBtnTitle = "jr_login_use_email_ID".localized
            countryCodeLabelWidth = 40.0
        default:
            resetData()
        }
    }
    
    private func resetData() {
        title = nil
        txtFieldPlaceholder = nil
        loginBtnTitle = nil
        txtFieldKeyboardType = nil
    }
    static func txtFieldType(_ jarvisLoginType: JarvisLoginType) -> LoginTextField {
        switch jarvisLoginType {
        case .email:
            return .emailAddress
        case .mobile:
            return .mobileNumber
        default:
            return .none
        }
    }
}

// MARK: - JRLOtpPsdVerifyModel
class JRLOtpPsdVerifyModel: NSObject {
    private(set) var loginType: JarvisLoginType = JarvisLoginType.mobile
    private(set) var loginId: String?
    var stateToken: String?
    var otpTextCount: Int?
    var allowUPI: Bool = false
    var isLoginFlow: Bool = false
    var isFromPassword: Bool = false
    var isFromUpdateEmail: Bool = false
    var emailToUpdate: String?
    
    init(loginId: String?, stateToken: String?,
         otpTextCount: Int?, loginType: JarvisLoginType) {
        self.loginId       = loginId
        self.stateToken    = stateToken
        self.otpTextCount  = otpTextCount
        self.loginType     = loginType
    }
    
    func setState(token: String?) {
        self.stateToken = token
    }
    
    func getMob() -> String{
        if loginType == .mobile, let mobileNumber = loginId{ return mobileNumber}
        return ""
    }
}

extension JRLOtpPsdVerifyModel {
    func invokeDoViewOTP(_ params: [String: String], completion: @escaping unblockResponseHandler) {
        JRLServiceManager.doView(params, isLoginFlow: false) { (data, error) in
            if let responseData = data,
                let resultInfo = responseData["resultInfo"] as? [String:Any],
                let resultCode = resultInfo["resultCode"] as? String,
                let verifyId = responseData["verifyId"] as? String,
                let method = responseData["method"] as? String {
                
                if resultCode == "SUCCESS" {
                    completion(true, nil, resultCode, nil, verifyId, method)
                } else {
                    completion(false, error?.localizedDescription, nil, nil, nil, nil)
                }
            }
            else {
                completion(false, error?.localizedDescription, nil, nil, nil, nil)
            }
        }
    }
    
    func invokeDoViewSMS(_ params: [String: String], completion: @escaping unblockResponseHandler) {
        JRLServiceManager.doView(params, isLoginFlow: false) { [weak self] (data, error) in
            if let responseData = data,
                let resultInfo = responseData["resultInfo"] as? [String:Any],
                let resultCode = resultInfo["resultCode"] as? String,
                let verifyId = responseData["verifyId"] as? String,
                let renderData = responseData["renderData"] as? [String:Any],
                let cardList = renderData["masked_card_list"] {
                
                if let cardString = cardList as? String,
                    let array = self?.convertToArray(str: cardString),
                    resultCode == "SUCCESS" {
                    completion(true, nil, resultCode, nil, verifyId, array[0])
                }
                else {
                    completion(false, error?.localizedDescription, nil, nil, nil, nil)
                }
            }
            else {
                completion(false, error?.localizedDescription, nil, nil, nil, nil)
            }
        }
    }
    
    func invokeDoVerify(_ params: [String: Any], completion: @escaping responseHandler) {
        JRLServiceManager.doVerify(params, isLoginFlow: false) { (data, error) in
            if let responseData = data,
                let resultInfo = responseData["resultInfo"] as? [String:Any],
                let resultCode = resultInfo["resultCode"] as? String {
                
                if resultCode == "SUCCESS" {
                    completion(true, nil, resultCode, nil)
                } else {
                    completion(false, nil, nil, nil)
                }
            }
            else {
                completion(false, nil, nil, nil)
            }
        }
    }
}

extension JRLOtpPsdVerifyModel {
    private func convertToArray(str: String) -> [String]? {
        let data = str.data(using: .utf8)
        do {
            return try JSONSerialization.jsonObject(with: data!, options: []) as? [String]
        } catch {
            print(error.localizedDescription)
        }
        return nil
    }
}
