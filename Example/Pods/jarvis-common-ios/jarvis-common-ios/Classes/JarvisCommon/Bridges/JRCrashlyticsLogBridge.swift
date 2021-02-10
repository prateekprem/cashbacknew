//
//  JRCrashlyticsLogBridge.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 10/12/20.
//

import Foundation

public class JRCrashlyticsLogBridge {
    public static let shared = JRCrashlyticsLogBridge()
    public var crashLogHandler: ((String) -> ())?
    
    func log(_ message: String) {
        crashLogHandler?(message)
    }
}
