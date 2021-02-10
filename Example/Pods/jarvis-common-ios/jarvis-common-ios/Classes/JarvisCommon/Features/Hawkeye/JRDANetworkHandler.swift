//
//  JRDANetworkManager.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 19/12/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import jarvis_network_ios
import jarvis_utility_ios

public class JRDANetworkHandler: JRDebugAnalyticsProtocol {

    public static var shared: JRDANetworkHandler = JRDANetworkHandler()
    
    public func sendAnalytics(timeInterval: TimeInterval?, data: Data?, urlResponse: URLResponse?, error: Error?, urlRequest: URLRequest?, route: JRRequest?, metrics: URLSessionTaskMetrics?, additionalParams: [JRHawkEyeAdditionalParam : Any]?) {
        
        guard let route = route else { return }
        
        let interval = timeInterval ?? 0.0
        
        //DEBUG ANALYTICS : ERROR
        PAHawkeyeWrapper.sendHawkeyeApi(urlRequest, response: urlResponse as? HTTPURLResponse, error: error as NSError?, responseTime: interval, reponseData: data, isResponseUserFacing: route.isUserFacing, verticalName: route.verticle, metrics: metrics, customMessage: nil, additionalParams: additionalParams)
    }
    
    public func networkGetDeviceId() -> String {
        return JRUtility.savedDeviceId()
    }
}
