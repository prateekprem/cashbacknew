//
//  JRWServices.swift
//  Jarvis
//
//  Created by Prakash Raj Jha on 06/08/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_network_ios

typealias JRWPJSONDictionary = [String:Any]
typealias JRWPServiceCompletion = (_ sucess: Bool, _ response: [String: Any]?, _ error: Error?) -> Swift.Void

public enum JRWPServiceMethod: String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case delete  = "DELETE"
    
    func requestWith(path: String, param: [String: Any]?, headers: [String: String]) -> URLRequest? {
        
        if let url = URL(string: path) {
            let request         = NSMutableURLRequest(url: url)
            request.httpMethod  = self.rawValue
            for hEntity in headers {
                request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
            }
            
            if param != nil && self != .get {
                request.httpBody = try! JSONSerialization.data(withJSONObject: param!, options: [])
            }
            return request as URLRequest
        }
        return nil
    }
    
    func requestWithStringParam(path: String, param: String?, headers: [String: String]) -> URLRequest? {
        if let url = URL(string: path) {
            let request         = NSMutableURLRequest(url: url)
            request.httpMethod  = self.rawValue
            for hEntity in headers {
                request.setValue(hEntity.value, forHTTPHeaderField: hEntity.key)
            }
            
            if param != nil && self != .get {
                request.httpBody = param?.data(using: .utf8)
                #if DEBUG
                let theJSONText = String(data: request.httpBody!, encoding: .utf8)
                print("Path = \(url)\nParam = \(theJSONText!)")
                #endif
            }
            return request as URLRequest
        }
        return nil
    }
    
}




//******************** JRSERVICE *********************//
class WalletApiModel
{
    var method: JRWPServiceMethod
    var url: String
    var param: [String: Any]?
    var additionalParams: [String : AnyHashable]
    var header: [String : String]
    var body : String?
    var verticle: JRVertical
    var userFacing: JRUserFacing
    var timeoutInterval: Double?
    
    init(method: JRWPServiceMethod, url: String, param: [String: Any]?,
         additionalParams: [String : AnyHashable], header: [String : String],
         verticle: JRVertical, userFacing: JRUserFacing, body : String? = nil, timeoutInterval : Double? = nil)
    {
        self.method = method
        self.url = url
        self.param = param
        self.additionalParams = additionalParams
        self.header = header
        self.userFacing = userFacing
        self.verticle = verticle
        self.body = body
        self.timeoutInterval = timeoutInterval
    }
}


enum WalletApi {
    case walletService(apiModel : WalletApiModel)
}

extension WalletApi: JRRequest {
    
    var baseURL: String? {
        switch self
        {
        case .walletService(let apiModel) :
            return apiModel.url
        }
    }
    
    var path: String? {
         return ""
    }
    
    var httpMethod: JRHTTPMethod {
        switch self{
        case .walletService(let apiModel) :
            if let method = JRHTTPMethod(rawValue: apiModel.method.rawValue)
            {
                return method
            }
            return .post
        }
    }
    
    var dataType: JRDataType {
        switch self {
        case .walletService(let apiModel):
            if let mBody = apiModel.body, mBody.count > 0 {
                return .Data
            }
            
            return .Json
        }
    }
    
    var requestType: JRHTTPRequestType {
        
        switch self {
            
        case .walletService(let apiModel):
            if let params = apiModel.param, params.count > 0
            {
                return .requestParameters(
                    
                    bodyParameters: apiModel.param,
                    
                    bodyEncoding: .jsonEncoding(bodyEncodingStyle: JRBodyEncodingStyle.jsonEncoded) ,
                    
                    urlParameters: [:])
            }
            
            if let mBody = apiModel.body, mBody.count > 0 {
                return JRHTTPRequestType.requestParameters(bodyParameters: mBody,
                                                                  bodyEncoding: JRParameterEncoding.jsonEncoding(bodyEncodingStyle: JRBodyEncodingStyle.rawString),
                                                                  urlParameters: nil)
            }
            
            return .request
            
        }}
    
    
    var headers: JRHTTPHeaders? {
        switch self{
        case .walletService(let apiModel):
           return apiModel.header
        }
    }
    
    var defautlURLParams: JRParameters? {
        return [:]
    }
    
    var defautlJsonParams: JRParameters? {
        return [:]
    }
    
    var defautlHeaderParams: JRHTTPHeaders? {
        return [:]
    }
    
    var verticle: JRVertical {
        switch self
        {
        case .walletService( _) :
            //return JRVerticle(rawValue: apiModel.verticle.rawValue)!
            return JRVertical.wallet
        }
    }
    
    var timeoutInterval: JRTimeout? {
        switch self
        {
        case .walletService(let apiModel) :
            return JRTimeout(timeoutValue: apiModel.timeoutInterval ?? 60)
        }
    }
    
    var isUserFacing: JRUserFacing {
        switch self
        {
        case .walletService(let apiModel) :
            if let userFacing = JRUserFacing(rawValue: apiModel.userFacing.rawValue)
            {
                return userFacing
            }
            return .none
        }
    }
    
    var printDebugLogs: Bool {
        return false
    }
}

class JRWServices {
    
    class func execute(model: WalletApiModel, completion: @escaping JRWPServiceCompletion) {
        let walletRequest = WalletApi.walletService(apiModel: model)
        
        let router = JRRouter<WalletApi>()
        router.request(type: JRDataType.self , walletRequest) { (responseObject, response, error) in
            // process response
            DispatchQueue.main.async {
                let isResp = responseObject != nil
                if isResp { print(responseObject!) }
                
                if model.verticle == JRVertical.acceptPayment {
                    if let mResp = responseObject as? [String: Any], isResp {
                        if let statusCode = mResp["statusCode"] as? String, (statusCode == "UMP-400" || statusCode == "UMP-401") {
                            let error = NSError(domain: "jr_ac_sessionTimedOut".localized, code: Int(-1), userInfo:[NSLocalizedDescriptionKey: "jr_ac_sessionExpiredMessage".localized])
                            completion (false, nil, error)
                            return
                        }
                    }
                }
                
                if let mResp = responseObject as? [String: Any] {
                    completion(isResp, mResp, error)
                } else if let mResp = responseObject {
                    completion(isResp, ["data": mResp], error)
                } else {
                    completion(isResp, nil, error)
                }
            }
        }
    }
    
    class func executeAPIWith(method: JRWPServiceMethod, urlS: String, param: [String: Any]?, isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown,additionalParams params: [String : AnyHashable] = [:],
                              header: [String : String],timeoutInterval : Double? = nil, completion: @escaping JRWPServiceCompletion) {
        
        if let pr = param {
            print("url : \(urlS) \n heade : \(header) \n param \(pr) ")
        } else {
            print("url : \(urlS) \n heade : \(header)")
        }
        
//        if !JRUtilities.isNetworkReachable() { // NO Network
//            completion(false, nil, NSError(domain:"No Network", code: -1, userInfo: nil))
//            return
//        }
        
        let apiModel = WalletApiModel(method: method, url: urlS, param: param,additionalParams: [:], header:header, verticle: vertical, userFacing: userFacing, timeoutInterval : timeoutInterval)
        JRWServices.execute(model: apiModel, completion: completion)
    }
    
    // If data is passed as String insted of Params Dict
    class func executeAPIWithDataString(method: JRWPServiceMethod, urlS: String, dataString:String?, isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown,additionalParams params: [String : AnyHashable] = [:],
                              header: [String : String],timeoutInterval : Double? = nil, completion: @escaping JRNetworkRouterCompletion) {
//        if !JRUtilities.isNetworkReachable() { // NO Network
//            completion(false, nil, NSError(domain:"No Network", code: -1, userInfo: nil))
//            return
//        }
        
        let apiModel = WalletApiModel(method: method, url: urlS, param:nil ,additionalParams: [:], header:header, verticle: vertical, userFacing: userFacing, body:dataString, timeoutInterval : timeoutInterval)
        
        let walletRequest = WalletApi.walletService(apiModel: apiModel)
        
        let router = JRRouter<WalletApi>()
        router.request(type: JRDataType.self , walletRequest) { (responseObject, response, error) in
            // process response
            DispatchQueue.main.async {
                completion(responseObject, response, error)
            }
        }
    }
    
    class func getAPIWith(urlS: String, param: [String: Any]?, header: [String : String], isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown ,additionalParams params: [String : AnyHashable] = [:],timeoutInterval : Double? = nil, completion: @escaping JRWPServiceCompletion) {
        JRWServices.executeAPIWith(method: .get, urlS: urlS, param: param, isResponseUserFacing:userFacing, verticalName:vertical ,additionalParams:params, header: header,timeoutInterval: timeoutInterval, completion: completion)
    }
    
    class func postAPIWith(urlS: String, param: [String: Any]?, header: [String : String], isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown ,additionalParams params: [String : AnyHashable] = [:],timeoutInterval : Double? = nil, completion: @escaping JRWPServiceCompletion) {
        JRWServices.executeAPIWith(method: .post, urlS: urlS, param: param,isResponseUserFacing:userFacing, verticalName:vertical ,additionalParams:params, header: header,timeoutInterval: timeoutInterval, completion: completion)
    }
    
    class func postAPIWithDataString(urlS: String, dataString: String?, header: [String : String], isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown ,additionalParams params: [String : AnyHashable] = [:],timeoutInterval : Double? = nil, completion: @escaping JRNetworkRouterCompletion) {
        JRWServices.executeAPIWithDataString(method: .post, urlS: urlS, dataString: dataString,isResponseUserFacing:userFacing, verticalName:vertical ,additionalParams:params, header: header,timeoutInterval: timeoutInterval, completion: completion)
    }
    
    class func putAPIWith(urlS: String, param: [String: Any]?, header: [String : String], isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown ,additionalParams params: [String : AnyHashable] = [:],timeoutInterval : Double? = nil, completion: @escaping JRWPServiceCompletion) {
        JRWServices.executeAPIWith(method: .put, urlS: urlS, param: param,isResponseUserFacing:userFacing, verticalName:vertical ,additionalParams:params, header: header,timeoutInterval: timeoutInterval, completion: completion)
    }
    
    class func deleteAPIWith(urlS: String, param: [String: Any]?, header: [String : String], isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown ,additionalParams params: [String : AnyHashable] = [:],timeoutInterval : Double? = nil, completion: @escaping JRWPServiceCompletion) {
        JRWServices.executeAPIWith(method: .delete, urlS: urlS, param: param,isResponseUserFacing:userFacing, verticalName:vertical ,additionalParams:params, header: header,timeoutInterval: timeoutInterval, completion: completion)
    }

}
