//
//  Ext_Int.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Int {
    
    public func commaString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = NumberFormatter.Style.decimal
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber
        }
        return "\(self)"
    }
    
    public var degreesToRadians : CGFloat {
        return CGFloat(self) * CGFloat(Double.pi) / 180.0
    }
    
    public static func randomNumber(MIN: Int, MAX: Int)-> Int {
        return Int(arc4random_uniform(UInt32(MAX)) + UInt32(MIN));
    }

}
