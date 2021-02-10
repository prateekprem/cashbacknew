//
//  JRHawkEyeUtilities.swift
//  jarvis-common-ios
//
//  Created by nasib ali on 17/06/19.
//

import UIKit
import CoreTelephony

enum DAEventResponseType : String{
    case json = "json"
    case nonJson = "nonJson"
}

public class JRHawkEyeUtils {
    
    class var iso8601DateString: String {
        let formatter = ISO8601DateFormatter()
        formatter.timeZone = TimeZone.current
        return formatter.string(from: Date())
    }
    
    
    class var cellularCarrierName: String? {
        var carrierString: String?
        let networkInfo = CTTelephonyNetworkInfo()
        let carrier = networkInfo.subscriberCellularProvider
        if (carrier?.mobileNetworkCode) != nil {
            if let name = carrier?.carrierName {
                carrierString = name;
            }
        }
        return carrierString
    }
    
    
    class func reponseType(with response: Data?) -> String? {
        
        guard let data = response else {
            return nil
        }
        
        var responseType = DAEventResponseType.nonJson.rawValue
        // check to differenciate between JSON and non-JSON data formats
        do {
            if (try JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments, JSONSerialization.ReadingOptions.mutableContainers]) as? [AnyHashable : Any]) != nil {
                responseType = DAEventResponseType.json.rawValue
            }
        } catch _ as NSError {}
        return responseType
    }
    
    
    class func dataSize(with data: Data?) -> Int? {
        
        guard let data = data else {
            return nil
        }
        return data.count
    }
    
    class var isEnvironmentStaging: Bool {
        return JRCommonManager.shared.moduleConfig.environment == .staging
    }
    
    
    public class var apiSecret : String {
        get {
            if JRHawkEyeUtils.isEnvironmentStaging {
                return "c64cb4c949acbc3187739fb96fe34328"
            }
            return "9JR3Hb2t8P9eXrbFP03NE8pfPJ7X8ttL"
        }
    }
    
    
    public class var apiKey : String { get {
        if JRHawkEyeUtils.isEnvironmentStaging { return "ios-staging" }
        return "ios-prod"
        }
    }
}
