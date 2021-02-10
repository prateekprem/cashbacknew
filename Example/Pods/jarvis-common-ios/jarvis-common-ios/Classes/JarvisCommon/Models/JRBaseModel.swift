//
//  JRBaseModel.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 31/05/19.
//

import UIKit

@objc open class JRBaseModel: NSObject {
    
    
    @objc public required init(dictionary:[AnyHashable : Any]) {
        
    }
    
    @objc open class func instanceFromJsonArray(list : [Any]?) -> [Any] {
        
        var items : [Any] = []
        if let list = list {
            
            for item in list {
                if let item = item as? [AnyHashable : Any] {
                    let instance = self.init(dictionary: item)
                    items.append(instance)
                }
            }
        }
        return items
    }
    
    open class func getArrayInstance<T: JRBaseModel>(list: [[String: Any]]?) -> [T]? {
        var items : [T] = []
        if let list = list {
            for item in list {
                let instance = T.init(dictionary: item)
                items.append(instance)
            }
        }
        return items.count > 0 ? items: nil
    }
}
