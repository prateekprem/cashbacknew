//
//  JRUtilityManager.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 05/11/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import CoreLocation
import jarvis_utility_ios

@objc public protocol JarvisCommonProtocol {
    func locationManagerDidChangeAuthrization(_ status: CLAuthorizationStatus)
    func sendLocalErrorToDebugAnalyticsServer(withMessage: String, errorcode: String, line: Int, error_class: String?, function: String?)
    func getSSOToken() -> String?
    func getWalletToken() -> String?
    func getSiteId() -> String?
    func getChildSiteId() -> String?
    func updateBottomBar()
    func flyout(_ show: Bool, animated: Bool)
    
    func geturlTypeProductFromJRDeeplinkHandler() -> String
    func fastagProductIdFromTollPDPManager() -> String
    func getUrlTypeFastagFromJRDeepLinkHandler() -> String
    func getCatalogCacheUpdatedFromJrServer() -> Bool
    func getCatalogItemsFromJrServer() -> [JRItem]?
    func getSelectedItemFromJRServer() -> JRItem?
    
    func getUserIdFromJRAccount() -> String
    func getIsLoggedInFromJRAccount() -> Bool
    func getMobileFromJRAccount() -> String
    func getEmailIdFromJRAccount() -> String
    
    //Login Methods
    func launchExternalLoginView(withController: UIViewController)
    func launchExternalRegisterView(withController: UIViewController)
    func launchLoginViewWithSignUpScreenAtFrontDueToAuthenticationError(value: Bool, withError:NSError, withTitle:String, bySkippingStep2:Bool, controller : UIViewController)
    func launchLoginViewDueToAuthenticationError(value: Bool, withError:NSError?, withTitle:String, bySkippingStep2:Bool, controller : UIViewController)
    func cancelButtonTappedInAuthorizationErrorCase(isAuthorizationCase : Bool, controller : UIViewController)
    func setTrace(value: JRFirebaseTraceAttributeValue, forAttribute attribute: JRFirebaseTraceAttributeType, inTrace trace: JRFirebaseTrace)
    func logExecutionTrace(name: JRFirebaseTrace, state: JRFirebaseLogState)
}

@objc public class JRCommonManager: CoreManager {
    @objc public static var shared : JRCommonManager = JRCommonManager()
    @objc public weak var applicationDelegate : JarvisCommonProtocol?

    internal lazy var operationQSerial: OperationQueue = {
        let operation = OperationQueue()
        operation.maxConcurrentOperationCount = 1
        return operation
    }()

    public override init() {
        super.init()
    }
    
    //Bridges
    @objc public var navigation : JRNavigationBridge = JRNavigationBridge.shared
}

extension JRCommonManager {
    
    public override func common_getWeexScalingFactoriOS() -> String? {
        return String.validString(val: JRRemoteConfigManager.value(key: "weex_image_scaling_factor_ios"))
    }
    
    public func kickOffIVersion() {
        iVersionManager.init_iVarsion()
    }
}
