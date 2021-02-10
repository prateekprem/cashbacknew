//
//  JRCommonGTMKeys.swift
//  jarvis-common-ios
//
//  Created by nasib ali on 13/06/19.
//

import UIKit

enum JRCommonGTMKey: String {
    
    case isNetworkSDK = "isNetworkSDKEnabled"
    case isErrorEvent = "isErrorEventEnabled"
    case networkSDK = "debug_analytics_sizeAlertInKb"
    case isLocalError = "isLocalErrorEventEnabled"
    case isApiLog = "isApiLogEventEnabled"
    
    var enabled: Bool {
        let value: Bool = JRRemoteConfigManager.value(key: self.rawValue) ?? true
        return value
    }
}
