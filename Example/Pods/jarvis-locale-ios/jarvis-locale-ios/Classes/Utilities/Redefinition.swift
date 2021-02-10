//
//  Redefinition.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 29/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension String{
    
    public var localized: String {
        return NSLocalizedString(self)
    }
}

extension NSString{
    
    public var localized : NSString{
        return NSString.init(string: NSLocalizedString(self as String))
    }
    
}

public func NSLocalizedString(_ key: String) -> String{
    return LanguageManager.shared.getLocalizedString(forKey: key)
}


/*
public func NSLocalizedString(_ key: String, tableName: String? = nil, bundle: Bundle = Bundle.main, value: String = "", comment: String) -> String{
    return NSLocalizedString(key)
}
*/
