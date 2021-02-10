//
//  JRNetworkAnalytics.swift
//  jarvis-locale-ios
//
//  Created by Shwetabh Singh on 19/12/18.
//

import Foundation

public protocol JRDebugAnalyticsProtocol {
    func sendAnalytics(timeInterval: TimeInterval?, data: Data?, urlResponse: URLResponse?, error: Error?, urlRequest: URLRequest?, route: JRRequest?, metrics: URLSessionTaskMetrics?, additionalParams : [JRHawkEyeAdditionalParam : Any]?)
    func networkGetDeviceId() -> String
}

public class JRNetworkAnalytics {
    
    public static let shared = JRNetworkAnalytics()
    public var delegate: JRDebugAnalyticsProtocol?
    
    private init() {}
    
    // JRNetworkAnalytics.deviceID
    class var deviceID: String? {
        return JRNetworkAnalytics.shared.delegate?.networkGetDeviceId()
    }
    
    func sendADataToAnalytics(timeInterval: TimeInterval?, data: Data?, urlResponse: URLResponse?, error: Error?, urlRequest: URLRequest?, route: JRRequest?, metrics: URLSessionTaskMetrics?) {
        
        guard let route = route else { return }
        let correlationID: String = urlRequest?.corelationId ?? ""
        
        var additionParam = route.hawkEyeAdditionalParams
        additionParam[.correlationId] = correlationID
        
        self.delegate?.sendAnalytics(timeInterval: timeInterval, data: data, urlResponse: urlResponse, error: error, urlRequest: urlRequest, route: route, metrics: metrics, additionalParams: additionParam)
    }
}
