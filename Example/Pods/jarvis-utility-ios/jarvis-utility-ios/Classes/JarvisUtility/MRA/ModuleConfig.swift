//
//  ModuleConfig.swift
//  Core
//
//  Created by Abhinav Kumar Roy on 19/07/19.
//  Copyright © 2019 Abhinav Roy. All rights reserved.
//

import UIKit

@objc public enum JREnvironment : Int{
    case production
    case staging
}

@objc public enum JRVarient : Int{
    case paytm
    case mall
}

@objc public enum JRBuildConfig : Int{
    case debug
    case release
    case adhoc
}

@objc public class ModuleConfig : NSObject{
    @objc public var environment : JREnvironment = .production
    @objc public var varient : JRVarient = .paytm
    @objc public var buildConfig : JRBuildConfig = .debug
    
    private override init() {}
    
    public convenience init(withEnvironment env : JREnvironment,
                            andVarient varient : JRVarient,
                            andbuildConfig buildConfig: JRBuildConfig) {
        self.init()
        self.environment = env
        self.varient = varient
        self.buildConfig = buildConfig
    }
}
