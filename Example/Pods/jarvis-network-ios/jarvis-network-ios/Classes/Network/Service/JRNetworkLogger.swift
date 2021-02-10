//
//  NetworkLogger.swift
//  Jarvis
//
//  Created by Kushalpal Singh on 10/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

class JRNetworkLogger {
    static func log(request: URLRequest) {
        
        print("\n - - - - - - - - - - OUTGOING - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        let urlAsString = request.url?.absoluteString ?? ""
        let urlComponents = NSURLComponents(string: urlAsString)
        
        let method = request.httpMethod != nil ? "\(request.httpMethod ?? "")" : ""
        let path = "\(urlComponents?.path ?? "")"
        let query = "\(urlComponents?.query ?? "")"
        let host = "\(urlComponents?.host ?? "")"
        
        var logOutput = """
        \(urlAsString) \n\n
        \(method) \(path)?\(query) HTTP/1.1 \n
        HOST: \(host)\n
        """
        for (key,value) in request.allHTTPHeaderFields ?? [:] {
            logOutput += "\(key): \(value) \n"
        }
        if let body = request.httpBody {
            logOutput += "\n \(String(data: body, encoding: .utf8) ?? "")"
        }
        
        print(logOutput)
    }
    
    static func log(response: URLResponse?, data: Data?) {
        print("\n - - - - - - - - - - RESPONSE - - - - - - - - - - \n")
        defer { print("\n - - - - - - - - - -  END - - - - - - - - - - \n") }
        
        guard let response = response as? HTTPURLResponse else {
            return
        }
        
        var logOutput = "Status Code == \(response.statusCode) \n\n Headers\n\n"
        for (key,value) in response.allHeaderFields {
            logOutput += "\(key): \(value) \n"
        }
        
        if let data = data {
            logOutput += "\n \(String(data: data, encoding: .utf8) ?? "")"
        }
        print(logOutput)
    }
}
