//
//  PABaseSession.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 04/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PABaseSession: NSObject {
    
    var requestUrlString: String?
    
    var isLoggingEnabled  = false
    
    var maxBatchSizeToCapture = 2000
    var maxBatchSizeToUpload = 10
    
    var dispatchStrategy: DispatchStrategy = .manual
    var buildType: PABuildType = .release
}

