//
//  JRLocalErrorHandler.swift
//  Jarvis
//
//  Created by nasib ali on 03/06/19.
//

import UIKit

@objc public final class JRLocalErrorHandler: NSObject {
    
    @objc public class func sendSilentError(on viewController: UIViewController?, withModel model: JRHawkEyeErrorModel, completionHandler: ((Bool) -> Void)?) {
        
        JRLocalErrorHandler.validateScreenName(of: viewController, in: model)
        model.sendToHawekeye(completionHandler)
    }
        
    @objc public class func showAlert(on viewController: UIViewController?, alertTitle title: String?, alertMessage message: String, cancelBtnTitle: String, otherBtnTitle: String?, withModel model: JRHawkEyeErrorModel, completionHandler: AlertViewWithBlockHandler?){
        
        JRLocalErrorHandler.validateScreenName(of: viewController, in: model)
        model.sendToHawekeye()
        
        JRAlertViewWithBlock.showAlertView(title, message: message, controller: viewController, cancelButtonTitle: cancelBtnTitle, otherButtonTitles: otherBtnTitle, handler: completionHandler)
    }
    
    @objc public class func showToast(on viewController: UIViewController?, toastTitle title: String?, toastMessage message: String, atPoint point: CGPoint, forDuration duration: TimeInterval, toastImage image: UIImage?, withModel model: JRHawkEyeErrorModel, completionHandler: ((Bool) -> Void)?){
        
        JRLocalErrorHandler.validateScreenName(of: viewController, in: model)
        model.sendToHawekeye()
        
        let style  = ToastManager.shared.style
        if let vc = viewController {
            vc.view?.makeToast(message, duration: duration, point: point, title: title, image: image, style: style, completion: completionHandler)
        }else{
            UIApplication.topViewController()?.view?.makeToast(message, duration: duration, point: point, title: title, image: image, style: style, completion: completionHandler)
        }
    }
    
    @objc public class func showToast(on viewController: UIViewController?, toastTitle title: String?, toastMessage message: String, atPosition position: ToastPosition, forDuration duration: TimeInterval, toastImage image: UIImage?, withModel model: JRHawkEyeErrorModel, completionHandler: ((Bool) -> Void)?){
        
        JRLocalErrorHandler.validateScreenName(of: viewController, in: model)
        model.sendToHawekeye()
        
        let style  = ToastManager.shared.style
        if let vc = viewController {
            vc.view?.makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completionHandler)
        }else{
            UIApplication.topViewController()?.view?.makeToast(message, duration: duration, position: position, title: title, image: image, style: style, completion: completionHandler)
        }
    }
    
    
    @objc public class func showSnackBar(on viewController: UIViewController?, barTitle title: String?, barMessage msg: String, isAutoDismiss autoDismiss: Bool, barPosition position: JRSnackBarPosition, withModel model: JRHawkEyeErrorModel, completionHandler: ((_ action: JRSnackBarAction) -> Void)?) {
        
        JRLocalErrorHandler.showSnackBar(on: viewController, barTitle: title, barMessage: msg, isAutoDismiss : autoDismiss, otherButtonTitle: nil, barPosition: position, barTheme: .defaultSnackbar, presentingMode: .priority, barVisibility: .medium, withModel: model, completionHandler: completionHandler)
    }
    
    @objc public class func showSnackBar(on viewController: UIViewController?, barTitle title: String?, barMessage msg: String, isAutoDismiss autoDismiss: Bool, otherButtonTitle: String?, barPosition position: JRSnackBarPosition, barTheme theme: JRSnackBarTheme, presentingMode mode: JRSnackBarPresentingMode, barVisibility visibility: JRSnackBarVisibility, withModel model: JRHawkEyeErrorModel, completionHandler: ((_ action: JRSnackBarAction) -> Void)?) {
        
        JRLocalErrorHandler.validateScreenName(of: viewController, in: model)
        model.sendToHawekeye()
        
        JRSnackBar.showSnackBar(title, barMessage: msg, isAutoDismiss: autoDismiss, barPosition: position, barTheme: theme, presentingMode: mode, barVisibility: visibility, otherButtonTitle: otherButtonTitle, completionHandler: completionHandler)
    }
    
    private class func validateScreenName(of viewController: UIViewController?, in model: JRHawkEyeErrorModel) {
        if let vc = viewController, model.additionalParam?[.screenName] == nil {
            model.updateAdditionalParam(forKey: .screenName, withValue: String(describing: type(of: vc.self)))
        }
    }
}

//Method with default value usedful for swift
extension JRLocalErrorHandler {
    
    public class func showAlertView(on viewController: UIViewController? = nil, alertTitle title: String? = nil, alertMessage message: String, cancelBtnTitle: String = "jr_ac_OK".localized, otherBtnTitle: String? = nil, withModel model: JRHawkEyeErrorModel = JRHawkEyeErrorModel.blankInfo, completionHandler: AlertViewWithBlockHandler? = nil){
        
        JRLocalErrorHandler.showAlert(on: viewController, alertTitle: title, alertMessage: message, cancelBtnTitle: cancelBtnTitle, otherBtnTitle: otherBtnTitle, withModel: model, completionHandler: completionHandler)
    }
    
    public class func showToastView(on viewController: UIViewController? = nil, toastTitle title: String? = nil, toastMessage message: String, atPoint point: CGPoint, forDuration duration: TimeInterval = ToastManager.shared.duration, toastImage image: UIImage? = nil, withModel model: JRHawkEyeErrorModel = JRHawkEyeErrorModel.blankInfo, completionHandler: ((Bool) -> Void)? = nil){
        
        JRLocalErrorHandler.showToast(on: viewController, toastTitle: title, toastMessage: message, atPoint: point, forDuration: duration, toastImage: image, withModel: model, completionHandler: completionHandler)
    }
    
    public class func showToastView(on viewController: UIViewController? = nil, toastTitle title: String? = nil, toastMessage message: String, atPosition position: ToastPosition = ToastManager.shared.position, forDuration duration: TimeInterval = ToastManager.shared.duration, toastImage image: UIImage? = nil, withModel model: JRHawkEyeErrorModel = JRHawkEyeErrorModel.blankInfo, completionHandler: ((Bool) -> Void)? = nil){
        
        JRLocalErrorHandler.showToast(on: viewController, toastTitle: title, toastMessage: message, atPosition: position, forDuration: duration, toastImage: image, withModel: model, completionHandler: completionHandler)
    }
    
    public class func showSnackBarView(on viewController: UIViewController? = nil, barTitle title: String? = nil, barMessage msg: String, isAutoDismiss autoDismiss: Bool = true, otherButtonTitle: String? = nil, barPosition position: JRSnackBarPosition = .bottom, barTheme theme: JRSnackBarTheme = .defaultSnackbar, presentingMode mode: JRSnackBarPresentingMode = .priority, barVisibility visibility: JRSnackBarVisibility = .high, withModel model: JRHawkEyeErrorModel = JRHawkEyeErrorModel.blankInfo, completionHandler: ((_ action: JRSnackBarAction) -> Void)? = nil) {
        
       JRLocalErrorHandler.showSnackBar(on: viewController, barTitle: title, barMessage: msg, isAutoDismiss: autoDismiss, otherButtonTitle: otherButtonTitle, barPosition: position, barTheme: theme, presentingMode: mode, barVisibility: visibility, withModel: model, completionHandler: completionHandler)
    }
}
