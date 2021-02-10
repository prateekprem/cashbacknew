//
//  JRGSTModel.swift
//  Jarvis
//
//  Created by Brammanand Soni on 8/23/17.
//  Copyright © 2017 One97. All rights reserved.
//

import UIKit

public class JRGSTModel: NSObject {
    
    @objc public var gstIn: String?
    @objc public var gstHolderName: String?
    @objc public var gstHolderAddress: String?
    @objc public var state: String?
    private(set) var gstID:Int?
    private(set) var isVerified:Bool = false
    var editMode = false
    
    @objc public func getDictForObject() -> [String : Any] {
        var configuration: [String : Any] = [:]
        if let gstIn = self.gstIn
        {
            configuration["gstin"] = gstIn
        }
        if let gstHolderName = self.gstHolderName
        {
            configuration["gstHolderName"] = gstHolderName
        }
        if let gstAddress = self.gstHolderAddress
        {
            configuration["address"] = gstAddress
        }
        if let gstState = self.state
        {
            configuration["state"] = gstState
        }
        if let gstID = self.gstID
        {
             configuration["id"] = gstID
        }
        if self.editMode == true {
            configuration["action"] = "edit"
        }
        return configuration
    }
    
    override init(){
        super.init()
    }
    
    @objc public convenience init(dictionary: [AnyHashable: Any]) {
        self.init()
        gstIn = dictionary.getStringKey("gstin")
        gstHolderName = dictionary.getStringKey("gstHolderName")
        gstHolderAddress = dictionary.getStringKey("address")
        state = dictionary.getStringKey("state")
        isVerified = dictionary.getBoolForKey("isVerified")
        gstID = dictionary.getIntKey("id")
    }
}
