//
//  JRLocalErrorModel.swift
//  Jarvis
//
//  Created by nasib ali on 03/06/19.
//

import Foundation
import jarvis_network_ios
import PaytmAnalytics
import jarvis_utility_ios

@objc public enum DAEventType : Int{
    case apiError
    case localError
    case apiLog
    case qrLog
    
    var value: String {
        switch self {
        case .apiError: return "apiError"
        case .apiLog: return "apiLog"
        case .localError: return "localError"
        case .qrLog: return "qrLog"
        }
    }
}

@objc public class JRHawkEyeErrorModel: NSObject {
    
    private(set) var errorCode: Int?
    private(set) var errorMessage: String?
    private(set) var vertical: JRVertical = .unknown
    private(set) var isPushHawkeyeRequired: Bool = false
    private(set) var additionalParam: [JRHawkEyeAdditionalParam: Any]?
    private(set) var eventType: DAEventType = DAEventType.localError
    private(set) var userFacing: JRUserFacing = .none
    private(set) var correlationID: String?
    private(set) var customMessage: String?
    
    @objc class public var blankInfo : JRHawkEyeErrorModel {
        return JRHawkEyeErrorModel()
    }
    
    var qrData: PANCQRData? {
        
        guard let qrLogStruct = additionalParam?[JRHawkEyeAdditionalParam.qrData] as? JRHawkeyeQRData else {
            return nil
        }
        return qrLogStruct.qrData
    }
    
    var location: PANCLocation {
        
        let location    = PANCLocation()
        location.lat    = JRLocationManager.shared.getCurrentLocationCords().0
        location.lon    = JRLocationManager.shared.getCurrentLocationCords().1
        return location
    }
    
    var event: PANCEvent {
        
        let event : PANCEvent = PANCEvent()
        
        event.timestamp = JRHawkEyeUtils.iso8601DateString
        event.type      = eventType.value
        event.location  = location
        event.qrData    = qrData
        
        event.networkCarrier    = JRHawkEyeUtils.cellularCarrierName
        event.errorCode         = errorCode
        event.verticalName      = vertical.name
        event.userFacing        = userFacing == .userFacing ? "true" : "false"
        event.errorMsg          = errorMessage
        event.customMessage     = customMessage
        
        UIDevice.current.isBatteryMonitoringEnabled = true
        if UIDevice.current.batteryLevel != -1.0{
            event.batteryPercentage = Int(UIDevice.current.batteryLevel  * 100)
        }
        
        if let freeSpace = Double(JRDiskStatus.freeDiskSpace.replacingOccurrences(of: " GB", with: "")), let totalSpace = Double(JRDiskStatus.totalDiskSpace.replacingOccurrences(of: " GB", with: "")){
            event.storageFreePercentage = Int((freeSpace/totalSpace) * 100)
            event.storageFreeSize = Int(freeSpace)
        }
        
        let ramSize = JRUtility.getMemory()
        event.ramFreeSize = Int(ramSize.freeRam)
        event.ramFreePercentage = Int((ramSize.freeRam/ramSize.totalRam) * 100)
        
        if let ip = JRUtility.getIPAddressForCellOrWireless(){
            event.clientIP = ip
        }
        
        if let networkType = Reachability()?.userSelectedNetworkType(){
            event.networktype = networkType
        }
        
        if let midValue = additionalParam?[JRHawkEyeAdditionalParam.mid] as? String{
            event.mid = midValue
        }
        
        if let PID = additionalParam?[JRHawkEyeAdditionalParam.pid] as? String{
            event.PID = PID
        }
        
        if let categoryID = additionalParam?[JRHawkEyeAdditionalParam.categoryID] as? String{
            event.categoryId = categoryID
        }
        
        if let correlationId = additionalParam?[JRHawkEyeAdditionalParam.correlationId] as? String{
            event.correlationID = correlationId
        }
        
        if let transactionIdValue = additionalParam?[JRHawkEyeAdditionalParam.transactionId] as? String{
            event.transactionId = transactionIdValue
        }
        
        if let flowNameValue = additionalParam?[JRHawkEyeAdditionalParam.flowName] as? String{
            event.flowName = flowNameValue
        }
        
        if let screenNameValue = additionalParam?[JRHawkEyeAdditionalParam.screenName] as? String{
            event.screenName = screenNameValue
        }
        
        if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
            event.appVersion = version
        }
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            event.appVersionCode = build
        }
        
        return event
    }
    
    fileprivate override init(){}
    
    public init(errCode: Int? = nil, errMsg: String? = nil, customMessage: String? = nil, eventType: DAEventType, userFacing: JRUserFacing, verName: JRVertical, hawkeye: Bool, additionalParam: [JRHawkEyeAdditionalParam: Any]? = nil) {
        
        self.errorCode = errCode
        self.errorMessage = errMsg
        self.customMessage = customMessage
        self.userFacing = userFacing
        self.vertical = verName
        self.eventType = eventType
        self.isPushHawkeyeRequired = hawkeye
        self.additionalParam = additionalParam
    }
    
    public convenience init(errCode: Int? = nil, errMsg: String? = nil, customMessage: String? = nil, userFacing: JRUserFacing, verName: JRVertical, hawkeye: Bool, additionalParam: [JRHawkEyeAdditionalParam: Any]? = nil) {
        
        self.init(errCode: errCode, errMsg: errMsg, eventType: .localError, userFacing: userFacing, verName: verName, hawkeye: hawkeye, additionalParam: additionalParam)
    }
    
    public func updateAdditionalParam(forKey key: JRHawkEyeAdditionalParam, withValue value: Any) {
        additionalParam?[key] = value
    }
    
    class func getAdditionalParam(from dic: [String: Any]?) -> [JRHawkEyeAdditionalParam: Any] {
        
        var additionalParams: [JRHawkEyeAdditionalParam: Any] = [JRHawkEyeAdditionalParam: Any]()
        
        if let params = dic {
            for (key, value) in params {
                
                if let key = JRHawkEyeAdditionalParam(rawValue: key) {
                    additionalParams[key] = value
                }
            }
        }
        return additionalParams
    }
    
    //MARK: - Objective c supported methods
    
    @objc public convenience init(errCode: Int, errMsg: String, eventType: DAEventType,
                      userFacing: JRUserFacing, verName: JRVertical, hawkeye: Bool, additionalParam: [String: Any]) {
        
        let params = JRHawkEyeErrorModel.getAdditionalParam(from: additionalParam)
        self.init(errCode: errCode, errMsg: errMsg, eventType: eventType, userFacing: userFacing, verName: verName, hawkeye: hawkeye, additionalParam: params)
    }
    
    @objc public func updateAdditionalParam(forKey key: String, withValue value: String) {
        if let key = JRHawkEyeAdditionalParam(rawValue: key){
         additionalParam?[key] = value
        }
    }
    
    //Call hawkeye methods
    func sendToHawekeye(_ completionHandler: ((Bool) -> Void)? = nil) {
        var pushHawkeye = false
        if JRCommonGTMKey.isNetworkSDK.enabled, JRCommonGTMKey.isLocalError.enabled, isPushHawkeyeRequired {
            PASignalManager.shared.push(withPANCEvent: event)
            pushHawkeye = true
        }
        completionHandler?(pushHawkeye)
    }
}
