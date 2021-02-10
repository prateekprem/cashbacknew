//
//  JRAuthOTPVM.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 05/05/20.
//

import UIKit

typealias OTPResponseHandler = (_ success:Bool,_ error : String?, _ responseCode: String?, _ oauthCode: String? ) -> Void

enum OTPMethod: String{
    case SMS = "SMS"
    case OBD = "OBD"
}

class JRAuthOTPVM{
    
    var model: JRLOtpPsdVerifyModel?
    private(set) var totalTime : Int = 30
    private(set) var smsOTPTime : Int = 20
    private(set) var callOTPTime : Int = 30
    var otpMethod = OTPMethod.SMS
    let statusBarHeight = UIApplication.shared.statusBarFrame.size.height
    
    func updateTotalTimeW(with value: Int){
        totalTime = value
    }
    
    func updateTotalTimeWithCallOTPTime(){
        totalTime = callOTPTime
    }
    
    func updateTotalTimeWithSmsOTPTime(){
        totalTime = smsOTPTime
    }
    
    func updateSmsOTPTime( with value: Int){
        smsOTPTime = value
    }

    func updateCallOTPTime( with value: Int){
        callOTPTime = value
    }
    
    func setTimerValues(){
        updateTotalTimeWithSmsOTPTime()
        if otpMethod == .OBD{
            updateTotalTimeWithCallOTPTime()
        }
    }

    func verifyOTP(_ params: [String: String], completion:  @escaping OTPResponseHandler) {
        JRLServiceManager.validateOTP(params) {[weak self] (data, error) in
            guard let weakSelf = self else {
                return
            }
            let genericMessage = JRLoginConstants.generic_error_message
            
            if let error = error {
                if (error as NSError).code == 311 {
                    completion(true, nil, LOGINRCkeys.invalidPublicKey, nil)
                } else if !error.localizedDescription.isEmpty {
                    completion(false, error.localizedDescription, nil , nil)
                } else {
                    completion(false, genericMessage, nil, nil)
                }
                return
            }
            
            guard let responseData = data, let _ = responseData[LOGINWSKeys.kStatus] as? String, let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String else {
                completion(false, genericMessage, nil, nil)
                return
            }
            
            if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String, !stateToken.isEmpty {
                weakSelf.model?.setState(token: stateToken)
            }
            
            let message: String = (responseData[LOGINWSKeys.kMesssage] as? String) ?? genericMessage
            let oauthCode = (responseData["oauthCode"] as? String) ?? ""
            
            completion(true, message, responseCode, oauthCode)
            return
        }
    }

    func resendOtp(stateToken: String, screenType: JarvisLoginScreenType = .fullScreen, retryCount: Int = 0, completion: @escaping OTPResponseHandler){
        
        JRLServiceManager.resendOTP([LOGINWSKeys.kStateToken: stateToken, "otpDeliveryMethod" : otpMethod.rawValue]) {[weak self] (data, error) in
            guard let weakSelf = self else {
                completion(false, nil, nil, nil)
                return
            }
            
            if let error = error {
                if (error as NSError).code == 311 {
                    if retryCount < 2 {
                        let updateRetryCount = (retryCount + 1)
                        weakSelf.resendOtp(stateToken: stateToken, screenType: screenType, retryCount: updateRetryCount, completion: completion)
                    } else {
                        completion(false, JRLoginConstants.generic_error_message, nil, nil)
                    }
                } else {
                    completion(false, JRLoginConstants.generic_error_message, nil , nil)
                }
                
            } else if let responseData = data,
                let responseCode = responseData[LOGINWSKeys.kResponseCode] as? String {
                
                switch responseCode {
                case LOGINRCkeys.success:
                    if let stateToken = responseData[LOGINWSKeys.kStateToken] as? String {
                        weakSelf.model?.stateToken = stateToken
                        if let passwordViolation = responseData[LOGINWSKeys.kpasswordViolation] as? Bool{
                            LoginAuth.sharedInstance().setPasswordVoilation(passwordViolation)
                        }
                        var msg: String = ""
                        if weakSelf.otpMethod == .OBD {
                            if screenType == .fullScreen {
                                msg = "jr_login_otp_will_be_received_on_call_successfully".localized
                            } else {
                                msg = "jr_login_otp_on_call_msg".localized
                            }
                        } else {
                            msg = "jr_login_otp_sent_successfully".localized
                        }
                        
                        completion(true, msg, responseCode, stateToken)
                        return
                    } else {
                        if let messsage = responseData[LOGINWSKeys.kMesssage] as? String {
                            completion(false, messsage, responseCode, nil)
                            return
                        }
                        completion(false, nil, responseCode, nil)
                        return
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
                    completion(false, JRLoginConstants.generic_error_message, responseCode, nil)
                    
                case LOGINRCkeys.invalidPublicKey:
                    if retryCount < 2 {
                        let updateRetryCount = (retryCount + 1)
                        weakSelf.resendOtp(stateToken: stateToken, screenType: screenType, retryCount: updateRetryCount, completion: completion)
                    } else {
                        completion(false, JRLoginConstants.generic_error_message, responseCode, nil)
                    }
                    
                case LOGINRCkeys.otpLimitReach:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        let model = JRDIYAccountUnblockPopupViewModel(title: "jr_login_dabu_OTP_Limit_Reached".localized,
                                                                      subtitle: message,
                                                                      confirmText: "jr_login_ok".localized,
                                                                      cancelText: nil)
                        JRDIYAccountUnblockHelper.sharedInstance.presentPopup(withModel: model) {_ in
                            completion(false, nil, responseCode, nil)
                        }
                    } else {
                        completion(false, JRLoginConstants.generic_error_message, responseCode, nil)
                    }
                    
                case LOGINRCkeys.unprocessableEntity,
                     LOGINRCkeys.accountBlocked:
                    fallthrough
                    
                default:
                    if let message = responseData[LOGINWSKeys.kMesssage] as? String {
                        completion(false, message, responseCode, nil)
                        return
                    }
                    completion(false, nil, responseCode, nil)
                    return
                }
            } else {
                completion(false, JRLoginConstants.generic_error_message, nil, nil)
            }
        }
    }
}
