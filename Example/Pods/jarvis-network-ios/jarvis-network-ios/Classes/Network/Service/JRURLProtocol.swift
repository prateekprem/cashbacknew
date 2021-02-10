//
//  JRURLProtocol.swift
//  JRNetworkRouter
//
//  Created by Kushal on 31/10/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

final class MockURLProtocol: URLProtocol {
    
    var startTime: Date!
    
    override class func canInit(with request: URLRequest) -> Bool {
        JRNetworkLogger.log(request: request)
        return false
    }
    
    override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        return request
    }
    
    override func startLoading() {
        startTime = Date()
    }
    
    override func stopLoading() {
        print(startTime.timeIntervalSinceNow * 1000)
    }
    
}
