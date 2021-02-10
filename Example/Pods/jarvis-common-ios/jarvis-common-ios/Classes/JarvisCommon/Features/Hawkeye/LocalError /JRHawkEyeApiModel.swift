//
//  JRHawkEyeApiModel.swift
//  jarvis-common-ios
//
//  Created by nasib ali on 17/06/19.
//

import Foundation
import jarvis_network_ios
import PaytmAnalytics
import jarvis_utility_ios

@objc public class JRHawkEyeApiModel: JRHawkEyeErrorModel {
    
    private(set) var respTime: TimeInterval?
    private(set) var respCode : Int?
    private(set) var reqData : Data?
    private(set) var respData : Data?
    private(set) var respUri: String?
    private(set) var matrics: JRNetworkMetrics?
    
    override var event: PANCEvent { get {
        
        let event: PANCEvent = super.event
        
        event.responseCode      = respCode
        event.uri               = respUri
        event.responseType      = JRHawkEyeUtils.reponseType(with: respData)
        
        if let respTime = respTime {
            event.responseTime = Int(respTime)
        }
        
        if let dataSize = JRHawkEyeUtils.dataSize(with: respData) {
            event.responseSize = dataSize
        }
        
        if let dataSize = JRHawkEyeUtils.dataSize(with: reqData) {
            event.requestSize = dataSize
        }
        
        if let metric = matrics {
            event.metricTotalTime = metric.totalTime
            event.metricRequestTime = metric.requestTime
            event.metricResponseTime = metric.responseTime
            event.metricConnectionTime = metric.connectionTime
            event.metricDomainlookupTime = metric.domainlookupTime
            event.metricSecureConnectionTime = metric.secureConnectionTime
        }
        
        return event
        }
    }
    
    public init(errCode: Int?, errMsg: String?, customMessage: String?, userFacing: JRUserFacing, verName: JRVertical,
                hawkeye: Bool, metric: JRNetworkMetrics?, additionalParam: [JRHawkEyeAdditionalParam: Any]?,
                eventType: DAEventType, respTime: TimeInterval, respCode: Int?,
                reqData: Data?, respData: Data?, respUri: String?) {
        
        super.init(errCode: errCode, errMsg: errMsg, customMessage: customMessage, eventType: eventType,
                   userFacing: userFacing, verName: verName, hawkeye: hawkeye,
                   additionalParam: additionalParam)
        
        self.respTime = respTime
        self.respCode = respCode
        self.reqData = reqData
        self.respData = respData
        self.respUri = respUri
        self.matrics = metric
    }
    
    //Call hawkeye methods
    override func sendToHawekeye(_ completionHandler: ((Bool) -> Void)? = nil) {
        var pushHawkeye = false
        if JRCommonGTMKey.isNetworkSDK.enabled, JRCommonGTMKey.isLocalError.enabled, isPushHawkeyeRequired {
            PASignalManager.shared.push(withPANCEvent: event)
            pushHawkeye = true
        }
        completionHandler?(pushHawkeye)
    }
}
