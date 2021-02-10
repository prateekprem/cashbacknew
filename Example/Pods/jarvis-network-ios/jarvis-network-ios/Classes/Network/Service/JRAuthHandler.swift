//
//  JRAuthHandler.swift
//  JRNetworkRouter
//
//  Created by Shwetabh Singh on 26/11/18.
//  Copyright © 2018 Paytm. All rights reserved.
//

import Foundation

public typealias JRRefreshTokenCompletion = (_ urlRequest: URLRequest?, _ urlResponse: URLResponse?, _ success: Bool, _ updatedSSOToken: String?, _ expiredSSOToken: String?,_ updatedWalletToken: String?, _ expiredWalletToken: String?, _ error: Error?) -> ()

public protocol JRRefreshTokenProtocol {
    func refreshToken(urlRequest: URLRequest?, urlResponse: URLResponse?, completion: @escaping JRRefreshTokenCompletion)
    func isAuthError(data: Any?, urlRequest: URLRequest?, urlResponse: URLResponse?) -> Bool
}

public class JRAuthHandler {
    
    public static let shared = JRAuthHandler()
    public var delegate: JRRefreshTokenProtocol?
    
    private init() {}
    var isLoginInProgress: Bool = false
    
    func  handleAuthError(urlRequest: URLRequest?, urlResponse: URLResponse?, data : Data?, route: JRRequest, completion: @escaping JRRefreshTokenCompletion) {
        let requestStartTime : Date = Date()
        self.isLoginInProgress = true
        self.delegate?.refreshToken(urlRequest: urlRequest, urlResponse: urlResponse, completion: { [weak self] (request, response, success, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, error) in
            if success == false{
                //send analytics
                let responseTime = Date().timeIntervalSince(requestStartTime) * 1000
                if ((response as? HTTPURLResponse)?.statusCode) != nil {
                    let jsonData = data?.jsonData()
                    var analyticsError: Error?
                    if jsonData == nil && error == nil {
                        analyticsError = JRNetworkUtility.serializationFailedError(request: urlRequest, response: response)
                    } else {
                        analyticsError = error
                    }
                    JRNetworkAnalytics.shared.sendADataToAnalytics(timeInterval: responseTime, data: data, urlResponse: response, error: analyticsError, urlRequest: urlRequest, route: route, metrics: nil)
                }
            }
            self?.isLoginInProgress = false
            completion(request, response, success, updatedSSOToken, expiredSSOToken, updatedWalletToken, expiredWalletToken, error)
        })
    }
    
    func checkForAuthError(urlRequest: URLRequest?, urlResponse: URLResponse?, data: Any?) -> Bool {
        let isAuthError = self.delegate?.isAuthError(data: data, urlRequest: urlRequest, urlResponse: urlResponse) ?? false
        return isAuthError
    }
}
