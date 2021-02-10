//
//  JRGoogleTrackManagerSequencer.swift
//  jarvis-common-ios
//
//  Created by Paytm Labs on 2020-10-20.
//  
//


import Foundation

@objc public class JRGoogleTrackManagerSequencer: NSObject {
    
    @objc public let sequentialQueue: OperationQueue
    @objc public static let sharedSequencer = JRGoogleTrackManagerSequencer()
    
    @objc public static var dimensionDict: [AnyHashable: Any]? {
        return JRSignalManager.shared.dimensionsDict
    }
    
    private override init() {
        self.sequentialQueue = OperationQueue()
        self.sequentialQueue.maxConcurrentOperationCount = 1
        super.init()
    }
    
}
