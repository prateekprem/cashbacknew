//
//  PANCMTQRData.swift
//  FirebaseABTesting
//
//  Created by Nasib Ali on 16/11/20.
//

import Foundation

public final class PANCMTQRData: NSObject, NSCoding, PANCQRDataProtocol {
    
    public var eventName: String?
    public var flow: String?
    public var status: String?
    public var scanSessionStartTime: String?
    public var scanSessionEndTime: String?
    public var scan: Int64?
    public var backend: Int64?
    public var cache: Int64?
    public var process: Int64?
    public var payment: Int64?
    public var timeTaken: Int64?
    public var eventStartTime: Int64?
    public var eventEndTime: Int64?
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let eventName = "eventName"
        static let flow = "flow"
        static let status = "status"
        static let scanSessionStartTime = "scanPaySessionStartTime"
        static let scanSessionEndTime = "scanPaySessionEndTime"
        static let scan = "Tscan"
        static let backend = "Tbackend"
        static let cache = "Tcache"
        static let process = "Tprocess"
        static let payment = "Tpayment"
        static let timeTaken = "timeTaken"
        static let eventStartTime = "eventStartTime"
        static let eventEndTime = "eventEndTime"
    }
    
    public func dictionaryRepresentation() -> [String: Any] {
        
        var dictionary: [String: Any] = [:]
        if let value = eventName { dictionary[SerializationKeys.eventName] = value }
        if let value = flow { dictionary[SerializationKeys.flow] = value }
        if let value = status { dictionary[SerializationKeys.status] = value }
        if let value = scanSessionStartTime { dictionary[SerializationKeys.scanSessionStartTime] = value }
        if let value = scanSessionEndTime { dictionary[SerializationKeys.scanSessionEndTime] = value }
        if let value = scan { dictionary[SerializationKeys.scan] = value }
        if let value = backend { dictionary[SerializationKeys.backend] = value }
        if let value = cache { dictionary[SerializationKeys.cache] = value }
        if let value = process { dictionary[SerializationKeys.process] = value }
        if let value = payment { dictionary[SerializationKeys.payment] = value }
        if let value = timeTaken { dictionary[SerializationKeys.timeTaken] = value }
        if let value = eventStartTime { dictionary[SerializationKeys.eventStartTime] = value }
        if let value = eventEndTime { dictionary[SerializationKeys.eventEndTime] = value }
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(eventName, forKey: SerializationKeys.eventName)
        aCoder.encode(flow, forKey: SerializationKeys.flow)
        aCoder.encode(status, forKey: SerializationKeys.status)
        aCoder.encode(scanSessionStartTime, forKey: SerializationKeys.scanSessionStartTime)
        aCoder.encode(scanSessionEndTime, forKey: SerializationKeys.scanSessionEndTime)
        aCoder.encode(scan, forKey: SerializationKeys.scan)
        aCoder.encode(backend, forKey: SerializationKeys.backend)
        aCoder.encode(cache, forKey: SerializationKeys.cache)
        aCoder.encode(process, forKey: SerializationKeys.process)
        aCoder.encode(payment, forKey: SerializationKeys.payment)
        aCoder.encode(timeTaken, forKey: SerializationKeys.timeTaken)
        aCoder.encode(eventStartTime, forKey: SerializationKeys.eventStartTime)
        aCoder.encode(eventEndTime, forKey: SerializationKeys.eventEndTime)
    }
    
    public override init() {
        super.init()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        self.eventName = aDecoder.decodeObject(forKey: SerializationKeys.eventName) as? String
        self.flow = aDecoder.decodeObject(forKey: SerializationKeys.flow) as? String
        self.status = aDecoder.decodeObject(forKey: SerializationKeys.status) as? String
        self.scanSessionStartTime = aDecoder.decodeObject(forKey: SerializationKeys.scanSessionStartTime) as? String
        self.scanSessionEndTime = aDecoder.decodeObject(forKey: SerializationKeys.scanSessionEndTime) as? String
        self.scan = aDecoder.decodeObject(forKey: SerializationKeys.scan) as? Int64
        self.backend = aDecoder.decodeObject(forKey: SerializationKeys.backend) as? Int64
        self.cache = aDecoder.decodeObject(forKey: SerializationKeys.cache) as? Int64
        self.process = aDecoder.decodeObject(forKey: SerializationKeys.process) as? Int64
        self.payment = aDecoder.decodeObject(forKey: SerializationKeys.payment) as? Int64
        self.timeTaken = aDecoder.decodeObject(forKey: SerializationKeys.timeTaken) as? Int64
        self.eventStartTime = aDecoder.decodeObject(forKey: SerializationKeys.eventStartTime) as? Int64
        self.eventEndTime = aDecoder.decodeObject(forKey: SerializationKeys.eventEndTime) as? Int64
    }
}
