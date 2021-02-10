//
//  Log.swift
//
//  Created by Abhinav Kumar Roy on 05/07/18
//  Copyright (c) Abhinav Roy. All rights reserved.
//

import Foundation

public class PANCLog : NSObject,NSCoding {
    
    public override init() {
        super.init()
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let origin = "origin"
        static let clientid = "clientId"
        static let events = "events"
        static let userId = "userId"
        static let deviceId = "deviceId"
        static let osType = "osType"
        static let osVersion = "osVersion"
        static let deviceManufacturer = "deviceManufacturer"
        static let deviceName = "deviceName"
    }

    // MARK: Properties
    public var origin: String?
    public var userID: String?
    public var clientid : String?
    public var deviceId: String?
    public var osType: String?
    public var osVersion: String?
    public var deviceManufacturer: String?
    public var deviceName: String?
    public var events: [PANCEvent]?
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = origin { dictionary[SerializationKeys.origin] = value }
        if let value = clientid { dictionary[SerializationKeys.clientid] = value }
        if let value = userID { dictionary[SerializationKeys.userId] = value }
        if let value = events { dictionary[SerializationKeys.events] = value.map { $0.dictionaryRepresentation() } }
        if let value = deviceId { dictionary[SerializationKeys.deviceId] = value }
        if let value = osType { dictionary[SerializationKeys.osType] = value }
        if let value = osVersion { dictionary[SerializationKeys.osVersion] = value }
        if let value = deviceManufacturer { dictionary[SerializationKeys.deviceManufacturer] = value }
        if let value = deviceName { dictionary[SerializationKeys.deviceName] = value }
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(origin, forKey: SerializationKeys.origin)
        aCoder.encode(clientid, forKey: SerializationKeys.clientid)
        aCoder.encode(userID, forKey: SerializationKeys.userId)
        aCoder.encode(events, forKey: SerializationKeys.origin)
        aCoder.encode(deviceId, forKey: SerializationKeys.deviceId)
        aCoder.encode(osType, forKey: SerializationKeys.osType)
        aCoder.encode(osVersion, forKey: SerializationKeys.osVersion)
        aCoder.encode(deviceManufacturer, forKey: SerializationKeys.deviceManufacturer)
        aCoder.encode(deviceName, forKey: SerializationKeys.deviceName)
        
    }
    
    public required init?(coder aDecoder: NSCoder) {
        self.origin = aDecoder.decodeObject(forKey: SerializationKeys.origin) as? String
        self.clientid = aDecoder.decodeObject(forKey: SerializationKeys.clientid) as? String
        self.userID = aDecoder.decodeObject(forKey: SerializationKeys.userId) as? String
        self.events = aDecoder.decodeObject(forKey: SerializationKeys.events) as? [PANCEvent]
        self.deviceId = aDecoder.decodeObject(forKey: SerializationKeys.deviceId) as? String
        self.osType = aDecoder.decodeObject(forKey: SerializationKeys.osType) as? String
        self.osVersion = aDecoder.decodeObject(forKey: SerializationKeys.osVersion) as? String
        self.deviceManufacturer = aDecoder.decodeObject(forKey: SerializationKeys.deviceManufacturer) as? String
        self.deviceName = aDecoder.decodeObject(forKey: SerializationKeys.deviceName) as? String
    }
}
