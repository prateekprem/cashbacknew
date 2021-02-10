//
//  JRTopNavigationTabModel.swift
//  TopNavigationTabsViewSample
//
//  Created by Alok Rao on 15/05/16.
//  Copyright © 2016 Paytm. All rights reserved.
//

import UIKit

public class JRTopNavigationTabModel: NSObject {
    
    @objc public var title:String?
    @objc public var selected:Bool = false
    @objc public var userInfo:AnyObject?
    @objc public var unreadMsgCount:Int = 0
    
}
