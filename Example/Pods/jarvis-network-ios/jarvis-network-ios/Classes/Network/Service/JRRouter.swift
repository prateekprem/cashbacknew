//
//  JRRouter.swift
//  JRNetworkRouter
//
//  Created by Shwetabh Singh on 02/11/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

public typealias JRNetworkRouterCompletion = (_ data: Any?,_ response: URLResponse?,_ error: Error?) -> Void
public typealias JRLoginInProgressCompletion = (_ isLoginInProgress: Bool) -> Void
typealias JRNetworkInteractorCompletion<T> = (_ data: ResponseData<T>?,_ response: URLResponse?,_ error: Error?) -> Void

open class JRRouter<Request: JRRequest> {
    
    var reachability: Reachability?
    
    public var loginInProgressCompletion: JRLoginInProgressCompletion?  // invoked in case of auth error to let concurrent api calls keep track of whether the api has to hit again.
    
    public init() {
        reachability = Reachability()
    }
    
    /**
     Function call for requesting the response for Api.
     
     - parameter type:  JRDataType.Json for Dictionary. JRDataType.Data for raw data.
     Codable model type for parsed response object.
     - parameter route: JRRequest type for making the request.
     - parameter completion: Completion handler containg the response.
     */
    @discardableResult
    public func request<T: Codable>(type: T.Type?, _ route: Request, completion: @escaping JRNetworkRouterCompletion) -> RequestReferenceable? {
        return request(route){ (data: ResponseData<T>?, response, error) in
            completion(data?.data(), response, error)
        }
    }
    
    /**
     Function call to get request Object
     
     - parameter route: JRRequest type for making the request.
     */
    @discardableResult
    public func getRequestInfo(_ route: Request)  throws -> URLRequest {
        let request = try self.buildRequest(from: route)
        return request
    }
    
    @discardableResult
    func request<T: Codable>(_ route: Request, completion: @escaping JRNetworkInteractorCompletion<T>) -> RequestReferenceable? {
        do {
            // return reachability error if no internet connection
            if let connectionStatus = reachability?.connection, connectionStatus == .none, route.bypassNetworkCheck == false {
                RequestCacheArsenal.shared.add(request: route, with: completion)
                completion (nil, nil, JRNetworkUtility.reachabilityError())
                return nil
            }
            
            var request = try self.buildRequest(from: route)
            #if DEBUG
            request = JRLinkExchangeManager.shared.reqAfterCheckLink(request:request)
            if route.printDebugLogs {
                JRNetworkLogger.log(request: request)
            }
            #endif
            
            return JRDataInteractor.shared.requestData(route, request, completion: completion, loginInProgressCompletion: self.loginInProgressCompletion)
        } catch {
            completion(nil, nil, error)
        }
        
        return nil
    }
    
    //MARK:- request builder helper methods
    
    fileprivate func setRequestTimeout(_ request: inout URLRequest, _ route: JRRequest) {
        let jrTimeout: JRTimeout = route.timeoutInterval ?? JRTimeout.sixty
        request.timeoutInterval = jrTimeout.timeoutValue
    }
    
    fileprivate func buildRequest(from route: Request) throws -> URLRequest {
        
        do {
        var request =  try URLRequest(url: route.url())
        request.httpMethod = route.httpMethod.rawValue
        self.setRequestTimeout(&request, route)
            
        request.httpShouldUsePipelining = route.usePipelining
        request.httpShouldHandleCookies = route.httpShouldHandleCookies
            
        self.addHeaders(route.headers, request: &request) //Adding default headers params to request
        self.addHeaders(route.defautlHeaderParams, request: &request)
        self.addCorrelationHeader(for: route, request: &request)
        
            switch route.requestType {
            case .request:
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
            case .requestParameters(let bodyParameters,
                                    let bodyEncoding,
                                    let urlParameters):
                
                try self.configureParameters(route, bodyParameters: bodyParameters,
                                             bodyEncoding: bodyEncoding,
                                             urlParameters: urlParameters,
                                             request: &request)
            }
            return request
        } catch {
            throw error
        }
    }
    
    fileprivate func configureParameters(_ route: Request, bodyParameters: Any?,
                                         bodyEncoding: JRParameterEncoding,
                                         urlParameters: JRParameters?,
                                         request: inout URLRequest) throws {
        do {
            guard let bodyDict = bodyParameters as? JRParameters else {
                let updatedURLParams = self.mergeParams(urlParameters, defaultParams: route.defautlURLParams)
                try bodyEncoding.encode(urlRequest: &request, route: route,
                                        bodyParameters: bodyParameters, urlParameters: updatedURLParams)
                return
            }
            let updatedBodyParams = self.mergeParams(bodyDict, defaultParams: route.defautlJsonParams)
            let updatedURLParams = self.mergeParams(urlParameters, defaultParams: route.defautlURLParams)
            try bodyEncoding.encode(urlRequest: &request, route: route,
                                    bodyParameters: updatedBodyParams, urlParameters: updatedURLParams)
        } catch {
            throw error
        }
    }
    
    fileprivate func mergeParams(_ currentParams: JRParameters?, defaultParams: JRParameters?) ->  JRParameters? {
        if let cParams = currentParams {
            if let dParams = defaultParams {
                return cParams.merging(dParams) { $1 }
            }
            return cParams
        }
        return defaultParams
    }
    
    fileprivate func addHeaders(_ additionalHeaders: JRHTTPHeaders?, request: inout URLRequest) {
        guard let headers = additionalHeaders else { return }
        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }
    }
    
    fileprivate func addCorrelationHeader(for route: JRRequest, request: inout URLRequest) {
        let correlationID = CorrelationIDGenerator.sharedInstance.correlationId
        request.setValue(correlationID, forHTTPHeaderField: CorrelationIDGenerator.correlationHeaderKey)
    }
}
