//
//  JRDataInteractor.swift
//  JRNetworkRouter
//
//  Created by Shwetabh Singh on 02/11/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

class JRDataInteractor: NSObject, URLSessionTaskDelegate {
    static let shared = JRDataInteractor()
    private var collector = MetricsCollector()
    private let sslPinningManager = SSLPinningManager.shared

    private lazy var session: URLSession =  {
        URLSession.init(configuration: .default, delegate: self, delegateQueue: nil)
    }()
    
    
    private override init() {
        super.init()
    }
    
    func requestData<T:Codable>(_ route: JRRequest, _ urlRequest: URLRequest, completion: @escaping JRNetworkInteractorCompletion<T>, loginInProgressCompletion: JRLoginInProgressCompletion?) -> RequestReferenceable? {
        
        let requestStartTime : Date = Date()
        let uid = UUID()
        
        let task = session.dataTask(with: urlRequest, completionHandler: { (data, response, error) in
            
            #if DEBUG
            if route.printDebugLogs {
                JRNetworkLogger.log(response: response, data: data)
            }
            #endif
            
            guard (error as NSError?)?.code != NSURLErrorCancelled else { return }
            JRNetworkResponseHandler().processResponse(route: route, request: urlRequest, data: data, error: error, response: response, completion: {[weak self] (pData: ResponseData<T>?, pResponse, pError) in
                
                //Send HawkEye
                let responseTime = Date().timeIntervalSince(requestStartTime) * 1000
                if let statusCode = (pResponse as? HTTPURLResponse)?.statusCode, statusCode != 401 && statusCode != 403 && statusCode != JRErrorCodeAuthorizationFailed {
                    let jsonData = data?.jsonData()
                    var analyticsError: Error? = pError
                    if jsonData == nil && error == nil {
                        analyticsError = JRNetworkUtility.serializationFailedError(request: urlRequest, response: response)
                    }
                    let metrics = self?.collector.pop(id: uid)
                    JRNetworkAnalytics.shared.sendADataToAnalytics(timeInterval: responseTime, data: data, urlResponse: response, error: analyticsError, urlRequest: urlRequest, route: route, metrics: metrics)
                }
                
                completion(pData,pResponse,pError)
                
            }, loginInProgressCompletion: loginInProgressCompletion)
            
        })
        task.resume()
        collector.set(listner: task, for: uid)
        return RequestReference(task: task, corelationRefId: urlRequest.corelationId)
    }
    
    //MARK:- URLSessionTaskDelegate methods
    public func urlSession(_ session: URLSession, task: URLSessionTask, didFinishCollecting metrics: URLSessionTaskMetrics) {
        //TODO: hit the network tracker api here
        collector.push(metrics: metrics, for: task)
    }
}

extension JRDataInteractor: URLSessionDelegate {
     func urlSession(_ session: URLSession,
                     didReceive challenge: URLAuthenticationChallenge,
                     completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        sslPinningManager.handleUrlSession(session, didReceive: challenge, completionHandler: completionHandler)
    }
}
