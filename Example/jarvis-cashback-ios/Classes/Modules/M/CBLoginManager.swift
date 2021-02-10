//
//  CBLoginManager.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 02/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import jarvis_auth_ios
import jarvis_common_ios

typealias CBLoginCompletion = (_ sucess: Bool, _ error: Error?) -> Swift.Void

class CBLoginManager {
    static let shared = CBLoginManager()
    private init() {
        configLoginAuth()
    }
    
    private var mCompletion: CBLoginCompletion?
    
    static let kAuthCode     = "Basic bWFya2V0LWFwcDo5YTA3MTc2Mi1hNDk5LTRiZDktOTE0YS00MzYxZTdjM2Y0YmM="
    static let kClientSecret = "9a071762-a499-4bd9-914a-4361e7c3f4bc"
    static let kClientId      = "market-app"
    
    class var isUsrLoggedIn: Bool { get { return LoginAuth.sharedInstance().isLoggedIn() } }
    
    // MARK: - Methods
    private func configLoginAuth() {
        JRLoginUI.sharedInstance().delegate = self
        LoginAuth.sharedInstance().delegate = self
        LoginAuth.sharedInstance().setClientID(CBLoginManager.kClientId)
        LoginAuth.sharedInstance().setClientSecret(CBLoginManager.kClientSecret)
        LoginAuth.sharedInstance().setAuthorizationCode(CBLoginManager.kAuthCode)
        LoginAuth.sharedInstance().setEnvironment(.production)
    }
    
    func getLogin(completion: CBLoginCompletion?) {
        self.mCompletion = completion
        JRLoginUI.sharedInstance().signIn()
    }
    
    func getLogout() {
        JRLoginUI.sharedInstance().signOut()
    }
    
    static func setUpEnvironment(viewController: UIViewController) {
        let selectedEnvironment = UserDefaults.standard.integer(forKey: "keySelectedEnvironment")
        if (selectedEnvironment == JRLPaytmEnvironment.none.rawValue) {
            DispatchQueue.main.async {
                // Create the alert controller
                let alertController = UIAlertController(title: "GTM Server selection", message: "Please select GTM server environment.", preferredStyle: .alert)
                
                // Create the actions
                let okAction = UIAlertAction(title: "Production", style: UIAlertAction.Style.default) {
                    UIAlertAction in
                    UserDefaults.standard.set(JRLPaytmEnvironment.production.rawValue, forKey: "keySelectedEnvironment")
                    UserDefaults.standard.synchronize()
                    
                }
                let cancelAction = UIAlertAction(title: "Staging API", style: UIAlertAction.Style.cancel) {
                    UIAlertAction in
                    UserDefaults.standard.set(JRLPaytmEnvironment.staging.rawValue, forKey: "keySelectedEnvironment")
                    UserDefaults.standard.synchronize()
                }
                
                // Add the actions
                alertController.addAction(okAction)
                alertController.addAction(cancelAction)
                
                // Present the controller
                viewController.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - JarvisLoginDelegate
extension CBLoginManager: JarvisLoginDelegate {
    func signIn(isSuccess: Bool?, error: Error?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signInComplete"), object: nil)
    }
    
    func signOut(success: Bool?, error: Error?) {
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "signOutComplete"), object: nil)
    }
    
    func signOut(completionHandler: @escaping ((Bool?, Error?) -> Void)) { }
   
    func signInUserDenied() { print("user Denied") }
    
    func pushLoginIssues(_ mobileNumber: String, _ fromViewController: UIViewController) { }
    
    func pushForgotPassword(_ loginId: String, _ fromViewController: UIViewController) { }
    
    func getGTMKeyValue<T>(_ gtmKey: String) -> T? {
      return  CBRemoteConfig.keyValue(gtmKey)
    }
    
    func trackCustomEventforScreen(_ screenName: String?, eventName: String?, variables: [AnyHashable : Any]?) { }
    
    func pushHomeView(_ animated: Bool, _ isLoginRequired: Bool) {
        JRLoginUI.sharedInstance().signIn()
    }

    func pushFacingOtherIssuesScreen(_ fromViewController: UIViewController) { print("push") }
}

// MARK: - LoginAuthDelegate
extension CBLoginManager: LoginAuthDelegate {
    func encryptDataWithRSAKey(_ data: String, _ publicKey: String) -> String? {
        return nil
    }
    
    func getWalletTokenFromJRAccount() -> String { return "" }
   
    func getClientSecret() -> String { return "" }
    
    func getClientAuthorizationCode() -> String { return "" }
    
    func defaultParamsWithSiteIDs(forUrl url: String?) -> [AnyHashable : Any]? { return [:] }
    
    func setServerTimeInJRDigitalProductManager(dateString: String) { }
    
    func setWalletToken(token: String, andObject object: [String : Any]) { }
    
    func getDefaultParams() -> [String : Any]? {
        return JRAPIManager.sharedManager().defaultParamsDictionary() as? [String : Any]
    }
    
    func setKeyChainObject(object: Any, forKey: String) { }
    
    func keyChainObject(forKey: String) -> Any? { return nil }
    
    func ssoTokenUpdatedSuccessfully() { }
}
