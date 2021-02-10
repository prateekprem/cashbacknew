//
//  JRAppManagerConfig.swift
//  Bolts
//
//  Created by Nasib Ali on 04/11/19.
//

import Foundation

public protocol JRAppManagerConfigurator {
    var baseURL: String { get }
    var authKey: String { get }
    var localFileName: String { get }
    var nameSpace: String { get }
}

class ConstantKeys {
    class var lastApiCallTime: String { return "LastApiCallTime" }
    class var list: String { return "list" }
    class var deletedList: String { return "deleted_list" }
    class var metaData: String { return "meta_data" }
    class var intervalTime: String { return "key_sync_threshold_time" }
    class var hasNext: String { return "has_next" }
    class var currentVersion: String { return "current_version" }
    class var response: String { return "response" }
    class var status: String { return "status" }
    class var key: String { return "key" }
    class var value: String { return "value" }
}

extension Dictionary where Key == String {
    
    func getString(_ key: Key) -> String {
        if let y = self[key] as? String, !y.isEmpty {
            return y
        }
        if let y = self[key] as? Int {
            return String(y)
        }
        if let y = self[key] as? Double {
            return floor(y) == y ? String(format: "%.0f", y) : String(y)
        }
        if let y = self[key] as? Bool {
            return String(y)
        }
        return ""
    }
}
