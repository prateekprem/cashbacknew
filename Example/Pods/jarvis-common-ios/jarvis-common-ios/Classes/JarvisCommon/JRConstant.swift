//
//  JarvisCommon.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 25/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

internal extension Bundle{
    
    class var framework : Bundle{
        get{
           return Bundle.init(for: JRConstant.self)
        }
    }
    
}

internal class JRConstant : NSObject {
    
}

@objc public class JRCommonHelper : NSObject{
    
    @objc public class var searchActivityItems: [String: AnyObject]? {
        var items: [String: AnyObject]? = nil
        if let jsonString = String.validString(val: JRCommonRemoteConfigClient.publicSearch) {
            if #available(iOS 9.0, *) {
                do {
                    if let data = (jsonString as NSString).data(using: String.Encoding.utf8.rawValue) {
                        let dict: [String : AnyObject]? = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String: AnyObject]
                        if let dict = dict {
                            var dictionary: [String: JRSearchActivityItem] = [String: JRSearchActivityItem]()
                            
                            for (key, val) in dict {
                                if let val = val as? [String : AnyObject] {
                                    dictionary[key] = JRSearchActivityItem.init(key: key, dictionary: val)
                                }
                            }
                            items = dictionary
                        }
                    }
                }catch{}
            }
        }
        return items
    }
    
}
