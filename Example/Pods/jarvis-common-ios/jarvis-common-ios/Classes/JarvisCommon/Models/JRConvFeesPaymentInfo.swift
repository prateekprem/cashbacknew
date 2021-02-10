//
//  JRConvFeesPaymentInfo.swift
//  Jarvis
//
//  Created by Ashutosh Lasod on 04/06/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

@objc public class JRConvFeesPaymentInfo: NSObject {
    
    @objc public var mid: String?
    public var nativeWithdraw: Bool
    public override  init() {
        nativeWithdraw = false
    }
    
    @objc public convenience init(dictionary: [AnyHashable: Any]) {
        self.init()
        mid = dictionary.getStringKey("mid")
        nativeWithdraw = dictionary.getBoolForKey("native_withdraw")
    }
}
