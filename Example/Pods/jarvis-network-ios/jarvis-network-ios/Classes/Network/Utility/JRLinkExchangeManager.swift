//
//  JRLinkExchangeManager.swift
//  jarvis-locale-ios
//
//  Created by Sanjay Mohnani on 22/01/19.
//

import Foundation

public class JRLinkExchangeManager {
    
    static let kExchangeLinksInfoKey = "kExchangeLinksInfoKey"
    public var linkInfos = [JRLinkExchangeInfo]()
    
    private init() {
        self.linkInfos = JRLinkExchangeManager.savedExchInfos
    }
    
    public static var shared = JRLinkExchangeManager()
    
    public func add(info: JRLinkExchangeInfo) {
        linkInfos.append(info)
        JRLinkExchangeManager.saveExchLink(infos: linkInfos)
    }
    
    public func remove(info: JRLinkExchangeInfo) {
        linkInfos = linkInfos.filter(){!($0.newLink.elementsEqual(info.newLink) && $0.oldLink.elementsEqual(info.oldLink))}
        JRLinkExchangeManager.saveExchLink(infos: linkInfos)
    }
    
    func reqAfterCheckLink(request: URLRequest) -> URLRequest {
        if linkInfos.count == 0 { return request }
        guard let uStr = request.url?.absoluteString else {
            return request
        }
        
        guard let mutableRequest = (request as NSURLRequest).mutableCopy() as? NSMutableURLRequest else {
            return request
        }
        
        let filteredList = linkInfos.filter() { uStr.hasPrefix($0.oldLink) }
        if filteredList.count > 0 {
            
            let newUrlS = uStr.replacingOccurrences(of: filteredList[0].oldLink, with: filteredList[0].newLink)
            
            if let mUrl = URL(string: newUrlS) {
                mutableRequest.url = mUrl
                URLProtocol.setProperty(true, forKey: "", in: mutableRequest)
                let newRequest = mutableRequest as URLRequest
                return newRequest
            }
        }
        return request
    }
    
    
    //MARK:- Saved Links
    class var savedExchInfos : [JRLinkExchangeInfo] {
        get {
            var infos = [JRLinkExchangeInfo]()
            if let decoded  = UserDefaults.standard.object(forKey: kExchangeLinksInfoKey) as? Data,
                let mList = NSKeyedUnarchiver.unarchiveObject(with: decoded) as? [JRLinkExchangeInfo] {
                infos = mList
            }
            return infos
        }
    }
    
    class func saveExchLink(infos: [JRLinkExchangeInfo]?) {
        let defaults = UserDefaults.standard
        defaults.set(nil, forKey: kExchangeLinksInfoKey)
        if let myLinks = infos {
            let encodedData: Data = NSKeyedArchiver.archivedData(withRootObject: myLinks)
            defaults.set(encodedData, forKey: kExchangeLinksInfoKey)
            defaults.synchronize()
        }
        defaults.synchronize()
    }
}


public class JRLinkExchangeInfo: NSObject, NSCoding {
    public var oldLink = ""
    public var newLink = ""
    
    public init(oldL: String, nLink: String) {
        self.oldLink = oldL
        self.newLink = nLink
    }
    
    override init() { super.init() }
    
    required public init(coder aDecoder: NSCoder) {
        if let aStr = aDecoder.decodeObject(forKey: "kOldLink") as? String {
            self.oldLink = aStr
        }
        
        if let aStr = aDecoder.decodeObject(forKey: "kNewLink") as? String {
            self.newLink = aStr
        }
    }
    
    public func encode(with aCoder: NSCoder) {
        aCoder.encode(self.oldLink, forKey: "kOldLink")
        aCoder.encode(self.newLink, forKey: "kNewLink")
    }
}
