//
//  JRJRIndicativePlanAttributes.swift
//  Jarvis
//
//  Created by Sandeep Chhabra on 27/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRIndicativePlanAttributes: NSObject {
     public var validity:String?
     public var operatorName:String?
     public var categoryName:String?
     public var circle:String?
     public var talktime:String?
     public var disclaimer:String?
    
    public func setWithDictionary(_ dictionary: [AnyHashable: Any]) {
        if let val1 = dictionary.getOptionalStringForKey("Validity"){
            validity = val1
        }else if let val2 = dictionary.getOptionalStringForKey("validity"){
            validity = val2
        }
        if let talk1 = dictionary.getOptionalStringForKey("Talktime"){
            talktime = talk1
        }else if let talk2 = dictionary.getOptionalStringForKey("talktime"){
            talktime = talk2
        }
        operatorName = dictionary.getOptionalStringForKey("Operator")
        categoryName = dictionary.getOptionalStringForKey("category_name")
        circle = dictionary.getOptionalStringForKey("Circle")
        disclaimer = dictionary.getOptionalStringForKey("Disclaimer")
    }
    
   public init(dictionary: [AnyHashable: Any]) {
        super.init()
        setWithDictionary(dictionary)
    }

}
