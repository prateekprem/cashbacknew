//
//  JRCartReturnPolicyModel.swift
//  Jarvis
//
//  Created by Samar Gupta on 2/22/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

@objc public class JRCartReturnPolicyModel: NSObject
{
    @objc var return_policy_text: String?
    @objc var cancellation_policy_text: String?
    @objc var isAllKeysValueNull = true
    
    @objc public convenience init(dictionary: [AnyHashable: Any]) {
        self.init()
    
        if var finalStr = dictionary.getOptionalStringForKey("return_policy_title"), finalStr.count > 0
        {
            isAllKeysValueNull = false
            if let str = dictionary.getOptionalStringForKey("return_policy_text"), str.count > 0
            {
                finalStr = finalStr + "-" + str
            }
            return_policy_text = finalStr
        }
        
        if var finalStr = dictionary.getOptionalStringForKey("cancellation_policy_title"), finalStr.count > 0
        {
            isAllKeysValueNull = false
            if let str = dictionary.getOptionalStringForKey("cancellation_policy_text"), str.count > 0
            {
                finalStr = finalStr + "-" + str
            }
            cancellation_policy_text = finalStr
        }
    }
}
