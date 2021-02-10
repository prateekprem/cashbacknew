//
//  JRNetworkUtility.swift
//  jarvis-network-ios
//
//  Created by Shwetabh Singh on 06/12/18.
//

import Foundation

public struct JRNetworkUtility {
    
    //MARK:- Custom error methods
    public static func reachabilityError() -> NSError {
        return customError(withDomain: "jr_ac_noInternetTitle".localized, code: JRNoNetworkError, localizedDescriptionMessage: "jr_ac_noInternetMsg".localized, localizedFailureReasonErrorMessage: nil)
    }
    
    public static func authorizationError() -> NSError
    {
        return customError(withDomain: "jr_ac_errors".localized, code: JRErrorCodeAuthorizationFailed, localizedDescriptionMessage: "jr_ac_authorizationError".localized, localizedFailureReasonErrorMessage: nil)
    }
    
    public static func someThingWentWrongError() -> NSError? {
        return customError(withDomain: "jr_ac_errors".localized, code: JRErrorCodeBadRequest, localizedDescriptionMessage: "jr_ac_facingTechnicalIssue".localized, localizedFailureReasonErrorMessage: "jr_ac_somethingWentWrongWithExclaimation".localized)
    }
    
    public static func sessioTimedOutError() -> NSError? {
        return customError(withDomain: "jr_ac_errors".localized, code: JRErrorCodeAuthorizationFailed, localizedDescriptionMessage: "jr_ac_sessionTimeOutError".localized, localizedFailureReasonErrorMessage: "jr_ac_sessionTimedOut".localized)
    }
    
    static func serializationFailedError(request: URLRequest?, response: URLResponse?) -> NSError? {
        let errorMessage = JRNetworkResponseHandler().apiFailureApologizeMethod(request: request, response: response)
        return customError(withDomain: "jr_ac_dataDisplayError".localized, code: JRErrorCodeJsonError, localizedDescriptionMessage: errorMessage, localizedFailureReasonErrorMessage: nil)
    }
    
    public static func customError(withDomain domain: String?, code: Int, localizedDescriptionMessage: String?, localizedFailureReasonErrorMessage: String?) -> NSError {
        let errorInfo = [NSLocalizedFailureReasonErrorKey: localizedFailureReasonErrorMessage ?? "",
                         NSLocalizedDescriptionKey:localizedDescriptionMessage ?? ""]
        let globalError = NSError(domain: domain ?? "", code: code, userInfo: errorInfo)
        return globalError
    }
    
    public static func customError(withDomain domain: String?, code: Int, errorInfoObject: [String:String]) -> NSError {
        let globalError = NSError(domain: domain ?? "", code: code, userInfo: errorInfoObject)
        return globalError
    }
    
    //MARK:- Network reachability and network utility methods
    public static func isNetworkReachable() -> Bool {
        let reachability = Reachability()
        if let connectionStatus = reachability?.connection, connectionStatus == .none {
            return false
        }
        return true
    }
    
    public static func retryIfNotReachable(handler: @escaping () -> Void) {
        if JRNetworkUtility.isNetworkReachable() {
            handler()
        } else {
            RequestCacheArsenal.shared.showRetryAlert(handler: handler)
        }
    }
    
    public static func retryIfNotReachableWithoutAlert(handler: @escaping () -> Void) {
        if JRNetworkUtility.isNetworkReachable() {
            handler()
        } else {
            RequestCacheArsenal.shared.addRetryBlock(block: handler)
        }
    }
    
    public static func executeAllCachedRequests() {
        RequestCacheArsenal.shared.executeAllCachedRequests()
    }
    
    public static func executeAllCachedRetryBlocks() {
        RequestCacheArsenal.shared.executeAllCachedNetworkRetryBlocks()
    }
    
    public static func networkType() -> String {
        return RequestCacheArsenal.shared.reachabilityNetworkType
    }
}

//MARK:- Request cache class for resuming cached calls
public let JRNetworkReachableNotification = "JRNetworkReachableNotification"
typealias JRNetworkRetryBlock = () -> Void

class RequestCacheArsenal {
    
    static let shared = RequestCacheArsenal()
    var isAlertShown: Bool = false
    var isPerformingRequests: Bool = false
    var completions =  [JRNetworkRetryBlock]()
    var retryBlockArray = [JRNetworkRetryBlock]()
    
    let reachability = Reachability()!
    lazy var reachabilityNetworkType: String = {
        return self.reachability.connection.description
    }()
    
    var alertView: UIAlertController?
    
    private init() {
        initializeReachabilityTracking()
    }
    
    func initializeReachabilityTracking() {
        reachability.whenReachable = { reachable in
            self.executeAllCachedNetworkRetryBlocks()
            if reachable.connection == .wifi {
                self.reachabilityNetworkType = "WiFi"
            } else {
                self.reachabilityNetworkType = "Cellular"
            }
        }
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }
    
    func showRetryAlert(handler:@escaping () -> Void) {
        if isAlertShown {
            return
        }
        self.isAlertShown = true
        let alertController = UIAlertController.init(title: "jr_ac_noInternetTitle".localized, message: "jr_ac_unableToDetectInternetConnectivity".localized, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "jr_ac_retry".localized, style: .default, handler: { (action) in
            self.isAlertShown = false
            JRNetworkUtility.retryIfNotReachable(handler: handler)
        }))
        alertController.addAction(UIAlertAction.init(title: "jr_ac_cancel".localized, style: .default, handler: { (action) in
            self.isAlertShown = false
        }))
        
        UIApplication.topVC()?.present(alertController, animated: true, completion: nil)
    }
    
    func add<T: Codable>(request: JRRequest, with handler: @escaping JRNetworkInteractorCompletion<T>) {
        if isPerformingRequests {
            return
        }

        completions.append {
            let routerObj = KungFu.Panda(jrRequest: request)
            let router = JRRouter<KungFu>()
            router.request(routerObj, completion: handler)
        }

    }
    
    func addRetryBlock(block: @escaping JRNetworkRetryBlock) {
        retryBlockArray.append(block)
    }
    
    func executeAllCachedRequests() {
        if JRNetworkUtility.isNetworkReachable() {
            NotificationCenter.default.post(name: NSNotification.Name(JRNetworkReachableNotification), object: nil)
            isPerformingRequests = true
            for completion in completions {
                completion()
            }
            completions.removeAll()
            isPerformingRequests = false
        }
    }
    
    func executeAllCachedNetworkRetryBlocks() {
        if JRNetworkUtility.isNetworkReachable() {
            for retryBlock in retryBlockArray {
                retryBlock()
            }
            retryBlockArray.removeAll()
        }
    }
    
}
