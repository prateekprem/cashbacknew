//
//  JRApplockModels.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 29/08/20.
//

protocol JRApplockDelegate: class {
    func userTappedConfirm()
    func userTappedSkip()
    func userTappedCancelOnSettingsAlert()
    func didReturnFromSettingsPage()
}

struct JRApplockViewModel {
    let mainTitle: String
    let subtitle1: String
    let subtitle2: String
    let confirmText: String
    let cancelText: String
    
    public init(mainTitle: String, subtitle1: String, subtitle2: String, confirmText: String, cancelText: String) {
        self.mainTitle = mainTitle
        self.subtitle1 = subtitle1
        self.subtitle2 = subtitle2
        self.confirmText = confirmText
        self.cancelText = cancelText
    }
}

public enum JRApplockTaskDefinition {
    case activation
    case deactivation
    case forceSet
}

public enum JRApplockError: String, Error {
    case authenticationFailed = "The user failed to provide valid credentials"
    case appCancel = "Authentication was cancelled by application"
    case invalidContext = "The context is invalid"
    case notInteractive = "Not interactive"
    case passcodeNotSet = "Passcode is not set on the device"
    case systemCancel = "Authentication was cancelled by the system"
    case userCancel = "The user did cancel"
    case userFallback = "The user chose to use the fallback"
    case evaluatePolicyFail = "Too many failed attempts / No authentication available / No authentication enrolled"
    case SET_OR_ACTIVATE_GTM_Unsatisfied = "Set/Activate GTM not satisfied"
    case VERIFY_GTM_Unsatisfied = "Verify GTM not satisfied"
    
    public var description: String {
        return self.rawValue
    }
}

public enum JRApplockMessage: String {
    case userLoggedOut = "User is logged out"
    case skipSelected = "SKIP"
    case cancelSelectedOnSettingsAlert = "Cancel tapped when prompted to go to settings"
    case authenticationSucceeded = "Authentication successful"
    case authenticationFailed = "Authentication unsuccessful"
    case deactivationSucceeded = "Deactivation successful"
    case SET_OR_ACTIVATE_GTM_Unsatisfied_CONTEXT = "oauthSetAppLockInterval_ios"
    case VERIFY_GTM_Unsatisfied_CONTEXT = "oauthVerifyLockOnLogin_ios / oauthVerifyLockOnAppLaunch_ios / BackgroundTime < 15 minutes"
    
    public var description: String {
        return self.rawValue
    }
}
