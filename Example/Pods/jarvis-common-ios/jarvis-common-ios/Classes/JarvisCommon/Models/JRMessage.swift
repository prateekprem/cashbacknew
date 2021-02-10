//
//  JRMessage.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 16/06/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

public class JRMessage: NSObject {

    @objc public let title: String?
    @objc public let message: String?
    @objc public let action: String?
    @objc public let buttonText: String?
    
    public init(dictionary: [AnyHashable: Any]) {
        
        title = dictionary.getOptionalStringForKey("title")
        message = dictionary.getOptionalStringForKey("message")
        action = dictionary.getOptionalStringForKey("action")
        buttonText = dictionary.getOptionalStringForKey("button_text")
        super.init()
    }
}
