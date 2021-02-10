//
//  Event.swift
//
//  Created by Abhinav Kumar Roy on 05/07/18
//  Copyright (c) Abhinav Roy. All rights reserved.
//

import Foundation

public protocol PANCQRDataProtocol {
    var eventName: String? { get set }
    func dictionaryRepresentation() -> [String: Any]
}

extension PANCQRDataProtocol {
    func dictionaryRepresentation() -> [String: Any] {
        return [:]
    }
}

public final class PANCEvent: NSObject, NSCoding {

    public override init() {
        super.init()
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let timestamp = "timestamp"
        static let location = "location"
        static let type = "eventType"
        static let networktype = "networkType"
        static let networkCarrier = "networkCarrier"
        static let networkSpeed = "networkSpeed"
        static let playstore = "playstore"
        static let batteryPercentage = "batteryPercentage"
        static let storageFreePercentage = "storageFreePercentage"
        static let networkStrength = "networkStrength"
        static let verticalName = "verticalName"
        static let screenName = "screenName"
        static let flowName = "flowName"
        static let uri = "uri"
        static let requestSize = "requestSize"
        static let responseCode = "responseCode"
        static let responseTime = "responseTime"
        static let responseSize = "responseSize"
        static let responseType = "responseType"
        static let userFacing = "userFacing"
        static let errorCode = "errorCode"
        static let errorMsg = "errorMsg"
        static let mid = "mid"
        static let transactionId = "transactionId"
        static let metricTotalTime = "metricTotalTime"
        static let metricRequestTime = "metricRequestTime"
        static let metricResponseTime = "metricResponseTime"
        static let metricConnectionTime = "metricConnectionTime"
        static let metricDomainlookupTime = "metricDomainLookupTime"
        static let metricSecureConnectionTime = "metricSecureConnectionTime"
        static let appVersion = "appVersion"
        static let appVersionCode = "appVersionCode"
        static let correlationID = "x-app-rid"
        static let customMessage = "customMessage"
        static let qrData = "qrData"
        static let clientIP = "clientIP"
        static let ramFreeSize = "ramFreeSize"
        static let ramFreePercentage = "ramFreePercentage"
        static let storageFreeSize = "storageFreeSize"
        static let PID = "PID"
        static let categoryId = "categoryId"
    }
    
    // MARK: Properties
    public var location: PANCLocation?
    public var type: String?
    public var networktype: String?
    public var networkCarrier: String?
    public var networkSpeed: String?
    public var playstore: String?
    public var batteryPercentage : Int?
    public var storageFreePercentage : Int?
    public var networkStrength : String?
    public var verticalName: String?
    public var screenName: String?
    public var flowName: String?
    public var timestamp: String?
    public var uri: String?
    public var requestSize: Int?
    public var responseCode: Int?
    public var responseTime: Int?
    public var responseSize: Int?
    public var responseType: String?
    public var userFacing: String?
    public var errorCode: Int?
    public var errorMsg: String?
    public var mid: String?
    public var transactionId: String?
    public var metricTotalTime: Double?
    public var metricRequestTime: Double?
    public var metricResponseTime: Double?
    public var metricConnectionTime: Double?
    public var metricDomainlookupTime: Double?
    public var metricSecureConnectionTime: Double?
    public var appVersion: String?
    public var appVersionCode: String?
    public var correlationID: String?
    public var customMessage: String?
    public var qrData: PANCQRDataProtocol?
    public var clientIP : String?
    public var ramFreeSize : Int?
    public var ramFreePercentage : Int?
    public var storageFreeSize : Int?
    public var PID: String?
    public var categoryId: String?
    
    public init?(coder aDecoder: NSCoder) {
        self.timestamp = aDecoder.decodeObject(forKey: SerializationKeys.timestamp) as? String
        self.type = aDecoder.decodeObject(forKey: SerializationKeys.type) as? String
        self.networktype = aDecoder.decodeObject(forKey: SerializationKeys.networktype) as? String
        self.networkCarrier = aDecoder.decodeObject(forKey: SerializationKeys.networkCarrier) as? String
        self.networkSpeed = aDecoder.decodeObject(forKey: SerializationKeys.networkSpeed) as? String
        self.playstore = aDecoder.decodeObject(forKey: SerializationKeys.playstore) as? String
        self.batteryPercentage = aDecoder.decodeObject(forKey: SerializationKeys.batteryPercentage) as? Int
        self.storageFreePercentage = aDecoder.decodeObject(forKey: SerializationKeys.storageFreePercentage) as? Int
        self.networkStrength = aDecoder.decodeObject(forKey: SerializationKeys.networkStrength) as? String
        self.verticalName = aDecoder.decodeObject(forKey:  SerializationKeys.verticalName) as? String
        self.screenName = aDecoder.decodeObject(forKey: SerializationKeys.screenName) as? String
        self.flowName = aDecoder.decodeObject(forKey:  SerializationKeys.flowName) as? String
        self.location = aDecoder.decodeObject(forKey: SerializationKeys.location) as? PANCLocation
        self.uri = aDecoder.decodeObject(forKey: SerializationKeys.uri) as? String
        self.requestSize = aDecoder.decodeObject(forKey: SerializationKeys.requestSize) as? Int
        self.responseCode = aDecoder.decodeObject(forKey: SerializationKeys.responseCode) as? Int
        self.responseTime = aDecoder.decodeObject(forKey: SerializationKeys.responseTime) as? Int
        self.responseSize = aDecoder.decodeObject(forKey: SerializationKeys.responseSize) as? Int
        self.responseType = aDecoder.decodeObject(forKey: SerializationKeys.responseType) as? String
        self.userFacing = aDecoder.decodeObject(forKey: SerializationKeys.userFacing) as? String
        self.errorCode = aDecoder.decodeObject(forKey: SerializationKeys.errorCode) as? Int
        self.errorMsg = aDecoder.decodeObject(forKey: SerializationKeys.errorMsg) as? String
        self.mid = aDecoder.decodeObject(forKey: SerializationKeys.mid) as? String
        self.transactionId = aDecoder.decodeObject(forKey: SerializationKeys.transactionId) as? String
        self.metricTotalTime = aDecoder.decodeObject(forKey: SerializationKeys.metricTotalTime) as? Double
        self.metricRequestTime = aDecoder.decodeObject(forKey: SerializationKeys.metricRequestTime) as? Double
        self.metricResponseTime = aDecoder.decodeObject(forKey: SerializationKeys.metricResponseTime) as? Double
        self.metricConnectionTime = aDecoder.decodeObject(forKey: SerializationKeys.metricConnectionTime) as? Double
        self.metricDomainlookupTime = aDecoder.decodeObject(forKey: SerializationKeys.metricDomainlookupTime) as? Double
        self.metricSecureConnectionTime = aDecoder.decodeObject(forKey: SerializationKeys.metricSecureConnectionTime) as? Double
        self.appVersion = aDecoder.decodeObject(forKey: SerializationKeys.appVersion) as? String
        self.appVersionCode = aDecoder.decodeObject(forKey: SerializationKeys.appVersionCode) as? String
        self.correlationID = aDecoder.decodeObject(forKey: SerializationKeys.correlationID) as? String
        self.customMessage = aDecoder.decodeObject(forKey: SerializationKeys.customMessage) as? String
        if let qrData = aDecoder.decodeObject(forKey: SerializationKeys.qrData) as? PANCQRData {
            self.qrData = qrData
        }else{
            self.qrData = aDecoder.decodeObject(forKey: SerializationKeys.qrData) as? PANCMTQRData
        }
        self.clientIP = aDecoder.decodeObject(forKey: SerializationKeys.clientIP) as? String
        self.ramFreeSize = aDecoder.decodeObject(forKey: SerializationKeys.ramFreeSize) as? Int
        self.ramFreePercentage = aDecoder.decodeObject(forKey: SerializationKeys.ramFreePercentage) as? Int
        self.storageFreeSize = aDecoder.decodeObject(forKey: SerializationKeys.storageFreeSize) as? Int
        self.PID = aDecoder.decodeObject(forKey: SerializationKeys.PID) as? String
        self.categoryId = aDecoder.decodeObject(forKey: SerializationKeys.categoryId) as? String
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = timestamp { dictionary[SerializationKeys.timestamp] = value }
        if let value = type { dictionary[SerializationKeys.type] = value }
        if let value = networktype { dictionary[SerializationKeys.networktype] = value }
        if let value = networkCarrier { dictionary[SerializationKeys.networkCarrier] = value }
        if let value = networkSpeed { dictionary[SerializationKeys.networkSpeed] = value }
        if let value = playstore { dictionary[SerializationKeys.playstore] = value }
        if let value = batteryPercentage { dictionary[SerializationKeys.batteryPercentage] = value}
        if let value = storageFreePercentage { dictionary[SerializationKeys.storageFreePercentage] = value}
        if let value = networkStrength { dictionary[SerializationKeys.networkStrength] = value}
        if let value = verticalName { dictionary[SerializationKeys.verticalName] = value }
        if let value = screenName { dictionary[SerializationKeys.screenName] = value }
        if let value = flowName { dictionary[SerializationKeys.flowName] = value }
        if let value = location { dictionary[SerializationKeys.location] = value.dictionaryRepresentation() }
        if let value = uri { dictionary[SerializationKeys.uri] = value}
        if let value = requestSize { dictionary[SerializationKeys.requestSize] = value }
        if let value = responseCode { dictionary[SerializationKeys.responseCode] = value }
        if let value = responseTime { dictionary[SerializationKeys.responseTime] = value }
        if let value = responseSize { dictionary[SerializationKeys.responseSize] = value }
        if let value = responseType { dictionary[SerializationKeys.responseType] = value }
        if let value = userFacing { dictionary[SerializationKeys.userFacing] = value }
        if let value = errorCode { dictionary[SerializationKeys.errorCode] = value }
        if let value = errorMsg { dictionary[SerializationKeys.errorMsg] = value }
        if let value = mid { dictionary[SerializationKeys.mid] = value }
        if let value = transactionId { dictionary[SerializationKeys.transactionId] = value }
        if let value = metricTotalTime { dictionary[SerializationKeys.metricTotalTime] = value }
        if let value = metricRequestTime { dictionary[SerializationKeys.metricRequestTime] = value }
        if let value = metricResponseTime { dictionary[SerializationKeys.metricResponseTime] = value }
        if let value = metricConnectionTime { dictionary[SerializationKeys.metricConnectionTime] = value }
        if let value = metricDomainlookupTime { dictionary[SerializationKeys.metricDomainlookupTime] = value }
        if let value = metricSecureConnectionTime { dictionary[SerializationKeys.metricSecureConnectionTime] = value }
        if let value = appVersion { dictionary[SerializationKeys.appVersion] = value }
        if let value = appVersionCode { dictionary[SerializationKeys.appVersionCode] = value }
        if let value = correlationID { dictionary[SerializationKeys.correlationID] = value }
        if let value = customMessage { dictionary[SerializationKeys.customMessage] = value }
        if let value = qrData { dictionary[SerializationKeys.qrData] = value.dictionaryRepresentation() }
        if let value = clientIP { dictionary[SerializationKeys.clientIP] = value }
        if let value = ramFreeSize { dictionary[SerializationKeys.ramFreeSize] = value }
        if let value = ramFreePercentage { dictionary[SerializationKeys.ramFreePercentage] = value }
        if let value = storageFreeSize { dictionary[SerializationKeys.storageFreeSize] = value }
        if let value = PID { dictionary[SerializationKeys.PID] = value }
        if let value = categoryId { dictionary[SerializationKeys.categoryId] = value }
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(timestamp, forKey: SerializationKeys.timestamp)
        aCoder.encode(type, forKey: SerializationKeys.type)
        aCoder.encode(networktype, forKey: SerializationKeys.networktype)
        aCoder.encode(networkCarrier, forKey: SerializationKeys.networkCarrier)
        aCoder.encode(networkSpeed, forKey: SerializationKeys.networkSpeed)
        aCoder.encode(playstore, forKey: SerializationKeys.playstore)
        aCoder.encode(batteryPercentage, forKey: SerializationKeys.batteryPercentage)
        aCoder.encode(storageFreePercentage, forKey: SerializationKeys.storageFreePercentage)
        aCoder.encode(networkStrength, forKey: SerializationKeys.networkStrength)
        aCoder.encode(verticalName, forKey: SerializationKeys.verticalName)
        aCoder.encode(screenName, forKey: SerializationKeys.screenName)
        aCoder.encode(flowName, forKey: SerializationKeys.flowName)
        aCoder.encode(location, forKey: SerializationKeys.location)
        aCoder.encode(uri, forKey: SerializationKeys.uri)
        aCoder.encode(requestSize, forKey: SerializationKeys.requestSize)
        aCoder.encode(responseCode, forKey: SerializationKeys.responseCode)
        aCoder.encode(responseTime, forKey: SerializationKeys.responseTime)
        aCoder.encode(responseSize, forKey: SerializationKeys.responseSize)
        aCoder.encode(responseType, forKey: SerializationKeys.responseType)
        aCoder.encode(userFacing, forKey: SerializationKeys.userFacing)
        aCoder.encode(errorCode, forKey: SerializationKeys.errorCode)
        aCoder.encode(errorMsg, forKey: SerializationKeys.errorMsg)
        aCoder.encode(mid, forKey: SerializationKeys.mid)
        aCoder.encode(transactionId, forKey: SerializationKeys.transactionId)
        aCoder.encode(metricTotalTime, forKey: SerializationKeys.metricTotalTime)
        aCoder.encode(metricRequestTime, forKey: SerializationKeys.metricRequestTime)
        aCoder.encode(metricResponseTime, forKey: SerializationKeys.metricResponseTime)
        aCoder.encode(metricConnectionTime, forKey: SerializationKeys.metricConnectionTime)
        aCoder.encode(metricDomainlookupTime, forKey: SerializationKeys.metricDomainlookupTime)
        aCoder.encode(metricSecureConnectionTime, forKey: SerializationKeys.metricSecureConnectionTime)
        aCoder.encode(appVersion, forKey: SerializationKeys.appVersion)
        aCoder.encode(appVersionCode, forKey: SerializationKeys.appVersionCode)
        aCoder.encode(correlationID, forKey: SerializationKeys.correlationID)
        aCoder.encode(customMessage, forKey: SerializationKeys.customMessage)
        aCoder.encode(qrData, forKey: SerializationKeys.qrData)
        aCoder.encode(clientIP, forKey: SerializationKeys.clientIP)
        aCoder.encode(ramFreeSize, forKey: SerializationKeys.ramFreeSize)
        aCoder.encode(ramFreePercentage, forKey: SerializationKeys.ramFreePercentage)
        aCoder.encode(storageFreeSize, forKey: SerializationKeys.storageFreeSize)
        aCoder.encode(PID, forKey: SerializationKeys.PID)
        aCoder.encode(categoryId, forKey: SerializationKeys.categoryId)
    }
}

public final class PANCLocation: NSObject, NSCoding {
    
    public override init() {
        super.init()
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let lat = "lat"
        static let lon = "lon"
    }
    
    public var lat: Double?
    public var lon: Double?
    
    public init?(coder aDecoder: NSCoder) {
        self.lat = aDecoder.decodeObject(forKey: SerializationKeys.lat) as? Double
        self.lon = aDecoder.decodeObject(forKey: SerializationKeys.lon) as? Double
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(lat, forKey: SerializationKeys.lat)
        aCoder.encode(lon, forKey: SerializationKeys.lon)
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = lat { dictionary[SerializationKeys.lat] = value }
        if let value = lon { dictionary[SerializationKeys.lon] = value }
        return dictionary
    }

}
