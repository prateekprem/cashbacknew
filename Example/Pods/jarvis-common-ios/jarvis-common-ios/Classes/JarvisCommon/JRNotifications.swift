//
//  JRNotifications.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 25/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

public extension Notification.Name {
    
    // Listen this to know the status of Jarvis Common Service Initialization
    static let JRCommonServiceInitialized = Notification.Name("JRCommonServiceInitialized")
    
    //Listen this to identify when version check is completed
    static let JRGotResultFromVersionCheck = Notification.Name("JRGotResultFromVersionCheck")
}
