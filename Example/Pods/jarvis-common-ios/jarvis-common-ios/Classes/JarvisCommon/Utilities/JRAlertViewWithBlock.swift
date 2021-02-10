//
//  JRAlertViewWithBlock.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 01/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

@objc public enum AlertViewType : Int{
    case none = 0
    case local
    case service
}

public typealias AlertViewWithBlockHandler = (_: JRAlertViewWithBlock?, _: Int) -> Void

@objc public class JRAlertViewWithBlock: UIAlertController {
    
    @objc public var topViewcontroller: UIViewController? // optional controller to present this view
  
    /**
      - Create your own JRAlertViewWithBlock instance with your own button
      - Use this method to show it on screen
    **/
    public func show() {
        show("", handler: nil, otherButtonTitles: nil, otherButtonhandler: nil)
    }
    
    /**
     - Use this method to show alert with default "OK" button and an handler
     **/
    public func show(_ handler: AlertViewWithBlockHandler?) {
        show("jr_ac_OK".localized, handler: handler, otherButtonTitles: nil, otherButtonhandler: nil)
    }
    
    /**
     - Use this method to show alert with default "OK" and "Cancel" button
     **/
    public func show(_ handler: AlertViewWithBlockHandler?, otherButtonhandler: AlertViewWithBlockHandler?) {
         show("jr_ac_OK".localized, handler: handler, otherButtonTitles: "jr_ac_cancel".localized, otherButtonhandler: otherButtonhandler)
    }
    
    /**
     - Use this method to show alert with two button, where button names should be provided by user as params
     **/
    @objc public func show(_ cancelButtonTitle: String?, handler: AlertViewWithBlockHandler?, otherButtonTitles: String?, otherButtonhandler: AlertViewWithBlockHandler?) {
        
        if let otherButtonTitles = otherButtonTitles {
            show(cancelButtonTitle, handler: handler, otherButtonTitleList:[otherButtonTitles], otherButtonhandler: otherButtonhandler)
        } else {
             show(cancelButtonTitle, handler: handler, otherButtonTitleList:nil, otherButtonhandler: otherButtonhandler)
        }
    }
    
    /**
     - Use this method to show alert with two button, where button names should be provided by user as params
     **/
    @objc public func show(_ cancelButtonTitle: String?, handler: AlertViewWithBlockHandler?, otherButtonTitleList: [String]?, otherButtonhandler: AlertViewWithBlockHandler?) {
        
        if  let cancelButtonTitle = cancelButtonTitle {
            let cancelButton: UIAlertAction = UIAlertAction(title:cancelButtonTitle, style: .default, handler: {[weak self] (alert: UIAlertAction?) in
                handler?(self, 0)
                })
            addAction(cancelButton)
        }
        if  let otherButtonTitleList = otherButtonTitleList {
            for (index, val) in otherButtonTitleList.enumerated() {
                let otherButton: UIAlertAction  = UIAlertAction(title:val, style: .default, handler: {[weak self] (alert: UIAlertAction?) in
                otherButtonhandler?(self, index + 1)
                })
                addAction(otherButton)
            }
        }
        if let topViewcontroller = topViewcontroller {
            topViewcontroller.present(self, animated: true, completion: nil)
        } else {
            JRCommonManager.shared.navigation.present(viewController: self, animated: true, completion: nil)
        }
    }
    /**
     Class method to show an message with Default "OK" button
     **/
    @objc public class func showAlertView(_ message: String?) {
        showAlertView("", message: message)
    }
    
    /**
     Class method to show "Message" and OK button
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    @objc public class func showAlertViewWithMessage(_ message: String?, handler:AlertViewWithBlockHandler?) {
        showAlertView("", message: message, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button
     **/
    @objc public class func showAlertView(_ title: String?, message: String?) {
        showAlertView(title, message: message, handler: nil)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button 
     Same as above method
     **/
    @objc public class func showAlertViewWithTitle(_ title: String?, message: String?) {
        showAlertView(title, message: message, handler: nil)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button 
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    @objc public class func showAlertView(_ title: String?, message: String?, handler:AlertViewWithBlockHandler?) {
        showAlertView(title, message: message, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }

    /**
     Class method to show an alert with "title", "message" and "OK" button
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    
    class public func showAlertViewWithTitle(_ title: String?, message: String?, handler:AlertViewWithBlockHandler?) {
        showAlertView(title, message: message, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }
    
    /**
     Class method to show an alert with "title", "message" and ("cancelButtonTitle", "otherButtonTitles") buttons
     An handler will be provided to listen for button click (cancelbuttonindex is 0)
     **/
    @objc public class func showAlertView(_ title: String?, message: String?, cancelButtonTitle:String?, otherButtonTitles: String?,  handler:AlertViewWithBlockHandler?) {
        
        if title != nil || message != nil {
            let newTitle: String = title ?? ""
            let alertView: JRAlertViewWithBlock = JRAlertViewWithBlock(title: newTitle , message: message, preferredStyle: .alert)
            alertView.show(cancelButtonTitle, handler: {(alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 0)
                }, otherButtonTitles: otherButtonTitles, otherButtonhandler: { (alertView, clickedButtonIndex) -> Void in
                    handler?(alertView, 1)
            })
        }
    }
    
    
    /**
     Class method to show an alert with "title", "message" and ("cancelButtonTitle", "otherButtonTitles") buttons
     controller will be the presenter.
     **/
    public class func showAlertView(_ title: String?, message: String?, controller: UIViewController?, cancelButtonTitle:String?, otherButtonTitles: String?,  handler:AlertViewWithBlockHandler?) {
        
        if title != nil || message != nil {
            let alertView: JRAlertViewWithBlock = JRAlertViewWithBlock(title: title ?? "", message: message, preferredStyle: .alert)
            alertView.topViewcontroller = controller
            alertView.show(cancelButtonTitle, handler: {(alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 0)
            }, otherButtonTitles: otherButtonTitles, otherButtonhandler: { (alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 1)
            })
        }
    }

    public class func showAlertViewWithLeftAlignment(_ title: String?, message: String?, handler: AlertViewWithBlockHandler?) {
        
        if title != nil || message != nil {
            let newTitle: String = title ?? ""
            let alertView: JRAlertViewWithBlock = JRAlertViewWithBlock(title: newTitle , message: message, preferredStyle: .alert)
            let paragraphStyle: NSMutableParagraphStyle = NSMutableParagraphStyle()
            paragraphStyle.alignment = .left
            if let message = message {
                let informationText: NSMutableAttributedString = NSMutableAttributedString(string: message, attributes: [NSAttributedString.Key.paragraphStyle: paragraphStyle, NSAttributedString.Key.font: UIFont.systemFont(ofSize: 13.0)])
                alertView.setValue(informationText, forKey: "attributedMessage")
            }
            alertView.show("jr_ac_OK".localized, handler: {(alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 0)
            }, otherButtonTitleList: nil, otherButtonhandler: nil)
        }
    }
    
    /**
     Class method to show an error
     error?.domain -> will be used as title
     error?.localizedDescription -> will be used as message 
     "OK" button will be shown
     **/
    @objc public class func showError(_ error: NSError?) {
        showAlertView("Error", message: error?.localizedDescription)
    }
    
    /**
     Class method to show an error
     error?.domain -> will be used as title
     error?.localizedDescription -> will be used as message
     "OK" button will be shown
     An hanlder is provided to listen button click
     **/
    @objc public class func showError(_ error: NSError?, handler:AlertViewWithBlockHandler?) {
        if let errorDomain = error?.domain, errorDomain.isEmpty == false {
            showAlertView(errorDomain, message: error?.localizedDescription,handler: handler)
        } else {
            showAlertView("jr_ac_errors".localized, message: error?.localizedDescription,handler: handler)
        }
    }

    /**
     Class method to show an Status
     status?.message.title -> will be used as title
     status?.message.message -> will be used as message
     "OK" button will be shown
     **/
    @objc public class func showStatus(_ status: JRStatus?) {
        showAlertView(status?.message?.title, message: status?.message?.message)
    }
    
    /**
     Class method to show an Status
     status?.message.title -> will be used as title
     status?.message.message -> will be used as message
     "OK" button will be shown
     An hanlder is provided to listen button click
     **/
    @objc public class func showStatus(_ status: JRStatus?, handler:AlertViewWithBlockHandler?) {
        showAlertView(status?.message?.title, message: status?.message?.message, handler: handler)
    }
}

public extension JRAlertViewWithBlock {
    /**
     Class method to show an ActionSheet with "title", list of items and ("cancelButtonTitle") button
     An handler will be provided to listen for button click (cancelbuttonindex is 0)
     index will start from 0
     **/
    @objc class func showActionSheet(_ title: String?, items: [String]?,itemsHandler:AlertViewWithBlockHandler?, cancelButtonTitle:String?,  cancelHandler:AlertViewWithBlockHandler?) {
        
        if title != nil || items != nil {
            let newTitle = title
            
            let actionSheet: JRAlertViewWithBlock = JRAlertViewWithBlock(title: newTitle , message: nil, preferredStyle: .actionSheet)
            actionSheet.show(items, itemsHandler: itemsHandler, cancelButtonTitle: cancelButtonTitle, handler: cancelHandler)
            
        }
    }
    
    
    class func showActionSheet(_ title: String?, items: [String]?,itemsHandler:AlertViewWithBlockHandler?) {
        showActionSheet(title, items: items, itemsHandler: itemsHandler, cancelButtonTitle: "jr_o2o_movie_cancel".localized, cancelHandler: nil)
    }
    
    /**
     - Use this method to show ActionSheet with two button, where button names should be provided by user as params
     **/
    fileprivate func show(_ items: [String]?, itemsHandler: AlertViewWithBlockHandler?,cancelButtonTitle: String?, handler: AlertViewWithBlockHandler?) {
        
        if  let items = items {
            for (index, val) in items.enumerated() {
                let otherButton: UIAlertAction  = UIAlertAction(title:val, style: .default, handler: {[weak self] (alert: UIAlertAction?) in
                    itemsHandler?(self, index)
                    })
                addAction(otherButton)
            }
        }
        
        if  let cancelButtonTitle = cancelButtonTitle {
            let cancelButton: UIAlertAction = UIAlertAction(title:cancelButtonTitle, style: .cancel, handler: {[weak self] (alert: UIAlertAction?) in
                handler?(self, 0)
                })
            addAction(cancelButton)
        }
        if let topViewcontroller = topViewcontroller {
            topViewcontroller.present(self, animated: true, completion: nil)
        } else {
            JRCommonManager.shared.navigation.present(viewController: self, animated: true, completion: nil)
        }
    }
}

//MARK: Added Alert view type for logging local data to Debug Analytics server
public extension JRAlertViewWithBlock{
    
    /**
     Class method to show an error
     error?.domain -> will be used as title
     error?.localizedDescription -> will be used as message
     "OK" button will be shown
     **/
    @objc class func showError(_ error: NSError?, withErrorType errorType: AlertViewType) {
        showAlertView("Error", message: error?.localizedDescription, withErrorType: errorType)
    }
    
    /**
     Class method to show an error
     error?.domain -> will be used as title
     error?.localizedDescription -> will be used as message
     "OK" button will be shown
     An hanlder is provided to listen button click
     **/
    @objc class func showError(_ error: NSError?, withErrorType errorType: AlertViewType, handler:AlertViewWithBlockHandler?) {
        showAlertView("jr_ac_errors".localized, message: error?.localizedDescription, withErrorType: errorType,handler: handler)
    }
    
    /**
     Class method to show an message with Default "OK" button
     **/
    @objc class func showAlertView(_ message: String?, withErrorType errorType: AlertViewType) {
        showAlertView("", message: message, withErrorType: errorType)
    }
    
    /**
     Class method to show "Message" and OK button
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    @objc class func showAlertViewWithMessage(_ message: String?,withErrorType errorType: AlertViewType, handler:AlertViewWithBlockHandler?) {
        showAlertView("", message: message, withErrorType: errorType, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button
     **/
    @objc class func showAlertView(_ title: String?, message: String?, withErrorType errorType: AlertViewType) {
        showAlertView(title, message: message, withErrorType: errorType, handler: nil)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button
     Same as above method
     **/
    @objc class func showAlertViewWithTitle(_ title: String?, message: String?, withErrorType errorType: AlertViewType) {
        showAlertView(title, message: message, withErrorType: errorType, handler: nil)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    @objc class func showAlertView(_ title: String?, message: String?, withErrorType errorType: AlertViewType, handler:AlertViewWithBlockHandler?) {
        showAlertView(title, message: message, withErrorType: errorType, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }
    
    /**
     Class method to show an alert with "title", "message" and "OK" button
     An handler will be provided to listen OK button click (buttonIndex is 0)
     **/
    
    class func showAlertViewWithTitle(_ title: String?, message: String?, withErrorType errorType: AlertViewType, handler:AlertViewWithBlockHandler?) {
        showAlertView(title, message: message, withErrorType: errorType, cancelButtonTitle: "jr_ac_OK".localized, otherButtonTitles: nil, handler: handler)
    }
    
    /**
     Class method to show an alert with "title", "message" and ("cancelButtonTitle", "otherButtonTitles") buttons
     An handler will be provided to listen for button click (cancelbuttonindex is 0)
     **/
    @objc class func showAlertView(_ title: String?, message: String?, withErrorType errorType: AlertViewType, cancelButtonTitle:String?, otherButtonTitles: String?,  handler:AlertViewWithBlockHandler?) {
        
        if title != nil || message != nil {
            let newTitle: String = title ?? ""
            let alertView: JRAlertViewWithBlock = JRAlertViewWithBlock(title: newTitle , message: message, preferredStyle: .alert)
            alertView.show(cancelButtonTitle, handler: {(alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 0)
            }, otherButtonTitles: otherButtonTitles, otherButtonhandler: { (alertView, clickedButtonIndex) -> Void in
                handler?(alertView, 1)
            })
        }
        
        pushLocalDataToAnalytics( message : message ?? "", errorCode : 0, withErrorType: errorType)
    }
    
    class func pushLocalDataToAnalytics( message : String, errorCode : Int = 0, withErrorType errorType : AlertViewType = .none){
        DispatchQueue.global(qos: .background).async{
            if errorType == .local{
                JRCommonManager.shared.applicationDelegate?.sendLocalErrorToDebugAnalyticsServer(withMessage: message, errorcode: "\(errorCode)", line: 0, error_class: nil, function: nil)
            }
        }
    }
}
