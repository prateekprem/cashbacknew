//
//  JRSFServices.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 26/06/20.
//

import Foundation
import jarvis_network_ios


public typealias JRSFAPICompletion = (_ sucess: Bool, _ response: [String: Any]?, _ error: Error?) -> Swift.Void



public enum JRSFServiceMethod: String {
    case get     = "GET"
    case post    = "POST"
}

public class JRSFApiModel {
    private(set) var method: JRSFServiceMethod
    private(set) var url: String
    private(set) var param: [String: Any]?
    private(set) var additionalParams: [String : AnyHashable]
    private(set) var header: [String : String]
    private(set) var body : String?
    private(set) var verticle: JRVertical
    private(set) var userFacing: JRUserFacing
    private(set) var timeoutInterval: Double?
    
    public init(method: JRSFServiceMethod, url: String,
         param: [String: Any]?,
         additionalParams: [String : AnyHashable],
         header: [String : String],
         verticle: JRVertical,
         userFacing: JRUserFacing,
         body : String? = nil,
         timeoutInterval : Double? = nil) {
        
        self.method           = method
        self.url              = url
        self.param            = param
        self.additionalParams = additionalParams
        self.header           = header
        self.userFacing       = userFacing
        self.verticle         = verticle
        self.body             = body
        self.timeoutInterval  = timeoutInterval
    }
}


class JRSFServices {
    class func execute(model: JRSFApiModel, completion: @escaping JRSFAPICompletion) {
        let hRequest = JRSFApiRequest.homeService(apiModel: model)
        
        let router = JRRouter<JRSFApiRequest>()
        router.request(type: JRDataType.self, hRequest) { (responseObject, response, error) in
            // process response
            let isResp = responseObject != nil
            if isResp { print(responseObject!) }
            
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


enum JRSFApiRequest {
    case homeService(apiModel: JRSFApiModel)
}

extension JRSFApiRequest: JRRequest {
    
    var baseURL: String? {
        switch self {
        case .homeService(let apiModel) :
            return apiModel.url
        }
    }
    
    var path: String? { return "" }
    
    var httpMethod: JRHTTPMethod {
        switch self{
        case .homeService(let apiModel) :
            if let method = JRHTTPMethod(rawValue: apiModel.method.rawValue) {
                return method
            }
            return .post
        }
    }
    
    var dataType: JRDataType {
        switch self {
        case .homeService(let apiModel):
            if let mBody = apiModel.body, mBody.count > 0 {
                return .Data
            }
            return .Json
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .homeService(let apiModel):
            if let params = apiModel.param, params.count > 0 {
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
        case .homeService(let apiModel):
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
        switch self {
        case .homeService( _) :
            return JRVertical.home
        }
    }
    
    var timeoutInterval: JRTimeout? {
        switch self
        {
        case .homeService(let apiModel) :
            return JRTimeout(timeoutValue: apiModel.timeoutInterval ?? 60)
        }
    }
    
    var isUserFacing: JRUserFacing {
        switch self {
        case .homeService(let apiModel) :
            if let userFacing = JRUserFacing(rawValue: apiModel.userFacing.rawValue) {
                return userFacing
            }
            return .none
        }
    }
    
    var printDebugLogs: Bool { return true }
}

