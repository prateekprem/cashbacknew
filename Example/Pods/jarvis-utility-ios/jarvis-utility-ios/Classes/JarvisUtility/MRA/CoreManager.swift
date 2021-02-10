//
//  CoreManager.swift
//  Core
//
//  Created by Abhinav Kumar Roy on 19/07/19.
//  Copyright © 2019 Abhinav Roy. All rights reserved.
//

import UIKit

@objc public protocol RouteFactory{
    
    //MARK: Methods for jarvis-common-ios
    func common_getWeexScalingFactoriOS() -> String?
    
    //MARK: Methods for Jarvis
    func getWalletToken() -> String?

    // MARK: Methods required by Recharges
    // From Auth
    func getSSOToken() -> String?
    
    // MARK: Methods provided by Recharges
    func constructDeepLink(with order: Any) -> String
    func showOrderSummary(for orderID: String, categoryID: String, isFromOrderHistory: Bool, in navigationController: UINavigationController?)
    func deleteSelectedFrequentOrders(completionHandler completion: @escaping ((Bool, Error?) -> Void))
    func showPaymentHistory()
    func isLoginRequiredFor(_ urlType: String, url: String?) -> Bool
    func isAPIHitRequiredFor(_ urlType: String) -> Bool
    func isAutomaticUrlType(_ urlType: String) -> Bool
    func isAutomaticSupported(_ categoryId: String) -> Bool
    func launchAutomaticFlow()
    func setupAutomatic(_ urlType: String, deeplinkInfo: [AnyHashable : Any], order: Any?)
    func handleAutomaticDeeplink(subscIDOrRechargeNumber: String, urlType: String, deeplinkInfo: [AnyHashable: Any])
    func createAutomaticSubscription(with params: [String: Any], completionHandler: @escaping ((Error?, Any?) -> Void))
    func deeplinkInfoFrom(components: [String], lastComponent: String) -> [AnyHashable: Any]
    func deeplinkInfoFrom(url: URL) -> [AnyHashable: Any]?
    func getBillPayments(multipleOrderInstances: Bool, completionHandler completion: @escaping (_ success: Bool, _ error: Error?, _ order: Any?) -> ())
    func synonym(for urlType: String) -> String?
    func unsubscribeReminder(remindableStatus: Int, operatorName: String, rechargeNumber: String, handler: @escaping ((Bool, Error?) -> Void))
    func doesSupportNewAutomatic(for categoryID: String) -> Bool
    
    // Method Need From others For Recharge
    func getProductWishListDetail(_ wishlistUrl: String, completion:@escaping (([Any]?, Error?) -> Void))
    func fetchAmount(forMobileBill: [String : Any]?, completion: @escaping (([AnyHashable : Any]?, Error?) -> Void))
    func updatePaytmCashInfo(withPostParams postParams: [AnyHashable : Any]?, completionHandler handler:@escaping ((Bool, Error?) -> Void))
    func deleteCard(byID: String, completion: @escaping (([AnyHashable : Any]?, Error?) -> Void))
    func getUserPlan(_ url: String, andParams param: [String: Any], completion: @escaping (([Any]?, Error?) -> Void))
    func loadIndictivePlanCategoryNames(forType type: String?, circle: String?, andOperator operatorName: String?, withCompletionHandler handler: @escaping ((Bool, [Any]?, Error?) -> Void))
    func getOrderPaymentHistoryVC(_ order: Any?) -> UIViewController?
    
    //Automatic Subscription
    func cachedSubsStatus(for rechargeNumber: String) -> String?
    func checkSubsStatus(for rechargeNumber: String, handler: @escaping (NSError?, [String: Any]?) -> Void)
    func updateSubsStatus(for rechargeNumber: String, dict: [String: Any])
    func clearAllCachedSubscriptionStatus()
    
    func checkIfControllerIsDealsPage(_ controller: UIViewController?) -> Bool
}

@objc open class CoreManager: NSObject, RouteFactory {
    @objc public var moduleConfig : ModuleConfig = ModuleConfig.init(withEnvironment: .production, andVarient: .paytm, andbuildConfig: .debug)

    //MARK: Methods for jarvis-common-ios
    dynamic open func common_getWeexScalingFactoriOS() -> String? {return nil}
    
    //MARK: Methods for Jarvis
    dynamic open func getWalletToken() -> String? {return nil}

    // MARK: Methods required by Recharges
    dynamic open func getSSOToken() -> String? {return nil}
    
    dynamic open func constructDeepLink(with order: Any) -> String { return "" }
    
    dynamic open func showOrderSummary(for orderID: String, categoryID: String, isFromOrderHistory: Bool, in navigationController: UINavigationController?) {}
        
    dynamic open func deleteSelectedFrequentOrders(completionHandler completion: @escaping ((Bool, Error?) -> Void)) {}
    
    dynamic open func showPaymentHistory() {}
    
    dynamic open func isLoginRequiredFor(_ urlType: String, url: String?) -> Bool {return false}
    
    dynamic open func isAPIHitRequiredFor(_ urlType: String) -> Bool {return false}
    
    dynamic open func isAutomaticUrlType(_ urlType: String) -> Bool {return false}
    
    dynamic open func isAutomaticSupported(_ categoryId: String) -> Bool {return false}
        
    dynamic open func launchAutomaticFlow() {}
        
    dynamic open func setupAutomatic(_ urlType: String, deeplinkInfo: [AnyHashable : Any], order: Any?) {}
    
    dynamic open func handleAutomaticDeeplink(subscIDOrRechargeNumber: String, urlType: String, deeplinkInfo: [AnyHashable : Any]) {}
    
    dynamic open func createAutomaticSubscription(with params: [String: Any], completionHandler: @escaping ((Error?, Any?) -> Void)) {
        completionHandler(nil, nil)
    }
    
    dynamic open func deeplinkInfoFrom(components: [String], lastComponent: String) -> [AnyHashable : Any] { return [:] }
    
    dynamic open func deeplinkInfoFrom(url: URL) -> [AnyHashable : Any]? {return nil}
    
    dynamic open func getBillPayments(multipleOrderInstances: Bool, completionHandler completion: @escaping (Bool, Error?, Any?) -> ()) {}
    
    dynamic open func synonym(for urlType: String) -> String? {return nil}
    
    dynamic open func unsubscribeReminder(remindableStatus: Int, operatorName: String, rechargeNumber: String, handler: @escaping ((Bool, Error?) -> Void)) {
        handler(false, nil)
    }
    
    dynamic open func doesSupportNewAutomatic(for categoryID: String) -> Bool {
        return false
    }

    dynamic open func getProductWishListDetail(_ wishlistUrl: String, completion:@escaping (([Any]?, Error?) -> Void)) {}

    dynamic open func fetchAmount(forMobileBill: [String : Any]?, completion: @escaping (([AnyHashable : Any]?, Error?) -> Void)) { }
    
    dynamic open func updatePaytmCashInfo(withPostParams postParams: [AnyHashable : Any]?, completionHandler handler: @escaping ((Bool, Error?) -> Void)) { }

    dynamic open func deleteCard(byID: String, completion: @escaping (([AnyHashable : Any]?, Error?) -> Void)) { }

    dynamic open func getUserPlan(_ url: String, andParams param: [String: Any], completion: @escaping (([Any]?, Error?) -> Void)) { }
    
    dynamic open func loadIndictivePlanCategoryNames(forType type: String?, circle: String?, andOperator operatorName: String?, withCompletionHandler handler: @escaping ((Bool, [Any]?, Error?) -> Void)) { }
    
    dynamic open func getOrderPaymentHistoryVC(_ order: Any?) -> UIViewController? { return nil }
    
    dynamic open func cachedSubsStatus(for rechargeNumber: String) -> String? { return nil }
    
    dynamic open func checkSubsStatus(for rechargeNumber: String, handler: @escaping (NSError?, [String: Any]?) -> Void) {}
    
    dynamic open func updateSubsStatus(for rechargeNumber: String, dict: [String: Any]) {}
    
    dynamic open func clearAllCachedSubscriptionStatus() {}
    
    dynamic open func checkIfControllerIsDealsPage(_ controller: UIViewController?) -> Bool { return false }

}
