//
//  JRLocale.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRLocale: NSObject {

    public var name : String?
    public var languageCode : String?
    public var countryCode : String?
    public var isDownloaded : Bool = false
    
    @objc public init(languageCode : String, countryCode : String, name : String) {
        self.languageCode = languageCode
        self.countryCode = countryCode
        self.name = name
        self.isDownloaded = false
    }
    
    convenience public init(withDictionary dict : [String : Any]) {
        let name = dict["name"] as? String ?? ""
        let languageCode = dict["languageCode"] as? String ?? ""
        let countryCode = dict["countryCode"] as? String ?? ""
        self.init(languageCode: languageCode, countryCode: countryCode, name: name)
    }
    
    func getDictionary() -> [String : Any]{
        var dic : [String : Any] = [String : Any]()
        dic["name"] = self.name ?? ""
        dic["languageCode"] = self.languageCode ?? ""
        dic["countryCode"] = self.countryCode ?? "IN"
        dic["isDownloaded"] = self.isDownloaded
        return dic
    }

}

public extension JRLocale {
    
    public var countryLangCode: String? {
        guard let langCode = languageCode, let countryCode = countryCode else {
            return nil
        }
        return "\(langCode)-\(countryCode)"
    }
    
}
