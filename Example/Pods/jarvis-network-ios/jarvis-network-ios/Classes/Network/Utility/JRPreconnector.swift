//
//  JRPreconnector.swift
//  Pods
//
//  Created by Bhabani Shankar Prusty on 01/07/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

public struct JRPreconnector {
    public static func connect(with hostUrl: String, vertical: JRVertical) {
        let request = PreConnectRouter.connect(hostUrl, vertical)
        let router = JRRouter<PreConnectRouter>()
        router.request(type: Data.self, request) { _, _, _ in }
    }
}

enum PreConnectRouter{
    case connect(_ hostUrl: String, _ vertical: JRVertical)
}


extension PreConnectRouter: JRRequest{
    
    var baseURL: String? {
        switch self {
        case .connect(let hostUrl, _):
            return hostUrl
        }
    }
    
    var verticle: JRVertical {
        switch self {
        case .connect(_, let vertical):
            return vertical
        }
    }
    
    var path: String? {
        return nil
    }

    var httpMethod: JRHTTPMethod {
        return .head
    }
    
    var headers: JRHTTPHeaders? {
        return nil
    }
    
    var usePipelining: Bool {
        return true
    }

}
