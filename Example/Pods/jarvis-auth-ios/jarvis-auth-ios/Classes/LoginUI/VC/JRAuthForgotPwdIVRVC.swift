//
//  JRAuthForgotPwdIVRVC.swift
//  jarvis-auth-ios
//
//  Created by Sanjay Mohnani on 07/02/19.
//

import Foundation
import UIKit
import jarvis_locale_ios

class JRAuthForgotPwdIVRVC: JRAuthBaseVC {
    
    @IBOutlet private weak var headerView    : UIView!
    @IBOutlet private weak var backBtn       : UIButton!
    @IBOutlet private weak var designImgView : UIImageView!
    @IBOutlet private weak var msgLbl        : UILabel!
    @IBOutlet private weak var callBtn       : UIButton!
    @IBOutlet private weak var bottomView    : UIView!
    @IBOutlet private weak var blueView      : UIView!
    @IBOutlet private weak var purpleView    : UIView!
    
    class var newInstance: JRAuthForgotPwdIVRVC {
        let vc = JRAuthManager.kAuthStoryboard.instantiateViewController(withIdentifier: "JRAuthForgotPwdIVRVC") as! JRAuthForgotPwdIVRVC
        return vc
    }
    
    // MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        var callNumber = ""
        if let value : String = JRLoginUI.sharedInstance().delegate?.getGTMKeyValue("key_forgot_password_ivr") {
            callNumber = value
        }
        callBtn.setTitle(" " + callNumber, for: .normal)
        callBtn.roundCorner(1, callBtn.titleColor(for: .normal), callBtn.frame.height/2, true)
        
        let message  = NSMutableAttributedString(string: NSLocalizedString("jr_ac_no_one_will_ever_call_back"), attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 16.0)])
        message.append(NSAttributedString(string: " \n " +  NSLocalizedString("jr_ac_still_wish_to_reset_password"), attributes:  [NSAttributedString.Key.font : UIFont.boldSystemFont(ofSize: 16.0)]))
        msgLbl.attributedText = message
    }
    
    // MARK: - IBActions
    @IBAction func onBackBtnTouch(_ sender: UIButton) {
        handleBackbtn()
    }
    
    @IBAction func onCallBtnTouch(_ sender: UIButton) {
        if let number = sender.currentTitle {
            let trimmedNumber = number.components(separatedBy: .whitespaces).joined()
            if let phoneCallURL:URL = URL(string: "tel://\(trimmedNumber)") {
                let application:UIApplication = UIApplication.shared
                if (application.canOpenURL(phoneCallURL)) {
//                    JRLoginGACall.forgotPwdCCNumberClicked()
                    application.open(phoneCallURL, options: [:], completionHandler: nil)
                }
            }
        }
    }
}
