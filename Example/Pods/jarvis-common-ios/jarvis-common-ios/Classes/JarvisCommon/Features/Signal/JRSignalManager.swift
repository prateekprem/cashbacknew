//
//  SignalManager.swift
//  Jarvis
//
//  Created by Kushalpal Singh on 12/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation
import PaytmAnalytics
import jarvis_auth_ios
import jarvis_utility_ios
import jarvis_network_ios

@objc public class JRSignalManager: NSObject {
    
    @objc public static let shared = JRSignalManager()
    public let dispatchStrategy: DispatchStrategy = .intervalBased(interval: 10.0)
    public let dispatchInterval: TimeInterval = 10.0
    public let maxBatchSizeToUpload: Int = 30
    public let maxBatchSizeToCapture: Int = 1000
    public let analyticsUniqueIdentifier: String = ""
    
    public func getSignalEndpointDomain(for buildType: PABuildType) -> String {
        return buildType == .debug ? "https://sig-staging.paytm.com" : "https://sig.paytm.com"
    }
    
    public func getSecretKey(for buildType: PABuildType) -> String {
        return buildType == .debug ? "0d4b8b226ff011e8adc0fa7ae01bbebc" : "c52fed22762c11e8adc0fa7ae01bbebc"
    }
    
    @objc public var dimensionsDict: [AnyHashable: Any]? {
        get {
            if let dimensionsDictionary = dimensionsDictionary, dimensionsDictionary.count != 0 {
                return dimensionsDictionary
            }
            
            guard let path = Bundle(for: JRAnalytics.self).path(forResource: "Dimensions", ofType: "plist"), let dict = NSDictionary(contentsOfFile: path) as? [AnyHashable : Any] else {
                return nil
            }
            
            dimensionsDictionary = dict
            return dimensionsDictionary
        }
    }
    
    private var dimensionsDictionary: [AnyHashable: Any]? = nil
    
    @objc public func push(object: [AnyHashable : Any]?) {
        guard let object = object, let eventType = object["event"] as? String else {
            return
        }
        
        let payload = replaceDimensionKey(for: object) as! [String: Any]
        let signalModel = PASignalLog(eventType: eventType, payload: payload)!
        signalModel.deviceId = JRUtility.savedDeviceId()
        if let appLanguage = LanguageManager.shared.getCurrentLocale()?.countryLangCode, !appLanguage.isEmpty {
            signalModel.appLanguage = appLanguage
        }
        if let client = JRAPIManager.sharedManager().client {
            signalModel.clientId = client
        } else {
            signalModel.clientId = ""
        }
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            signalModel.appVersion = version
        } else {
            signalModel.appVersion = ""
        }
        
        // Network info
        if let deviceIP = JRUtility.getIPAddressForCellOrWireless() {
            signalModel.deviceIp = deviceIP
        }
        if let deviceConnectionType = Reachability()?.userSelectedNetworkType() {
            signalModel.deviceConnType = deviceConnectionType
        }
        if let carrierName = JRHawkEyeUtils.cellularCarrierName {
            signalModel.deviceCarrier = carrierName
        }
        
        // Location info: longitude and latitude
        let currentLocationCords = JRLocationManager.shared.getCurrentLocationCords()
        if currentLocationCords.0 != 0.0 && currentLocationCords.1 != 0.0 {
            // latitude: 0
            signalModel.deviceGeoLatitude = String(format: "%.1f", currentLocationCords.0)
            // longitude: 1
            signalModel.deviceGeoLongitude = String(format: "%.1f", currentLocationCords.1)
        }
        
        PASignalManager.shared.push(withPASignalLog: signalModel)
    }
    
    /// Replaces keys found in the Dimensions.plist with its corresponding textual representation for the given dictionary
    ///
    /// - Parameter dictionary: The dictionary of which we want to replace the keys found in Dimensions.plist
    /// - Returns: A new dictionary with keys found in the Dimensions.plist replaced with its corresponding textual representation
    func replaceDimensionKey(for dictionary: [AnyHashable: Any]) -> [AnyHashable: Any] {
        var signalData = [AnyHashable: Any]()
        
        for (key, value) in dictionary {
            guard let k = key as? String, let _ = k.range(of: "dimension"),
                let dDict = dimensionsDict, let newKey = dDict[k] as? String else {
                    if let valueDict = value as? [AnyHashable: Any] {
                        // Recursively replace the `dimensionx` key with its corresponding textual representation
                        signalData[key] = replaceDimensionKey(for: valueDict)
                    } else if let valueArray = value as? [Any] {
                        signalData[key] = replaceDimensionKey(for: valueArray)
                    } else {
                        signalData[key] = value
                    }
                    continue
            }
            // Replace the `dimensionx` key with its corresponding textual representation
            signalData[newKey] = value
        }
        
        return signalData
    }
    
    // MARK: - Private methods
    /// Returns a new array in which any dictionary object has its keys found in the Dimensions.plist replaced with
    /// its corresponding textual representation
    ///
    /// - Parameter array: The array of which we want to do the replacement
    /// - Returns: A new array in which any dictionary object has its keys found in the Dimensions.plist replaced with
    ///   its corresponding textual representation
    private func replaceDimensionKey(for array: [Any]) -> [Any] {
        var newArray: [Any] = [Any]()
        
        for value in array {
            if let valueArray = value as? [Any] {
                newArray.append(replaceDimensionKey(for: valueArray))
            } else if let valueDict = value as? [String: Any] {
                newArray.append(replaceDimensionKey(for: valueDict))
            } else {
                newArray.append(value)
            }
        }
        
        return newArray
    }
    
}
