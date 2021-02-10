//
//  PANCQRLog.swift
//  PaytmAnalytics
//
//  Created by nasib ali on 21/08/19.
//

import Foundation

public final class PANCQRData: NSObject, NSCoding, PANCQRDataProtocol {
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let eventName = "eventName"
        static let isMultiQREnabled = "isMultiQREnabled"
        static let scanDuration = "scanDuration"
        static let firstQrDetectedTime = "firstQrDetectedTime"
        static let scannedCount = "scannedCount"
        static let isSuccess = "isSuccess"
        static let qrPayload = "qrPayload"
        static let scanSessionId = "scanSessionId"
        static let failReason = "failReason"
        static let isWinner = "isWinner"
        static let qrVersion = "qrVersion"
        static let correctionLevel = "correctionLevel"
    }
    
    // MARK: Properties
    public var eventName: String?
    public var isMultiQREnabled: Bool?
    public var scanDuration: Int?
    public var firstQrDetectedTime: Int?
    public var scannedCount: Int?
    public var isSuccess: Bool?
    public var qrPayload: String?
    public var scanSessionId: String?
    public var failReason: String?
    public var isWinner: Bool?
    public var qrVersion: Int?
    public var correctionLevel: String?
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = eventName { dictionary[SerializationKeys.eventName] = value }
        if let value = isMultiQREnabled { dictionary[SerializationKeys.isMultiQREnabled] = value }
        if let value = scanDuration { dictionary[SerializationKeys.scanDuration] = value }
        if let value = firstQrDetectedTime { dictionary[SerializationKeys.firstQrDetectedTime] = value }
        if let value = scannedCount { dictionary[SerializationKeys.scannedCount] = value }
        if let value = isSuccess { dictionary[SerializationKeys.isSuccess] = value }
        if let value = qrPayload { dictionary[SerializationKeys.qrPayload] = value }
        if let value = scanSessionId { dictionary[SerializationKeys.scanSessionId] = value }
        if let value = failReason { dictionary[SerializationKeys.failReason] = value }
        if let value = isWinner { dictionary[SerializationKeys.isWinner] = value }
        if let value = qrVersion { dictionary[SerializationKeys.qrVersion] = value }
        if let value = correctionLevel { dictionary[SerializationKeys.correctionLevel] = value }
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(eventName, forKey: SerializationKeys.eventName)
        aCoder.encode(isMultiQREnabled, forKey: SerializationKeys.isMultiQREnabled)
        aCoder.encode(scanDuration, forKey: SerializationKeys.scanDuration)
        aCoder.encode(firstQrDetectedTime, forKey: SerializationKeys.firstQrDetectedTime)
        aCoder.encode(scannedCount, forKey: SerializationKeys.scannedCount)
        aCoder.encode(isSuccess, forKey: SerializationKeys.isSuccess)
        aCoder.encode(qrPayload, forKey: SerializationKeys.qrPayload)
        aCoder.encode(scanSessionId, forKey: SerializationKeys.scanSessionId)
        aCoder.encode(failReason, forKey: SerializationKeys.failReason)
        aCoder.encode(isWinner, forKey: SerializationKeys.isWinner)
        aCoder.encode(qrVersion, forKey: SerializationKeys.qrVersion)
        aCoder.encode(correctionLevel, forKey: SerializationKeys.correctionLevel)
    }
    
    public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.eventName = aDecoder.decodeObject(forKey: SerializationKeys.eventName) as? String
        self.isMultiQREnabled = aDecoder.decodeObject(forKey: SerializationKeys.isMultiQREnabled) as? Bool
        self.scanDuration = aDecoder.decodeObject(forKey: SerializationKeys.scanDuration) as? Int
        self.firstQrDetectedTime = aDecoder.decodeObject(forKey: SerializationKeys.firstQrDetectedTime) as? Int
        self.scannedCount = aDecoder.decodeObject(forKey: SerializationKeys.scannedCount) as? Int
        self.isSuccess = aDecoder.decodeObject(forKey: SerializationKeys.isSuccess) as? Bool
        self.qrPayload = aDecoder.decodeObject(forKey: SerializationKeys.qrPayload) as? String
        self.scanSessionId = aDecoder.decodeObject(forKey: SerializationKeys.scanSessionId) as? String
        self.failReason = aDecoder.decodeObject(forKey: SerializationKeys.failReason) as? String
        self.isWinner = aDecoder.decodeObject(forKey: SerializationKeys.isWinner) as? Bool
        self.qrVersion = aDecoder.decodeObject(forKey: SerializationKeys.qrVersion) as? Int
        self.correctionLevel = aDecoder.decodeObject(forKey: SerializationKeys.correctionLevel) as? String
    }
}
