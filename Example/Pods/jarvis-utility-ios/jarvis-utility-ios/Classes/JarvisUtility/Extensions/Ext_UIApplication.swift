//
//  Ext_UIApplication.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 23/05/19.
//

import UIKit

public extension UIApplication{
    
    var statusBarView: UIView? {
        if responds(to: Selector(("statusBar"))) {
            return value(forKey: "statusBar") as? UIView
        }
        return nil
    }
    
    @objc class func topViewController(base: UIViewController? = UIApplication.shared.delegate?.window??.rootViewController) -> UIViewController? {
        if let nav = base as? UINavigationController {
            return topViewController(base: nav.visibleViewController)
        }
        if let tab = base as? UITabBarController {
            if let selected = tab.selectedViewController {
                return topViewController(base: selected)
            }
        }
        if let presented = base?.presentedViewController {
            return topViewController(base: presented)
        }
        return base
    }
    

    
    class func checkIfTopVCIsPresented(vc : UIViewController) -> Bool {
        if vc.presentingViewController != nil {
            return true
        }
        return false
    }
    
    class func dismissTopVCIfItIsPresented(completion : @escaping (_ dismissed: Bool) -> Void ) {
        if let vc = UIApplication.topViewController() {
            if UIApplication.checkIfTopVCIsPresented(vc: vc) {
                vc.dismiss(animated: false, completion: {
                    completion(true)
                })
            }else{
                completion(false)
            }
        }
        else{
            completion(false)
        }
    }
    
}
