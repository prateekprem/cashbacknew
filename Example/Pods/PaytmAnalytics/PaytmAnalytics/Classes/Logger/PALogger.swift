//
//  PALogger.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import os

class PALogger: NSObject {
    
    private static let logger = OSLog(subsystem: Bundle.main.bundleIdentifier!, category: "Paytm Analytics SDK")
    
    /// Prints out a formatted logging message to Xcode's debug console or macOS' Console app when Xcode is not avaiable
    ///
    /// - Parameters:
    ///     - paType: The source of the logging message which indicates whether it's from Signal or Hawkeye
    ///     - messageType: The type of the logging message which indicates whether it's a successful operation or not,
    ///                    the default value is `.message`
    ///     - message: The original logging message provided by the caller
    ///     - isCritical: A boolean value indicating whether this logging message is critical and needs to be printed out to the
    ///                   debug console regardless of whether the logging system itself is turned on or not
    static func log(message: String, withPAType paType: PALogType = .signalSDK,
                    andMessageType messageType: PALogMessageType = .message,
                    isCritical: Bool = false,
                    file: String = #file,
                    function: String = #function,
                    line: Int = #line) {
        guard (paType == .signalSDK && PASignalSession.shared.isLoggingEnabled) || (paType == .networkSDK && PANetworkSession.shared.isLoggingEnabled) || isCritical else {
            return
        }
        
        let module = paType == .signalSDK ? "Signal" : "Hawkeye"
        let className = file.components(separatedBy: "/").last ?? "Unknown class name"
        let logString = StaticString("%{public}s \n%-11s = *%{public}s*\n%-11s = %{public}s\n%-11s = %{public}s \n%-11s = %{public}d\n%-11s = %{public}s")
        os_log(logString,
               log: logger,
               type: messageType == .success ? .debug : .error,
               // The list of arguments starts here
               messageType.getEmoji(),
               "Message", message,
               "Inside file", className,
               "In function", function,
               "At line", line,
               "Module", module)
        print()
    }
    
    enum PALogMessageType {
        case message, success, fail
        
        fileprivate func getEmoji() -> String {
            switch self {
            case .fail:
                return "❌"
            case .message:
                return "💬"
            case .success:
                return "✅"
            }
        }
    }
    
}
