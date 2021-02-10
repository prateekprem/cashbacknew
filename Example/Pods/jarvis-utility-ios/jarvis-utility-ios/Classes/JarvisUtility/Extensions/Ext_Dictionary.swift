//
//  Ext_Dictionary.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

public func += <KeyType, ValueType> ( left: inout Dictionary<KeyType, ValueType>, right: Dictionary<KeyType, ValueType>) {
    for (k, v) in right {
        left.updateValue(v, forKey: k)
    }
}

extension Dictionary{
    
    public var json: String {
        let emptyJson = "{}"
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            let jsonString = String(data: jsonData, encoding: String.Encoding.utf8) ?? emptyJson
            return jsonString
        } catch {
            return emptyJson
        }
    }
    
    public func getOptionalIntForKey(_ key: Key) -> Int? {
        if let x = self[key] as? Int {
            return x
        }
        if let s = self.getOptionalDoubleKey(key) {
            return Int(exactly:s)
        }
        return nil
    }
    
    public func getIntKey(_ key: Key) -> Int {
        if let y = self.getOptionalIntForKey(key) {
            return y
        }
        return 0
    }
    
    public func getOptionalDoubleKey(_ key: Key) -> Double? {
        if let y = self[key] as? Double {
            return y
        }
        if let y = self.getOptionalStringForKey(key){
            return Double(y)
        }
        return nil
    }
    
    public func getDoubleKey(_ key: Key) -> Double {
        if let y = self.getOptionalDoubleKey(key) {
            return y
        }
        return 0.0
    }
    
    public func getOptionalBoolKey(_ key: Key) -> Bool? {
        if let y = self[key] as? Bool {
            return y
        }
        if let y = self.getOptionalIntForKey(key) {
            return Bool(y)
        }
        if let y = self.getOptionalStringForKey(key), y == "1" {
            return true
        }
        return nil
    }
    
    public func getBoolForKey(_ key: Key) -> Bool {
        if let y = self.getOptionalBoolKey(key) {
            return y
        }
        return false
    }
    
    public func getOptionalStringForKey(_ key: Key) -> String? {
        if let y = self[key] as? String, !y.isEmpty {
            return y
        }
        if let y = self[key] as? Int {
            return String(y)
        }
        if let y = self[key] as? Double {
            return floor(y) == y ? String(format: "%.0f", y) : String(y)
        }
        return nil
    }
    
    public func getValueForKey<T>(key: Key, className: T) -> T? {
        if let y = self[key] as? T {
            return y
        }
        return nil
    }
    
    public func getOptionalArrayKey(_ key: Key) -> [Any]? {
        if let y = self[key] as? [Any] {
            return y
        }
        return nil
    }
    
    public func getArrayKey(_ key: Key) -> [Any] {
        if let y = self.getOptionalArrayKey(key) {
            return y
        }
        return []
        
    }
    
    
    public func getOptionalDictionaryKey(_ key: Key) -> [String: Any]? {
        if let y = self[key] as? [String: Any] {
            return y
        }
        return nil
    }
    
    public func getDictionaryKey(_ key: Key) -> [String:Any] {
        if let y = self.getOptionalDictionaryKey(key) {
            return y
        }
        return [:]
    }
    
    public func getOptionalPriceForKey(_ key: Key) -> Double? {
        var amount:Double?
        if let amt = getOptionalDoubleKey(key) {
            amount = amt
        } else if let amt = getOptionalIntForKey(key) {
            amount = Double(amt)
        }
        return amount
    }
    
    mutating public func setValue(value: Any, forKeyPath keyPath: String) {
        var keys = keyPath.components(separatedBy: ".")
        guard let first = keys.first as? Key else { print("Unable to use string as key on type: \(Key.self)"); return }
        keys.remove(at: 0)
        if keys.isEmpty, let settable = value as? Value {
            self[first] = settable
        } else {
            let rejoined = keys.joined(separator: ".")
            var subdict: [NSObject : AnyObject] = [:]
            if let sub = self[first] as? [NSObject : AnyObject] {
                subdict = sub
            }
            subdict.setValue(value: value, forKeyPath: rejoined)
            if let settable = subdict as? Value {
                self[first] = settable
            } else {
                print("Unable to set value: \(subdict) to dictionary of type: \(type(of: self))")
            }
        }
    }
    
    public func getStringKey(_ key: Key) -> String {
        if let y = self.getOptionalStringForKey(key) {
            let finalValue = y.handleNull()
            return finalValue
        }
        return ""
    }
    
    public func stringWithKeyValuePairsAsGETParams() -> String {
        return (self as NSDictionary).stringWithKeyValuePairsAsGETParams()
    }
    
    public func stringWithKeyValuePairsAsGETParamsTypeCheck() -> String {
        var arguments = [String]()
        for (key, value) in self {
            let stringKey = "\(key)"
            var stringValue = ""
            switch value {
            case is Array<Any>, is Dictionary:
                guard let data = try? JSONSerialization.data(withJSONObject: value, options: []) else { continue }
                stringValue = String(data: data, encoding: .utf8) ?? ""
            case let number as NSNumber:
                stringValue = "\(number)"
            default:
                stringValue = "\(value)"
            }
            let format = "\(stringKey.urlEncode())=\(stringValue.urlEncode())"
            arguments.append(format)
        }
        return arguments.joined(separator: "&")
    }
}

extension Dictionary where Key == String {

    public func stringFor(key: String) -> String {
        return self.actualValueFor(key: key, inInt: true)
    }
    
    public func intFor(key: String) -> Int {
        if let mInt = self[key] as? Int { return mInt }
        let value = Int(self.actualValueFor(key: key, inInt: true))
        return value != nil ? value! : 0
    }
    
    public func doubleFor(key: String) -> Double {
        let value = Double(self.actualValueFor(key: key, inInt: false))
        return value != nil ? value! : 0.0
    }
    
    public func booleanFor(key: String) -> Bool {
        return self.stringFor(key: key).lowercased() == "true" || self.intFor(key: key) >= 1
    }
    
    private func actualValueFor(key: String, inInt: Bool) -> String {
        let str1 = self[key]
        if str1 == nil { return "" }
        
        if let str = str1 as? String {
            return (str.lowercased() == "nil" || str.lowercased() == "null") ? "" : str
        }
        
        if let num = str1 as? NSNumber {
            return inInt ? String(format:"%i", num.int32Value) : String(format:"%f", num.doubleValue)
        }
        return ""
    }
}

extension NSDictionary {
    @objc
    public func dictionaryByReplacingNullsWithBlanks() -> NSMutableDictionary? {
        guard let mutableDictionary = self.mutableCopy() as? NSMutableDictionary else { return nil }
        for (key, value) in mutableDictionary {
            switch value {
            case is NSNull:
                mutableDictionary[key] = ""
            case let arrayItem as NSArray:
                mutableDictionary[key] = arrayItem.arrayByReplacingNullsWithBlanks()
            case let dictItem as NSDictionary:
                mutableDictionary[key] = dictItem.dictionaryByReplacingNullsWithBlanks()
            default:
                continue
            }
        }
        return mutableDictionary
    }
    
    @objc
    public func getFullMutableCopy() -> NSMutableDictionary? {
        guard let mutableDictionary = self.mutableCopy() as? NSMutableDictionary else { return nil }
        for (key, value) in mutableDictionary {
            switch value {
            case let arrayItem as NSArray:
                mutableDictionary[key] = arrayItem.getFullMutableCopy()
            case let dictItem as NSDictionary:
                mutableDictionary[key] = dictItem.getFullMutableCopy()
            default:
                continue
            }
        }
        guard let dictionary = mutableDictionary.copy() as? NSDictionary else { return nil }
        return NSMutableDictionary(dictionary: dictionary)
    }
    
    /**
    Method to generate Dictionary for the provided key and value with pre defined pair.
    Here "label" and "value" are predefined keys. This supports localization.
        
        key to be paired with "label".
        value to be paired with "value".
        returns a dictionary with following format
        
            {
               "label" : key,
               "value" : value
           }
    
    Here converting value to String, sometimes it may come as number also. Which crashes in iOS 11. CA-15394
    */
    
    @objc
    public class func generateDictionaryForkey(_ key: String, value: Any) -> [String: Any] {
        var dictionary = [String: Any]()
        dictionary["label"] = key.localized
        let valueInString = "\(value)"
        dictionary["value"] = valueInString.localized
        return dictionary
    }
    
    @objc
    public func stringWithKeyValuePairsAsGETParams() -> String {
        var arguments = [String]()
        for (key, value) in self {
            let stringValue = "\(value)"
            let stringKey = "\(key)"
            let format = "\(stringKey.urlEncode())=\(stringValue.urlEncode())"
            arguments.append(format)
        }
        return arguments.joined(separator: "&")
    }
}
