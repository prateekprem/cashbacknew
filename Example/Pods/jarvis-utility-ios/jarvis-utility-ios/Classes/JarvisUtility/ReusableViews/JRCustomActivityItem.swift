//
//  JRCustomActivityItem.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 04/01/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

public class JRCustomActivityItem: NSObject, UIActivityItemSource {
    
    public var message: String?
    public var contentUrl: String?
    public var emailShareString = "Share"

    // MARK: - Initialization Methods

    public init(message: String, shareUrlString: String, subjectTitle: String) {
        super.init()
        self.message = message
        self.contentUrl = shareUrlString
        emailShareString = subjectTitle
    }
    
    // MARK: - UIActivityItemSource Methods
    public func activityViewControllerPlaceholderItem(_ activityViewController: UIActivityViewController) -> Any {
        return ""
    }
    
    
    public func activityViewController(_ activityViewController: UIActivityViewController, itemForActivityType activityType: UIActivity.ActivityType?) -> Any? {
        let message = self.message
        let shareOnPDPURLString = self.contentUrl
        let shareOnPDPURL: URL?
        if let shareOnPDPURLString = shareOnPDPURLString {
            shareOnPDPURL = URL(string:  shareOnPDPURLString)
        } else {
            shareOnPDPURL = nil
        }
        var shareMessageString = ""
        if let message = message, let shareOnPDPURL = shareOnPDPURL {
            shareMessageString = "\(message)\n\n\(shareOnPDPURL)"
        }
        
        if  activityType == .postToTwitter {
            
            let maxCharactersToShareOnTwitter = 140
            let extraCharacter = shareMessageString.length - maxCharactersToShareOnTwitter
            if let message = message {
                
                let bound = (message.length - (extraCharacter + 3))
                if bound > 0 && bound < message.length {
                    
                    var subMessageString = (message as  NSString).substring(to: bound)
                    subMessageString = subMessageString.appending("...")
                    if let shareOnPDPURL = shareOnPDPURL {
                        shareMessageString = "\(subMessageString)\n\n\(shareOnPDPURL)"
                    }
                }
            }
        } else if activityType?.rawValue == "pinterest.ShareExtension" {
            
            /**
             
             Need more R&D on this issue since pinterest does not allow add any description and other parameters to to its sheet.
             http://stackoverflow.com/questions/27030169/share-to-pinterest-via-share-extension
             
             
             NSURL *imageURL = [NSURL URLWithString:self.product.imageUrl];
             return @{@"description": message, @"media": imageURL};
             **/
            
            if let contentUrl = contentUrl {
                let sourceUrl = URL(string: contentUrl)
                if let sourceUrl = sourceUrl {
                    return sourceUrl
                }
            }
            return nil
        }
        
        return shareMessageString
    }
    
    
    public func activityViewController(_ activityViewController: UIActivityViewController, subjectForActivityType activityType: UIActivity.ActivityType?) -> String {
        if activityType == .mail {
            return emailShareString
        }
        return ""
    }
}
