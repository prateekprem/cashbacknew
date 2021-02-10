//
//  JRCBCommonBridge.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 18/04/20.
//

import Foundation
import jarvis_network_ios

class JRCBCommonBridge {
    class var defaultNavVC: UINavigationController? {
        return JRCashbackManager.shared.cbEnvDelegate.cbAppDefaulNavVC()
    }
    
    class func urlByAppendingDefaultParam(urlStr: String?) -> String? {
        return JRCashbackManager.shared.cbEnvDelegate.cbUrlByAppendingDefaultParam(urlStr: urlStr)
    }
    
    class func remoteValueFor<T>(key: String) -> T? {
       return JRCashbackManager.shared.cbEnvDelegate.cbRemoteValueFor(key: key)
    }
    
    class func remoteStringFor(key: String) -> String? {
        return JRCashbackManager.shared.cbEnvDelegate.cbRemoteStringFor(key: key)
    }
}


// jarvis_network_ios
extension JRCBCommonBridge {
    class var isNetworkAvailable: Bool {
        return JRNetworkUtility.isNetworkReachable()
    }
}

public enum RequestMethodType: String {
    case get   = "GET"
    case post  = "POST"
    case put   = "PUT"
    
    var httpMethod: JRHTTPMethod {
        switch self {
        case .get : return .get
        case .post : return .post
        case .put : return .put
        }
    }
}
