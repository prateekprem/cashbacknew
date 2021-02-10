//
//  JRLoginConstants.swift
//  Login
//
//  Created by Parmod on 12/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

let JRLBundle = Bundle.init(for: JRAuthBaseVC.self)
internal let JRSSOToken: String = "SSO_TOKEN"
internal let JRWalletToken: String = "WALLET_TOKEN"
internal let JRUserID: String = "USER_ID"
internal let JREncSSOToken: String = "ENC_SSO_TOKEN"
internal let JRPaytmTokenDict: String = "PAYTM_TOKEN_DICT"
internal let JRWalletTokenDict: String = "WALLET_TOKEN_DICT"
internal let JRReloginErrorCode: Int = -11
internal let JRUISessionError = -12

typealias LOGINWSKeys = JRLoginConstants.WebServicesKey
typealias LOGINACKeys = JRLoginConstants.APIConstantsKey
typealias LOGINRCkeys = JRLoginConstants.ResponseCode
typealias LOGINGAKeys = JRLoginConstants.GACallConstantsKey
typealias LOGINCOLOR = JRLoginConstants.Colors

internal struct JRLoginConstants {
    static let generic_error_message = "jr_login_something_went_wrong_please_try_after_sometime".localized
    static let no_internet_error_message = "jr_ac_noInternetMsg".localized
    static let kPrimeStatusUpdate = "PrimeStatusUpdate";
    static let kSessionExipiryUIDismiss = "SessionExipiryUIDismiss";
    
    struct Colors{
        static let lightGray: UIColor =  UIColor(red: 184/255.0, green: 194/255.0, blue: 203/255.0, alpha: 1.0)
        static let darkGray: UIColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1.0)
        static let blue :UIColor = UIColor(red: 0, green: 185/255.0, blue: 245/255.0, alpha: 1.0)
        static let cyan :UIColor = UIColor.init(red: 0, green: 172/255, blue: 237/255, alpha: 1.0)
        static let green: UIColor = UIColor(red: 33/255.0, green: 193/255.0, blue: 122/255.0, alpha: 1.0)
        static let textGray: UIColor = UIColor(red: 139/255.0, green: 166/255.0, blue: 193/255.0, alpha: 1.0)
        static let lightBlueBG: UIColor = UIColor(red: 241/255.0, green: 252/255.0, blue: 255/255.0, alpha: 1.0)
        static let blackBgWithAlpha70 : UIColor = UIColor(red: 0.0, green: 0.0, blue: 0.0, alpha: 0.7)
        static let lightGreen: UIColor = UIColor(red: 232/255.0, green: 248/255.0, blue: 241/255.0, alpha: 1.0)
        static let lightGray2: UIColor =  UIColor(red: 243/255.0, green: 247/255.0, blue: 248/255.0, alpha: 1.0)
        static let pastelRed: UIColor = UIColor(red: 253/255.0, green: 92/255.0, blue: 92/255.0, alpha: 1.0)
        static let pastelDarkYellow: UIColor = UIColor(red: 255/255.0, green: 164/255.0, blue: 0/255.0, alpha: 1.0)
        static let darkGray2: UIColor = UIColor(red: 153/255.0, green: 153/255.0, blue: 153/255.0, alpha: 1.0)
        static let navyBlue: UIColor = UIColor(red: 0/255.0, green: 46/255.0, blue: 110/255.0, alpha: 1.0)
        static let lightGray3: UIColor =  UIColor(red: 226/255.0, green: 235/255.0, blue: 238/255.0, alpha: 1.0)
        static let darkGreen: UIColor = UIColor(red: 19/256.0, green: 141/256.0, blue: 117/256.0, alpha: 1.0)
    }
    
    struct ResponseCode {
        static let success = "01"
        static let success200 = "200"
        static let successBE = "BE1400001"
        static let authErr = "401"
        static let invalidOTP = "407"
        static let invalidToken = "410"
        static let badRequest = "434"
        static let invalidAuthorization = "430"
        static let invalidOtp = "403"
        static let accountBlocked = "459"
        static let invalidMobile = "431"
        static let emptyDeviceId = "811"
        static let clientFetchPermissionDenied = "1301"
        static let OTPVerificationLimitReached = "3007"
        static let authRiskError = "3005"
        static let DIYAccountBlocked = "BE1424004"
        static let accountClosure = "BE1424005"
        static let otpLimitReach = "708"
        static let otpLimitReachedBE = "BE1425004"
        static let issueProcessingRequest = "827"
        static let loginOTP = "3000"
        static let loginPassword = "3001"
        static let accountClaimable = "3003"
        static let signUpOTP = "3004"
        static let unprocessableEntity = "3006"
        static let invalidLogin = "3010"
        static let BESuccess = "BE1400000"
        static let scopeNotRefreshable = "BE1422001"
        static let invalidRefreshToken = "BE1422002"
        static let BEInvalidToken = "BE1422003"
        static let invalidPublicKey = "BE1423001"
        static let signatureTimeExpired = "BE1423002"
        static let invalidSignature = "BE1423003"
        static let authorizationMissing = "BE1423004"
        static let invalidAuthCode = "BE1423005"
        static let clientPermissionNotFound = "BE1423006"
        static let missingMandatoryHeaders = "BE1423007"
        static let deviceAlreadyUpgraded = "BE1426001"
        static let internalServerErr = "BE1526000"
        static let stateTokenMethodNotSupported = "PU_DIY_03"
        static let tokenAndStateUserIdMismatch = "PU_DIY_07"
        static let authorizationAndStateClientIdMismatch = "PU_DIY_12"
        static let tokenAndStateClientIdMismatch = "PU_DIY_13"
        static let stateTokenMethodNotSupportedBE = "BE1426009"
        static let emptyStateToken = "BE1426007"
        static let invalidStateToken = "BE1426002"
        static let authorizationAndClientIdMismatch = "BE1423011"
        static let invalidEmail = "BE1426008"
        static let emailAlreadyLinked = "BE1424003"
        static let noChangesDone = "BE1426010"
        static let emailCannotBeChanged = "BE1424002"
        static let invalidTokenBE = "BE1422003"
        // Account Block/Unblock
        static let issueProcessingRequestAB = "BE1526003"
        static let internalServerErrorAB = "BE1426028"
        static let internalServerError2AB = "BE1426003"
        static let anyParamterMissingAB = "BE1426030"
        static let invalidStateTokenAB = "BE1426026"
        static let invalidSessionTokenAB = "BE1426029"
        static let verificationCannotBeFulfilled = "BE1426022"
        static let userDoesNotExist = "BE1426021"
        static let userAlreadyBlocked = "BE1424018"
        static let userAlreadyUnblocked = "BE1424021"
        static let limitReachedForDevice = "BE1425012"
        static let limitReachedForIP = "BE1425013"
        static let userVerificationFailed = "BE1426005"
        static let userVerificationPending = "BE1426006"
        static let userVerificationCantBeFulfilled = "BE1426023"
        static let initBadRequest = "BE1426001"
        static let unblockBefore24Hours = "BE1426038"
        static let limitExceededDeviceIDUnblock = "BE1425010"
        static let limitExceededIPUnblock = "BE1425011"
    }
    
    struct WebServicesKey {
        static let kMobile = "mobile"
        static let kLoginId = "loginId"
        static let kFlow = "flow"
        static let kStatus = "status"
        static let kStateToken = "stateToken"
        static let kResponseCode = "responseCode"
        static let kMesssage = "message"
        static let kPassword = "password"
        static let kOTP = "otp"
        static let kOauthCode = "oauthCode"
        static let kMode = "mode"
        static let kGrantMode = "grantType"
        static let kCode = "code"
        static let kRefreshToken = "refreshToken"
        static let kDeviceId = "deviceId"
        static let kError = "error"
        static let kpasswordViolation = "passwordViolation"
    }
    
    struct APIConstantsKey {    //Data to be sent constant in API request
        static let kSignup = "signup"
    }
    
    struct GACallConstantsKey {
        static let kCategory = "event_category"
        static let kAction = "event_action"
        static let kCustom = "custom_event"
        static let kVertical = "vertical_name"
        static let kVerticalOauth = "oauth"
        static let kValue = "event_value"
        static let kLbl1 = "event_label"
        static let kLbl2 = "event_label2"
        static let kLbl3 = "event_label3"
        static let kLbl4 = "event_label4"
        static let kLbl5 = "event_label5"
        static let kPassword = "password"
        static let kOtp = "otp"
        //{{event_screen}}
        static let kScreenLoginSignUp = "/login-signup"
        static let kScreenPassword = "/login-password"
        static let kScreenLoginOtp = "/login-otp"
        static let kScreenSignupOtp = "/signup-otp"
        static let kScreenLoginBottomSheet = "/session_expiry_phone_number_prompt"
        static let kscreenSesExPwdPrompt = "/session_expiry_password_prompt"
        static let kscreenSesExOtpPrompt = "/session_expiry_otp_prompt"
        static let kchangePwd = "/change_password_security"
        static let kupgradePwd = "/upgrade_password"
        static let kforgotPwdPhoneNum = "/forgot_password_phone_number"
        static let kforgotPwdIvr = "/forgot_password_ivr"
        static let kforgotPwdOtp = "/forgot_password_otp"
        //{{event_category}}
        static let kCatLoginSignup = "login_signup"
        static let kCatAuthV2 = "auth"
        static let kCatLoginV2 = "login"
        static let kCatSignUpV2 = "signup"
        static let kCatIndVerticalLoginSignup = "ind_vertical_login_signup"
        static let kSessionExpiryPrompt = "session_expiry_prompt"
        static let kchangePwdSec = "change_password_security"
        static let kupgradePwdCat = "upgrade_password"
        static let kforgotPwd = "forgot_password"
        //{{event_action}}
        static let kLoginScreenLoaded = "login_signup_screen_loaded"
        static let kPasswordScreenLoaded = "login_password_screen_loaded"
        static let kChangeLang = "change_lang_clicked"
        static let kHidePwd = "hide_clicked"
        static let kShowPwd = "show_clicked"
        static let kOtpSignupLoaded = "signup_otp_screen_loaded"
        static let kOtpSigninLoaded = "login_otp_screen_loaded"
        static let kResendOtpPopupLoaded = "resend_popup_loaded"
        static let kResendOtpSmsClicked = "resend_otp_sms"
        static let kResendOtpCallClicked = "resend_otp_call"
        static let kLabelLoginMobile = "mobile_number"
        static let kLabelLoginCache = "cache"
        static let kLabelApp = "app"
        static let kLabelAPI = "api"
        static let kLabelPwdOtp = "password_otp"
        static let kLabelCustId = "Customer_Id"
        static let kSignUpSuccess = "signup_successful"
        static let kLoginSuccess = "login_successful"
        static let kmobile_number_entered = "mobile_number_entered"
        static let kproceed_clicked = "proceed_clicked"
        static let klogin_issue_clicked = "login_issue_clicked"
        static let klogin_otp_entered = "otp_entered"
        static let kresend_otp_clicked = "resend_otp_clicked"
        static let kback_button_clicked = "back_button_clicked"
        static let kforgot_password_clicked = "forgot_password_clicked"
        static let kskip_button_clicked = "skip_button_clicked"
        static let kfullPage = "full page"
        static let kbottomSheet = "bottom page"
        static let ksesseionExpiry = "session_expiry"
        static let kphoneNumberPopupLoaded = "phone_number_popup_loaded"
        static let kpopupDiscarded = "popup_discarded"
        static let kpasswordPopupLoadeed = "password_popup_loaded"
        static let kloginWithDiffAccount = "login_to_a_diff_account"
        static let kproceedSecurelyClicked = "login_securely_clicked"
        static let kotpPopupLoaded = "otp_popup_loaded"
        static let kotpLoginIssueeClicked = "having_login_issue_clicked"
        static let kchangePwdLoaded = "change_password_screen_loaded"
        static let kforgotPwdLoaded = "forgot_password_phone_number_screen_loaded"
        static let kforgotPwdIVRLoaded = "forgot_password_ivr_pop_up_loaded"
        static let kforgotPwdOtpLoaded = "forgot_password_sms_screen_loaded"
        static let ksetForgotPwdLoaded = "forgot_password_set_new_loaded"
        static let kforgotPwdResentOtp = "forgot_password_resend_otp"
        static let ksetForgotPwdSavedClicked = "set_new_password_save_clicked"
        static let ksetForgotPwdSuccess = "password_set_success"
        static let ksetForgotPwdLoginSuccess = "forgot_password_login_success"
        static let kivrTapped = "ivr_pop_up_clicked"
        static let ksavedClicked = "save_clicked"
        static let kforgotPwdConfirmClicked = "confirm_clicked"
        static let kpwdChangeSuccess = "password_change_success"
        static let kpwdUpgradeSuccess = "password_change_success"
        static let ksameMobileNumber = "same_mobile_number"
        static let kdiffMobileNumber = "diff_mobile_number"
    }
}
