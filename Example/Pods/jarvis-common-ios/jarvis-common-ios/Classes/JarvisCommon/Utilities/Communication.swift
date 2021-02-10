//
//  Communication.swift
//  MerchantApp
//
//  Created by Prakash Raj Jha on 7/27/18.
//  Copyright © 2018 PayTm. All rights reserved.
//

import UIKit
import MessageUI

class Communication: NSObject, MFMailComposeViewControllerDelegate  {
    
    static let sharedInstance : Communication = {
        let instance = Communication()
        return instance
    }()

    class func getCalledOn(_ ph: String) -> Bool {
        if ph.isEmpty{
            JRAlertViewWithBlock.showAlertView("Phone number is not currect.")
            return false
        }
        
        // make call
        if let url = URL(string: "tel://\(ph)") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url, options: [:], completionHandler: nil)
                return true
            }
            
            JRAlertViewWithBlock.showAlertView("Your device does not support call facility.")
            return false
        }
        
        return false
    }
    
    class func mailTo(_ toIds:[String]?, ccIds:[String]?, sub: String, body: String, controller: UIViewController) {
        if MFMailComposeViewController.canSendMail() {
            let composer = MFMailComposeViewController()
            composer.mailComposeDelegate = Communication.sharedInstance
            composer.setMessageBody(body, isHTML: false)
            composer.setSubject(sub)
            
            if toIds != nil { composer.setToRecipients(toIds); }
            if ccIds != nil { composer.setCcRecipients(ccIds); }
            controller.present(composer, animated: true, completion: nil)
            
        } else {
            JRAlertViewWithBlock.showAlertView("Email facility is not available on this device.")
        }
    }
    
    // MARK: - MFMailComposeViewControllerDelegate
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        
        var alrtMsg = ""
        switch result {
        case .cancelled: alrtMsg = "Mail cancelled"
        case .saved:     alrtMsg = "Mail saved"
        case .sent:      alrtMsg = "Mail sent"
        case .failed:    alrtMsg = error!.localizedDescription
        @unknown default: alrtMsg = ""
        }
        
        controller.dismiss(animated: true, completion: {
            if !alrtMsg.isEmpty {
                JRAlertViewWithBlock.showAlertView(alrtMsg)
            }
        })
    }
    
}
