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
import jarvis_auth_ios

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        JRCashbackRouter.initCashback()
       // JRCashbackManager.shared.shouldMock = true
        return true
    }
}


class JRDeeplinkHandler {
    
    static var shared : JRDeeplinkHandler = JRDeeplinkHandler()
    private init() { }
    
    @discardableResult func handleClickFor(item: JRItem?, shouldRoute: Bool, context: Any?, propertiesHandler: ((JRViewControllerInputProperties)->Void)?, viewControllersHandler: (([JRBaseVC]?)->Void)?) -> Bool {
        return true
    }
}
