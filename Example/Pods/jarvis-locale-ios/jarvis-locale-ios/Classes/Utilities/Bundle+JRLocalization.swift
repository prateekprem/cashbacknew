//
//  Bundle+JRLocalization.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 09/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Bundle{

    class var languageBundle : Bundle{
        get{
            return DirectoryManager.getLanguageBundle()
        }
    }
    
    /* Not being used
     
    class func swizzle(){
        let originalSelector = #selector(localizedString(forKey:value:table:))
        let newSelector = #selector(swizzledLocalizedString(forKey:value:table:))
        
        if let originalMethod = class_getInstanceMethod(self, originalSelector), let swizzledMethod = class_getInstanceMethod(self, newSelector){
            method_exchangeImplementations(originalMethod, swizzledMethod)
        }
    }
    
    @objc func swizzledLocalizedString(forKey: String, value: String?, table: String?) -> String{
        return NSLocalizedString(forKey)
    }
    */
}
