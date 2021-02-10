//
//  CorrelationIDGenerator.swift
//  jarvis-network-ios
//
//  Created by Shwetabh Singh on 18/07/19.
//

import Foundation

@objc public class CorrelationIDGenerator: NSObject {
    
    @objc public static let sharedInstance: CorrelationIDGenerator = CorrelationIDGenerator()
    private override init() {}
    
    static let correlationHeaderKey: String = "x-app-rid"
    
    private let queue: DispatchQueue = DispatchQueue(label: "correlationIDQueue", qos: .default, attributes: .concurrent)
    private var sessionID: String = ""
    private var requestCounter: Int = 0
    private var appLaunchCounter: Int = 1
    
    public var correlationId: String {
        //x-app-rid: <<device id(UUID)><epoch time till ms><2hex session Seq>-<3hex Seq>>
        
        //increment the request counter
        self.requestCounter += 1
        
        var correlationId = ""
        let vendorUUID = JRNetworkAnalytics.deviceID
        if let vendorUUID = vendorUUID, !vendorUUID.isEmpty {
            correlationId += "\(vendorUUID):"
        }
        
        let echoTime = String(Int(Date().timeIntervalSince1970))
    
        correlationId += "\(echoTime):"
        correlationId += String(format:"%02X:", appLaunchCounter)
        correlationId += String(format:"%03X", requestCounter)

        return correlationId
    }
    
    @objc public func notifyForAppLaunch() {
        requestCounter = 0
        appLaunchCounter = 1
    }
    
    @objc public func notifyForAppComesToForeground() {
        appLaunchCounter += 1
    }
}
