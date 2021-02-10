//
//  Ext_NSMutableUrlRequest.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 26/12/18.
//

import UIKit

extension NSMutableURLRequest {
    
    public func setHeaders(headers: [String : String]?) {
        guard let headers = headers else {
            return
        }
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    public class func httpPostRequest(urlString: String?, params: Any?, headers: [String : String]?) -> NSMutableURLRequest? {
        if urlString == nil {
            return nil
        }
        guard let url = URL(string: urlString!) else {
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.setHeaders(headers: headers)
        request.httpMethod = "POST"
        if let paramsData = params {
            let jsonData = try? JSONSerialization.data(withJSONObject: paramsData)
            // insert json data to the request
            request.httpBody = jsonData
        }
        
        return request
        
    }
    
    public class func httpRequest(urlString: String?, params: [String : String]?, headers: [String : String]?) -> NSMutableURLRequest? {
        if urlString == nil {
            return nil
        }
        guard let url = URL.getUrlWithParam(url: urlString!, params: params) else {
            return nil
        }
        
        let request = NSMutableURLRequest(url: url)
        request.setHeaders(headers: headers)
        return request
        
    }
}
