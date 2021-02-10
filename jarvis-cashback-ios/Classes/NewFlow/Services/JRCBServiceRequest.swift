//
//  JRCBServiceRequest.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 27/12/19.
//

import Foundation
import jarvis_network_ios

enum JRCBServiceRequest: JRRequest {
    case cashbackApi(apiModel: JRCBApiModel)
}

// All Protocols methods...
extension JRCBServiceRequest {
    var baseURL: String? {
        switch self {
        case .cashbackApi(let model):
            return model.apiUrlString
        }
    }
    
    var path: String? {
        switch self {
        case .cashbackApi(let model):
            return model.apiType.path
        }
    }

    var httpMethod: JRHTTPMethod {
        switch self {
        case .cashbackApi(let model):
            return model.reqMethod.httpMethod
        }
    }
    
    var dataType: JRDataType {
        switch self {
        case .cashbackApi(let model):
            return model.dType
        }
    }
    
    var defautlURLParams: JRParameters? { return nil }
    var defautlJsonParams: JRParameters? { return [:] }
    var defautlHeaderParams: JRHTTPHeaders? { return nil }
    
    var exculdeErrorCodes: Set<Int> {return []}
    
    var verticle: JRVertical {
        return JRVertical.cashback
    }
    var isUserFacing: JRUserFacing {
        return JRUserFacing.userFacing
    }
    
    var timeoutInterval: JRTimeout? { return .sixty }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .cashbackApi(let model):
            return JRHTTPRequestType.requestParameters(bodyParameters: model.body,
                                                       bodyEncoding: model.bodyEncoding,
                                                       urlParameters: model.param)
            
        }
    }
    
    
    var printDebugLogs: Bool { return true }
    
    var headers: JRHTTPHeaders? {
        switch self {
        case .cashbackApi(let model):
            return model.apiType.header
        }
    }
}
