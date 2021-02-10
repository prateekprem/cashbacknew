//
//  URLRequestExtension.swift
//  Jarvis
//
//  Created by Khushalpal Singh on 21/02/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

extension URLRequest {
    
    mutating func setHeaders(headers: [String : String]?) {
        guard let headers = headers else {
            return
        }
        for (key, value) in headers {
            self.addValue(value, forHTTPHeaderField: key)
        }
    }
    
    static func webViewPostRequest(urlString: String?, params: [AnyHashable : Any]?, headers: [String : String]?) -> URLRequest? {
        if urlString == nil {
            return nil
        }
        guard let url = URL(string: urlString!) else {
            return nil
        }
        
        var request = URLRequest(url: url)
        request.setHeaders(headers: headers)
        request.httpMethod = "POST"
        request.addValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
        
        if let params = params {
            let urlParams = params.compactMap({ (key, value) -> String in
                return "\(key)=\(value)"
            }).joined(separator: "&")
            
            if let postData = urlParams.data(using: String.Encoding.ascii, allowLossyConversion: true) {
                request.httpBody = postData
            }
        }
        return request
    }
    
    private func percentEscapeString(_ string: String) -> String {
        var characterSet = CharacterSet.alphanumerics
        characterSet.insert(charactersIn: "-._* ")
        
        return string
            .addingPercentEncoding(withAllowedCharacters: characterSet)!
            .replacingOccurrences(of: " ", with: "+")
            .replacingOccurrences(of: " ", with: "+", options: [], range: nil)
    }
    
    mutating func encodeParameters(parameters: [String : String]) {
        let parameterArray = parameters.map { (arg) -> String in
            let (key, value) = arg
            return "\(key)=\(self.percentEscapeString(value))"
        }
        
        httpBody = parameterArray.joined(separator: "&").data(using: String.Encoding.utf8)
    }
}
