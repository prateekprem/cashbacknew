//
//  ResponseData.swift
//  jarvis-network-ios
//
//  Created by Bhabani Shankar Prusty on 14/10/19.
//

import Foundation

enum ResponseData<T> {
    case any(Any?)
    case codable(T?)
    
    func data() -> Any? {
        switch self {
        case .any(let data):
            return data
        case .codable(let data):
            return data
        }
    }
}

