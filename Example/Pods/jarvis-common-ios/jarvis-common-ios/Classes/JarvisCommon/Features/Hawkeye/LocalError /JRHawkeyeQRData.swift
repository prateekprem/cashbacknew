//
//  JRHawkeyeQRLog.swift
//  jarvis-common-ios
//
//  Created by nasib ali on 21/08/19.
//

import Foundation
import PaytmAnalytics

public struct JRHawkeyeQRData {
    
    var eventName: String?
    var isMultiQREnabled: Bool?
    var scanDuration: Int?
    var firstQrDetectedTime: Int?
    var scannedCount: Int?
    var isSuccess: Bool?
    var qrPayload: String?
    var scanSessionId: String?
    var failReason: String?
    var isWinner: Bool?
    var qrVersion: Int?
    var correctionLevel: String?
    
    var qrData: PANCQRData {
        let qrLog = PANCQRData()
        qrLog.eventName             = eventName
        qrLog.isMultiQREnabled      = isMultiQREnabled
        qrLog.scanDuration          = scanDuration
        qrLog.firstQrDetectedTime   = firstQrDetectedTime
        qrLog.scannedCount          = scannedCount
        qrLog.isSuccess              = isSuccess
        qrLog.qrPayload             = qrPayload
        qrLog.scanSessionId         = scanSessionId
        qrLog.failReason            = failReason
        qrLog.isWinner              = isWinner
        qrLog.qrVersion             = qrVersion
        qrLog.correctionLevel       = correctionLevel
        return qrLog
    }
    
    public init(eventName: String?, isMultiQREnabled: Bool, scanDuration: Int, firstQrDetectedTime: Int? = nil, scannedCount: Int? = nil, isSuccess: Bool? = nil, qrPayload: String? = nil, scanSessionId: String? = nil, failReason: String? = nil, isWinner: Bool? = nil, qrVersion: Int? = nil, correctionLevel: String? = nil) {
        
        self.eventName             = eventName
        self.isMultiQREnabled      = isMultiQREnabled
        self.scanDuration          = scanDuration
        self.firstQrDetectedTime   = firstQrDetectedTime
        self.scannedCount          = scannedCount
        self.isSuccess             = isSuccess
        self.qrPayload             = qrPayload
        self.scanSessionId         = scanSessionId
        self.failReason            = failReason
        self.isWinner              = isWinner
        self.qrVersion             = qrVersion
        self.correctionLevel       = correctionLevel
    }
}
