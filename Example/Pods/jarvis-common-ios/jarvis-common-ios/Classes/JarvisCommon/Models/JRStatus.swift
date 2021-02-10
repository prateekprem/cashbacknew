//
//  JRStatus.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 16/06/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation
@objcMembers
public class JRStatus: NSObject {

    public let result: String?
    public let message: JRMessage?
    public let code: String?
    
    public init(dictionary: [AnyHashable: Any]) {
        
        result = dictionary.getOptionalStringForKey("result")
        code = dictionary.getOptionalStringForKey("code")
        if let messageInfo = dictionary.getOptionalDictionaryKey("message") {
            message = JRMessage(dictionary: messageInfo)
        } else {
            message = nil
        }
        super.init()
    }
    
    
    public class func errorForFailureState(_ dictionary: [AnyHashable: Any]) -> NSError? {
        
        let status = JRStatus.init(dictionary: dictionary)
        if status.result?.caseInsensitiveCompare("failure") == .orderedSame {
            if let message = status.message?.message {
                let title: String = status.message?.title ?? ""
                let code: String = status.code ?? "0"
                let errorInfo: [String : String] = [NSLocalizedFailureReasonErrorKey: title, NSLocalizedDescriptionKey: message]
                return NSError(domain: title, code: Int(code) ?? 0, userInfo: errorInfo)
            }
        }
        return nil
    }
}
