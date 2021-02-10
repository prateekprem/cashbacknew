//
//  JRCBConfig.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 17/01/20.
//

import Foundation

@objc public enum JRCashbackEnvironment: Int{
    case production
    case staging
}

@objc public enum JRCashbackVarient: Int {
    case paytm
    case mall
    case merchantApp
}

@objc public enum JRCashbackBuildType: Int {
    case debug
    case release
}

public struct JRCBConfig {
    private(set) var cbEnvironment : JRCashbackEnvironment = .production
    private(set) var cbVarient : JRCashbackVarient = .paytm
    private(set) var cbBuildType : JRCashbackBuildType = .debug

    public init(env: JRCashbackEnvironment = .production,
         verient: JRCashbackVarient = .paytm,
         buildType: JRCashbackBuildType = .release) {
        
        self.cbEnvironment = env
        self.cbVarient = verient
        self.cbBuildType = buildType
    }
}
