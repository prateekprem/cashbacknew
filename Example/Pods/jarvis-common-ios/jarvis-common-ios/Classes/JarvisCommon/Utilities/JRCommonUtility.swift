//
//  JRCommonUtility.swift
//  jarvis-common-ios
//
//  Created by Abhinav Kumar Roy on 28/05/19.
//

import UIKit
import jarvis_utility_ios

public class JRCommonUtility: NSObject {
    
    class public func getLocationString() -> String {
        
        func addAddressField(toLocation location: String, field: String?) -> String {
            var loc: String = location
            if let field = field, field.length > 0 {
                if loc.length > 0 {
                    loc = String(format: "%@,%@", loc, field)
                } else {
                    loc = field
                }
            }
            return loc
        }
        
        if let cachedAddress = JRLocationManager.shared.lastFetchedAddress {
            var location: String = ""
            location = addAddressField(toLocation: location, field: cachedAddress.address2)
            location = addAddressField(toLocation: location, field: cachedAddress.city)
            location = addAddressField(toLocation: location, field: cachedAddress.state)
            location = addAddressField(toLocation: location, field: cachedAddress.pin)
            
            if location.length > 0 {
                return location //address
            }
        }
        return "India"
    }
    
}


extension JRUtility {
    
    @available(*, deprecated, renamed: "savedDeviceId")
    @objc public static var uuid : String?{
        get{
            return JRUtility.savedDeviceId()
        }
    }
    
    // JRUtility.savedDeviceId()
    @objc public class func savedDeviceId() -> String {
        // Direct from keychain
        if let uniqueId = FXKeychain.default().object(forKey: JRUUID) as? String {
            return uniqueId
        }
        
        // check local cache
        if let uniqueId = JRUtility.deviceIDFromLocalCache {
            logUUIDOnHawkeye(isNewGenerated: false, deviceId: uniqueId)
            return uniqueId
        }
        
        // generate New
        if let uniqueId = JRUtility.newGenerateDeviceId() {
            
            logUUIDOnHawkeye(isNewGenerated: true, deviceId: uniqueId)
            return uniqueId
        }
        
        // not found at all
        return "Unknown_Device"
    }
    
    class private func newGenerateDeviceId() -> String? {
        if let uniqueId = UIDevice.current.identifierForVendor?.uuidString {
            FXKeychain.default().setObject(uniqueId, forKey: JRUUID)
            UserDefaults.standard.set(uniqueId, forKey: "kLocallySavedDeviceId")
            return uniqueId
        }
        return nil
    }
    
    class private var deviceIDFromLocalCache: String? {
        let version = UserDefaults.standard.value(forKey: "kLocallySavedDeviceId")
        return version as? String
    }
    
    
    class private func logUUIDOnHawkeye(isNewGenerated: Bool, deviceId: String) {
    
        var msg = ""
        if isNewGenerated {
            msg = "New DeviceId is created"
        } else {
            msg = "Kechain fails to read DeviceId, retrived from local cache"
        }
        
        let errorModel = JRHawkEyeErrorModel(errMsg: msg, customMessage: deviceId, userFacing: .none, verName: .common, hawkeye: true)
        JRLocalErrorHandler.sendSilentError(on: nil, withModel: errorModel, completionHandler: nil)
    }
}
