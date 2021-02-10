//
//  JRError.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 03/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation
@objc public class JRError: NSObject {

    @objc public var message: String?
    @objc public var title: String?
    @objc public var cancelButton: String?
    @objc public var okbutton: String?

    @objc public init(dictionary: [AnyHashable : Any]) {
        message = dictionary.getOptionalStringForKey("message")
        title = dictionary.getOptionalStringForKey("title")
        cancelButton = dictionary.getOptionalStringForKey("cancelButton")
        okbutton = dictionary.getOptionalStringForKey("okbutton")
    }
    
    @objc public static func isValidInput(dict: [AnyHashable : Any]) -> Bool {
        var isValid: Bool = false
        
        if let _ = dict.getOptionalStringForKey("message"), let _ = dict.getOptionalStringForKey("title") {
            isValid = true
        }
        
        return isValid
    }
}
