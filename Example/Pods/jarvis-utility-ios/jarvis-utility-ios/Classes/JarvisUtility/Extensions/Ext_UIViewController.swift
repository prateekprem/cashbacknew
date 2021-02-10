//
//  Ext_UIViewController.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIViewController {
    
    public func scrollToTop() {
        func scrollToTop(view: UIView?) {
            guard let view = view else { return }
            
            switch view {
            case let scrollView as UIScrollView:
                if scrollView.scrollsToTop == true {
                    scrollView.setContentOffset(CGPoint(x: 0.0, y: -scrollView.contentInset.top), animated: true)
                    return
                }
            default:
                break
            }
            
            for subView in view.subviews {
                scrollToTop(view: subView)
            }
        }
        
        scrollToTop(view: view)
    }
    
    public func pushViewControllerByRemovingLast(_ viewController: UIViewController, animated: Bool) {
        if var viewControllers = navigationController?.viewControllers {
            viewControllers.removeLast()
            viewControllers.append(viewController)
            navigationController?.setViewControllers(viewControllers, animated: animated)
        }
    }
    
    public func changeErrorMessageMail(_ error: NSError?) -> NSError? {
        if let message = error?.localizedDescription {
            if message.contains("error@paytm.com") {
                let replacedMessage = (message as NSString).replacingOccurrences(of: "error@paytm.com", with: "error.bus@paytm.com")
                if let error = error {
                    let customError = NSError(domain: "Error", code: error.code, userInfo:[NSLocalizedDescriptionKey: replacedMessage])
                    return customError
                }
            }
        }
        return error
    }
    
    @objc public func showAlert(_ message: String) {
        showAlert(message, andTitle: "")
    }
    
    public func showAlert(_ message: String, andTitle title: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertController.Style.alert)
        
        // add an action (button)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil))
        
        // show the alert
        self.present(alert, animated: true, completion: nil)
    }
}
