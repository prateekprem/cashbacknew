//
//  AppDelegate.swift
//  jarvis-cashback-ios
//
//  Created by nasib ali on 05/27/2019.
//  Copyright (c) 2019 nasib ali. All rights reserved.
//

import UIKit
import jarvis_common_ios
import jarvis_cashback_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let _ = LoginHelper.sharedInstance
        JRCashbackManager.shared.cashbackDelegate = JRDummyCashbackBridge.shared
        JRCashbackManager.shared.shouldMock = true
        return true
    }
}



