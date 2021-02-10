
//
//  Ext_Bool.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Bool {

    public init<T : BinaryInteger>(_ integer: T) {
        if integer == 0 {
            self.init(false)
        } else {
            self.init(true)
        }
    }
    
    public init(string: String?) {
        guard let value = string else {
            self = false
            return
        }
        let lowerCaseValue = value.lowercased()
        let trueValues: Set<String> = ["true", "yes", "1", "success"]
        
        if trueValues.contains(lowerCaseValue) {
            self = true
        } else {
            self = false
        }
    }
    
}
