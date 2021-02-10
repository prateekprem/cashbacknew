//
//  PASignalLog.swift
//
//  Created by Abhinav Kumar Roy on 05/07/18
//  Copyright (c) Abhinav Roy. All rights reserved.
//

import Foundation
import AdSupport

public final class PASignalLog: NSObject, NSCoding {
    
    //release notes: https://wiki.mypaytm.com/display/MAP/iOS+Signal+SDK+Release+Notes
    //Important Notes: always update version number to latest one
    private static let currentSDKVersion = "10.2.0"
    
    //device related info must be in every event, so make them as default
    var deviceAdsId: String = ASIdentifierManager.shared().advertisingIdentifier.uuidString
    var deviceOs: String  = UIDevice.current.systemName             //value format: iOS
    var deviceOsVersion: String  = UIDevice.current.systemVersion   //value format: 12.1
    var deviceModel: String  = UIDevice.current.modelName           //value format: iPhone 8
    var deviceBrand: String  = "Apple"
    
    //Internal properties
    var uploadTime: String?
    var appLaunchTime: String?
    
    //public properties
    public var deviceId: String?
    
    //still use this field to avoid app-side code change, but send to backend with `dateTime`
    public var dataTime: String? {
        didSet {
            deviceDateTime = dataTime
        }
    }
    public var eventType: String?
    public var customerId: String?
    public var clientId: String?
    public var appVersion: String?
    public var appLanguage: String?
    
    public var deviceIp: String?
    public var deviceCarrier: String?
    public var deviceConnType: String?
    public var deviceGeoLatitude: String?
    public var deviceGeoLongitude: String?
    
    public var payload: [String : Any]?
    
    //private properties
    private var deviceDateTime: String? //this field is for backend, and its value = dataTime
    private var sdkVersion = currentSDKVersion
    
    @available(*, deprecated, message: "The default initializer is deprecated and will be removed in the next release, please use init?(eventType:timestamp:payload:deviceID:customerID:) instead")
    public override init() {
        super.init()
    }
    
    /// Initializes a new instance of signal event with given parameters
    ///
    /// `eventType` and `payload` are mandatory fields, of which `payload` also can't be empty.
    ///
    /// - Returns: An initialized object, or nil if any of the passed in parameters fails the validation check.
    public required init?(eventType: String,
                          timestamp: Date = Date(),
                          payload: [String: Any],
                          deviceID: String? = nil,
                          customerID: String? = nil) {
        guard payload.count != 0 else { return nil }
        
        self.eventType = eventType
        self.deviceDateTime = String(UInt64((timestamp.timeIntervalSince1970 * 1000).rounded(.down)))
        
        self.payload = payload
        self.deviceId = deviceID
        self.customerId = customerID
    }
    
    func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        
        //value has to be existed
        dictionary[SerializationKeys.deviceAdsId] = deviceAdsId
        dictionary[SerializationKeys.deviceOs] = deviceOs
        dictionary[SerializationKeys.deviceOsVersion] = deviceOsVersion
        dictionary[SerializationKeys.deviceModel] = deviceModel
        dictionary[SerializationKeys.deviceBrand] = deviceBrand
        dictionary[SerializationKeys.sdkVersion] = sdkVersion
        
        if let value = deviceId { dictionary[SerializationKeys.deviceId] = value }
        if let value = deviceDateTime { dictionary[SerializationKeys.deviceDateTime] = value }
        if let value = payload { dictionary[SerializationKeys.payload] = value }
        if let value = eventType { dictionary[SerializationKeys.eventType] = value }
        if let value = customerId { dictionary[SerializationKeys.customerId] = value }
        if let value = clientId { dictionary[SerializationKeys.clientId] = value }
        if let value = appVersion { dictionary[SerializationKeys.appVersion] = value }
        if let value = appLanguage { dictionary[SerializationKeys.appLanguage] = value }
        if let value = deviceIp { dictionary[SerializationKeys.deviceIp] = value }
        if let value = deviceCarrier { dictionary[SerializationKeys.deviceCarrier] = value }
        if let value = deviceConnType { dictionary[SerializationKeys.deviceConnType] = value }
        if let value = deviceGeoLatitude { dictionary[SerializationKeys.deviceGeoLat] = value }
        if let value = deviceGeoLongitude { dictionary[SerializationKeys.deviceGeoLong] = value }
        if let value = uploadTime { dictionary[SerializationKeys.uploadTime] = value }
        if let value = appLaunchTime { dictionary[SerializationKeys.lastAppOpenDate] = value }
        
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {   //archive
        aCoder.encode(deviceId, forKey: SerializationKeys.deviceId)
        aCoder.encode(deviceDateTime, forKey: SerializationKeys.deviceDateTime)
        aCoder.encode(payload, forKey: SerializationKeys.payload)
        aCoder.encode(eventType, forKey: SerializationKeys.eventType)
        aCoder.encode(customerId, forKey: SerializationKeys.customerId)
        aCoder.encode(clientId, forKey: SerializationKeys.clientId)
        aCoder.encode(appVersion, forKey: SerializationKeys.appVersion)
        aCoder.encode(appLanguage, forKey: SerializationKeys.appLanguage)
        
        aCoder.encode(deviceAdsId, forKey: SerializationKeys.deviceAdsId)
        aCoder.encode(deviceOs, forKey: SerializationKeys.deviceOs)
        aCoder.encode(deviceOsVersion, forKey: SerializationKeys.deviceOsVersion)
        aCoder.encode(deviceModel, forKey: SerializationKeys.deviceModel)
        aCoder.encode(deviceBrand, forKey: SerializationKeys.deviceBrand)
        aCoder.encode(deviceIp, forKey: SerializationKeys.deviceIp)
        aCoder.encode(deviceCarrier, forKey: SerializationKeys.deviceCarrier)
        aCoder.encode(deviceConnType, forKey: SerializationKeys.deviceConnType)
        aCoder.encode(deviceGeoLatitude, forKey: SerializationKeys.deviceGeoLat)
        aCoder.encode(deviceGeoLongitude, forKey: SerializationKeys.deviceGeoLong)
        aCoder.encode(uploadTime, forKey: SerializationKeys.uploadTime)
        aCoder.encode(appLaunchTime, forKey: SerializationKeys.lastAppOpenDate)
        aCoder.encode(sdkVersion, forKey: SerializationKeys.sdkVersion)
        
    }
    
    //provide a default value to indicate `required`
    public init?(coder aDecoder: NSCoder) {  //unarchive
        self.deviceId = aDecoder.decodeObject(forKey: SerializationKeys.deviceId) as? String
        self.payload = aDecoder.decodeObject(forKey: SerializationKeys.payload) as? [String: Any]
        self.eventType = aDecoder.decodeObject(forKey : SerializationKeys.eventType) as? String
        self.customerId = aDecoder.decodeObject(forKey: SerializationKeys.customerId) as? String
        self.clientId = aDecoder.decodeObject(forKey: SerializationKeys.clientId) as? String
        self.appVersion = aDecoder.decodeObject(forKey: SerializationKeys.appVersion) as? String
        self.deviceIp = aDecoder.decodeObject(forKey: SerializationKeys.deviceIp) as? String ?? PAConstant.EMPTY_STRING
        self.deviceCarrier = aDecoder.decodeObject(forKey: SerializationKeys.deviceCarrier) as? String ?? PAConstant.EMPTY_STRING
        self.deviceConnType = aDecoder.decodeObject(forKey: SerializationKeys.deviceConnType) as? String ?? PAConstant.EMPTY_STRING
        self.deviceGeoLatitude = aDecoder.decodeObject(forKey: SerializationKeys.deviceGeoLat) as? String ?? PAConstant.EMPTY_STRING
        self.deviceGeoLongitude = aDecoder.decodeObject(forKey: SerializationKeys.deviceGeoLong) as? String ?? PAConstant.EMPTY_STRING
        self.uploadTime = aDecoder.decodeObject(forKey: SerializationKeys.uploadTime) as? String ?? PAConstant.EMPTY_STRING
        self.appLaunchTime = aDecoder.decodeObject(forKey: SerializationKeys.lastAppOpenDate) as? String ?? PAConstant.EMPTY_STRING
        self.sdkVersion = aDecoder.decodeObject(forKey: SerializationKeys.sdkVersion) as? String ?? PASignalLog.currentSDKVersion
        
        self.deviceDateTime = aDecoder.decodeObject(forKey: SerializationKeys.deviceDateTime) as? String
        self.appLanguage = aDecoder.decodeObject(forKey: SerializationKeys.appLanguage) as? String ?? aDecoder.decodeObject(forKey: "app_Language") as? String
        self.deviceAdsId = aDecoder.decodeObject(forKey: SerializationKeys.deviceAdsId) as? String ?? ASIdentifierManager.shared().advertisingIdentifier.uuidString
        self.deviceOs = aDecoder.decodeObject(forKey: SerializationKeys.deviceOs) as? String ?? UIDevice.current.systemName
        self.deviceOsVersion = aDecoder.decodeObject(forKey: SerializationKeys.deviceOsVersion) as? String ?? UIDevice.current.systemVersion
        self.deviceModel = aDecoder.decodeObject(forKey: SerializationKeys.deviceModel) as? String ?? UIDevice.current.localizedModel
        self.deviceBrand = aDecoder.decodeObject(forKey: SerializationKeys.deviceBrand) as? String ?? "Apple"
    }
    
    func isValidSignaEvent() -> Bool {
        return (self.eventType != nil && self.deviceDateTime != nil && self.payload != nil)
    }
    
    public override var description: String {
        return """
                [
                    \"customer id\" = \(customerId ?? "nil"),
                    \"event type\"  = \(eventType ?? "Invalid event"),
                    \"device time\" = \(deviceDateTime ?? "No device time"),
                    \"payload\"     = \(payload ?? [:])
                ]
               """
    }
    
    
    //MARK: Declaration for string constants to be used to decode and also serialize.
    //Notes: Make the keys the same as what defined in app
    private struct SerializationKeys {
        
        static let deviceId         = "deviceId"
        
        //send `dateTime` rather than "deviceDateTime" , link: https://docs.google.com/document/d/1cjt9xDsIWwYNf8LfBiN0aEbih_BfzsMFzBQaAJCkqcI/edit?ts=5f17a962#heading=h.m8la9040493z
        static let deviceDateTime   = "dateTime"
        
        static let payload          = "payload"
        static let eventType        = "eventType"
        static let customerId       = "customerId"
        static let clientId         = "clientId"
        static let appVersion       = "appVersion"
        static let sdkVersion       = "sdkVersion"      //added since sdkVersion = 9.1.0
        static let appLanguage      = "appLanguage"
        
        static let deviceAdsId      = "advertisementId"
        static let deviceOs         = "osType"
        static let deviceOsVersion  = "osVersion"
        static let deviceModel      = "model"
        static let deviceBrand      = "brand"
        static let deviceIp         = "ip"
        static let deviceCarrier    = "carrier"
        static let deviceConnType   = "connectionType"
        static let deviceGeoLat     = "latitude"
        static let deviceGeoLong    = "longitude"
        static let uploadTime       = "uploadTime"
        static let lastAppOpenDate  = "lastAppOpenDate"
    }
    
}
