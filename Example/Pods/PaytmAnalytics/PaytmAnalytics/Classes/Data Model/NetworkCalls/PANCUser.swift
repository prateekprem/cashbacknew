//
//  User.swift
//
//  Created by Abhinav Kumar Roy on 05/07/18
//  Copyright (c) Abhinav Roy. All rights reserved.
//

import Foundation

public final class PANCUser : NSObject, NSCoding {

    public override init() {
        super.init()
    }
    
    // MARK: Declaration for string constants to be used to decode and also serialize.
    private struct SerializationKeys {
        static let id = "id"
        static let mobile = "mobile"
    }
    
    // MARK: Properties
    public var id: String?
    public var mobile: String?
    
    public func dictionaryRepresentation() -> [String: Any] {
        var dictionary: [String: Any] = [:]
        if let value = id { dictionary[SerializationKeys.id] = value }
        if let value = mobile { dictionary[SerializationKeys.mobile] = value }
        return dictionary
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(id, forKey: SerializationKeys.id)
        aCoder.encode(mobile, forKey: SerializationKeys.mobile)
    }
    
    public init?(coder aDecoder: NSCoder) {
        self.id = aDecoder.decodeObject(forKey: SerializationKeys.id) as? String
        self.mobile = aDecoder.decodeObject(forKey: SerializationKeys.mobile) as? String
    }
}
