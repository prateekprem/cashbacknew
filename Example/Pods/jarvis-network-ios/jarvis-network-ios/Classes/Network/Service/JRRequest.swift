//
//  JRRequestData.swift
//  Jarvis
//
//  Created by Kushalpal Singh on 09/10/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation


public struct JRNetworkConfig {
    static var defautlURLParams: JRParameters?
    static var defautlJsonParams: JRParameters?
    static var defautlHeaderParams: JRHTTPHeaders?
}


//This defines which status code should not be handled by router
public enum JRHTTPErrorCodes : Int {
    case success = 200
    case badRequest = 400
    case accessDenied = 401
    case forbidden = 403
    case notFound = 404
    case gone = 410
    case preConditionFailed = 412
    case excecutionFailed = 417
    case tooManyRequest = 429
    case internalServerError = 500
    case badGateway = 502
    case serviceUnavailable = 503
    case gatewayTimeout = 504
    case all = 10479721
}

//This defines the type of HTTP request
public enum JRHTTPMethod : String {
    case get     = "GET"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case head    = "HEAD"
}

/**
 Define the request type.
 case Json : For Json response
 case Data : For Data response
 case CodableModel : For Response Model conforming to Codable
 */
public enum JRDataType:String, Codable {
    case Json
    case Data
    case CodableModel
}

/**
 Define the request type.
 case request : For request with no body or url encoding
 case requestParameters : For request with body or url encoding
 */
public enum JRHTTPRequestType{
    case request
    
    case requestParameters(bodyParameters: Any?,
        bodyEncoding: JRParameterEncoding,
        urlParameters: JRParameters?)
}


@objc public enum JRUserFacing: Int {
    case none
    case userFacing
    case silent
}

/**
 Defines the timeout of the URLRequest.
 The default value is 60.
 */
public enum JRTimeout {
    case thirty
    case sixty
    case ninety
    case oneTwenty
    case oneFifty
    case oneEighty
    case customValue(timeout: Double)
    
    var timeoutValue: Double {
        switch self {
        case .thirty:
                return 30
        case .sixty:
                return 60
        case .ninety:
                return 90
        case .oneTwenty:
                return 120
        case .oneFifty:
                return 150
        case .oneEighty:
                return 180
        case .customValue(let timeout):
                return timeout
        }
    }
    
    public init(timeoutValue: Double) {
        switch timeoutValue {
        case 30:
            self = .thirty
        case 60:
            self = .sixty
        case 90:
            self = .ninety
        case 120:
            self = .oneTwenty
        case 150:
            self = .oneFifty
        default:
            self = .customValue(timeout: timeoutValue)
        }
    }
}

/**
 Additional Request params to send
 */
public enum JRHawkEyeAdditionalParam : String{
    case mid = "mid"
    case transactionId = "transactionId"
    case flowName = "flowName"
    case functionName = "functionName"
    case lineNumber = "lineNumber"
    case screenName = "screenName"
    case correlationId = "correlationId"
    case qrData = "qrData"
    case pid = "PID"
    case categoryID = "categoryId"
}

/**
 Protocol to implement for making JRRouter request for data.
 Implement properties to customize the request.
 */

public protocol JRRequest {
    
    var baseURL: String? { get }
    var path: String? { get }
    var httpMethod: JRHTTPMethod { get }
    var requestType: JRHTTPRequestType { get }
    
    var headers: JRHTTPHeaders? { get }
    
    var dataType: JRDataType { get }
    
    var defautlURLParams: JRParameters? { get }
    var defautlJsonParams: JRParameters? { get }
    var defautlHeaderParams: JRHTTPHeaders? { get }
    
    var exculdeErrorCodes: Set<Int> {get}
    
    var verticle: JRVertical {get}
    var isUserFacing: JRUserFacing {get}
    
    var timeoutInterval: JRTimeout? {get}
    
    var printDebugLogs: Bool {get}
    var bypassNetworkCheck: Bool {get}
    
    var hawkEyeAdditionalParams : [JRHawkEyeAdditionalParam : Any] {get}
    var usePipelining: Bool {get}
    var isContentLengthRequired: Bool {get}
    
    var httpShouldHandleCookies: Bool {get}
}

public extension JRRequest {
    
    func url() throws -> URL {
        let base = baseURL ?? ""
        let pathUrl = path ?? ""
        do {
            guard let url = URL.init(string: "\(base)\(pathUrl)") else {
                throw JRNetworkError.urlEncodingFailed
            }
            return url
        } catch {
            throw error
        }
    }
    
    var httpMethod: JRHTTPMethod {
        return .get
    }
    
    var dataType: JRDataType {
        return JRDataType.Json
    }
    
    var requestType: JRHTTPRequestType {
        return .request
    }
    
    var defautlURLParams: JRParameters? {
        return JRNetworkConfig.defautlURLParams
    }
    var defautlJsonParams: JRParameters? {
        return JRNetworkConfig.defautlJsonParams
    }
    var defautlHeaderParams: JRHTTPHeaders? {
        return JRNetworkConfig.defautlHeaderParams
    }
    
    var exculdeErrorCodes: Set<Int> {
        return []
    }
    
    var verticle: JRVertical {
        return .unknown
    }
    
    var isUserFacing: JRUserFacing {
        return .none
    }
    
    var timeoutInterval: JRTimeout? {
        return .sixty
    }
    
    var printDebugLogs: Bool {
        return false
    }
    
    var bypassNetworkCheck: Bool {
        return false
    }
    
    var hawkEyeAdditionalParams : [JRHawkEyeAdditionalParam : Any] {
        return [:]
    }

    var usePipelining: Bool {
        return false
    }

    var isContentLengthRequired: Bool {
        return true
    }
    
    var httpShouldHandleCookies: Bool {
        return true
    }
}

@objc public enum JRVertical : Int{
    case unknown
    case cst
    case profile
    case bank
    case payments
    case nativePayment
    case home
    case moneyTransfer
    case upi
    case rechargeAndUtilities
    case chat
    case wallet
    case hotel
    case o2o
    case travel
    case marketplace
    case kyc
    case common
    case acceptPayment
    case cashback
    case insurance
    case flights
    case bus
    case trains
    case forex
    case gold
    case postpaid
    case channel
    case zomato
    case auth
    case travelPass
    case paytmCreditcard
    case h5

    public var name : String{
        get{
            switch self{
            case .unknown: return "unknown"
            case .cst: return "cst"
            case .profile: return "profile"
            case .bank: return "bank"
            case .payments: return "payments"
            case .nativePayment: return "nativePayment"
            case .home: return "home"
            case .moneyTransfer: return "moneyTransfer"
            case .upi: return "upi"
            case .rechargeAndUtilities: return "rechargeAndUtilities"
            case .chat: return "chat"
            case .wallet: return "wallet"
            case .hotel: return "hotel"
            case .o2o: return "o2o"
            case .travel: return "travel"
            case .marketplace: return "marketplace"
            case .kyc: return "kyc"
            case .common: return "common"
            case .acceptPayment: return "acceptPayment"
            case .cashback: return "cashback"
            case .insurance: return "Insurance"
            case .flights: return "flights"
            case .bus: return "bus"
            case .trains: return "trains"
            case .forex: return "forex"
            case .gold : return "gold"
            case .postpaid : return "postPaid"
            case .channel: return "channel"
            case .zomato: return "zomato"
            case .auth: return "auth"
            case .travelPass: return "travelPass"
            case .paytmCreditcard: return "paytmCreditcard"
            case .h5: return "H5"
            }
        }
    }
}

