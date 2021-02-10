//
//  JRApplockHelper.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 29/08/20.
//


import UIKit
import LocalAuthentication

//MARK:- Enums
public enum JRApplockOnboardingStatus: Int {
    case login = 2
    case signup = 1
    case none = 0
}

private enum JRApplockCase {
    case activate, verify
}

public enum JRApplockVerifyStatus {
    case activate    // Show Popup and then authenticate
    case set         // Show Popup and then authenticate
    case forceset    // Authenticate directly
    case none
}

//MARK:- JRApplockHelper
public final class JRApplockHelper {
    static public let sharedInstance = JRApplockHelper()
    private var completionHandler: ((Bool, JRApplockError?, JRApplockMessage?) -> Void)?
    private var extraCompletionHandler: ((Bool, JRApplockError?, JRApplockMessage?) -> Void)?
    private var localAuthenticationContext = LAContext()
    private var mandatoryAlert: UIAlertController?
    private var blurVisualEffectView = UIVisualEffectView()
    private var controller: UIViewController?
    private var error: NSError?
    private var isForceSet: Bool = false
    private var isFromBackground: Bool = false
    private var isSystemCancel: Bool = false
    private var isBlurAdded = false
    private var isMandatoryAlertBeingShown: Bool = false
    private var isInVerifyLoop: Bool = false
    
    private init() {
        addNotificationObservers()
        if UserDefaults.standard.bool(forKey: "areApplockGTMUserDefaultsInitialised") == false {
            initialiseGTMUserDefaults()
        }
    }
    
    public func devicePasscodeSet() -> Bool {
        //checks to see if devices (not apps) passcode has been set
        LAContext().canEvaluatePolicy(.deviceOwnerAuthentication, error: nil)
    }
    
    public func isAppLockEnanledForUI() -> Bool {
        let val = devicePasscodeSet() && isApplockEnabled()
        setApplockEnabled(to: val)
        return val
    }
    
    public func perform(_ task: JRApplockTaskDefinition, navigationController: UINavigationController? = nil,completion: ((Bool, JRApplockError?, JRApplockMessage?) -> Void)?) {
        let ltopVC: UIViewController?
        if let nav = navigationController{
            ltopVC = nav.topViewController
        }
        else{
            if let vc = UIApplication.topViewController(){
                ltopVC = vc
            }
            else{
                handleCompletion(false, error: .notInteractive, message: .none)
                return
            }
        }
        guard let topVC = ltopVC else {
            handleCompletion(false, error: .notInteractive, message: .none)
            return
        }
        controller = topVC
        completionHandler = completion
        extraCompletionHandler = completion
        switch task {
        case .activation:
            self.isForceSet = false
            self.initiateActivation()
        case .deactivation:
            self.deactivateApplock()
        case .forceSet:
            self.isForceSet = true
            self.initiateActivation()
        }
    }
    
    public func processSubsequentLoginDatesForApplock(date: Date) {
        guard getIsLoginFromFullScreen() else { return }
        let daysBwSubsequentLogins = NSDate.numberOfDaysFromDate(getInitialLoginDate(), toDate: date)
        setIsLoginAfterThresholdDays(to: daysBwSubsequentLogins > applockSetActivateInterval())
        setInitialLoginDate(with: Date())
    }
}

//MARK:- private Methods
extension JRApplockHelper {
    private func deactivateApplock() {
        addBlurView()
        let reason = "jr_login_confirm_text_deactivate".localized
        localAuthenticationContext.invalidate()
        localAuthenticationContext = LAContext()
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [weak self] success, error in
                DispatchQueue.main.async { [weak self] in
                    guard let weakSelf = self else { return }
                    if success {
                        // Diable AppLock in paytm app security settings
                        weakSelf.setApplockEnabled(to: false)
                        weakSelf.handleCompletion(true, error: nil, message: .deactivationSucceeded)
                    } else {
                        guard let error = error as NSError? else { return }
                        weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                    }
                }
            }
        } else {
            guard let error = error as NSError? else { return }
            self.handleCompletion(false, error: self.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
        }
    }
    
    private func addBlurView() {
        guard !isBlurAdded, let controller = self.controller else { return }
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        self.blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        self.blurVisualEffectView.frame = controller.view.bounds
        self.blurVisualEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.addSubview(self.blurVisualEffectView)
        self.isBlurAdded = true
    }
    
    private func startAuthFlow(isPasscodeSet: Bool) {
        guard shouldProceedWithApplockActivation(isPasscodeSet: isPasscodeSet) else {
            handleCompletion(false, error: .SET_OR_ACTIVATE_GTM_Unsatisfied, message: .SET_OR_ACTIVATE_GTM_Unsatisfied_CONTEXT)
            return
        }
        setIsLoginAfterThresholdDays(to: false)
        setApplockEnabled(to: false)
        let model = JRApplockViewModel(mainTitle: "jr_login_main_title".localized,
                                       subtitle1: isPasscodeSet ? "jr_login_device_lock_set_sbtitle1".localized : "jr_login_device_lock_not_set_sbtitle1".localized,
                                       subtitle2: isPasscodeSet ? "jr_login_device_lock_set_sbtitle2".localized : "",
                                       confirmText: isPasscodeSet ? "jr_login_confirm_text_activate".localized : "jr_login_confirm_text_set".localized,
                                       cancelText: "jr_login_cancel_text".localized)
        let popup = getPopupController(isPasscodeSet: isPasscodeSet, viewController: self)
        DispatchQueue.main.async {
            popup.viewModel = model
            self.controller?.present(popup, animated: true, completion: nil)
        }
    }
    
    private func initiateActivation() {
        guard LoginAuth.sharedInstance().isLoggedIn() else {
            handleCompletion(false, error: nil, message: .userLoggedOut)
            return
        }
        localAuthenticationContext.invalidate()
        localAuthenticationContext = LAContext()
        localAuthenticationContext.localizedFallbackTitle = "jr_login_applock_fallback_title".localized
        if localAuthenticationContext.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            // Case: PASSCODE is turned ON in Device
            if isApplockEnabled() {
                // VERIFY: Device - ON | Paytm App - ON //
                authenticateUser(after: .none)
            } else {
                // ACTIVATE: Device - ON | Paytm App - OFF //
                isForceSet ? authenticateUser(after: .forceset) : startAuthFlow(isPasscodeSet: true)
            }
        } else {
            guard let error = error else { return }
            if error._code == LAError.passcodeNotSet.rawValue {
                handlePasscodeNotSetError()
            } else {
                handleCompletion(false, error: evaluateAuthenticationPolicyMessage(errorCode: error._code), message: nil)
            }
        }
    }
    
    private func getPopupController(isPasscodeSet: Bool, viewController: JRApplockDelegate) -> ApplockViewController {
        guard let controller = ApplockViewController.getController() else { return ApplockViewController() }
        controller.modalPresentationStyle = .overCurrentContext
        controller.modalTransitionStyle = .crossDissolve
        controller.isPasscodeSet = isPasscodeSet
        controller.delegate = viewController
        return controller
    }
    
    private func authenticateUser(after userStatus: JRApplockVerifyStatus) {
        guard shouldProceedWithUserVerification() else {
            handleCompletion(false, error: .VERIFY_GTM_Unsatisfied, message: .VERIFY_GTM_Unsatisfied_CONTEXT)
            return
        }
        localAuthenticationContext.invalidate()
        localAuthenticationContext = LAContext()
        addBlurView()
        let reason: String
        switch userStatus {
        case .activate, .forceset: reason = "jr_login_confirm_text_activate".localized
        case .set: reason = "jr_login_confirm_text_set".localized
        default: reason = "jr_login_confirm_text_unlock".localized
        }
        localAuthenticationContext.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason ) { [weak self] success, error in
            DispatchQueue.main.async { [weak self] in
                guard let weakSelf = self else { return }
                if success {
                    // Case: PASSCODE was turned ON -> ACTIVATE clicked -> User-Authentication Done (Enable AppLock in paytm app security settings)
                    weakSelf.setApplockEnabled(to: true)
                    weakSelf.handleCompletion(true, error: nil, message: .authenticationSucceeded)
                } else {
                    guard let error = error as NSError? else { return }
                    if #available(iOS 13.0, *) {
                        switch weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code) {
                        case .userCancel:
                            if userStatus == .none {
                                // Case: PASSCODE was turned ON -> ACTIVATE clicked -> CANCEL clicked
                                weakSelf.showVerificationMandatoryAlert()
                            } else {
                                weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                            }
                        case .systemCancel, .evaluatePolicyFail:
                            weakSelf.isSystemCancel = true
                            weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                        default:
                            weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                        }
                    } else {
                        switch weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code) {
                        case .userCancel:
                            if userStatus == .none {
                                // Case: PASSCODE was turned ON -> ACTIVATE clicked -> CANCEL clicked
                                weakSelf.showVerificationMandatoryAlert()
                            } else {
                                weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                            }
                        default:
                            weakSelf.isSystemCancel = true
                            weakSelf.handleCompletion(false, error: weakSelf.evaluateAuthenticationPolicyMessage(errorCode: error._code), message: .authenticationFailed)
                        }
                    }
                }
            }
        }
    }
    
    private func showVerificationMandatoryAlert() {
        DispatchQueue.main.async {
            self.mandatoryAlert = UIAlertController(title: "jr_login_applock_mandatory_title".localized, message: "jr_login_applock_mandatory_subtitle".localized, preferredStyle: UIAlertController.Style.alert)
            self.mandatoryAlert?.addAction(UIAlertAction(title: "jr_login_ok".localized, style: .default, handler: { (action: UIAlertAction!) in
                self.isMandatoryAlertBeingShown = false
                self.isInVerifyLoop = true
                self.authenticateUser(after: .none)
            }))
            self.isMandatoryAlertBeingShown = true
            if let alert = self.mandatoryAlert {
                UIApplication.topViewController()?.present(alert, animated: true, completion: nil)
            }
        }
    }
    
    private func handlePasscodeNotSetError() {
        // Case: PASSCODE is turned OFF in Device
        DispatchQueue.main.async {
            // Turn the Applock OFF in Paytm App: Device - OFF | Paytm App - ON
            if self.isApplockEnabled() {
                self.setApplockEnabled(to: false)
            }
            // SET: Device - OFF | Paytm App - OFF //
            self.startAuthFlow(isPasscodeSet: false)
        }
    }
    
    private func evaluateAuthenticationPolicyMessage(errorCode: Int) -> JRApplockError? {
        var applockError: JRApplockError?
        switch errorCode {
        case LAError.authenticationFailed.rawValue: applockError = .authenticationFailed
        case LAError.appCancel.rawValue: applockError = .appCancel
        case LAError.invalidContext.rawValue: applockError = .invalidContext
        case LAError.notInteractive.rawValue: applockError = .notInteractive
        case LAError.systemCancel.rawValue: applockError = .systemCancel
        case LAError.userCancel.rawValue: applockError = .userCancel
        case LAError.userFallback.rawValue: applockError = .userFallback
        default: applockError = .evaluatePolicyFail
        }
        return applockError
    }
    
    private func handleCompletion(_ value: Bool, error: JRApplockError?, message: JRApplockMessage?) {
        isForceSet = false
        isInVerifyLoop = false
        if isBlurAdded {
            blurVisualEffectView.removeFromSuperview()
            isBlurAdded = false
        }
        if let completion = self.completionHandler {
            completion(value, error, message)
            self.completionHandler = nil
            LoginAuth.sharedInstance().applockFlowCompleted()
        }
    }
}

//MARK: - Notification Observers
extension JRApplockHelper {
    private func addNotificationObservers() {
        addObserver(for: UIApplication.willEnterForegroundNotification, selector: #selector(willEnterForeground))
        addObserver(for: UIApplication.didEnterBackgroundNotification, selector: #selector(didEnterBackground))
        addObserver(for: UIApplication.didBecomeActiveNotification, selector: #selector(didBecomeActive))
        addObserver(for: NSNotification.Name(rawValue: "notificationDidEndDeferredInit"), selector: #selector(setGTMUserDefaults))
    }
    private func addObserver(for name: NSNotification.Name, selector: Selector) {
        NotificationCenter.default.addObserver(self, selector: selector, name: name, object: nil)
    }
    @objc func willEnterForeground() {
        guard JRApplockHelper.sharedInstance.applockFeatureGTM() else { return }
        if let didEnterBackgroundTime = getApplicationWentToBackground() {
            let timeSpentInBackground = NSDate().numberOfMinutesSinceDate(didEnterBackgroundTime)
            setTotalBackgroundTime(to: timeSpentInBackground)
        }
        if LoginAuth.sharedInstance().isLoggedIn() && isApplockEnabled() {
            self.completionHandler = self.extraCompletionHandler
            if isMandatoryAlertBeingShown {
                DispatchQueue.main.async {
                    self.mandatoryAlert?.dismiss(animated: true, completion: nil)
                    self.isFromBackground = true
                    self.authenticateUser(after: .none)
                }
            } else {
                isFromBackground = true
                if getTotalBackgroundTime() >= 15 || isSystemCancel || isMandatoryAlertBeingShown { authenticateUser(after: .none) }
                else { isFromBackground = false }
            }
        }
    }
    @objc func didEnterBackground() { setApplicationWentToBackground(with: Date()) }
    @objc func didBecomeActive() {
        guard isSystemCancel else { return }
        self.completionHandler = self.extraCompletionHandler
        authenticateUser(after: .none)
    }
}

//MARK: - ApplockDelegate
extension JRApplockHelper: JRApplockDelegate {
    func userTappedConfirm() { authenticateUser(after: .activate) }
    func userTappedSkip() { handleCompletion(false, error: nil, message: .skipSelected) }
    func userTappedCancelOnSettingsAlert() { handleCompletion(false, error: nil, message: .cancelSelectedOnSettingsAlert) }
    func didReturnFromSettingsPage() {
        isForceSet = true
        initiateActivation()
    }
}

//MARK: - Main Conditions
extension JRApplockHelper {
    private func shouldProceedWithApplockActivation(isPasscodeSet: Bool) -> Bool {
        defer {
            setIsInitialActivation(to: false)
        }
        if isForceSet || getIsLoginAfterThresholdDays() {
            return true
        }
        if isAppUpdated(for: .activate) {
            setInitialSetDate(with: Date())
            setInitialActivateDate(with: Date())
            return true
        }
        if getIsInitialActivation() && getIsLoginFromFullScreen() {
            return true
        }
        if !isPasscodeSet {
            //every 14 days
            let daysInBetween = NSDate.numberOfDaysFromDate(getInitialSetDate(), toDate: Date())
            setInitialSetDate(with: Date())
            return getIsLoginFromFullScreen() && daysInBetween >= applockSetFrequency()
        } else {
            //every 7 days
            let daysInBetween = NSDate.numberOfDaysFromDate(getInitialActivateDate(), toDate: Date())
            setInitialActivateDate(with: Date())
            return getIsLoginFromFullScreen() && daysInBetween >= applockActivateFrequency()
        }
    }
    
    private func shouldProceedWithUserVerification() -> Bool {
        defer {
            setIsLoginFromFullScreen(to: false)
            setOnboardingStatus(to: .none)
            isSystemCancel = false
            setIsInitialVerification(to: false)
        }
        if isForceSet || isInVerifyLoop || isAppUpdated(for: .verify) || (getIsInitialVerification() && getIsLoginFromFullScreen()) {
            return true
        }
        if isFromBackground {
            isFromBackground = false
            let flag =  (getTotalBackgroundTime() >= 15) || isSystemCancel || isMandatoryAlertBeingShown
            setTotalBackgroundTime(to: 0)
            return flag
        }
        if getOnboardingStatus() == .none {
            return applockVerifyOnEveryLaunch()
        } else {
            //Use this when verification is required only through full screen login -> return applockVerifyOnLogin() && getIsLoginFromFullScreen()
            return applockVerifyOnLogin()
        }
    }
    
    private func initialiseGTMUserDefaults() {
        setApplockFeatureGTM(to: false)
        setApplockSetActivateInterval(to: 90)
        setApplockVerifyOnLogin(to: false)
        setApplockVerifyOnEveryLaunch(to: false)
        setApplockSetFrequency(to: 14)
        setApplockActivateFrequency(to: 7)
        UserDefaults.standard.set(true, forKey: "areApplockGTMUserDefaultsInitialised")
    }
    
    @objc private func setGTMUserDefaults() {
        setApplockFeatureGTM(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthEnableAppLock_ios") ?? false)
        setApplockSetActivateInterval(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSetAppLockInterval_ios") ?? 90)
        setApplockVerifyOnLogin(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthVerifyLockOnLogin_ios") ?? false)
        setApplockVerifyOnEveryLaunch(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthVerifyLockOnAppLaunch_ios") ?? false)
        setApplockSetFrequency(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthSetApplockFrequency_iOS") ?? 14)
        setApplockActivateFrequency(to: JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("oauthActivateApplockFrequency_iOS") ?? 7)
    }
}

//MARK: - GTMs
extension JRApplockHelper {
    
    // Getter Methods
    public func applockFeatureGTM() -> Bool { UserDefaults.standard.bool(forKey: "oauthEnableAppLock_ios_gtm") }
    public func applockSetActivateInterval() -> Int { UserDefaults.standard.integer(forKey: "oauthSetAppLockInterval_ios_gtm") }
    private func applockVerifyOnLogin() -> Bool { UserDefaults.standard.bool(forKey: "oauthVerifyLockOnLogin_ios_gtm") }
    private func applockVerifyOnEveryLaunch() -> Bool { UserDefaults.standard.bool(forKey: "oauthVerifyLockOnAppLaunch_ios_gtm") }
    private func applockSetFrequency() -> Int { UserDefaults.standard.integer(forKey: "oauthSetApplockFrequency_iOS_gtm") }
    private func applockActivateFrequency() -> Int { UserDefaults.standard.integer(forKey: "oauthActivateApplockFrequency_iOS_gtm") }
    
    // Setter Methods
    private func setApplockFeatureGTM(to value: Bool) { UserDefaults.standard.set(value, forKey: "oauthEnableAppLock_ios_gtm") }
    private func setApplockSetActivateInterval(to value: Int) { UserDefaults.standard.set(value, forKey: "oauthSetAppLockInterval_ios_gtm") }
    private func setApplockVerifyOnLogin(to value: Bool) { UserDefaults.standard.set(value, forKey: "oauthVerifyLockOnLogin_ios_gtm") }
    private func setApplockVerifyOnEveryLaunch(to value: Bool) { UserDefaults.standard.set(value, forKey: "oauthVerifyLockOnAppLaunch_ios_gtm") }
    private func setApplockSetFrequency(to value: Int) { UserDefaults.standard.set(value, forKey: "oauthSetApplockFrequency_iOS_gtm") }
    private func setApplockActivateFrequency(to value: Int) { UserDefaults.standard.set(value, forKey: "oauthActivateApplockFrequency_iOS_gtm") }
}

//MARK: - User Defaults
extension JRApplockHelper {
    // Getter Methods
    public func isApplockEnabled() -> Bool { UserDefaults.standard.bool(forKey: "ShowAlertForAppLock") }
    public func getIsLoginFromFullScreen() -> Bool { UserDefaults.standard.bool(forKey: "isLoginFromFullScreen") }
    public func getInitialLoginDate() -> Date { UserDefaults.standard.object(forKey: "InitialLoginDate") as? Date ?? Date() }
    public func getIsLoginAfterThresholdDays() -> Bool { UserDefaults.standard.bool(forKey: "IsLoginAfterThresholdDays") }
    private func getApplicationWentToBackground() -> Date? { UserDefaults.standard.object(forKey: "ApplicationWentToBackground") as? Date }
    private func getTotalBackgroundTime() -> Int { UserDefaults.standard.integer(forKey: "TotalBackgroundTime") }
    private func getInitialSetDate() -> Date { UserDefaults.standard.object(forKey: "InitialSetDate") as? Date ?? Date() }
    private func getInitialActivateDate() -> Date { UserDefaults.standard.object(forKey: "InitialActivateDate") as? Date ?? Date() }
    private func getIsInitialActivation() -> Bool { !UserDefaults.standard.bool(forKey: "IsInitialActivation") }
    private func getIsInitialVerification() -> Bool { !UserDefaults.standard.bool(forKey: "IsInitialVerification") }
    private func isAppUpdated(for applockCase: JRApplockCase) -> Bool { checkVersion(userDefaultKey: (applockCase == .activate) ? "appVersion_applock_activate" : "appVersion_applock_verify") }
    public func getOnboardingStatus() -> JRApplockOnboardingStatus {
        let status = UserDefaults.standard.integer(forKey: "hasUserLoggedIn")
        switch status {
        case 1: return .signup
        case 2: return .login
        default: return .none
        }
    }
    // Setter Methods
    public func setOnboardingStatus(to value: JRApplockOnboardingStatus) { UserDefaults.standard.set(value.rawValue, forKey: "hasUserLoggedIn") }
    public func setIsLoginFromFullScreen(to value: Bool) { UserDefaults.standard.set(value, forKey: "isLoginFromFullScreen") }
    public func setInitialLoginDate(with date: Date) { UserDefaults.standard.set(date, forKey: "InitialLoginDate") }
    public func setIsLoginAfterThresholdDays(to value: Bool) { UserDefaults.standard.set(value, forKey: "IsLoginAfterThresholdDays") }
    private func setApplockEnabled(to value: Bool) { UserDefaults.standard.set(value, forKey: "ShowAlertForAppLock") }
    private func setApplicationWentToBackground(with date: Date) { UserDefaults.standard.set(date, forKey: "ApplicationWentToBackground") }
    private func setTotalBackgroundTime(to value: Int) { UserDefaults.standard.set(value, forKey: "TotalBackgroundTime") }
    private func setInitialSetDate(with date: Date) { UserDefaults.standard.set(date, forKey: "InitialSetDate") }
    private func setInitialActivateDate(with date: Date) { UserDefaults.standard.set(date, forKey: "InitialActivateDate") }
    private func setIsInitialActivation(to value: Bool) { UserDefaults.standard.set(!value, forKey: "IsInitialActivation") }
    private func setIsInitialVerification(to value: Bool) { UserDefaults.standard.set(!value, forKey: "IsInitialVerification") }
    internal func setVersionUserDefaults() {
        checkVersion(userDefaultKey: "appVersion_applock_activate")
        checkVersion(userDefaultKey: "appVersion_applock_verify")
    }
    @discardableResult private func checkVersion(userDefaultKey: String) -> Bool {
        guard let currentAppVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String else { return false }
        if let previousVersion = UserDefaults.standard.string(forKey: userDefaultKey), previousVersion != currentAppVersion {
            UserDefaults.standard.set(currentAppVersion, forKey: userDefaultKey)
            return true
        } else if UserDefaults.standard.string(forKey: userDefaultKey) == nil {
            UserDefaults.standard.set(currentAppVersion, forKey: userDefaultKey)
            return true
        }
        return false
    }
}
