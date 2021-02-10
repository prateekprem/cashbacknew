//
//  Ext_NSData.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension NSData{
    
    public func dictionary() -> [String: AnyObject]
    {
        do {
            let result = try JSONSerialization.jsonObject(with: self as Data, options: [JSONSerialization.ReadingOptions.mutableContainers, JSONSerialization.ReadingOptions.mutableLeaves])
            
            guard let results = result as? [String : AnyObject] else
            {
                return [String: AnyObject]()
            }
            return results
        }
        catch {
            return [String: AnyObject]()
        }
    }
    
}
