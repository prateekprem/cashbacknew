//
//  JRRemoteConfigManager.swift
//  Jarvis
//
//  Created by Prakash Jha on 25/07/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

internal enum JRConfigPlatform: String {
    //case firebase = "Firebase"
    case gtm = "GTM"
    case local = "LOCAL"
}

public typealias JRRemoteConfigHandler = () -> Void

public class JRRemoteConfigManager: NSObject {
    static let shared = JRRemoteConfigManager()
    private override init() { }
    
    public class func stringFor(key : String) -> String? {
        return JRRemoteConfigManager.value(key: key)
    }
    
    public class func value<T>(key: String)-> T? {
       return shared.value(key: key, platform: .local)
    }
    
    public class func update(_ value: String, for key: String, handler: (() -> Void)? = nil) {
        JRAppManager.update(value, for: key, handler: handler)
    }
    
    public class func kickOffWith(configurator: JRAppManagerConfigurator, completion : @escaping JRRemoteConfigHandler) {
        JRAppManager.kickOff(configurator) {
            JRAnalytics.remoteConfigInitialized(isInitialized: true)
            completion()
        }
    }
    
    internal func value<T>(key: String, platform: JRConfigPlatform) -> T? {
        
        switch platform {
        case .local:
            return JRAppManager.value(forKey: key)
        default: return nil
        }
    }
}


@available(*, deprecated)
public class JRGTMBridge: NSObject {
    public static let shared = JRGTMBridge()
    private override init() {}
    
    public func value<T>(key: String)-> T? {
        return JRRemoteConfigManager.value(key: key)
    }
}
