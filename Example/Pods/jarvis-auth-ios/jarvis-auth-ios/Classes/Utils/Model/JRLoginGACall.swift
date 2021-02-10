//
//  JRLoginGACall.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 06/12/20.
//

import UIKit

public class JRLoginGACall: NSObject {
    
//MARK:- -----------Login & Signup - Enter Phone Number---------------
    static func loginSkipBtnClicked(){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.kskip_button_clicked, LOGINGAKeys.kfullPage)
    }
    
    static func loginHelpMeClicked() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.klogin_issue_clicked, LOGINGAKeys.kfullPage)
    }
    
    static func loginChangeLangClicked() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.kChangeLang, LOGINGAKeys.kfullPage)
    }
    
    static func loginScreenLoaded(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.kLoginScreenLoaded, LOGINGAKeys.kfullPage)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kphoneNumberPopupLoaded, LOGINGAKeys.kbottomSheet)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kphoneNumberPopupLoaded, LOGINGAKeys.ksesseionExpiry)
            }
        }
    }
    
    static func loginMobileNumberEntered(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType){
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.kmobile_number_entered, LOGINGAKeys.kfullPage)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kmobile_number_entered, LOGINGAKeys.kbottomSheet)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kmobile_number_entered, LOGINGAKeys.ksesseionExpiry)
            }
        }
    }
    
    static func loginProceedClicked(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType, el1: String = "" , el2: String = "" , el3: String = "", el4: String = "" ){
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginSignUp, LOGINGAKeys.kCatLoginSignup, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.kfullPage, el1, el2, el3, el4, nil, nil)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.kbottomSheet, el1, el2, el3, el4, nil, nil)

            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.ksesseionExpiry, el1, el2, el3, el4, nil, nil)
            }
        }
    }
    
    static func loginPopupDiscarded(_ flow: JarvisLoginFlowType, mob: String){
        switch flow {
        case .login:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.kbottomSheet, mob)
        case .sessionExpiry:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginBottomSheet, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.ksesseionExpiry, mob)
        }
    }
        
//MARK:- -----------------Login Password------------------
    static func passwordScreenLoaded(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kPasswordScreenLoaded, LOGINGAKeys.kfullPage)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kpasswordPopupLoadeed, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kpasswordPopupLoadeed, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            }
        }
    }
    
    static func passwordShowHideClicked(action: String) {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, action, LOGINGAKeys.kfullPage)
    }
    
    static func passwordScreenForgotPwdClicked(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kforgot_password_clicked, LOGINGAKeys.kfullPage)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kforgot_password_clicked, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kforgot_password_clicked, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            }
        }
    }
    
    static func passwordScreenLoginWithDiffAcc(_ flow: JarvisLoginFlowType){
        switch flow {
        case .login:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kloginWithDiffAccount, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
        case .sessionExpiry:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kloginWithDiffAccount, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
        }
    }
    
    static func passwordScreenBackBtnClicked(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kback_button_clicked, LOGINGAKeys.kfullPage)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.kbottomSheet, LOGINGAKeys.kPassword, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.ksesseionExpiry, LOGINGAKeys.kPassword, nil, nil, nil, nil, LOGINGAKeys.kCatLoginV2)
            }
        }
    }
    
    static func passwordScreenProceedClicked(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType, el2: String = "" , el3: String = "", el4: String = "" ) {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.kfullPage, LOGINGAKeys.kPassword, el2, el3, el4, nil, nil)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kproceedSecurelyClicked, LOGINGAKeys.kbottomSheet, LOGINGAKeys.kPassword, el2, el3, el4, nil, LOGINGAKeys.kCatLoginV2)

            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kproceedSecurelyClicked, LOGINGAKeys.ksesseionExpiry,LOGINGAKeys.kPassword, el2, el3, el4, nil, LOGINGAKeys.kCatLoginV2)
            }
        }
    }
    
    static func passwordScreenSuccess(_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType, custId: String = "") {
        switch screen {
        case .fullScreen:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenPassword, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.kfullPage, nil, nil, nil, nil, custId, nil)
        case .popup:
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, custId, LOGINGAKeys.kCatLoginV2)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExPwdPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, custId, LOGINGAKeys.kCatLoginV2)
            }
        }
    }
    
//MARK:- -----------------Login/SignUp OTP -----------------
    static func otpScreenLoaded(_ isSignUp: Bool, _ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kOtpSignupLoaded, LOGINGAKeys.kfullPage)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kOtpSigninLoaded, LOGINGAKeys.kfullPage)
            }
        case .popup:
            let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kotpPopupLoaded, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, eval)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kotpPopupLoaded, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, eval)
            }
        }
    }
    
    static func otpScreenOtpEntered(isSignUp: Bool) {
        if isSignUp{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.klogin_otp_entered, LOGINGAKeys.kfullPage)
        }
        else{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.klogin_otp_entered, LOGINGAKeys.kfullPage)
        }
    }
    
    static func otpScreenResendOtpClicked(isSignUp: Bool) {
        if isSignUp{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kresend_otp_clicked, LOGINGAKeys.kfullPage)
        }
        else{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kresend_otp_clicked, LOGINGAKeys.kfullPage)
        }
    }
    
    static func otpScreenResendOtpPopUpLoaded(isSignUp: Bool) {
        if isSignUp{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kResendOtpPopupLoaded, LOGINGAKeys.kfullPage)
        }
        else{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kResendOtpPopupLoaded, LOGINGAKeys.kfullPage)
        }
    }
    
    static func otpScreenResendOtpSmsClicked(_ isSignUp: Bool, _ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kResendOtpSmsClicked, LOGINGAKeys.kfullPage)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kResendOtpSmsClicked, LOGINGAKeys.kfullPage)
            }
        case .popup:
            let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kResendOtpSmsClicked, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, eval)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kResendOtpSmsClicked, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, eval)
            }
        }
    }
    
    static func otpScreenResendOtpCallClicked(_ isSignUp: Bool, _ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kResendOtpCallClicked, LOGINGAKeys.kfullPage)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kResendOtpCallClicked, LOGINGAKeys.kfullPage)
            }
        case .popup:
            let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kResendOtpCallClicked, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, eval)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kResendOtpCallClicked, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, eval)
            }
        }
    }
    
    static func otpScreenBackBtnClicked(_ isSignUp: Bool, _ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType) {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kback_button_clicked, LOGINGAKeys.kfullPage, LOGINGAKeys.kOtp)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kback_button_clicked, LOGINGAKeys.kfullPage, LOGINGAKeys.kOtp)
            }
        case .popup:
            let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.kbottomSheet, LOGINGAKeys.kOtp, nil, nil, nil, nil, eval)
            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kpopupDiscarded, LOGINGAKeys.ksesseionExpiry, LOGINGAKeys.kOtp, nil, nil, nil, nil, eval)
            }
        }
    }
    
    static func otpScreenLoginIssuesClicked(_ isSignUp: Bool){
        if isSignUp{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kotpLoginIssueeClicked, LOGINGAKeys.kfullPage)
        }
        else{
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kotpLoginIssueeClicked, LOGINGAKeys.kfullPage)
        }
    }
    
    static func otpScreenLoginWithDiffAcc(_ isSignUp: Bool, _ flow: JarvisLoginFlowType){
        let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
        switch flow {
        case .login:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kloginWithDiffAccount, LOGINGAKeys.kbottomSheet, nil, nil, nil, nil, nil, eval)
        case .sessionExpiry:
            JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kloginWithDiffAccount, LOGINGAKeys.ksesseionExpiry, nil, nil, nil, nil, nil, eval)
        }
    }
    
    static func otpScreenProceedClicked(_ isSignUp: Bool,_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType, _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ) {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.kfullPage, el1, el2, el3, el4, nil, nil)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kproceed_clicked, LOGINGAKeys.kfullPage, el1, el2, el3, el4, nil, nil)
            }
        case .popup:
            let eval = isSignUp ? LOGINGAKeys.kCatSignUpV2 : LOGINGAKeys.kCatLoginV2
            switch flow {
            case .login:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kproceedSecurelyClicked, LOGINGAKeys.kbottomSheet, el1, el2, el3, el4, nil, eval)

            case .sessionExpiry:
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kproceedSecurelyClicked, LOGINGAKeys.ksesseionExpiry, el1, el2, el3, el4, nil, eval)
            }
        }
    }
    
    static func otpScreenSuccess(_ isSignUp: Bool,_ screen:JarvisLoginScreenType, _ flow: JarvisLoginFlowType, custId: String = "", el1_signup: String = "", el1_signin: String = "") {
        switch screen {
        case .fullScreen:
            if isSignUp{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenSignupOtp, LOGINGAKeys.kCatSignUpV2, LOGINGAKeys.kSignUpSuccess, LOGINGAKeys.kfullPage, el1_signup, nil, nil, nil, custId, nil)
            }
            else{
                JRLoginGACall.generateGAEvent(LOGINGAKeys.kScreenLoginOtp, LOGINGAKeys.kCatLoginV2, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.kfullPage, el1_signin, nil, nil, nil, custId, nil)
            }
        case .popup:
            switch flow {
            case .login:
                if isSignUp{
                    JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kSignUpSuccess, LOGINGAKeys.kbottomSheet, el1_signup, nil, nil, nil, custId, LOGINGAKeys.kCatSignUpV2)
                } else{
                    JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kCatIndVerticalLoginSignup, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.kbottomSheet, el1_signin, nil, nil, nil, custId, LOGINGAKeys.kCatLoginV2)
                }
            case .sessionExpiry:
                if isSignUp{
                    JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kSignUpSuccess, LOGINGAKeys.ksesseionExpiry, el1_signup, nil, nil, nil, custId, LOGINGAKeys.kCatSignUpV2)
                } else{
                    JRLoginGACall.generateGAEvent(LOGINGAKeys.kscreenSesExOtpPrompt, LOGINGAKeys.kSessionExpiryPrompt, LOGINGAKeys.kLoginSuccess, LOGINGAKeys.ksesseionExpiry, el1_signin, nil, nil, nil, custId, LOGINGAKeys.kCatLoginV2)
                }
            }
        }
    }

//MARK:- ----------------- Forgot Password -----------------
    //FP- Screen
    static func forgotPwdLoaded() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdPhoneNum, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kforgotPwdLoaded, "")
    }
    
    static func forgotPwdSaveClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdPhoneNum, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kproceed_clicked, "", el1, el2, el3, el4, nil, nil)
    }
    
    //FP- IVR Screen
    static func forgotPwdIVRLoaded() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdIvr, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kforgotPwdIVRLoaded, "")
    }
    
    static func forgotPwdIVRTapped(carrier: String) {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdIvr, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kivrTapped, "", nil, carrier, nil, nil, nil, nil)
    }
    
    //FP- OTP Screen
    static func forgotPwdOtpLoaded() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdOtp, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kforgotPwdOtpLoaded, "")
    }
    
    static func forgotPwdResendOtp() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdOtp, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kforgotPwdResentOtp, "")
    }
    
    static func forgotPwdOTPClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kforgotPwdOtp, LOGINGAKeys.kforgotPwd, LOGINGAKeys.kforgotPwdConfirmClicked, "", el1, el2, el3, el4, nil, nil)
    }
    
    //FP- Set New Password Screen
    static func setForgotPwdLoaded() {
        JRLoginGACall.generateGAEvent("", LOGINGAKeys.kforgotPwd, LOGINGAKeys.ksetForgotPwdLoaded, "")
    }
    
    static func setForgotPwdSuccess(_ el1: String) {
        JRLoginGACall.generateGAEvent("" , LOGINGAKeys.kforgotPwd, LOGINGAKeys.ksetForgotPwdSuccess, "", el1, "", "", "", nil, nil)

    }
    
    static func setForgotPwdLoginSuccess() {
        JRLoginGACall.generateGAEvent("" , LOGINGAKeys.kforgotPwd, LOGINGAKeys.ksetForgotPwdLoginSuccess, "")
    }
    
    static func setForgotPwdSavedClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        JRLoginGACall.generateGAEvent("" , LOGINGAKeys.kforgotPwd, LOGINGAKeys.ksetForgotPwdSavedClicked, "", el1, el2, el3, el4, nil, nil)
    }
    
//MARK:- ----------------- Change Password -----------------

    static func changePwdLoaded() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kchangePwd, LOGINGAKeys.kchangePwdSec, LOGINGAKeys.kchangePwdLoaded, "")
    }
    
    static func changePwdFPClicked() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kchangePwd, LOGINGAKeys.kchangePwdSec, LOGINGAKeys.kforgot_password_clicked, "")
    }
    
    static func changePwdBckBtnClicked() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kchangePwd, LOGINGAKeys.kchangePwdSec, LOGINGAKeys.kback_button_clicked, "")
    }
    
    static func changePwdSaveClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kchangePwd, LOGINGAKeys.kchangePwdSec, LOGINGAKeys.ksavedClicked, "", el1, el2, el3, el4, nil, nil)
    }
    
    static func changePwdSuccess(_ el1: String = ""){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kchangePwd, LOGINGAKeys.kchangePwdSec, LOGINGAKeys.kpwdChangeSuccess, "", el1, nil, nil, nil, nil, nil)
    }
    
//MARK:- ----------------- Upgrade Password -----------------
    static func upgradePwdTxtEntered(_ txt: String) {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kupgradePwd, LOGINGAKeys.kupgradePwdCat, txt, "")
    }
    
    static func upgradePwdBackTapped() {
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kupgradePwd, LOGINGAKeys.kupgradePwdCat, LOGINGAKeys.kback_button_clicked, "")
    }
    
    static func upgradePwdSaveClicked( _ el1: String = "" , _ el2: String = "" , _ el3: String = "", _ el4: String = "" ){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kupgradePwd, LOGINGAKeys.kupgradePwdCat, LOGINGAKeys.ksavedClicked, "", el1, el2, el3, el4, nil, nil)
    }
    
    static func upgradePwdSuccess(_ el1: String = ""){
        JRLoginGACall.generateGAEvent(LOGINGAKeys.kupgradePwd, LOGINGAKeys.kupgradePwdCat, LOGINGAKeys.kpwdUpgradeSuccess, "", el1, nil, nil, nil, nil, nil)
    }

// MARK: -------------- Helper ------------------
    
    static private func generateGAEvent(_ screen: String, _ category: String, _ action: String, _ el5: String, _ el1: String? = nil, _ el2: String? = nil, _ el3: String? = nil, _ el4: String? = nil, _ custId: String? = nil, _ eVal: String? = nil ){
        
        var eventVars: [String: String] = [:]
        eventVars[LOGINGAKeys.kVertical] = LOGINGAKeys.kVerticalOauth
        eventVars[LOGINGAKeys.kCategory] = category
        eventVars[LOGINGAKeys.kAction] = action
        if let el_1 = el1, !el_1.isEmpty{
            eventVars[LOGINGAKeys.kLbl1] = el_1
        }
        if let el_2 = el2, !el_2.isEmpty{
            eventVars[LOGINGAKeys.kLbl2] = el_2
        }
        if let el_3 = el3, !el_3.isEmpty{
            eventVars[LOGINGAKeys.kLbl3] = el_3
        }
        if let el_4 = el4, !el_4.isEmpty{
            eventVars[LOGINGAKeys.kLbl4] = el_4
        }
//        if !el5.isEmpty{
//            eventVars[LOGINGAKeys.kLbl5] = el5
//        }
        if let lcustId = custId, !lcustId.isEmpty{
            eventVars[LOGINGAKeys.kLabelCustId] = lcustId
        }
        if let e_Val = eVal, !e_Val.isEmpty{
            eventVars[LOGINGAKeys.kValue] = e_Val
        }
        JRLoginGACall.executeGAEvent(screen, LOGINGAKeys.kCustom, eventVars)
    }

    static private func executeGAEvent(_ screenName: String, _ eventScreen: String, _ variables: [AnyHashable : Any]?){
        JRLoginUI.sharedInstance().delegate?.trackCustomEventforScreen(screenName, eventName: eventScreen, variables: variables)
    }
}
