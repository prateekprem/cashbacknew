//
//  JRTagManager.swift
//  JRTagManagerDemo
//
//  Created by nasib ali on 01/08/19.
//  Copyright © 2019 nasib ali. All rights reserved.
//

import Foundation

public class JRAppManager {
    
    static fileprivate var shared: JRAppManager = JRAppManager()
    private var tagContainer: JRAppManagerContainer?
    
    public static func kickOff(_ configurator: JRAppManagerConfigurator, completionHandler: (() -> Void)? = nil) {
        shared.tagContainer = JRAppManagerContainer(with: configurator)
        shared.tagContainer?.checkAndSyncTags(completionHandler: completionHandler)
    }
}

extension JRAppManager {
    
    public static func value<T>(forKey key: String) -> T? {
        
        switch T.self {
        case is Bool.Type:
            return shared.tagContainer?.boolValue(forKey: key) as? T
        case is Int.Type:
            return shared.tagContainer?.intValue(forKey: key) as? T
        case is Double.Type:
            return shared.tagContainer?.doubleValue(forKey: key) as? T
        default:
            return shared.tagContainer?.stringValue(forKey: key) as? T
        }
    }
    
    public static func update(_ value: String, for key: String, handler: (() -> Void)? = nil) {
        shared.tagContainer?.update(value, for: key, handler: handler)
    }
}
