//
//  JRSearchActivityItem.swift
//  Jarvis
//
//  Created by Shrinivasa Bhat on 08/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

public class JRSearchActivityItem: NSObject, NSCoding {
    public var urlType: String?
    public var activityKey: String?
    @objc public var title: String?
    @objc public var contentDescription: String?
    public var imageUrl: String?
    public var shouldAppendImage: Bool = false
    @objc public var keywords: [String]?
    @objc public var isPublic: Bool = true
    @objc public var deeplinkUrl: String?
    
    public init(key: String, dictionary:[String: AnyObject]){
        urlType = key
        activityKey = dictionary.getOptionalStringForKey("activityKey")
        title = dictionary.getOptionalStringForKey("title")
        contentDescription = dictionary.getOptionalStringForKey("description")
        imageUrl = dictionary.getOptionalStringForKey("imageurl")
        shouldAppendImage = dictionary.getBoolForKey("shouldAppendImage")
        isPublic = dictionary.getBoolForKey("isPublic")
        keywords = dictionary["keywords"] as? [String]
        deeplinkUrl = dictionary.getOptionalStringForKey("deeplinkUrl")
    }
    
    required public init(coder aDecoder: NSCoder) {
        aDecoder.decodeObject(forKey: "urlType")
        aDecoder.decodeObject(forKey: "activityKey")
        aDecoder.decodeObject(forKey: "title")
        aDecoder.decodeObject(forKey: "contentDescription")
        
        if let data = aDecoder.decodeObject(forKey: "imageUrl") as? Data {
            imageUrl = NSString.stringArchiveDecode(data)
        }
        
        aDecoder.decodeBool(forKey: "shouldAppendImage")
        aDecoder.decodeBool(forKey: "isPublic")
        aDecoder.decodeObject(forKey: "keywords")
        
        if let data = aDecoder.decodeObject(forKey: "deeplinkUrl") as? Data {
            deeplinkUrl = NSString.stringArchiveDecode(data)
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(urlType, forKey: "urlType")
        aCoder.encode(activityKey, forKey: "activityKey")
        aCoder.encode(title, forKey: "title")
        aCoder.encode(contentDescription, forKey: "contentDescription")
        
        if let imageUrl = imageUrl {
            let data: Data? = NSString.stringArchiveEncode(imageUrl)
            data?.withUnsafeBytes({ (unsafeRawBufferPointer: UnsafeRawBufferPointer) -> Void in
                if let length = data?.count {
                    let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
                    let bytes = unsafeBufferPointer.baseAddress
                    aCoder.encodeBytes(bytes, length: length, forKey: "imageUrl")
                }
            })
    }
        
        aCoder.encode(shouldAppendImage, forKey: "shouldAppendImage")
        aCoder.encode(isPublic, forKey: "isPublic")
        aCoder.encode(keywords, forKey: "keywords")
        
        if let deeplinkUrl = deeplinkUrl {
            let data: Data? = NSString.stringArchiveEncode(deeplinkUrl)
            data?.withUnsafeBytes({ (unsafeRawBufferPointer: UnsafeRawBufferPointer) -> Void in
                if let length = data?.count {
                    let unsafeBufferPointer = unsafeRawBufferPointer.bindMemory(to: UInt8.self)
                    let bytes = unsafeBufferPointer.baseAddress
                    aCoder.encodeBytes(bytes, length: length, forKey: "deeplinkUrl")
                }
            })
            
        }
    }
}

