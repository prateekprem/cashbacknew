//
//  EncryptionUtils.swift
//  PaytmFD
//
//  Created by Kushalpal Singh on 19/06/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

public class PNEncryptionUtils {
    public class func hamc(method: String, httpPath: String, headerString: String = "x-requester:iosapp", body: [AnyHashable : Any]?,key: String)-> String? {
        guard let httpPath = httpPath.removingPercentEncoding else {
            return nil
        }
        
        var buffers:[String] = [method,httpPath,headerString]
        if let httpBody = body {
            guard let jsonData = try? JSONSerialization.data(withJSONObject: httpBody, options: []) , let bodyString = String(data: jsonData, encoding: .utf8)  else {
                return nil
            }
            buffers.append(bodyString)
        }
        
        //hash buffer data
        let buffer = buffers.joined(separator: "|")
        return buffer.hmacSHA256(key: key)
    }
}
