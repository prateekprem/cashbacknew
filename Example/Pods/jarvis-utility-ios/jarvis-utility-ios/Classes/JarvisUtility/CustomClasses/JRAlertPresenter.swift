//
//  JRAlertPresenter.swift
//  SnackbarApp
//
//  Created by Sunny on 14/06/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation
import UIKit

@objc public enum JRAlertType: Int {
    case snackBar
    
    // Removed from the first version.
    /*case nativeAlert
    case nativeActionSheet*/
}

public class JRAlertPresenter : NSObject {
    /// Creating a new instance will have its own presentation queue.
    @objc public static let shared = JRAlertPresenter()
    
    /**
     Shows snackbar on the main window. All presentations are sequential through a queue.
     
     - parameter title: Title to be shown in bold.
     - parameter message: message to be shown.
     - parameter autoDismiss: If true then snack bar should be dismissed automatically in 3 seconds.
     - parameter actions: List of actions to be shown. Maximum 3 actions are supported. List should be in bottom right.
     - parameter dismissHandler: This should be called after the snackbar dismisses with the selected action. In case of no actions or auto dismiss without user interaction the selected action should be -1.
     */
    @objc public func presentSnackBar(title: String?, message: String, autoDismiss: Bool, actions: [String]?, dismissHandler: ((Int) -> Void)?) {
        let req: JRAlertRequest = JRAlertRequest()
        req.type = .snackBar
        req.title = title
        req.message = message
        req.autoDismiss = autoDismiss
        if let actions = actions {
            req.actions = actions
        }
        req.handlingInfo = dismissHandler
        
        push(req: req)
    }
    
    override public init() {
        super.init()
        registerForNotifications()
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    private var pendingAlerts: [JRAlertRequest] = [JRAlertRequest]()
    @objc public private(set) var presenting: Bool = false
    
    private var cancelBtnMap: [UIButton : (req: JRAlertRequest, view: Any?)] = [UIButton:(req: JRAlertRequest, view: Any?)]()
    private var showingKeyboard: Bool = false
    
    private var closeButtonWidth: CGFloat = 20
    private var edgeInset: CGFloat = 20
}

private extension JRAlertPresenter {
    func registerForNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDidHide(_:)), name: UIResponder.keyboardDidHideNotification, object: nil)
    }
    
    @objc func keyboardWillShow(_ notification: NSNotification) {
        showingKeyboard = true
    }
    
    @objc func keyboardDidHide(_ notification: NSNotification) {
        showingKeyboard = false
    }
    
    func request(type: JRAlertType, title: String?, message: String, action1Title: String? = nil, action1: JRAlertReqHandler? = nil, action2Title: String? = nil, action2: JRAlertReqHandler? = nil, action3Title: String? = nil, action3: JRAlertReqHandler? = nil) -> JRAlertRequest {
        let req = JRAlertRequest()
        req.type = type
        req.title = title
        req.message = message
        
        req.action1Title = action1Title
        req.action1 = action1
        req.action2Title = action2Title
        req.action2 = action2
        req.action3Title = action3Title
        req.action3 = action3
        
        return req
    }
    
    func presentNotEnqueue(req: JRAlertRequest) {
        switch req.type {
        case .snackBar:
            present(snackBar: req)
            break
        /*case .nativeAlert:
            present(nativeAlert: req)
            break
        case .nativeActionSheet:
            present(nativeAction: req)*/
        }
    }
    
    //MARK:- Queue handling
    func push(req: JRAlertRequest) {
        DispatchQueue.main.async { [weak self] () in
            self?.pendingAlerts.append(req)
            self?.presentPending()
        }
    }
    
    func presentPending() {
        DispatchQueue.main.async { [weak self] () in
            guard let unwrpSelf = self, false == unwrpSelf.presenting else {
                return
            }
            
            guard let firstReq = unwrpSelf.pendingAlerts.first else {
                unwrpSelf.presenting = false
                return
            }
            
            unwrpSelf.presenting = true
            switch firstReq.type {
            case .snackBar:
                unwrpSelf.present(snackBar: firstReq)
                break
            /*case .nativeAlert:
                unwrpSelf.present(nativeAlert: firstReq)
                break
                
            case .nativeActionSheet:
                unwrpSelf.present(nativeAction: firstReq)*/
            }
        }
    }
    
    func continuePresenting() {
        DispatchQueue.main.async { [weak self] () in
            guard let unwrpSelf = self, let firstReq = unwrpSelf.pendingAlerts.first else {
                self?.presenting = false
                return
            }
            
            firstReq.dismissHandler?(firstReq)
            
            // This should be removed in case of any 2nd version. dismissHandler should be enough.
            if let handler = firstReq.handlingInfo as? ((Int) -> Void) {
                var selectedAction: Int = -1
                if false == firstReq.actions.isEmpty, let action = firstReq.selectedAction, let index = firstReq.actions.firstIndex(of: action) {
                    selectedAction = index
                }
                handler(selectedAction)
            }
            
            unwrpSelf.pendingAlerts.removeFirst()
            
            unwrpSelf.presenting = false
            unwrpSelf.presentPending()
        }
    }
    
    //MARK:- Presentation Snackbar
    func present(snackBar: JRAlertRequest) {
        // Create message body
        let attribMsg = attributedMessageTextString(titleString: snackBar.title, messageString: snackBar.message, request: snackBar)
        
        // Final dismissal block
        let handler = { (bar: JRSnackbar) in
            bar.dismiss()
        }
        
        var cancelBtn: UIButton?
        var snkBar: JRSnackbar?
        let duration: TTGSnackbarDuration = snackBar.autoDismiss ? .middle : .forever
        if false == snackBar.actions.isEmpty {
            // Not supporting more than 3 actions in a snackBar.
            var act1 = "", act2 = "", act3 = ""
            for i in 0..<snackBar.actions.count {
                if i == 0 {
                    act1 = snackBar.actions[i]
                } else if i == 1 {
                    act2 = snackBar.actions[i]
                } else if i == 2 {
                    act3 = snackBar.actions[i]
                } else {
                    break
                }
            }
            
            snkBar = JRSnackbar(message: attribMsg, duration: duration, snackBarButtonAlignment: snackBarBtnAlignment(snackBar.btnAlignment), actionText: act1, actionBlock: { (bar) in
                snackBar.selectedAction = act1
                handler(bar)
            }, secondActionText: act2, secondActionBlock: { (bar) in
                snackBar.selectedAction = act2
                handler(bar)
            }, thirdActionText: act3) { (bar) in
                snackBar.selectedAction = act3
                handler(bar)
            }
        } else {
            if let customView = snackBar.customView {
                snkBar = JRSnackbar(customContentView: customView, duration: duration)
                if snackBar.showCloseButton {
                    cancelBtn = addCloseBtn(snkBar!, customView: customView)
                    cancelBtnMap[cancelBtn!] = (snackBar, snkBar)
                }
            } else {
                var actt1: String = "", actt2: String = "", actt3: String = ""
                if let act1 = snackBar.action1Title, false == act1.isEmpty, snackBar.action1 != nil {
                    actt1 = act1
                    if let act2 = snackBar.action2Title, false == act2.isEmpty, snackBar.action2 != nil {
                        actt2 = act2
                        if let act3 = snackBar.action3Title, false == act3.isEmpty, snackBar.action3 != nil {
                            actt3 = act3
                        }
                    }
                }
                
                
                snkBar = JRSnackbar(message: attribMsg, duration: duration, snackBarButtonAlignment: snackBarBtnAlignment(snackBar.btnAlignment), actionText: actt1, actionBlock: { (bar) in
                    snackBar.action1?(snackBar)
                    handler(bar)
                }, secondActionText: actt2, secondActionBlock: { (bar) in
                    snackBar.action2?(snackBar)
                    handler(bar)
                }, thirdActionText: actt3) { (bar) in
                    snackBar.action3?(snackBar)
                    handler(bar)
                }
                
                if actt1.isEmpty {
                    snkBar?.onTapBlock = { (bar) in
                        handler(bar)
                    }
                    snkBar?.onSwipeBlock = { (bar, direction) in
                        if direction == .right {
                            bar.animationType = .slideFromLeftToRight
                        } else if direction == .left {
                            bar.animationType = .slideFromRightToLeft
                        }
                        handler(bar)
                    }
                }
            }
        }
        
        if shouldShowClose(request: snackBar) {
            if let customView = snackBar.customView {
                cancelBtn = addCloseBtn(snkBar!, customView: customView)
            } else {
                cancelBtn = addCloseBtn(snkBar!, customView: nil)
            }
            cancelBtnMap[cancelBtn!] = (snackBar, snkBar)
        }
        
        snkBar?.dismissBlock = { [weak self](bar) in
            DispatchQueue.main.async {
                self?.continuePresenting()
            }
        }
        
        // Use container if any
        if let sourceView = snackBar.containerView {
            snkBar?.containerView = sourceView
        } else if let sourceView = snackBar.containerController?.view {
            snkBar?.containerView = sourceView
        }
        
        if let icon = snackBar.iconImage {
            snkBar?.icon = icon
        }
        
        snkBar?.messageTextAlign = .natural
        snkBar?.animationType = (snackBar.checksKeyboard && showingKeyboard) ? .slideFromTopBackToTop : .slideFromBottomBackToBottom
        snkBar?.contentInset = UIEdgeInsets(top: edgeInset, left: edgeInset, bottom: edgeInset, right: edgeInset)
        snkBar?.actionTextColor = UIColor(red: 0, green: 185.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        snkBar?.secondActionTextColor = UIColor(red: 0, green: 185.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        snkBar?.thirdActionTextColor = UIColor(red: 0, green: 185.0/255.0, blue: 245.0/255.0, alpha: 1.0)
        snkBar?.backgroundColor = UIColor(red: 33.0/255.0, green: 33.0/255.0, blue: 33.0/255.0, alpha: 1.0)
        
        snkBar?.show()
        
        if let btn = cancelBtn {
            snkBar?.bringSubviewToFront(btn)
        }
    }
    
    func shouldShowClose(request: JRAlertRequest) -> Bool {
        var show: Bool = request.showCloseButton
        if false == request.actions.isEmpty {
            show = false
        } else {
            if request.customView == nil {
                var actt1: String = ""
                if let act1 = request.action1Title, false == act1.isEmpty, request.action1 != nil {
                    actt1 = act1
                }
                
                if actt1.isEmpty == false {
                    show = false
                }
            }
        }
        return show
    }
    
    func attributedText(title:String, titleFont:UIFont, message:String, messageFont:UIFont, request: JRAlertRequest) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: title)
        
        var attributes1: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: titleFont]
        var attributes2: [NSAttributedString.Key:Any] = [NSAttributedString.Key.font: messageFont]
        var paraStyle: NSMutableParagraphStyle?
        if shouldShowClose(request: request) {
            paraStyle = NSMutableParagraphStyle()
            paraStyle?.tailIndent = -closeButtonWidth
        }
        
        let separatorFont: UIFont = UIFont.systemFont(ofSize: 12.0, weight: .regular)
        var separator: String = "\n\n"
        if title.isEmpty {
            separator = ""
            if let para = paraStyle {
                attributes2[NSAttributedString.Key.paragraphStyle] = para
            }
        } else {
            if let para = paraStyle {
                attributes1[NSAttributedString.Key.paragraphStyle] = para
            }
        }
        
        attributedString.addAttributes(attributes1, range: NSRange(location:0, length: title.count))
        attributedString.append(NSAttributedString(string: separator, attributes: [NSAttributedString.Key.font: separatorFont]))
        
        attributedString.append(NSAttributedString(string: message, attributes: attributes2))
        
        return attributedString
    }
    
    func attributedMessageTextString(titleString:String?, messageString:String, request: JRAlertRequest) -> NSAttributedString {
        var titleText: String = ""
        if let title = titleString, titleString?.isEmpty == false {
            titleText  = title
        }
        let messageTextString: NSAttributedString = attributedText(title: titleText , titleFont: UIFont.systemFont(ofSize: 16.0, weight: .semibold) , message: messageString, messageFont: UIFont.systemFont(ofSize: 14.0, weight: .regular), request: request)
        return messageTextString
    }
    
    func snackBarBtnAlignment(_ alertAlignment: JRAlertBtnAlignment) -> SnackBarButtonAlignment {
        var btnAlignment: SnackBarButtonAlignment = SnackBarButtonAlignment.bottomRight
        switch alertAlignment {
        case .right:
            btnAlignment = SnackBarButtonAlignment.right
        default:
            break
        }
        
        return btnAlignment
    }
    
    func addCloseBtn(_ bar: JRSnackbar, customView: UIView?) -> UIButton {
        let closeButton: UIButton = UIButton()
        closeButton.setBackgroundImage(UIImage(named: "icClose"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.closeButtonAction(_:)) , for: .touchUpInside)
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .width, relatedBy: .equal, toItem: nil, attribute: .width, multiplier: 1.0, constant: closeButtonWidth))
        closeButton.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .height, multiplier: 1.0, constant: closeButtonWidth))
        
        if let customView = customView {
            customView.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            customView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: customView, attribute: .top, multiplier: 1.0, constant: edgeInset))
            customView.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: customView, attribute: .trailing, multiplier: 1.0, constant: -edgeInset))
        } else {
            bar.addSubview(closeButton)
            closeButton.translatesAutoresizingMaskIntoConstraints = false
            bar.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .top, relatedBy: .equal, toItem: bar, attribute: .top, multiplier: 1.0, constant: edgeInset))
            bar.addConstraint(NSLayoutConstraint(item: closeButton, attribute: .trailing, relatedBy: .equal, toItem: bar, attribute: .trailing, multiplier: 1.0, constant: -edgeInset))
        }
        
        return closeButton
    }
    
    @objc func closeButtonAction(_ sender: UIButton) {
        if let tuple = cancelBtnMap[sender] {
            cancelBtnMap.removeValue(forKey: sender)
            
            if let snkBar = tuple.view as? JRSnackbar {
                snkBar.dismiss()
            } else {
                presentPending()
            }
        } else {
            presentPending()
        }
    }
    
    //MARK:- Presentation native
    func present(nativeAlert: JRAlertRequest) {
        let alertCtrl: UIAlertController = UIAlertController(title: nativeAlert.title, message: nativeAlert.message, preferredStyle: .alert)
        setupActions(alertCtrl: alertCtrl, native: nativeAlert)
        present(alertCtrl: alertCtrl, request: nativeAlert)
    }
    
    func present(nativeAction: JRAlertRequest) {
        let alertCtrl: UIAlertController = UIAlertController(title: nativeAction.title, message: nativeAction.message, preferredStyle: .actionSheet)
        setupActions(alertCtrl: alertCtrl, native: nativeAction)
        present(alertCtrl: alertCtrl, request: nativeAction)
    }
    
    func setupActions(alertCtrl: UIAlertController, native: JRAlertRequest) {
        let finalBlock: () -> () = { [weak self] () in
            DispatchQueue.main.async {
                self?.continuePresenting()
            }
        }
        
        if false == native.actions.isEmpty {
            for act in native.actions {
                alertCtrl.addAction(UIAlertAction(title: act, style: .default, handler: {  (action) in
                    native.selectedAction = act
                    finalBlock()
                }))
            }
        } else {
            if let act1 = native.action1Title, native.action1 != nil {
                alertCtrl.addAction(UIAlertAction(title: act1, style: .default, handler: { (action) in
                    native.action1?(native)
                    finalBlock()
                }))
                
                if let act2 = native.action2Title, native.action2 != nil {
                    alertCtrl.addAction(UIAlertAction(title: act2, style: .default, handler: { (action) in
                        native.action2?(native)
                        finalBlock()
                    }))
                    
                    if let act3 = native.action3Title, native.action3 != nil {
                        alertCtrl.addAction(UIAlertAction(title: act3, style: .default, handler: { (action) in
                            native.action3?(native)
                            finalBlock()
                        }))
                    }
                }
            } else {
                let action: String = native.defaultAction.isEmpty ? "jr_ac_OK".localized : native.defaultAction
                alertCtrl.addAction(UIAlertAction(title: action, style: .default, handler: { (action) in
                    finalBlock()
                }))
            }
        }
    }
    
    func present(alertCtrl: UIAlertController, request: JRAlertRequest) {
        if let controller: UIViewController = request.containerController {
            controller.present(alertCtrl, animated: true, completion: nil)
        } else {
            UIApplication.shared.keyWindow?.rootViewController?.present(alertCtrl, animated: true, completion: nil)
        }
    }
}

//MARK:- Removed from the first version.

fileprivate enum JRAlertBtnAlignment: Int {
    case right
    case bottomRight
}

fileprivate typealias JRAlertReqHandler = ((JRAlertRequest) -> Void)

fileprivate class JRAlertRequest: NSObject {
    //MARK:- Inputs
    @objc var type = JRAlertType.snackBar
    @objc var title: String?
    @objc var message: String = ""
    
    /// Any info that should be available after the alert dismissal or while processing action.
    @objc var context: Any?
    
    @objc var action1Title: String?
    @objc var action1: JRAlertReqHandler?
    
    @objc var action2Title: String?
    @objc var action2: JRAlertReqHandler?
    
    @objc var action3Title: String?
    @objc var action3: JRAlertReqHandler?
    
    /// To support more than 3 actions. As of now supported for native. Please check selectedAction in dismissHandler to continue handling user action.
    @objc var actions: [String] = [String]()
    
    /// Should be called on dismissal of the alert; independent of any action handler.
    @objc var dismissHandler: JRAlertReqHandler?
    
    /// This should be used for default action in case of no action provided.
    @objc var defaultAction: String = "OK"
    
    
    /// Should be used as container for alert. Lower priority for non-native.
    @objc var containerController: UIViewController?
    
    /// Should be used as container for alert non-native. Higher priority for non-native.
    @objc var containerView: UIView?
    
    /// This should work for non-native alert e.g. snackbar. Auto dismissing a native alert or action sheet would look like an error.
    @objc var autoDismiss: Bool = false
    
    /// This sould work for non-native alert.
    var btnAlignment = JRAlertBtnAlignment.bottomRight
    
    /// This should be shown in place of alert's default UI. Works for non-native alert.
    @objc var customView: UIView?
    
    /// This should show a close button for appropriate cases. Works for non-native.
    @objc var showCloseButton: Bool = true
    
    /// An icon to be used in alert. Used in non-native alert.
    @objc var iconImage: UIImage?
    
    /// This should help avoid keyboard overlapping while showing alert. Useful for non-native.
    @objc var checksKeyboard: Bool = true
    
    
    //MARK:- Output
    /// This should have the action selected by user from available options in actions. Please use dismissHandler to continue handling user action.
    @objc var selectedAction: String?
    
    
    /// This should not be used from outside. Please use context in case of any storage needed.
    fileprivate var handlingInfo: Any?
}

private extension JRAlertPresenter {
    @discardableResult
    @objc func present(type: JRAlertType, title: String?, message: String) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message)
        present(alertReq: req)
        return req
    }
    
    @discardableResult
    @objc func present(type: JRAlertType, autoDismiss: Bool, title: String?, message: String) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message)
        req.autoDismiss = autoDismiss
        present(alertReq: req)
        return req
    }
    
    @discardableResult
    @objc func present(type: JRAlertType, title: String?, message: String, action1Title: String, action1: @escaping JRAlertReqHandler) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message, action1Title: action1Title, action1: action1)
        present(alertReq: req)
        return req
    }
    
    @discardableResult
    @objc func present(type: JRAlertType, title: String?, message: String, action1Title: String, action1: @escaping JRAlertReqHandler, action2Title: String, action2: @escaping JRAlertReqHandler) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message, action1Title: action1Title, action1: action1, action2Title: action2Title, action2: action2)
        present(alertReq: req)
        return req
    }
    
    @discardableResult
    @objc func present(type: JRAlertType, title: String?, message: String, action1Title: String, action1: @escaping JRAlertReqHandler, action2Title: String, action2: @escaping JRAlertReqHandler, action3Title: String, action3: @escaping JRAlertReqHandler) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message, action1Title: action1Title, action1: action1, action2Title: action2Title, action2: action2, action3Title: action3Title, action3: action3)
        present(alertReq: req)
        return req
    }
    
    @discardableResult
    @objc func present(type: JRAlertType, autoDismiss: Bool, title: String?, message: String, action1Title: String, action1: @escaping JRAlertReqHandler, action2Title: String?, action2: JRAlertReqHandler?, action3Title: String?, action3: JRAlertReqHandler?) -> JRAlertRequest {
        let req: JRAlertRequest = request(type: type, title: title, message: message, action1Title: action1Title, action1: action1, action2Title: action2Title, action2: action2, action3Title: action3Title, action3: action3)
        req.autoDismiss = autoDismiss
        present(alertReq: req)
        return req
    }
    
    @objc func present(alertReq: JRAlertRequest) {
        DispatchQueue.main.async { [weak self] () in
            self?.presentNotEnqueue(req: alertReq)
        }
    }
}
