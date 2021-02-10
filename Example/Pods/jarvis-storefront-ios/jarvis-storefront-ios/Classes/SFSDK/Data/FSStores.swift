//
//  FSStores.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import Foundation

public class FSStores {
    
    public var storeItems: [FSStoresLayout] = [FSStoresLayout]()
    
    public init(dict: SFJSONDictionary) {
        if let data = dict["data"] as? SFJSONDictionary, let mStores = data["items"] as? [SFJSONDictionary], mStores.count > 0 {
            storeItems.removeAll()
            for storeDict in mStores {
                storeItems.append(FSStoresLayout(dict: storeDict))
            }
        }else if let data = dict["data"] as? SFJSONDictionary, let mStores = data["stores"] as? [SFJSONDictionary], mStores.count > 0 {
            storeItems.removeAll()
            for storeDict in mStores {
                storeItems.append(FSStoresLayout(dict: storeDict))
            }
        }
    }
}

public class FSStoresLayout: NSObject {
    
    public private(set) var storeId: String?
    public private(set) var storeName: String = ""
    public private(set) var imageUrl: String?
    public private(set) var distance: String?
    public private(set) var rating: Double?
    public private(set) var storeSeoUrl = ""
    public private(set) var address: String?
    public private(set) var contact: String?
    public private(set) var lat: Double?
    public private(set) var lon: Double?
    
    public init(dict: SFJSONDictionary) {
        self.storeId = dict.sfStringFor(key: "id")
        self.storeName = dict.sfStringFor(key: "name")
        self.imageUrl = dict.sfStringFor(key: "image_url")
        self.distance = dict.sfStringFor(key: "distance")
        self.storeSeoUrl  = dict.sfStringFor(key: "seourl")
        self.rating = dict["rating"] as? Double
        self.address = dict.sfStringFor(key: "address")
        self.contact = dict.sfStringFor(key: "contact")
        if let location = dict["location"] as? SFJSONDictionary, let lat = location["lat"] as? Double, let lon = location["lon"] as? Double {
            self.lat = lat
            self.lon = lon
        }
    }
}

public class FSOffersLayout: NSObject {
    
    public private(set) var itemTitle: String?
    
    public init(dict: SFJSONDictionary) {
        self.itemTitle = dict.sfStringFor(key: "offerText")
    }
}

public class FSFeedItemLayout {
    
    public var items: [SFLayoutItem] = [SFLayoutItem]()
    
    public init(dict: SFJSONDictionary) {
        if let mItems = dict["items"] as? [SFJSONDictionary], mItems.count > 0 {
            items.removeAll()
            for itemDict in mItems {
                items.append(SFLayoutItem(dict: itemDict))
            }
        }
    }
}
