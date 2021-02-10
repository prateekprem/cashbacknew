//
//  JRNetworkResponseHandler.swift
//  MyTestingApp
//
//  Created by Shwetabh Singh on 26/10/18.
//  Copyright © 2018 Shwetabh Singh. All rights reserved.
//

import Foundation
import jarvis_locale_ios

let JRErrorCodeGlobal = 007007
let JRNoNetworkError = -1009
let JRErrorCodeJsonError = 003003
let JRErrorCodeAuthorizationFailed = 410
let JRErrorCodeBadRequest = 400

protocol JRProcessResponse {
    func processResponse<T:Codable>(route: JRRequest, request: URLRequest, data: Data?, error: Error?, response: URLResponse?,completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?)
}

struct JRNetworkResponseHandler: JRProcessResponse {
    
    func processResponse<T:Codable>(route: JRRequest, request: URLRequest, data: Data?, error: Error?, response: URLResponse?,completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?) {
        
        if shouldBypassProcessing(route: route, response: response) {
            completion(.any(data), response, error)
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
            return
        } else {
            let handledForSpecificStatusCodes = handleResponseForSpecificErrorCases(route: route, request: request, data: data, error: error, response: response, completion: completion,loginInProgressCompletion: loginInProgressCompletion)
            
            if !handledForSpecificStatusCodes {
                processResponseBasedOnExpectedReturnType(route: route, data: data, error: error, response: response, completion: completion, loginInProgressCompletion: loginInProgressCompletion)
            }
        }
        
    }
    
    private func processResponseBasedOnExpectedReturnType<T: Codable>(route: JRRequest, data: Data?, error: Error?, response: URLResponse?,completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?) {
        
        var processedData : ResponseData<T>?
        var errorIfAny: Error? = error
        
        defer {
            completion(processedData, response, errorIfAny)
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
        }
        
        guard let data = data else {
            processedData = nil
            return
        }
        
        switch route.dataType {
        case .Data:
            processedData = .any(data)
        case .Json:
            processedData = .any(data.jsonData())
        case .CodableModel:
            let result: (model: T?, error: Error?) = data.objectData()
            processedData = result.model == nil ? .any(data.jsonData()) : .codable(result.model)
            errorIfAny = result.error
        }
    }
    
    private func shouldBypassProcessing(route: JRRequest, response: URLResponse?) -> Bool {
        if route.exculdeErrorCodes.contains(JRHTTPErrorCodes.all.rawValue) {
            return true
        }
        guard let httpResponse = response as? HTTPURLResponse else {
            return false
        }
        return route.exculdeErrorCodes.contains(httpResponse.statusCode)
    }
    
    private func triggerLoginInProgressCompletion(_ loginInProgressCompletion: JRLoginInProgressCompletion?, withValue: Bool) {
        guard let loginCompletion = loginInProgressCompletion else {
            return
        }
        loginCompletion(withValue)
    }
    
    //MARK:- Error handling methods
    
    private func handleResponseForSpecificErrorCases<T: Codable>(route: JRRequest, request: URLRequest, data: Data?, error: Error?, response: URLResponse?,completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?) -> Bool {
        
        guard let statusCode = (response as? HTTPURLResponse)?.statusCode else {
            completion(.any(data), response, error)
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
            return true
        }
        
        // specific auth error handling for handling getAllActiveTokens api and checkForAbsenceOfUserTokensInData
        if JRAuthHandler.shared.checkForAuthError(urlRequest: request, urlResponse: response, data: data?.jsonData()) {
            handleAuth(route: route, request: request, data: data, error: error, response: response, completion: completion, loginInProgressCompletion: loginInProgressCompletion)
            return true
        }
        
        switch statusCode {
        case 499, 502, 503, 504 :   // defined case
            
            let jsonDict = isErrorObject(data: data)
            if let jsonDict = jsonDict as? [String: Any] {
                let statusObject = JRResponseStatus.init(dict: jsonDict)
                if statusObject.result == "failure" {
                    var message = ""
                    let url = urlByRemovingQueryParamsForRequest(request: request)
                    message = statusObject.response?.message?.appending("(\(url) | HTTP \(statusCode))") ?? ""
                    let globalError = JRNetworkUtility.customError(withDomain: statusObject.response?.title, code: JRErrorCodeGlobal, localizedDescriptionMessage: message, localizedFailureReasonErrorMessage: statusObject.response?.title)
                    completion(.any(data), response, globalError)
                    triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                    return true
                } else {
                    let globalError = errorForStatusCode(statusCode: statusCode, errorCode: JRErrorCodeGlobal, withRequest: request)
                    completion(.any(data), response, globalError)
                    triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                    return true
                }
            } else {
                let globalError = errorForStatusCode(statusCode: statusCode, errorCode: JRErrorCodeGlobal, withRequest: request)
                completion(nil, response, globalError)
                triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                return true
            }
            
        case 410, 401, 403: // auth error
            handleAuth(route: route, request: request, data: data, error: error, response: response, completion: completion,loginInProgressCompletion: loginInProgressCompletion)
            return true
            
        case 412:
            
            let jsonDict = isErrorObject(data: data)
            if let jsonDict = jsonDict as? [String: Any], let statusDict = jsonDict["status"] as? [String: Any] {
                let statusObject = JRResponseStatus.init(dict: statusDict)
                if statusObject.result == "failure" {
                    
                    let message = statusObject.response?.message ?? ""
                    let globalError = JRNetworkUtility.customError(withDomain: statusObject.response?.title, code: statusCode, localizedDescriptionMessage: message, localizedFailureReasonErrorMessage: statusObject.response?.title)
                    completion(nil, response, globalError)
                    triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                    return true
                }
            } else {
                let globalError = errorForStatusCode(statusCode: statusCode, errorCode: statusCode, withRequest: request)
                completion(nil, response, globalError)
                triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                return true
            }
            
        case 429:
            
            let errorMessage = apiFailureApologizeMethod(request: request, response: response)
            let domainError = JRNetworkUtility.customError(withDomain: "jr_ac_dataDisplayError".localized, code: 429, localizedDescriptionMessage: errorMessage, localizedFailureReasonErrorMessage: nil)
            completion(nil, response, domainError)
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
            return true
            
        case -1009, -1001: //JRNoNetworkError and time out condition
            
            var domainError: Error?
            if statusCode == JRNoNetworkError {
                domainError = JRNetworkUtility.customError(withDomain: "jr_ac_noInternetTitle".localized, code: JRNoNetworkError, localizedDescriptionMessage: "jr_ac_noInternetMsg".localized, localizedFailureReasonErrorMessage: nil)
            }
            else if (statusCode == -1001) // time out condition
            {
                domainError = JRNetworkUtility.customError(withDomain: "Request timed out", code: statusCode, localizedDescriptionMessage: "jr_ac_errorMessage".localized, localizedFailureReasonErrorMessage: nil)
            }
            completion(.any(data), response, domainError)
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
            return true
            
        default:
            // specific auth handling in case of error code returned from dataTaskWithRequest
            if let domainError = error as NSError?, domainError.code == -1012 {
                handleAuth(route: route, request: request, data: data, error: error, response: response, completion: completion, loginInProgressCompletion: loginInProgressCompletion)
                return true
            }
            
            var domainError: Error?
            if  statusCode == 200, let data = data, data.isEmpty {
                // case when the data is empty with status code 200
                return false
            }
            else if let data = data, !data.isEmpty {
                return false
            }
            else if let data = data, data.isEmpty, error == nil {
                // case when the data is empty with status code eg. 204
                return false
            }
            else
            {
                let domainErrorMessage = "jr_ac_requestCantProcessed".localized
                let domainErrormessage = "\(error?.localizedDescription ?? domainErrorMessage)"
                domainError = JRNetworkUtility.customError(withDomain: "An error has occurred", code: statusCode, localizedDescriptionMessage: domainErrormessage, localizedFailureReasonErrorMessage: nil)
                completion(nil, response, domainError)
                triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
                return true
            }
        }
        
        return false
    }
    
    private func handleAuth<T: Codable>(route: JRRequest, request: URLRequest, data: Data?, error: Error?, response: URLResponse?,completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?) {
        
        // trigger the second completion if login is in progress and we get simultaneous auth error for concurrent calls
        if  JRAuthHandler.shared.isLoginInProgress {
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: true)
        } else {
            triggerLoginInProgressCompletion(loginInProgressCompletion, withValue: false)
        }
        
        JRAuthHandler.shared.handleAuthError(urlRequest: request, urlResponse: response, data: data, route: route) { (request, response, success, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, error) in
            if success {
                self.updateAPIWithToken(route: route, urlRequest: request, urlResponse: response, updatedSSOToken: updatedSSOToken, expiredSSOToken: expiredSSOToken, updatedWalletToken: updatedWalletToken, expiredWalletToken: expiredWalletToken, error: error, completion: completion)
            } else {
                completion(nil, response, error)
            }
        }
    }
    
    //MARK:- Error handling utility methods
    
    private func errorForStatusCode(statusCode: Int, errorCode: Int, withRequest request: URLRequest?) -> NSError? {
        
        let errorInfo = self.errorInfoForStatusCode(statusCode, withRequest: request)
        if let domainName = errorInfo[NSLocalizedFailureReasonErrorKey] {
            return JRNetworkUtility.customError(withDomain: domainName, code: errorCode, errorInfoObject: errorInfo)
        }
        return nil
    }
    
    private func errorInfoForStatusCode(_ statusCode: Int, withRequest request: URLRequest?) -> [String : String] {
        
        var title = ""
        var message = ""
        
        switch statusCode {
            
        case 499 :
            title = "jr_ac_temporaryError".localized
            message = "jr_ac_takingLonger".localized
            
        case 502 :
            title = "jr_ac_serverError".localized
            message = "jr_ac_facingTechnicalIssue".localized
            
        case  503 :
            title = "jr_ac_serviceUnavailable".localized
            message = "jr_ac_facingTechnicalIssue".localized
            
        case 504 :
            title = "jr_ac_gatewayTimedOut".localized
            message = "jr_ac_facingTechnicalIssue".localized
            
        case 410, 401, 403 :
            title = "jr_ac_sessionTimedOut".localized
            message = "jr_ac_sessionTimeOutError".localized
            
        case 400:
            title = "jr_ac_somethingWentWrongWithExclaimation".localized
            message = "jr_ac_facingTechnicalIssue".localized
            
        default :
            break
        }
        
        if let request = request {
            let url = urlByRemovingQueryParamsForRequest(request: request)
            message = message.appending("(\(url) | HTTP \(statusCode))")
        }
        
        return [NSLocalizedFailureReasonErrorKey : title, NSLocalizedDescriptionKey : message]
    }
    
    private func urlByRemovingQueryParamsForRequest(request: URLRequest?) -> String {
        guard let request = request else {
            return ""
        }
        if let path = request.url?.path {
            let urlString = request.url?.host?.appending(path)
            return urlString == nil ? "" : urlString ?? ""
        }
        return ""
    }
    
    private func getErrorDescriptionAppendingURLAndStatusCode(errorDescription: String, url: String, statusCode: Int) -> String {
        return errorDescription.appending("(\(url) | HTTP \(statusCode))")
    }
    
    func apiFailureApologizeMethod(request: URLRequest?, response: URLResponse?) -> String {
        var apiMessage = ""
        let url = urlByRemovingQueryParamsForRequest(request: request)
        apiMessage.append(url)
        
        if let statusCode = (response as? HTTPURLResponse)?.statusCode {
            apiMessage.append("|HTTP \(statusCode)")
        }
        
        var errorMessage = "\("jr_ac_issueFacingMessage".localized) "
        errorMessage.append(apiMessage)
        return errorMessage
    }
    
    private func isErrorObject(data:Data?) -> Any?{
        let jsonData = data?.jsonData()
        return jsonData
    }
    
    private func shouldCheckHttpBodyForSessionExpire(forStr str : String?) -> Bool{
        guard let urlstr = str else {
            return false
        }
        return urlstr.contains("https://securegw.paytm.in/theia/api/v1/fetchQRPaymentDetails") || urlstr.contains("https://securegw.paytm.in/theia/api/v1/fetchPaymentOptions") || urlstr.contains("https://securegw.paytm.in/theia/HANDLER_IVR/CLW_APP_PAY/APP") || urlstr.contains("https://securegw.paytm.in/theia/api/v1/processTransaction")
    }
    
    func getUpdatedHttpBodyWithNewSSOToken(httpBody:Data?, token:String?)->[String : Any]?{
        do {
            guard let body = httpBody, var json = try JSONSerialization.jsonObject(with: body, options: []) as? [String:Any], var head = json["head"] as? [String:Any], let _ = head["token"] as? String else {
                return nil
            }
            head["token"] = token
            json["head"] = head
            return json
        } catch {
            return nil
        }
    }
    
    //MARK:- resume api method
    func updateAPIWithToken<T: Codable>(route: JRRequest, urlRequest: URLRequest?, urlResponse: URLResponse?, updatedSSOToken: String?, expiredSSOToken: String?, updatedWalletToken: String?, expiredWalletToken: String?,error: Error?, completion: @escaping JRNetworkInteractorCompletion<T>) {
        
        if  ( (updatedWalletToken != nil && expiredWalletToken != nil) || (updatedSSOToken != nil && expiredSSOToken != nil) ) {
            guard var request = urlRequest else {
                completion (nil, urlResponse, JRNetworkUtility.authorizationError())
                return
            }
            
            // updating url
            if let requestUrl = request.url {
                var updatedURLString = requestUrl.absoluteString
                if expiredSSOToken != nil && updatedURLString.range(of: expiredSSOToken!) != nil {
                    updatedURLString = updatedURLString.replacingOccurrences(of: expiredSSOToken!, with: updatedSSOToken!)
                }
                if expiredWalletToken != nil && updatedURLString.range(of: expiredWalletToken!) != nil {
                    updatedURLString = updatedURLString.replacingOccurrences(of: expiredWalletToken!, with: updatedWalletToken!)
                }
                request.url = URL(string: updatedURLString)
            }
            
            // updating headers
            if let httpHeaders = request.allHTTPHeaderFields {
                for (key , value) in httpHeaders {
                    if value == expiredSSOToken{
                        request.setValue(updatedSSOToken!, forHTTPHeaderField: key)
                    }
                    if value == expiredWalletToken{
                        request.setValue(updatedWalletToken!, forHTTPHeaderField: key)
                    }
                }
            }
            
            //Updating Body
            var updatedRequestType : JRHTTPRequestType?
            if expiredSSOToken != nil && shouldCheckHttpBodyForSessionExpire(forStr:urlRequest?.url?.absoluteString){
                if let updatdeHttpBody = getUpdatedHttpBodyWithNewSSOToken(httpBody:urlRequest?.httpBody, token:updatedSSOToken){
                    updatedRequestType = JRHTTPRequestType.requestParameters(bodyParameters: updatdeHttpBody, bodyEncoding: .jsonEncoding(bodyEncodingStyle: .jsonEncoded), urlParameters: nil)
                }
            }
            
            let routerObj = KungFu.refreshPanda(route: route, urlRequest: request, updatedRequestType: updatedRequestType)
            let router = JRRouter<KungFu>()
            router.request(routerObj, completion: completion)
        } else {
            completion (nil, urlResponse, JRNetworkUtility.authorizationError())
        }
    }

}

// MARK:- dummy enum for resume api

enum KungFu {
    case Panda (jrRequest: JRRequest)
    case refreshPanda (route: JRRequest, urlRequest: URLRequest?,updatedRequestType : JRHTTPRequestType?)
}

extension KungFu: JRRequest {
    var baseURL: String? {
        switch self {
        case .Panda(let obj):
            return obj.baseURL
        case .refreshPanda(_, let urlRequest, _):
            return urlRequest?.url?.absoluteString
        }
        
        
    }
    
    var defautlURLParams: JRParameters? {
        switch self {
        case .Panda(let obj):
            return obj.defautlURLParams
        case .refreshPanda:
            return nil
        }
    }
    
    var defautlJsonParams: JRParameters? {
        switch self {
        case .Panda(let obj):
            return obj.defautlJsonParams
        case .refreshPanda(let route,_,_):
            return route.defautlJsonParams
        }
    }
    
    var defautlHeaderParams: JRHTTPHeaders? {
        switch self {
        case .Panda(let obj):
            return obj.defautlHeaderParams
        case .refreshPanda(_, let urlRequest,_):
            return urlRequest?.allHTTPHeaderFields
        }
    }
    
    var exculdeErrorCodes: Set<Int> {
        switch self {
        case .Panda(let obj):
            return obj.exculdeErrorCodes
        case .refreshPanda(let route,_,_):
            return route.exculdeErrorCodes
        }
    }
    
    var path: String? {
        switch self {
        case .Panda(let obj):
            return obj.path
        case .refreshPanda:
            return nil
        }
    }
    
    var httpMethod: JRHTTPMethod {
        switch self {
        case .Panda(let obj):
            return obj.httpMethod
        case .refreshPanda(let route,_,_):
            return route.httpMethod
        }
    }
    
    var dataType: JRDataType {
        switch self {
        case .Panda(let obj):
            return obj.dataType
        case .refreshPanda(let route,_,_):
            return route.dataType
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self {
        case .Panda(let obj):
            return obj.requestType
        case .refreshPanda(let route,_,let updatedRequestType):
            switch route.requestType {
            case .request:
                return .request
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    _):
                if let updatedRequestType = updatedRequestType{
                    return updatedRequestType
                }
                return .requestParameters(bodyParameters: bodyParameters, bodyEncoding: bodyEncoding, urlParameters: nil)
            }
        }
    }
    
    var headers: JRHTTPHeaders? {
        switch self {
        case .Panda(let obj):
            return obj.headers
        case .refreshPanda:
            return nil
        }
    }
    
    var verticle: JRVertical {
        switch self {
        case .Panda(let obj):
            return obj.verticle
        case .refreshPanda(let route,_,_):
            return route.verticle
        }
    }
    
    var isUserFacing: JRUserFacing {
        switch self {
        case .Panda(let obj):
            return obj.isUserFacing
        case .refreshPanda(let route,_,_):
            return route.isUserFacing
        }
    }
    
    var timeoutInterval: JRTimeout? {
        switch self {
        case .Panda(let obj):
            return obj.timeoutInterval
        case .refreshPanda(let route,_,_):
            return route.timeoutInterval
        }
    }
}

