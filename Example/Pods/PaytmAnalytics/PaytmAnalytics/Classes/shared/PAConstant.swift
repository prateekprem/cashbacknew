//
//  PAConstant.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

typealias PABoolVoidCompletion = (Bool) -> ()

struct PAConstant {
    
    // MARK: - Signal events default values
    
    struct Signal {
        static let V2_BATCH_SIZE_LIMIT                             = 10
        static let FORCED_DISPATCH_INTERVAL                        = 2.0
        
        static let V2_ENDPOINT                                     = "/v2/api/signals/batch"
        // NOTE: Will be deprecated soon
        static let SIGNALV2_ENDPOINT_DEBUG                         = "https://sig-staging.paytm.com/v2/api/signals/batch"
        static var SIGNALV2_ENDPOINT_RELEASE                       = "https://sig.paytm.com/v2/api/signals/batch"
    }

    // MARK: - Network request

    static let COOKIE_HEADER            = "Cookie"
    static let HMAC_HEADER              = "hash"
    static let XREQUESTER_HEADER        = "x-requester"
    static let AUTHORIZATION_HEADER     = "Authorization"
    static let BEARER_PREFIX            = "Bearer"
    static let HTTP_POST                = "POST"
    static let RESPONSE_STATUS          = "status"
    static let RESPONSE_SUCCESS         = "SUCCESS"
    
    // MARK: - Misc
    
    static let EMPTY_STRING = ""
    static let EVENT_EXPIRATION_INTERVAL: TimeInterval = 30 * 24 * 3600 // 30 days
    
}

public enum DispatchStrategy {
    
    case manual
    case intervalBased(interval: TimeInterval)
    case background
}

enum PALogType: Int {
    
    case none = 0
    case networkSDK
    case signalSDK
}

public enum PABuildType {
    
    case debug
    case adhoc
    case release
}
