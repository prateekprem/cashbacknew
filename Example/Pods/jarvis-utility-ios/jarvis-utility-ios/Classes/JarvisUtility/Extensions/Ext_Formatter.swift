//
//  Ext_Formatter.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 26/12/18.
//

import UIKit

extension Formatter {
    
    public static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
    
}
