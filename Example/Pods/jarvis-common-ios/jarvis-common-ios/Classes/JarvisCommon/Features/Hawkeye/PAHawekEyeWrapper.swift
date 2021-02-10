//
//  PAHawkeyeWrapper.swift
//  Jarvis
//
//  Created by nasib ali on 04/06/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit
import jarvis_network_ios

@objc public class PAHawkeyeWrapper: NSObject {
    
    public class func sendHawkeyeApi(_ request: URLRequest?, response: HTTPURLResponse?, error: NSError?, responseTime: TimeInterval, reponseData data: Data?, isResponseUserFacing userFacing: JRUserFacing = .none, verticalName vertical: JRVertical = .unknown, metrics: URLSessionTaskMetrics?, customMessage: String?, additionalParams params: [JRHawkEyeAdditionalParam : Any]? = nil) {
        
        if JRCommonGTMKey.isNetworkSDK.enabled {
            
            guard let uri = response?.url?.absoluteString else {
                return
            }
            
            if response?.statusCode == 200, error == nil {
                
                if JRCommonGTMKey.isApiLog.enabled {
                    PAHawkeyeWrapper.pushNetworkApi(event: .apiLog, message: nil, responseTime: responseTime, uri: uri.components(separatedBy: "?")[0], responseCode: response?.statusCode, errorCode: nil, requestData: request?.httpBody, responseData: data, isResponseUserFacing: userFacing, verticalName: vertical, metric: metrics?.metrics, customMessage: customMessage, additionalParams: params)
                }
                
            }else if JRCommonGTMKey.isErrorEvent.enabled {
                
                PAHawkeyeWrapper.pushNetworkApi(event: .apiError, message: error?.localizedDescription, responseTime: responseTime, uri: uri.components(separatedBy: "?")[0], responseCode: response?.statusCode, errorCode: error?.code, requestData: request?.httpBody, responseData: data, isResponseUserFacing: userFacing, verticalName: vertical, metric: metrics?.metrics, customMessage: customMessage, additionalParams: params)
            }
        }
    }
    
    private class func pushNetworkApi(event type: DAEventType, message: String?, responseTime: TimeInterval, uri: String = "", responseCode: Int?, errorCode: Int?, requestData: Data?, responseData: Data?, isResponseUserFacing userFacing: JRUserFacing, verticalName vertical: JRVertical = .unknown, metric: JRNetworkMetrics?, customMessage: String?, additionalParams params: [JRHawkEyeAdditionalParam : Any]? = nil) {
        
        let errorInfo = JRHawkEyeApiModel(errCode: errorCode, errMsg: message, customMessage: customMessage, userFacing: userFacing,
                                          verName: vertical, hawkeye: true, metric: metric,  additionalParam: params,
                                          eventType: type, respTime: responseTime, respCode: responseCode,
                                          reqData: requestData, respData: responseData,
                                          respUri: uri)
        
        errorInfo.sendToHawekeye()
    }
    
    //TODO: Need to remove once all module will implement local error
    public class func sendHawkeyeLocalError(withMessage message: String, errorcode: Int?, verticalName vertical: JRVertical = .unknown, metric: JRNetworkMetrics?, additionalParams params: [JRHawkEyeAdditionalParam : Any]? = nil){
        if JRCommonGTMKey.isNetworkSDK.enabled, JRCommonGTMKey.isLocalError.enabled {
            
            let errorInfo = JRHawkEyeErrorModel(errCode: errorcode, errMsg: message,
                                                userFacing: .none, verName: vertical, hawkeye: false,
                                                additionalParam: params)
            errorInfo.sendToHawekeye()
        }
    }
    
    public class func trackAppLaunch(veticalName vetical: JRVertical, additionalParams params: [JRHawkEyeAdditionalParam: Any]?,responseTime respTime: TimeInterval){
        
        let errorInfo = JRHawkEyeApiModel(errCode: nil, errMsg: nil, customMessage: nil, userFacing: .silent,
                                          verName: vetical, hawkeye: true, metric: nil,  additionalParam: params,
                                          eventType: .localError, respTime: respTime, respCode: nil,
                                          reqData: nil, respData: nil,
                                          respUri: nil)
        
        errorInfo.sendToHawekeye()
    }
}
