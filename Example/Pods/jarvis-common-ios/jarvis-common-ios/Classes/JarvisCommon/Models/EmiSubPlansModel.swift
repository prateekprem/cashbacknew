//
//  EmiSubPlansModel.swift
//  Jarvis
//
//  Created by Brammanand Soni on 16/08/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

@objc public class EmiSubPlansModel: NSObject {
    public var bankName: String?
    public var bankCode: String?
    public var cardType: String?
    
    public var tenures: [EmiSubTenureModel] = [EmiSubTenureModel]()
    
    @objc public init(dictionary: [String: Any]) {
        bankName = dictionary["bankName"] as? String
        bankCode = dictionary["bankCode"] as? String
        cardType = dictionary["cardType"] as? String
        
        if let tenuresDictArray = dictionary["details"] as? [[String: Any]], !tenuresDictArray.isEmpty {
            tenures.removeAll()
            for tenureDict in tenuresDictArray {
                let tenureModel = EmiSubTenureModel(dictionary: tenureDict)
                tenures.append(tenureModel)
            }
        }
    }
}
