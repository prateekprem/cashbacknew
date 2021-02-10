//
//  PAAnalyticProtocol.swift
//  PaytmAnalytics
//
//  Created by nasib ali on 11/06/19.
//

import Foundation

public protocol PAAnalyticProtocol {
    var userID: String? { get }
}

public class PAAnalyticManager: NSObject {
    
    public static var shared: PAAnalyticManager = PAAnalyticManager()
    public var analyticDelegate: PAAnalyticProtocol?   //only here
}


//TODO: this class is only used in PANetworkSession
