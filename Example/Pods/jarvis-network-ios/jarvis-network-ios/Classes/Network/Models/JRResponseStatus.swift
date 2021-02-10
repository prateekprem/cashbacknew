//
//  JRResponseStatus.swift
//  JRNetworkRouter
//
//  Created by Shwetabh Singh on 06/11/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

public struct JRResponseStatus: Codable {
    let result: String?
    let code: String?
    let responseCode: String?
    let message: String?
    let status: String?
    let response: JRResponseMessage?
    
    init(dict: [String: Any]) {
        
        status = dict["status"] as? String
        result = dict["result"] as? String
        code = dict["code"] as? String
        responseCode = dict["responseCode"] as? String
        
        message = dict["message"] as? String
        if let messageDict = dict.getOptionalDictionaryKey(key: "message")
        {
            response = JRResponseMessage.init(dict: messageDict)
        } else {
            response = nil
        }
        
    }
}

public struct JRResponseMessage: Codable {
    let message: String?
    let title: String?
    
    init(dict:[String: Any]) {
        message = dict["message"] as? String
        title = dict["title"] as? String
    }
}
