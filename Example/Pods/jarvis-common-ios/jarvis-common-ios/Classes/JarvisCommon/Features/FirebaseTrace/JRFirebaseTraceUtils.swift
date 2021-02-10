//
//  JRFirebaseTraceUtils.swift
//  Jarvis
//
//  Created by Nitin Upadhyay on 23/10/20.
//  Copyright © 2020 One97. All rights reserved.
//

import Foundation

@objc public enum JRFirebaseTrace: Int {
    case launchTime
    case initEssentials
    case deferredInit
    case deeplink
    case deeplinkH5
    case h5HTMLLoad

    public var stringValue: String {
        switch self {
        case .launchTime:
            return "app_launch_time"
        case .initEssentials:
            return "init_essentials"
        case .deferredInit:
            return "init_deferred"
        case .deeplink:
            return "DeepLinkEngine_handleDeepLinkTrace"
        case .deeplinkH5:
            return "phoenix_start_activity_webPageStart_trace"
        case .h5HTMLLoad:
            return "phoenix_webPageLoadStart_finish_trace"
        }
    }
}

@objc public enum JRFirebaseLogState: Int {
    case start
    case end
}

@objc public enum JRFirebaseTraceAttributeType: Int {
    case appLaunchFlowType
    case appLock

    public var stringValue: String {
        switch self {
        case .appLaunchFlowType:
            return "app_launch_flow_type"
        case .appLock:
            return "app_lock"
        }
    }
}

@objc public enum JRFirebaseTraceAttributeValue: Int {
    case appLaunchFlowTypeLogin
    case appLaunchFlowTypeStandard

    case appLockFlowTypeOpted
    case appLockFlowTypeNotOpted

    public var stringValue: String {
        switch self {
        case .appLaunchFlowTypeLogin:
            return "launch_via_login"
        case .appLaunchFlowTypeStandard:
            return "launch_normal"
        case .appLockFlowTypeOpted:
            return "app_lock_opted"
        case .appLockFlowTypeNotOpted:
            return "app_lock_notOpted"
        }
    }
}
