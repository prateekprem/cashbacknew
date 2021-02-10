//
//  JRParameterEncoding.swift
//  Jarvis
//
//  Created by Kushalpal Singh on 10/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

public typealias JRParameters = [String:Any]

public typealias JRHTTPHeaders = [String:String]

/** Used for defining the URLRequest body encoding type.
 It can be Json serialized or a custom string.
 */
public enum JRBodyEncodingStyle {
    case jsonEncoded
    case stringEncoded
    case rawString
    case jsonEncodedWithOptions(options: JSONSerialization.WritingOptions)
    case stringEncodedWithAscii
}

/** Encoding errors.
    Used for throwing encoding exceptions
 */
public enum JRNetworkError : String, Error {
    case urlEncodingFailed = "URL encoding failed."
    case encodingFailed = "Parameter encoding failed."
    case missingURL = "URL is nil."
}

public enum JRParameterEncoding {
    
    case urlEncoding
    case jsonEncoding(bodyEncodingStyle: JRBodyEncodingStyle)
    case urlAndJsonEncoding(bodyEncodingStyle: JRBodyEncodingStyle)
    
    public func encode(urlRequest: inout URLRequest, route: JRRequest,
                       bodyParameters: Any?,
                       urlParameters: JRParameters?) throws {
        do {
            switch self {
            case .urlEncoding:
                guard let urlParameters = urlParameters else { return }
                try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                
            case .jsonEncoding(let bodyEncodingStyle):
                guard let bodyParameters = bodyParameters else { return }
                try JSONParameterEncoder().encode(urlRequest: &urlRequest, route: route, with: bodyParameters, and: bodyEncodingStyle)
                
            case .urlAndJsonEncoding(let bodyEncodingStyle):
                if let bodyParameters = bodyParameters {
                    try JSONParameterEncoder().encode(urlRequest: &urlRequest, route: route, with: bodyParameters, and: bodyEncodingStyle)
                }
                if let urlParameters = urlParameters {
                    try URLParameterEncoder().encode(urlRequest: &urlRequest, with: urlParameters)
                }
                
            }
        } catch {
            throw error
        }
    }
}

public struct URLParameterEncoder {
    public func encode(urlRequest: inout URLRequest, with parameters: JRParameters) throws {
        
        guard let url = urlRequest.url, let updatedUrl = url.append(params: parameters) else {
            throw JRNetworkError.missingURL
        }
        
        urlRequest.url = updatedUrl
        
        if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
            urlRequest.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        }
    }
}

public struct JSONParameterEncoder {
    public func encode(urlRequest: inout URLRequest, route: JRRequest, with parameters: Any, and encodingStyle: JRBodyEncodingStyle) throws {
        if let parameters = parameters as? [String:Any]  {
            if parameters.isEmpty {
                return
            }
        }
        
        if let parameters = parameters as? [Any]  {
            if parameters.isEmpty {
                return
            }
        }
        
        do {
            switch encodingStyle {
            case .jsonEncoded:
                let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
                urlRequest.httpBody = jsonAsData
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if route.isContentLengthRequired {
                    urlRequest.addValue(String(describing: jsonAsData.count) , forHTTPHeaderField: "Content-length")
                }
            case .stringEncoded:
                guard let bodyString = parameters as? [String:Any] else {
                    throw JRNetworkError.encodingFailed
                }
                let body = bodyString.stringWithKeyValuePairsAsGETParams()
                let stringAsData = body.data(using: .utf8)
                urlRequest.httpBody = stringAsData
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
                if route.isContentLengthRequired {
                    urlRequest.addValue(String(describing: stringAsData?.count) , forHTTPHeaderField: "Content-length")
                }
            case .rawString:
                guard let strParam = parameters as? String else {
                    throw JRNetworkError.encodingFailed
                }
                let stringAsData = strParam.data(using: .utf8)
                urlRequest.httpBody = stringAsData
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/json;charset=UTF-8", forHTTPHeaderField: "Content-Type")
                }
                if route.isContentLengthRequired {
                    urlRequest.addValue(String(describing: stringAsData?.count) , forHTTPHeaderField: "Content-length")
                }
            case .jsonEncodedWithOptions(let withOptions):
                let jsonAsData = try JSONSerialization.data(withJSONObject: parameters, options: withOptions)
                urlRequest.httpBody = jsonAsData
                urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
                if route.isContentLengthRequired {
                    urlRequest.addValue(String(describing: jsonAsData.count) , forHTTPHeaderField: "Content-length")
                }
            case .stringEncodedWithAscii:
                var mutableParams: [String: String] = [:]
                if let params = parameters as? [String: String] {
                    mutableParams = params
                }
                let parameterArray = mutableParams.map { (key, value) -> String in
                    let encodedKey = key.percentEncodedString
                    let encodedValue = value.percentEncodedString
                    let final = String(format:"%@=%@", encodedKey, encodedValue)
                    return final
                }
                let stringAsData = parameterArray.joined(separator: "&").data(using: String.Encoding.ascii)
                urlRequest.httpBody = stringAsData
                if urlRequest.value(forHTTPHeaderField: "Content-Type") == nil {
                    urlRequest.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
                }
                if route.isContentLengthRequired {
                    urlRequest.addValue(String(describing: stringAsData?.count) , forHTTPHeaderField: "Content-length")
                }
            }
        }  catch {
            throw JRNetworkError.encodingFailed
        }
    }
}


