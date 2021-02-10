//
//  Ext_Collection.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 26/12/18.
//

import UIKit

extension Collection {
    
    public var pairs: [SubSequence] {
        var start = startIndex
        return (0...count/2).map { _ in
            let end = index(start, offsetBy: 5, limitedBy: endIndex) ?? endIndex
            defer { start = end }
            return self[start..<Swift.min(end, endIndex)]
        }
    }
    
}
