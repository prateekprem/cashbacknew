//
//  JRAlertView.swift
//  LogoutFromAll
//
//  Created by Rahul Kamra on 24/05/18.
//  Copyright © 2018 Rahul Kamra. All rights reserved.
//

import UIKit

public protocol JRAlertViewDelegate:NSObjectProtocol {
    func didTapOnActionButton()
    func didTapOnCloseButton()
}

open class JRAlertView: UIView {

    @IBOutlet weak open var titleLabel: UILabel!
    @IBOutlet weak open var messageLabel: UILabel!
    @IBOutlet weak open var actionButton: UIButton!
    @IBOutlet weak open var containerView: UIView!
    
    weak open var alertViewDelegate:JRAlertViewDelegate?
    
    open var lineHeight:CGFloat?
    open var requireCornerRadius = true
    open var messageString:String = ""
    
    open class func instanceFromNib(title: String = "", message: String = "", actionButtonTitle:String = "") -> JRAlertView {
        let alertView = JRAlertView.nib.instantiate(withOwner: nil, options: nil)[0] as! JRAlertView
        alertView.titleLabel.text = title
        alertView.actionButton.setTitle(actionButtonTitle, for:.normal)
        alertView.messageString = message
        return alertView
    }
    
    public static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.framework)
    }
    
    private static var identifier: String {
        return String(describing: self)
    }
    
    open func showAlert() {
        setUIForAlertView(message: messageString)
    }
    
    open func setUIForAlertView(message:String) {
        if let lineSpacing = lineHeight {
            messageLabel.attributedText = getAttributedStringForMessage(message: message,lineHeight: lineSpacing)
        }
        else {
            messageLabel.text = message
        }
        if requireCornerRadius {
            actionButton.layer.cornerRadius = 2.0
            containerView.layer.cornerRadius = 6.0
        }
    }
    
    private func getAttributedStringForMessage(message:String,lineHeight:CGFloat)->NSMutableAttributedString {
        let attrString = NSMutableAttributedString(string: message)
        let style = NSMutableParagraphStyle()
        style.minimumLineHeight = lineHeight // change line spacing between each line like 30 or 40
        let range = NSMakeRange(0, attrString.length)
        attrString.addAttribute(.paragraphStyle, value: style, range: range)
        return attrString
    }
    
    @IBAction func closeButtonTapped(_ sender: Any) {
        alertViewDelegate?.didTapOnCloseButton()
    }
    
    @IBAction func logoutButtonTapped(_ sender: Any) {
        alertViewDelegate?.didTapOnActionButton()
    }

}
