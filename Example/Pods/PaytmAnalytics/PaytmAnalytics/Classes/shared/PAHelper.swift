//
//  PAUtils.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PAHelper: NSObject {

    /// Detailed steps: https://wiki.mypaytm.com/display/PUSH/Signal+Service+Developer%27s+Guide#SignalServiceDeveloper'sGuide-BatchEndpoint
    /// Use this site to verify hmac result: https://www.freeformatter.com/hmac-generator.html
    ///
    /// - Parameters:
    ///   - requestMethod: POST/GET
    ///   - apiPath: the path component of the request url string
    ///   - xRequester: client id being assigned to each tenant
    ///   - secretKey: secret key being assigned to each tenant
    ///   - payload: request payload in Data format; nil for GET
    static func hmac(requestMethod: String, apiPath: String, xRequester: String, secretKey: String, payload: Data?) -> String? {
        guard let httpPath = apiPath.removingPercentEncoding else {
            return nil
        }
        
        guard !xRequester.isEmpty || !secretKey.isEmpty else {
            return nil
        }
        
        let xRequesterKeyValuePairString = PAConstant.XREQUESTER_HEADER + ":" + xRequester
        
        //concatenate 4 strings in the order of following
        var buffers: [String] = [requestMethod, httpPath, xRequesterKeyValuePairString]
        var isBodyStringIncluded: Bool = false
        
        if let httpBody = payload {
            guard  let bodyString = String(data: httpBody, encoding: .utf8) else {
                return nil
            }
            
            buffers.append(bodyString)
            isBodyStringIncluded = true
        }
        
        //hash buffer data
        var buffer = buffers.joined(separator: "|")
        
        //trailing "|" should be present if body is empty
        //Format: GET|/signal|x-requester:ios-requester|
        if !isBodyStringIncluded {
            buffer.append("|")
        }
        
        //Calculate buffer using SHA256 with the given secret key
        let hmac = buffer.getHmacSHA256(key: secretKey)!
        return hmac
    }
    
    
    /// Get thread type in current running loop
    /// - Parameter label: a string to identify specific location
    static func currentThread(_ label: String) {
        if Thread.isMainThread {
            PALogger.log(message: "Main thread in \(label)")
        } else {
            PALogger.log(message: "Background thread in \(label)")
        }
    }
    
}
