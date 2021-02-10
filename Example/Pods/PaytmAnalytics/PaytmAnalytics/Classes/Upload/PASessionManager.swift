//
//  PASessionManager.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 05/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//
import Foundation

class PASessionManager: NSObject {
    
    static let kTimeOut = 150
    let defaultSession = URLSession(configuration: URLSessionConfiguration.default)
    
    func sendRequest(requestTuple: PARequestTuple, timeout: Int = kTimeOut, withCompletionHandler completion: @escaping (_ success: Bool, _ responseDate: Data?)->()) {
        //make signal end point Url
        let dataTaskUrl: URL? = URL.init(string: requestTuple.inUrl)
        guard let url = dataTaskUrl else { return }
        
        //Initiatize request
        let dataTaskRequest: NSMutableURLRequest = NSMutableURLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval(timeout))
        
        //Add cookies if required
        if requestTuple.isCookiesRequired {
            let cookieUrl : NSURL = NSURL.init(string: "\(url.scheme ?? PAConstant.EMPTY_STRING)://\(url.host ?? PAConstant.EMPTY_STRING)")!
            let cookieArray : [HTTPCookie] = HTTPCookieStorage.shared.cookies(for: cookieUrl as URL)!
            let cookiesDic : Dictionary? = HTTPCookie.requestHeaderFields(with: cookieArray)
            
            if(cookiesDic != nil){
                if let cookie = cookiesDic?[PAConstant.COOKIE_HEADER] {
                    dataTaskRequest.addValue(cookie, forHTTPHeaderField: PAConstant.COOKIE_HEADER)
                }
            }
        }
        
        //set content type
        let contentType: String
        switch requestTuple.inContentType {
        case .eRequestJsonType:
            contentType = "application/json"
        case .eRequestXWWWFormType:
            contentType = "application/x-www-form-urlencoded"
        case .eRequestTextPlainType:
            contentType = "text/plain"
        case .eRequestNoneType:
            contentType = PAConstant.EMPTY_STRING
        }
        if contentType.lengthOfBytes(using: .utf8) > 0 {
            dataTaskRequest.addValue(contentType, forHTTPHeaderField: "Content-Type")
        }
        
        //set request method
        dataTaskRequest.httpMethod = requestTuple.inRequestType
        
        //Additional header dic
        for (key,value) in requestTuple.inHeaderDic {
            dataTaskRequest.addValue(value, forHTTPHeaderField: key)
        }
        
        //serialize body
        if let inJsonDic = requestTuple.inJsonDic {
            do {
                if(requestTuple.inContentType == .eRequestJsonType) {
                    var jsonData: Data = try JSONSerialization.data(withJSONObject: inJsonDic as AnyObject)
                    
                    if requestTuple.isGzipRequired {
                        let data = jsonData
                        jsonData = try data.gzipped()
                        dataTaskRequest.addValue("gzip", forHTTPHeaderField: "Content-Encoding")
                    }
                    
                    dataTaskRequest.httpBody = jsonData
                } else {
                    dataTaskRequest.httpBody = (inJsonDic as! String).data(using: .utf8)
                }
            } catch  {
                PALogger.log(message: "[Signal Send] Data compression failed: error = \(error.localizedDescription)", andMessageType: .fail)
            }
        }
        
        //Service hit using data task
        let myDataTask = defaultSession.dataTask(with: dataTaskRequest as URLRequest, completionHandler: { (data, response, err) in
            //Invalidate session
            self.defaultSession.finishTasksAndInvalidate()
            
            if let httpResponse = response as? HTTPURLResponse {
                let didRequestFail = err != nil || !(httpResponse.statusCode >= 200 && httpResponse.statusCode < 300)
                
                PALogger.log(message: "[Signal Send] Sent signal events to backend: statusCode = \(httpResponse.statusCode)", andMessageType: didRequestFail ? .fail : .success)
                
                if didRequestFail {
                    completion(false, nil)
                }else{
                    completion(true, data)
                }
            }else{
                completion(false, nil)
            }
        })
        
        myDataTask.resume()
    }
}

enum PAContentType {
    
    case eRequestNoneType
    case eRequestJsonType
    case eRequestXWWWFormType
    case eRequestTextPlainType
}

enum APIResponseFormat {
    
    case defaultFormat
    case jsonFormat
}

typealias PARequestTuple = (inUrl: String, inJsonDic: AnyObject?, isCookiesRequired: Bool, inRequestType: String, inContentType: PAContentType, inHeaderDic: [String : String], isGzipRequired: Bool)
