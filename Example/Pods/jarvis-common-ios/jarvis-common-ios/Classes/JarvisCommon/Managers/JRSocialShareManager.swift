//
//  JRSocialShareManager.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 04/01/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import Social
import jarvis_utility_ios

@objc public enum SocialShareType: Int {
    
    case whatsApp = 0, facebook, twitter, othersShareOption, messanger
}

/**
 A class to share product information through social media.
 Sharing of product information is controlled from here.
 
 */
public class JRSocialShareManager: UIViewController {
    public var message: String?
    public var contentUrl: String?
    public var contentImage: UIImage?
    public var gaKey: String?
    fileprivate var emailSubject: String = "Share"
    fileprivate var imagePreference: Bool = false
    public var shareFromLifafa: Bool = false
    fileprivate var activityPopover: UIViewController?
    
    @objc public static let sharedInstance = JRSocialShareManager()
    
    @objc public func launchShareViewWithType(_ type: SocialShareType, message: String?, contentUrl: String?, gaKey: String?) {
        
        self.message = message
        self.contentUrl = contentUrl
        self.gaKey = gaKey
        displayShareViewForType(type)
    }
    
    public func launchShareViewWithType(_ type: SocialShareType, message: String?, contentUrl: String?, gaKey: String?, imagePreference : Bool) {
        
        self.message = message
        self.contentUrl = contentUrl
        self.gaKey = gaKey
        self.imagePreference = imagePreference
        displayShareViewForType(type)
        //        self.imagePreference = false
    }
    
    //MARK: - Messanger sharing
    public func setShare(message: String?, contentURL: String?) {
        self.message = message
        self.contentUrl = contentURL
    }
    
    @objc public func launchShareView(image: UIImage?){
        self.contentImage = image
        self.imagePreference = true
        let activityViewController = getActivityViewControllerFor("", shareUrlString: "")
        JRCommonManager.shared.navigation.rootNavController.present(activityViewController, animated: true, completion:  nil)
        self.imagePreference = false
    }
    
    public func launchShareView(image: UIImage?, onViewController: UIViewController?){
        self.contentImage = image
        self.imagePreference = true
        let activityViewController = getActivityViewControllerFor("", shareUrlString: "")
        onViewController?.present(activityViewController, animated: true, completion: nil)
        self.imagePreference = false
    }
    
    public func displayShareViewForType(_ type: SocialShareType) {
        var composeViewController: SLComposeViewController?
        switch(type) {
            
        case SocialShareType.whatsApp :
            
            JRGoogleTrackManager.trackCustomEventforScreen(gaKey, eventName: JREventProductSharedOnSocial, variables: [JRVariableVerticalName:"marketpalce","PLATFORM_NAME":"whatsapp"])
            var shareMessage = self.message
            shareMessage = shareMessage?.replacingOccurrences(of: " & ", with: " and ")
            if let shareMessage = shareMessage {
                postMessageUsingWhatsAppWithMessage(shareMessage)
            }
            break
            
        case SocialShareType.facebook :
            
            JRGoogleTrackManager.trackCustomEventforScreen(gaKey, eventName: JREventProductSharedOnSocial, variables: [JRVariableVerticalName:"marketpalce","PLATFORM_NAME":"FaceBook"])
            let shareMessage = shareMessageStringForType(type)
            composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if let shareMessage = shareMessage {
                composeViewController?.setInitialText(shareMessage)
            }
            
            if let contentUrl = contentUrl, let url = URL.init(string: contentUrl){
                composeViewController?.add(url)
            }
            break
            
        case SocialShareType.twitter :
            
            JRGoogleTrackManager.trackCustomEventforScreen(gaKey, eventName: JREventProductSharedOnSocial, variables: [JRVariableVerticalName:"marketpalce","PLATFORM_NAME":"twitter"])
            composeViewController = SLComposeViewController.init(forServiceType: SLServiceTypeTwitter)
            break
        case SocialShareType.messanger :
            
            JRGoogleTrackManager.trackCustomEventforScreen(gaKey, eventName: JREventProductSharedOnSocial, variables: [JRVariableVerticalName:"marketpalce","PLATFORM_NAME":"messanger"])
            
            var shareMessage = self.message
            shareMessage = shareMessage?.replacingOccurrences(of: " & ", with: " and ")
            
            composeViewController = SLComposeViewController(forServiceType: SLServiceTypeFacebook)
            if let shareMessage = shareMessage {
                composeViewController?.setInitialText(shareMessage)
            }
            
            if let contentUrl = contentUrl, let url = URL.init(string: contentUrl){
                composeViewController?.add(url)
            }
            
            break
        case SocialShareType.othersShareOption :
            
            loadDefaultShareView()
            break
            
        }
        
        if let composeViewController = composeViewController {
            
            let shareMessage = shareMessageStringForType(type)
            if let shareMessage = shareMessage {
                composeViewController.setInitialText(shareMessage)
                composeViewController.completionHandler = {[weak self](result: SLComposeViewControllerResult) -> Void in
                    
                    switch(result) {
                    case .cancelled :
                        
                        self?.showAlertViewOnMainThread()
                        break
                        
                    case .done :
                        
                        break
                    @unknown default:
                        break
                    }
                }
                if shareFromLifafa {
                    shareFromLifafa = false
                    var topMostViewController = JRCommonManager.shared.navigation.rootNavController.topViewController
                    while (topMostViewController?.presentedViewController != nil) {
                        topMostViewController = topMostViewController?.presentedViewController
                    }
                    topMostViewController?.present(composeViewController, animated: true, completion: nil)
                }
                else {
                    JRCommonManager.shared.navigation.rootNavController.present(composeViewController, animated: true, completion: nil)
                }
            }
        }
    }
}


fileprivate extension JRSocialShareManager {
    
    func showAlertViewOnMainThread() {
        DispatchQueue.main.async { [weak self] () -> Void in
            self?.presentAlertViewWithMessage("Message sending failed")
        }
    }
    
    
    func shareMessageStringForType(_ socialShareType: SocialShareType) -> String? {
        
        let message = self.message
        let shareOnPDPURLString = self.contentUrl
        var shareOnPDPURL: URL?
        if let shareOnPDPURLString = shareOnPDPURLString {
            
            shareOnPDPURL = URL(string: shareOnPDPURLString)
        }
        var shareMessageString = ""
        if let message = message, let shareOnPDPURL = shareOnPDPURL {
            shareMessageString = "\(message)\n\n\(shareOnPDPURL)"
        }
        
        if socialShareType == SocialShareType.twitter {
            
            let maxCharactersToShareOnTwitter = 140
            let extraCharacter = shareMessageString.length - maxCharactersToShareOnTwitter
            if let message = message {
                
                let bound = (message.length - (extraCharacter + 3))
                if bound > 0 && bound < message.length {
                    
                    var subMessageString = (message as  NSString).substring(to: bound)
                    subMessageString = subMessageString + "..."
                    if let shareOnPDPURL = shareOnPDPURL {
                        shareMessageString = "\(subMessageString)\n\n\(shareOnPDPURL)"
                    }
                }
                else if shareFromLifafa {
                    if message.length < 140 {
                        return message
                    }
                }
            }
        } else if socialShareType == SocialShareType.facebook {
            if let message = message {
                return message
            }
        }
        
        return shareMessageString
    }
    
    
    func presentAlertViewWithMessage(_ message: String) {
        JRAlertViewWithBlock.showAlertView("", message: message)
    }
    
    
    func loadDefaultShareView() {
        
        if let message = message, let contentUrl = contentUrl {
            
            let activityViewController = getActivityViewControllerFor(message, shareUrlString: contentUrl)
            JRCommonManager.shared.navigation.rootNavController.present(activityViewController, animated: true, completion:  nil)
        }
    }
    
    func getActivityViewControllerFor(_ message: String, shareUrlString: String) -> UIActivityViewController {
        
        let activityItem = JRCustomActivityItem.init(message: message, shareUrlString: shareUrlString, subjectTitle: emailSubject)
        var activityItems = [Any]()
        if let contentImage = contentImage {
            if imagePreference == true {
                activityItems = [activityItem,contentImage]
            } else {
                activityItems = [activityItem]
            }
        } else {
            activityItems = [activityItem]
        }
        let activityViewController = UIActivityViewController.init(activityItems: activityItems as [AnyObject], applicationActivities: nil)
        
        activityViewController.setValue(emailSubject, forKey: "subject")
        
        activityViewController.completionWithItemsHandler = {[weak self] (activityType, completed, returnedItems, activityError) -> Void in
            
            if let activityType = activityType {
                JRGoogleTrackManager.trackCustomEventforScreen(self?.gaKey ?? "", eventName: JREventProductSharedOnSocial, variables: [JRVariableVerticalName:"marketpalce","PLATFORM_NAME":activityType.rawValue])
            }
            self?.activityPopover = nil
        }
        return activityViewController
    }
    
    //MARK: - WhatsApp sharing
    
    func postMessageUsingWhatsAppWithMessage(_ message: String) {
        
        let shareString = "whatsapp://send?text=\(message)"
        let shareStringUrl = shareString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        if let shareStringUrl = shareStringUrl {
            
            let whatsAppUrl = URL.init(string: shareStringUrl)
            if let whatsAppUrl = whatsAppUrl {
                
                if UIApplication.shared.canOpenURL(whatsAppUrl) {
                    UIApplication.shared.open(whatsAppUrl, options: [:], completionHandler: nil)
                } else {
                    presentAlertViewWithMessage("It seems whatsapp is not installed in your device. Please install and try again.")
                }
            }
        }
    }
}
