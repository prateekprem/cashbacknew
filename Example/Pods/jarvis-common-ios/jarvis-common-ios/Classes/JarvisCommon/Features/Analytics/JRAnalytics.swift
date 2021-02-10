//
//  JRAnalytics.swift
//  GTMDemo
//
//  Created by Kushal on 11/12/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

@objc public class JRAnalytics : NSObject {
    
    private static var unloggedEvents = [[AnyHashable : Any]]()
    private static var unloggedEventsQueue = DispatchQueue.init(label: "JRAnalytics_concurrent_queue", qos: .background, attributes: .concurrent)
    private static var isRemoteConfigInitialized = false
    
    class func pushToSignal(event : [AnyHashable : Any]) {
        JRSignalManager.shared.push(object: event)
    }
    
    @objc public class func logEvent(_ event: [AnyHashable : Any]) {
        if !isRemoteConfigInitialized {
            unloggedEventsQueue.async(flags: .barrier) {
                unloggedEvents.append(event)
            }
            return
        }
        pushEvent(event)
    }
    
    @objc class func remoteConfigInitialized(isInitialized: Bool) {
        isRemoteConfigInitialized = isInitialized
        logQueuedEvents()
    }
    
    // MARK: - Private methods
    private class func logQueuedEvents() {
        if unloggedEvents.isEmpty { return }
        
        for event in unloggedEvents {
            pushEvent(event)
        }
        unloggedEvents.removeAll()
    }
    
    private class func pushEvent(_ event: [AnyHashable : Any]) {
        pushToSignal(event: event)
    }
}
