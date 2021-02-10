//
//  JRCommonRemoteConfigClient.swift
//  jarvis-common-ios
//
//  Created by Prakash Jha on 31/07/19.
//

import UIKit

@objc public class JRCommonRemoteConfigClient : NSObject {
    
    @objc public static var QRInfoNetworkTimeout : Double {
        get{
            if let remoteValue : String = JRRemoteConfigManager.value(key: "qrInfoNetworkTimeout"){
                if let value = Int(String.validString(val: remoteValue) ?? "10"){
                    return Double(value)
                }
            }
            return 10.0
        }
    }
    
    @objc public static var URLGetAllTokens : String? { get {
            return JRRemoteConfigManager.value(key: "getalltokens")
        }
    }
    
    @objc public static var publicSearch : String? { get {
            return JRRemoteConfigManager.value(key: "publicSearch")
        }
    }
    
    @objc public static var isGAEnabled : Bool {
        if let value: Bool = JRRemoteConfigManager.value(key: "isGASDKEnabled") {
            return value
        }
        return false
    }
    
    @objc public static var unKnownUrlHandlingDictionary: [String: AnyObject]? {
        //UnknownUrl Type handling
        var dict: [String: AnyObject]? = nil
        if let jsonString  = String.validString(val: JRRemoteConfigManager.string(forKey: "unknow_url_message_map")), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                dict = jsonDict as? [String: AnyObject]
            } catch {}
        }
        return dict
    }
}
