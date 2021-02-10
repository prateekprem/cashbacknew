//
//  Ext_NSObject.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension NSObject {
    public class var className: String {
        return String(describing: self)
    }
    
    @objc
    public func isNull() -> Bool {
        guard !(self is NSNull) else { return true }
        
        switch "\(self)" {
        case "<null>", "(null)", "null", "NULL":
            return true
        default:
            return false
        }
    }
    
    @objc
    public func isDictionaryEmpty() -> Bool {
        guard let dict = self as? [AnyHashable: Any] else { return false }
        return dict.isEmpty
    }
    
    @objc
    public func isArrayEmpty() -> Bool {
        guard let array = self as? Array<Any> else { return false }
        return array.isEmpty
    }
    
    @objc
    public func changeTextFieldSize(_ textfield: UITextField!, onEditBegin boolValue: Bool) {
        var frame = textfield.frame
        frame.size.height = boolValue ? 50 : 36
        textfield.frame = frame
    }
    
    @objc
    public func getCountryCodeRemovedMobileNumber(_ mobileNumber: String) -> String {
        return mobileNumber.replacingOccurrences(of: JRPrefixCountryCode, with: "")
    }
    
    @objc
    public func validObjectValue() -> AnyObject? {
        return self.isNull() ? nil : self
    }
}
