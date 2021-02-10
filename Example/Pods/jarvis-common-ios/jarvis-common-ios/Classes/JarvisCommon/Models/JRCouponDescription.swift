//
//  JRCouponDescription.swift
//  Jarvis
//
//  Created by Sandeep Chhabra on 02/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRCouponDescription: NSObject {
  @objc  public var title :String!
  @objc public var couponDescription :String!
  public var attributes: JRIndicativePlanAttributes?
  @objc  public var show_on_tap = false
    
   @objc public func setWithDictionary(_ dictionary: [AnyHashable: Any]) {
        title = dictionary.getStringKey("title")
        couponDescription = dictionary.getStringKey("description")
        if let dict = dictionary["attributes"] as? [AnyHashable: Any]{
            attributes = JRIndicativePlanAttributes(dictionary: dict)
        }
        if let showOnTap = dictionary["show_on_tap"] as? Bool{
            show_on_tap = showOnTap
        }else{
            show_on_tap = false
        }
    } 
    
  @objc public convenience init(dictionary: [AnyHashable: Any]) {
        self.init()
        setWithDictionary(dictionary)
    }

}
