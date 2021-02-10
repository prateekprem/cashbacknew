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

let kProfileType: String = "kProfileType"

internal class JRConstant : NSObject {

    
}
