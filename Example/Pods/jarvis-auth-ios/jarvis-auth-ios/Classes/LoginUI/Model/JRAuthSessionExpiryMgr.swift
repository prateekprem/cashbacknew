//
//  JRAuthSessionExpiryMgr.swift
//  jarvis-auth-ios
//
//  Created by Chetan Agarwal on 24/02/20.
//

import UIKit

final class JRAuthSessionExpiryMgr: NSObject {
    
    final class func openLogin() {
        DispatchQueue.main.async {
            var preFilledLoginId = ""
            if let loginId = UserDefaults.standard.string(forKey: "prefilledLoginId") {
                preFilledLoginId = loginId
            }
            JRLoginUI.sharedInstance().signIn(.mobile, preFilledLoginId, screenType: .fullScreen)
        }
    }
    
    final class func openLoginPassword(model: JRLOtpPsdVerifyModel, completion: JRQuickLoginCompletion?){
        JRLoginUI.sharedInstance().delegate?.sessionExpired()
        
        if let vc = UIApplication.topViewController() {
            let tVc = JRAuthPwdPopupVC.controller(model, loginFlowType: .sessionExpiry)
            tVc.completion = completion
            let nav = UINavigationController.init(rootViewController: tVc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
            vc.present(nav, animated: true, completion: nil)
        }    }
    
    final class func openLoginOTP(loginId: String, stateToken: String, loginType: JarvisLoginType, completion: JRQuickLoginCompletion?, allowUPI: Bool = false){
        JRLoginUI.sharedInstance().delegate?.sessionExpired()
        
        if let vc = UIApplication.topViewController() {
            let dataModel = JRLOtpPsdVerifyModel(loginId: loginId, stateToken: stateToken, otpTextCount: 6, loginType: loginType)
            dataModel.allowUPI = allowUPI
            let tVc = JRAuthOTPPopupVC.newInstance(dataModel, loginFlowType: .sessionExpiry)
            tVc.completion = completion
            let nav = UINavigationController.init(rootViewController: tVc)
            nav.navigationBar.isHidden = true
            nav.modalPresentationStyle =  UIModalPresentationStyle.overFullScreen
            vc.present(nav, animated: true, completion: nil)
        }
    }
}
