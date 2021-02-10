//
//  NsobjectExtension.swift
//  Jarvis
//
//  Created by Gaurav Sharma on 02/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
// NOTE : All the functions from NSObject utilities are to be replaced by the functions of this class. NSNull, NSDictionary etc checks will be removed once all the objective c files are converted to swift files.
public class JRObjectUtilities{
    
    public init() {}
    
    public func isNull<T>(element : T?) -> Bool{
        if let obj = element{
            if obj is NSNull{
                return true
            }
            return ("\(obj)" == "<null>") || ("\(obj)" == "(null)") || ("\(obj)" == "null") || ("\(obj)" == "NULL")
        }else{
            return true
        }
    }
}
