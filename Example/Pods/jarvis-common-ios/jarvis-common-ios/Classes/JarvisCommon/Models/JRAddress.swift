//
//  JRAddress.swift
//  Jarvis
//
//  Created by Shwetha Mugeraya on 05/09/13. Migrated 12/05/20
//  Copyright (c) 2013 Robosoft. All rights reserved.
//

import Foundation

@objc(JRAddress)
public class JRAddress: NSObject, NSCoding {
    @objc public var name: String?
    @objc public var addressId: String?
    @objc public var addStr: String?
    @objc public var address1: String?
    @objc public var address2: String?
    @objc public var city: String?
    @objc public var country: String?
    @objc public var state: String?
    @objc public var pin: String?
    @objc public var mobile: String?
    @objc public var addressTitle: String? //such as home, work etc
    @objc public var latitude: Double = 0.0
    @objc public var longitude: Double = 0.0
    @objc public var areaName: String?
    
    @objc public var isDeleted: Bool = false
    @objc public var isDefault: Bool = false
    @objc public var isSelected: Bool = false
    @objc public var rawAddress: [AnyHashable: Any]?
    @objc public var locationRawAddress: [AnyHashable: Any]?
    
    @objc public var formattedAddressLines: Array<Any>? {
        guard let addressLines = locationRawAddress?["FormattedAddressLines"] as? Array<Any> else {
            return nil
        }
        return addressLines
    }
    
    @objc public override init() {
        super.init()
    }
    
    @objc required public init?(coder aDecoder: NSCoder) {
        super.init()
        
        name = aDecoder.decodeObject(forKey: "name") as? String
        addressId = aDecoder.decodeObject(forKey: "addressId") as? String
        address1 = aDecoder.decodeObject(forKey: "address1") as? String
        address2 = aDecoder.decodeObject(forKey:"address2") as? String
        city = aDecoder.decodeObject(forKey: "city") as? String
        state = aDecoder.decodeObject(forKey: "state") as? String
        pin = aDecoder.decodeObject(forKey: "pin") as? String
        mobile = aDecoder.decodeObject(forKey: "mobile") as? String
        addressTitle = aDecoder.decodeObject(forKey: "addressTitle") as? String
        
        isDeleted = aDecoder.decodeBool(forKey: "isDeleted")
        isDefault = aDecoder.decodeBool(forKey: "isDefault")
        isSelected = aDecoder.decodeBool(forKey: "isSelected")
        rawAddress = aDecoder.decodeObject(forKey: "rawAddress") as? [AnyHashable: Any]
        
        areaName = aDecoder.decodeObject(forKey: "areaName") as? String
        latitude = aDecoder.decodeDouble(forKey: "latitude")
        longitude = aDecoder.decodeDouble(forKey: "longitude")
        locationRawAddress = aDecoder.decodeObject(forKey: "locationRawAddress") as? [AnyHashable: Any]
    }
    
    @objc public func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: "name")
        aCoder.encode(addressId, forKey: "addressId")
        aCoder.encode(address1, forKey: "address1")
        aCoder.encode(address2, forKey: "address2")
        aCoder.encode(city, forKey: "city")
        aCoder.encode(state, forKey: "state")
        aCoder.encode(pin, forKey: "pin")
        aCoder.encode(mobile, forKey: "mobile")
        aCoder.encode(addressTitle, forKey: "addressTitle")
        aCoder.encode(areaName, forKey: "areaName")
        aCoder.encode(latitude, forKey: "latitude")
        aCoder.encode(longitude, forKey: "longitude")
        aCoder.encode(isDeleted, forKey: "isDeleted")
        aCoder.encode(isDefault, forKey: "isDefault")
        aCoder.encode(isSelected, forKey: "isSelected")
        aCoder.encode(rawAddress, forKey: "rawAddress")
        aCoder.encode(locationRawAddress, forKey: "locationRawAddress")
    }
    
    @objc public init(dictionary: [AnyHashable: Any]!) {
        super.init()
        guard let dictionary: [AnyHashable: Any] = dictionary else {
            return
        }
        setWithDictionary(dictionary)
    }
    
    //Since we are getting different server response for OrderSummary and Get Address APIs we need 2 different methods to create a address object.
    @objc public func setWithDictionary(_ dictionary: [AnyHashable: Any]!) {
        guard let dictionary: [AnyHashable: Any] = dictionary,
            dictionary.isEmpty == false else {
                return
        }
        
        mobile = dictionary["mobile"] as? String
        city = dictionary["city"] as? String
        state = dictionary["state"] as? String
        address1 = dictionary["address1"] as? String
        address2 = dictionary["address2"] as? String
        name = dictionary["name"] as? String
        addressTitle = dictionary["title"] as? String
        areaName = dictionary["areaName"] as? String
        
        if let tempDeleted: Bool = dictionary.getOptionalBoolKey("isDeleted") {
            isDeleted = tempDeleted
        }
        if let tempPriority: Bool = dictionary.getOptionalBoolKey("priority") {
            isDefault = tempPriority
        }
        
        pin = dictionary.getOptionalStringForKey("pin")
        addressId = dictionary.getOptionalStringForKey("id")
        addStr = dictionary.getOptionalStringForKey("id_str")
        
        if let locDict = dictionary["location"] as? [AnyHashable: Any] {
            latitude = locDict.getOptionalDoubleKey("latitude") ?? 0.0
            longitude = locDict.getOptionalDoubleKey("longitude") ?? 0.0
        }
        
        rawAddress = dictionary
    }
    
    
    @objc public func setWithOrderSummaryDictionary(_ dictionary: [AnyHashable: Any]!) {
        mobile = dictionary?["mobile"] as? String ?? ""
        city = dictionary?["city"] as? String ?? ""
        state = dictionary?["state"] as? String ?? ""
        address1 = dictionary?["address1"] as? String ?? ""
        address2 = dictionary?["address2"] as? String ?? ""
        pin = dictionary?.getOptionalStringForKey("pin") ?? ""
        name = dictionary?["name"] as? String ?? ""
        
        rawAddress  = dictionary
    }
    
    @objc public func dictionaryRepresentation() -> [AnyHashable: Any] {
        var addressDict: [AnyHashable: Any] = [AnyHashable: Any]()
        if let mobile = mobile { addressDict["mobile"] = mobile }
        if let city = city {    addressDict["city"] = city  }
        if let state = state {  addressDict["state"] = state    }
        if let address1 = address1 {    addressDict["address1"] = address1  }
        if let address2 = address2 {    addressDict["address2"] = address2  }
        if let pin = pin {  addressDict["pin"] = pin    }
        if let name = name {    addressDict["name"] = name  }
        if let title = addressTitle {   addressDict["title"] = title    }
        if let addressId = addressId {  addressDict["id"] = addressId   }
        if let addStr = addStr {    addressDict["id_str"] = addStr  }
        if let areaName = areaName {    addressDict["areaName"] = areaName  }
        
        addressDict["isDeleted"] = isDeleted
        addressDict["priority"] = isDefault ? 1 : 0
        
        if latitude > 0.0, longitude > 0.0 {
            var locationDict: [AnyHashable: Any] = [AnyHashable: Any]()
            locationDict["latitude"] = latitude
            locationDict["longitude"] = longitude
            addressDict["location"] = locationDict
        }
        return addressDict
    }
    
    @objc public func returnReplaceDictionaryRepresentation() -> [AnyHashable: Any] {
        var addressDict: [AnyHashable: Any] = [AnyHashable: Any]()
        if let name = name {    addressDict["firstname"] = name    }
        addressDict["lastname"] = ""
        if let address1 = address1 {    addressDict["address"] = address1   }
        if let address2 = address2 {    addressDict["address2"] = address2 }
        if let city = city { addressDict["city"] = city  }
        if let state = state {  addressDict["state"] = state  }
        if let mobile = mobile {    addressDict["phone"] = mobile   }
        if let pin = pin {  addressDict["pincode"] = pin  }
        addressDict["country"] = ""
        addressDict["email"] = ""
        
        return addressDict
    }
    
    @objc public func dictionaryRepresentationForAddress(_ address: JRAddress?) -> [AnyHashable: Any] {
        var addressDict: [AnyHashable: Any] = [AnyHashable: Any]()
        guard let address: JRAddress = address else {
            return addressDict
        }
        
        if let address1 = address.address1 {
            addressDict["address1"] = address1
            if let mobile = address.mobile {
                addressDict["mobile"] = mobile
            }
            if let city = address.city {
                addressDict["city"] = city
            }
            if let state = address.state {
                addressDict["state"] = state
            }
            if let address2 = address.address2 {
                addressDict["address2"] = address2
            }
            if let pin = address.pin {
                addressDict["pin"] = pin
            }
            if let name = address.name {
                addressDict["name"] = name
            }
            if let title = address.addressTitle {
                addressDict["title"] = title
            }
            addressDict["isDeleted"] = address.isDeleted
            addressDict["priority"] = address.isDefault ? 1 : 0
            
            //Using self.addressId here as per existing implementation.
            if let addressId = addressId {
                addressDict["id"] = addressId
            }
        }
        else {
            if let pin = address.pin {
                addressDict["pin"] = pin
            }
        }
        return addressDict
    }
}

/*
 @implementation JRAddress
 - (NSString *)description
 {
 //TODO:Update title and isDefault here , if required
 NSString *addString = self.name;
 addString = [addString stringByAppendingString:@"\n"];
 addString = [addString stringByAppendingString:[NSString stringWithFormat:@"%@,",self.address1]];
 addString = [addString stringByAppendingString:[NSString stringWithFormat:@" %@,", self.address2]];
 addString = [addString stringByAppendingString:[NSString stringWithFormat:@" %@,", self.city]];
 addString = [addString stringByAppendingString:[NSString stringWithFormat:@" %@", self.state]];
 addString = [addString stringByAppendingString:[NSString stringWithFormat:@"-%@,", self.pin]];;
 //addString = [addString stringByAppendingString:[NSString stringWithFormat:@" %@,", self.state]];;
 return addString;
 
 }
 @end
 */
