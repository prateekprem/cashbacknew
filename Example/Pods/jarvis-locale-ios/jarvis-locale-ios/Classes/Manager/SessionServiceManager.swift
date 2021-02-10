//
//  SessionServiceManager.swift
//  JRLocalization
//
//  Created by Abhinav Kumar Roy on 01/05/18.
//  Copyright © 2018 One97. All rights reserved.

import Foundation
import UIKit

public enum enJRLocalizationRequestContentType{
    case eRequestNoneType
    case eRequestJsonType
    case eRequestXWWWFormType
    case eRequestTextPlainType
}

public enum APIResponseFormat{
    case defaultFormat
    case jsonFormat
}

public typealias JRLocalizationRequestTuple = (inUrl:String, inJsonDic:AnyObject?, isCookiesRequired : Bool, inRequestType : String, inContentType : enJRLocalizationRequestContentType, inHeaderDic : [String : String])

class SessionServiceManager : NSObject {
    
    let kTimeOut = 150
    
    func sendRequest(requestTuple : JRLocalizationRequestTuple, withCompletionHandler completion : @escaping (_ success : Bool,_ responseDate : Data?)->(),_ dataTaskHandler : (_ dataTask : URLSessionDataTask)->()){
        
        //url session
        let defaultSession = URLSession(configuration: URLSessionConfiguration.default, delegate: nil, delegateQueue: OperationQueue.main)
        
        //make data task Url
        let dataTaskUrl : URL? = URL.init(string: requestTuple.inUrl)
        
        //Request
        guard let url = dataTaskUrl else{
            return
        }
        
        //Initiatize request
        let dataTaskRequest : NSMutableURLRequest = NSMutableURLRequest.init(url: url, cachePolicy: NSURLRequest.CachePolicy.useProtocolCachePolicy, timeoutInterval: TimeInterval(kTimeOut))
        
        //Add cookies if required
        if requestTuple.isCookiesRequired {
            let cookieUrl : NSURL = NSURL.init(string: "\(url.scheme ?? "")://\(url.host ?? "")")!
            let cookieArray : [HTTPCookie] = HTTPCookieStorage.shared.cookies(for: cookieUrl as URL)!
            let cookiesDic : Dictionary? = HTTPCookie.requestHeaderFields(with: cookieArray)
            if(cookiesDic != nil){
                if let cookie = cookiesDic?["Cookie"]{
                    dataTaskRequest.addValue(cookie, forHTTPHeaderField: "Cookie")
                }
            }
        }
        
        //set content type
        let contentType : String?
        switch requestTuple.inContentType {
        case .eRequestJsonType:
            contentType = "application/JSON"
            break
            
        case .eRequestXWWWFormType:
            contentType = "application/x-www-form-urlencoded"
            break
        
        case .eRequestTextPlainType:
            contentType = "text/plain"
            break
        case .eRequestNoneType:
            contentType = ""
            break
        }
        if (contentType?.lengthOfBytes(using: String.Encoding.utf8))! > 0 {
            dataTaskRequest.addValue(contentType!, forHTTPHeaderField: "Content-Type")
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
                if(requestTuple.inContentType == .eRequestJsonType){
                    let jsonData : Data = try JSONSerialization.data(withJSONObject: inJsonDic as AnyObject, options: JSONSerialization.WritingOptions.prettyPrinted)
                    dataTaskRequest.httpBody = jsonData
                }else{
                    dataTaskRequest.httpBody = (inJsonDic as! String).data(using: .utf8)
                }
            } catch  {
                print(error)
            }
        }
        
        //Service hit using data task
        let myDataTask = defaultSession.dataTask(with: dataTaskRequest as URLRequest, completionHandler: { (data, response, err) in
            if let httpResoonse = response as? HTTPURLResponse{
                if (err != nil || httpResoonse.statusCode != 200){
                    completion(false, nil)
                }else{
                    completion(true, data)
                }
            }else{
                completion(false, nil)
            }
        })
        dataTaskHandler(myDataTask)
        myDataTask.resume()
        
    }
}
