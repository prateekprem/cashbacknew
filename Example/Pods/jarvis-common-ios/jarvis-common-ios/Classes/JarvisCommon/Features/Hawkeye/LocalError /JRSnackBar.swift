//
//  JRSnackBar.swift
//  Demo
//
//  Created by nasib ali on 07/06/19.
//  Copyright © 2019 nasib ali. All rights reserved.
//

import UIKit

@objc public enum JRSnackBarPresentingMode: Int{
    case priority = 0
    case overlap
}

@objc public enum JRSnackBarState: Int{
    case presenting = 0
    case free
}

@objc public enum JRSnackBarVisibility: Int {
    case low = 2
    case medium = 4
    case high = 6
}

@objc public enum JRSnackBarPosition: Int {
    case top
    case bottom
}

@objc public enum JRSnackBarAction: Int {
    case cancel
    case other
}

private enum ThemeColors {
    case halfColonialWhite
    case black
    case white
    case blue
    var color: UIColor {
        switch self {
        case .halfColonialWhite:
            return UIColor(red: 253/255, green: 250/255, blue: 212/255, alpha: 1.0)
        case .black:
            return UIColor.black
        case .white:
            return UIColor.white
        case .blue:
            return UIColor(red: 0.0, green: 122.0/255.0, blue: 1.0, alpha: 1.0)
        }
    }
}

@objc public enum JRSnackBarTheme: Int {
    case defaultSnackbar
    case payment
    public var colors: (bgColor: UIColor, textColor: UIColor, buttonTextColor: UIColor) {
        switch self {
        case .defaultSnackbar:
            return (bgColor: ThemeColors.black.color, textColor: ThemeColors.white.color, buttonTextColor: ThemeColors.blue.color)
        case .payment:
            return (bgColor: ThemeColors.halfColonialWhite.color, textColor: ThemeColors.black.color, buttonTextColor: ThemeColors.blue.color)
        }
    }
}

final class JRSnackBar: UIView {
    
    @IBOutlet weak var visualEffectView: UIVisualEffectView!
    @IBOutlet weak var tryAgainButton: UIButton!
    @IBOutlet weak var closeButton: UIButton!
    @IBOutlet weak var lblTitle: UILabel!
    @IBOutlet weak var lblContent: UILabel!
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var containerStackView: UIStackView!
    private var presentingState: JRSnackBarState = .free
    internal static var shared: JRSnackBar!
    private var position: JRSnackBarPosition = .top
    private var handler: ((_ action:JRSnackBarAction) -> Void)?
    private static let serialQueue = DispatchQueue(label: "common.snackbar.serialQueue")
    @objc private static func sharedInstance() -> JRSnackBar {
        serialQueue.sync { () -> Void in
            if shared == nil {
                shared = JRSnackBar.instanceFromNib()
            }
        }
        return shared
    }
    
    private var bottomSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return getKeyWindow()?.safeAreaInsets.bottom ?? 0
        } else {
            return 10
        }
    }
    
    private var topSafeArea: CGFloat {
        if #available(iOS 11.0, *) {
            return getKeyWindow()?.safeAreaInsets.top ?? 0
        } else {
            return 10
        }
    }
    
    private class func getSnackInstance(for mode: JRSnackBarPresentingMode)-> JRSnackBar{
        return mode == .priority ? JRSnackBar.sharedInstance() : JRSnackBar.instanceFromNib()
    }
    
    public class func showSnackBar(_ title: String? = nil, barMessage msg: String, isAutoDismiss autoDismiss: Bool, barPosition position: JRSnackBarPosition, barTheme theme: JRSnackBarTheme, presentingMode mode: JRSnackBarPresentingMode = .priority, barVisibility visibility: JRSnackBarVisibility = .medium, otherButtonTitle btnTitle: String? = nil, completionHandler: ((_ action:JRSnackBarAction) -> Void)?) {
        
        let existTitle: String = title ?? ""
        let snack: JRSnackBar = JRSnackBar.getSnackInstance(for: mode)
        if snack.presentingState == .presenting || msg.containsNoChar && existTitle.containsNoChar {return}
        snack.backgroundColor = theme.colors.bgColor
        snack.lblTitle.textColor = theme.colors.textColor
        snack.lblContent.textColor = theme.colors.textColor
        snack.lblTitle.text = existTitle
        snack.lblContent.text = msg
        snack.position = position
        snack.closeButton.isHidden = autoDismiss
        if let btnTitle = btnTitle, btnTitle.containsNoChar && btnTitle.count > 0 {
            snack.tryAgainButton.isHidden = true
        }
        snack.tryAgainButton.setTitle(btnTitle, for: .normal)
        snack.tryAgainButton.setTitleColor(theme.colors.buttonTextColor, for: .normal)
        snack.layoutSnackBar(title: title, message: msg, isAutoDismiss: autoDismiss)
        
        if theme == .payment {
            snack.visualEffectView.effect = UIBlurEffect(style: .extraLight)
        }else{
            snack.visualEffectView.effect = UIBlurEffect(style: .light)
        }
        
        snack.addTap()
        snack.add()
        snack.handler = completionHandler
        snack.addAutoDismiss(visibility: autoDismiss ? visibility : .high)
    }
    
    private func layoutSnackBar(title: String?, message: String, isAutoDismiss autoDismiss: Bool) {
        
        var containerMargin: CGFloat = 25.0
        
        if position == .top {
            containerMargin += topSafeArea
            topConstraint.constant = topSafeArea > 0 ? topSafeArea : 10
        }else if position == .bottom {
            containerMargin += bottomSafeArea
            bottomConstraint.constant = bottomSafeArea > 0 ? bottomSafeArea : 10
        }
        
        containerMargin += (closeButton.isHidden ? 0.0 : 20.0)
        containerMargin += (tryAgainButton.isHidden ? 0.0 : 20.0)
        
        var height: CGFloat = 0.0
        if message.count > 0 {
            height += message.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: lblContent.font) + containerMargin
        }
        
        if let titleExist = title, titleExist.count > 0 {
            height += titleExist.height(withConstrainedWidth: UIScreen.main.bounds.width - 40, font: lblTitle.font)
        }
        
        sizeFit(height: height)
    }
    
    private func addAutoDismiss(visibility: JRSnackBarVisibility){
        self.presentingState = .presenting
        perform(#selector(dismissTapped), with: nil, afterDelay: TimeInterval(visibility.rawValue))
    }
    
    private func sizeFit(height: CGFloat) {
        if position == .top {
            frame = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: height)
        }else if position == .bottom {
            frame = CGRect(x: 0, y: UIScreen.main.bounds.height-height, width: UIScreen.main.bounds.width, height: height)
        }
        layoutIfNeeded()
    }
    
    private func add(){
        let tempFrame  = self.frame
        if position == .top {
            self.frame = CGRect(x: tempFrame.minX, y: tempFrame.minY - tempFrame.height, width: tempFrame.width, height: tempFrame.height)
        }else if position == .bottom {
            self.frame = CGRect(x: tempFrame.minX, y: tempFrame.minY + tempFrame.height, width: tempFrame.width, height: tempFrame.height)
        }
        
        self.getKeyWindow()?.addSubview(self)
        self.layoutIfNeeded()
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            guard let strongSelf = self else {return}
            strongSelf.frame = CGRect(x: tempFrame.minX, y: tempFrame.minY, width: tempFrame.width, height: tempFrame.height)
            strongSelf.layoutIfNeeded()
            }, completion: nil)
    }
    
    private class func instanceFromNib() -> JRSnackBar {
        let snack = JRSnackBar.nib.instantiate(withOwner: nil, options: nil)[0] as! JRSnackBar
        snack.frame = .zero
        return snack
    }
    
    private static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.framework)
    }
    
    private static var identifier: String {
        return String(describing: self)
    }
    
    @IBAction func closeBtnClick(_ sender: UIButton) {
        dismissTapped(with: .cancel)
    }
    
    
    @IBAction func tryAgainClicked(_ sender: UIButton) {
        dismissTapped(with: .other)
    }
    
    private func addTap() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap(sender:)))
        self.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(sender: UITapGestureRecognizer? = nil) {
        dismissTapped(with: .cancel)
    }
    
    @objc private func dismissTapped(with action: JRSnackBarAction) {
        UIView.animate(withDuration: 0.5, delay: 0, options: [.beginFromCurrentState, .curveEaseIn], animations: { [weak self] in
            guard let strongSelf = self else {return}
            if self?.position == .top {
                strongSelf.frame = CGRect(x: strongSelf.frame.minX, y: strongSelf.frame.minY - strongSelf.frame.height, width: strongSelf.frame.width, height: strongSelf.frame.height)
            }else if self?.position == .bottom {
                strongSelf.frame = CGRect(x: strongSelf.frame.minX, y: strongSelf.frame.minY + strongSelf.frame.height, width: strongSelf.frame.width, height: strongSelf.frame.height)
            }
            
            strongSelf.layoutIfNeeded()
            }, completion: { [weak self] completed in
                guard let strongSelf = self else {return}
                self?.handler?(action)
                strongSelf.removeFromSuperview()
                strongSelf.presentingState = .free
        })
    }
    
    private func getKeyWindow() -> UIWindow? {
        var window: UIWindow?
        let appDelegate: UIApplicationDelegate? = UIApplication.shared.delegate
        // Otherwise fall back on the first window of the app's collection, if present.
        window = appDelegate?.window ?? nil
        return window ?? UIApplication.shared.windows.first
    }
}


private extension String{
    var containsNoChar: Bool{
        return (self.trimmingCharacters(in: .whitespacesAndNewlines)).count == 0
    }
}
