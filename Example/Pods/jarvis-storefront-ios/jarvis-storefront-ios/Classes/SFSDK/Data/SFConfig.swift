//
//  SFConfig.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import Foundation

public typealias SFJSONDictionary = [String:Any]

public enum SFAppType: String {
    case consumerApp = "PaytmConsumerApp"
    case merchantApp = "PaytmMerchantApp"
    case marketplace = "marketplace"
    case channel = "channel"
    case cashback = "PaytmCashback"
    case other = "other"
}

public enum SFEnvironment: Int {
    case staging = 0
    case production = 1
}

public enum SFTarget: Int {
    case debug = 0
    case release = 1
}

class SFConfig {
    private(set) var sfAppType    = SFAppType.merchantApp
    private(set) var sfEnviorment = SFEnvironment.production
    
    init(appType: SFAppType, environment: SFEnvironment) {
        self.sfAppType = appType
        self.sfEnviorment = environment
    }
}
