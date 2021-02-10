//
//  JRBaseVC.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 08/09/20.
//

import UIKit
import Foundation
import jarvis_utility_ios
import CoreSpotlight
import MobileCoreServices

public protocol PublicSearchActivityProtocol: AnyObject {
    func urlTypeOfCurrentTopController() -> String
}

public protocol JRLoginAndRegisterViewDelegate: AnyObject {
    func didSuccessLogin(_ success: Bool)
    func cancelButtonTappedInAuthorizationErrorCase(isAuthorizationCase: Bool)
    func signInUserDenied()
}

extension JRLoginAndRegisterViewDelegate {
    public func didSuccessLogin(_ success: Bool) {}
    public func cancelButtonTappedInAuthorizationErrorCase(isAuthorizationCase: Bool) {}
    public func signInUserDenied() {}
}

open class JRBaseVC: JRNavBaseController {
    @objc open var isFromSearch = false
    @objc open var trackingInfo: [AnyHashable : Any]?
    @objc open var isFromDeepLinking = false
    @objc open var deepLinkInfo: [AnyHashable : Any]? {
        didSet {
            guard let info = deepLinkInfo else { return  }
            setDeepLinkInfo(info)
        }
    }
    @objc open var disableDefaultLoading = false
    @objc open var disableErrorAlert = false
    @objc open var gtmOrigin: String?
    @objc open var containerInstanceID: String?
    @objc open var listID = 0.0
    @objc open var viewOrigin: String?
    @objc open var item: JRItem?
    @objc open var urlType: String = ""
    @objc open var urlHTTPMethod: String = "GET"
    @objc open var urlString: String? {
        didSet {
            guard let urlString = self.urlString else { return }
            if !disableDefaultLoading {
                if !urlString.isEmpty && urlString.hasPrefix("http") {
                    loadUrl()
                }
            }
        }
    }
    @objc open var urlHeaders: [String : String]?
    
    /**
    *  This will be called after the url contents are fetched and parsed.
    */
    @objc open var urlCompletionBlock: ((_ success: Bool, _ response: [AnyHashable : Any]?) -> Void)?
    @objc open var isViewContentAlreadyLoaded = false
    @objc open var isLoading = false
    @objc open var hideActivityIndicator = false
    @IBOutlet open var activityIndicatorView: UIActivityIndicatorView! {
        get {
            if !hideActivityIndicator &&  _activityIndicatorView == nil, activityIndicator == nil {
                let view = UIActivityIndicatorView(style: .gray)
                activityIndicator = view
                view.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin, .flexibleTopMargin, .flexibleBottomMargin]

                // Please do not access the self.view, it  forcefully calls viewDidLoad befor the navigation.
                //_aciftivityIndicator.center = self.view.center;
                activityIndicator?.hidesWhenStopped = true
                if isBeingDismissed || isMovingFromParent {
                    self.view.addSubview(view)
                }
            }
            
            return _activityIndicatorView ?? activityIndicator
            
        }
        set { _activityIndicatorView = newValue }
    }
    
    open var shouldHideIndicator = false
    
    /// This property is used to handle Offline mode
    /// Returns NO for default No network error in the screen
    /// Returns YES if the UI can work in offline mode
    open var canHandleOfflineMode = false
    
    /// This property is used to  show navigation bar on no network screen if needed
    /// Returns NO for default No network error in the screen
    /// Returns YES if the UI can work in offline mode
    open var showNavigationBarInOffline = false
    
    /// This property is used to display back button on no network view by default would be false
    open var showBackButtonOnNoNetworkView = false
    
    /// No Network Controller
    open var networkController: JRNetworkConnectionVC?
    
    /// This property is used to handle Offline mode for MarketPlace
    /// Returns NO for default No network error in the screen
    /// Returns YES if the UI can work in offline mode
    open var isMPNoNetViewShow = false
    
    open var downloadFile = false
    open var pageIndex = 0
    open var isSmoothPayFlow = false
    open var isUserDataFetched = false
    
    //DeepLink property for GA tracking
    open var gaKey: String?
    open var qrCodeID: String?
    
    //This property is being used in JRWebViewcontroller
    //To enable save and email feature to web view
    open var shouldShowShareButtonOnNavigationBar = false
    
    /// Any information which is needed post login. It should be reset after login. Should be meaningful only in login case.
    @objc open var loginContext: Any?
    
    /// This property is used to hide back button on no network view for Mall by default would be false
    open var hideMPBackButtonOnNoNetworkView = false
    
    private var activityIndicator: UIActivityIndicatorView?
    private var _activityIndicatorView: UIActivityIndicatorView?
    
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        JRCrashlyticsLogBridge.shared.log(String(describing: self))
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(networkStatusChanged),
                                               name: NSNotification.Name(rawValue: JRNetworkUtilityObjc.jrNetworkReachableNotification()),
                                               object: nil)
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        NotificationCenter.default.addObserver(self, selector: #selector(reloadBottomTabbar),
                                               name: UIApplication.willEnterForegroundNotification,
                                                object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadBottomTabbarFromSearch),
                                               name: NSNotification.Name("LoadBottomBarNotification"),
                                               object: nil)
        reloadBottomTabbar()

        activityIndicatorView?.stopAnimating()
        if !JRNetworkUtilityObjc.isNetworkReachable() {
            showNoNetworkConnectivityView()
        }
        configurePublicSearchActivity()
    }
    
    open override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if JRNetworkUtilityObjc.isNetworkReachable(), let activityIndicator = activityIndicator {
            if activityIndicator.superview == nil {
                view.addSubview(activityIndicator)
                activityIndicator.center = CGPoint(x: view.bounds.midX, y: view.bounds.midY - 20.0)
            }
        }
    }
    
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        view.endEditing(true)
        NotificationCenter.default.removeObserver(self, name: UIApplication.willEnterForegroundNotification, object: nil)
        networkController?.showMPNoNetViewWithoutBackBtn = hideMPBackButtonOnNoNetworkView
    }
    
    open override func present(_ viewControllerToPresent: UIViewController, animated flag: Bool, completion: (() -> Void)? = nil) {
        if #available(iOS 13.0, *) {
            // Restriction of swipe to dismiss functionality (iOS 13)
            viewControllerToPresent.isModalInPresentation = true
        }
        super.present(viewControllerToPresent, animated: flag, completion: completion)
    }
    

    open func finalHeight() -> CGFloat {
        return 0
    }

    open func fetchSearchContext() -> [AnyHashable : Any]? {
        return nil
    }

    open func fetchSearchPlaceholderName() -> String? {
        return nil
    }

    private func screenName() -> String? {
        return nil
    }
    
    private func setDeepLinkInfo(_ deepLinkInfo: [AnyHashable : Any]) {
        guard let searchTerm = deepLinkInfo[GTM_KEY_SEARCH_TERM] as? String, !searchTerm.isEmpty else { return }
        isFromSearch = true
        trackingInfo = [
            GTM_KEY_SEARCH_TYPE: deepLinkInfo[GTM_KEY_SEARCH_TYPE] ?? "",
            GTM_KEY_SEARCH_TERM: deepLinkInfo[GTM_KEY_SEARCH_TERM] ?? "",
            GTM_KEY_SEARCH_CATEGORY: deepLinkInfo[GTM_KEY_SEARCH_CATEGORY] ?? "",
            GTM_KEY_SEARCH_RESULT_TYPE: deepLinkInfo[GTM_KEY_SEARCH_RESULT_TYPE] ?? ""
        ]
    }
    
    @objc private func reloadBottomTabbar() {
        guard JRCommonManager.shared.moduleConfig.varient == .mall,
            navigationController?.viewControllers.count == 1,
            JRCommonManager.shared.conforms(to: JarvisCommonProtocol.self)
            else { return }
        JRCommonManager.shared.applicationDelegate?.updateBottomBar()
    }

    @objc private func reloadBottomTabbarFromSearch() {
        guard JRCommonManager.shared.moduleConfig.varient == .mall,
           navigationController?.viewControllers.count == 1,
           JRCommonManager.shared.conforms(to: JarvisCommonProtocol.self)
           else { return }
        JRCommonManager.shared.applicationDelegate?.updateBottomBar()
    }
    
    open func layOutView() {
        //Sub classes need to be implement this method if they set the urlString
    }
    
    // MARK: Methods for activity indicator
    
    @objc open func networkStatusChanged() {
        if JRNetworkUtilityObjc.isNetworkReachable() {
            if (networkController != nil) {
                networkController?.view.removeFromSuperview()
                networkController?.removeFromParent()
                networkController = nil
            }
        } else {
            showNoNetworkConnectivityView()
        }
    }

    open func startNetworkReachablity() {
        NotificationCenter.default.addObserver(
        self,
        selector: #selector(networkStatusChanged),
        name: NSNotification.Name(rawValue: JRNetworkUtilityObjc.jrNetworkReachableNotification()),
        object: nil)
    }

    open func stopNetworkReachablity() {
        NotificationCenter.default.removeObserver(
        self,
        name: NSNotification.Name(rawValue: JRNetworkUtilityObjc.jrNetworkReachableNotification()),
        object: nil)
    }

    open func addSubview(_ subView: UIView?, to parentView: UIView?) {
        guard let subView = subView else { return }
        parentView?.addSubview(subView)

        let views = [
            "subView": subView
        ]
        var constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "H:|[subView]|",
            options: [],
            metrics: nil,
            views: views)
        parentView?.addConstraints(constraints)
        constraints = NSLayoutConstraint.constraints(
            withVisualFormat: "V:|[subView]|",
            options: [],
            metrics: nil,
            views: views)
        parentView?.addConstraints(constraints)
    }

    open func showNoNetworkConnectivityView() {
        if !canHandleOfflineMode {
            if !(networkController != nil) {
                networkController = JRNetworkConnectionVC.instance
                networkController?.showNavigationBarInOffline = showNavigationBarInOffline
                networkController?.view.translatesAutoresizingMaskIntoConstraints = false
                networkController?.delegate = self
                networkController?.showBackButton = showBackButtonOnNoNetworkView
                addChild(networkController!)
                if isMPNoNetViewShow {
                    networkController?.showMPNoNetView = true
                }
                addSubview(networkController!.view, to: view)
                view.bringSubviewToFront(networkController!.view)
            }
        }
    }

    open func retryButtonPressed() {
    }

    open func noNetworkBackButtonPressed() {
    }
    
    open func parseResponseDictionary(_ jsonData: [AnyHashable : Any]?, withError error: Error?) {
    }

    open func launchExternalLoginView() {
        JRCommonManager.shared.applicationDelegate?.launchExternalLoginView(withController: self)

    } ////Note:Should be called only when user launches login view by intension,i.e by tapping login button

    open func launchExternalRegisterView() {
        JRCommonManager.shared.applicationDelegate?.launchExternalRegisterView(withController: self)
    }

    open func launchLoginViewWithSignUpScreenAtFrontDue(toAuthenticationError value: Bool, withError authenticationError: Error?, withTitle loginTitle: String?, bySkippingStep2 skipRegistration: Bool) {
        JRCommonManager.shared.applicationDelegate?.launchLoginViewDueToAuthenticationError(value: value, withError: authenticationError as NSError?, withTitle: loginTitle!, bySkippingStep2: skipRegistration, controller: self)
    } //used in wallet and updates screens,since for some cases we need to show sign up view first

    open func launchLoginViewDue(toAuthenticationError value: Bool, withError authenticationError: Error?, withTitle loginTitle: String?, bySkippingStep2 skipRegistration: Bool) {
        JRCommonManager.shared.applicationDelegate?.launchLoginViewDueToAuthenticationError(value: value, withError: authenticationError as NSError?, withTitle: loginTitle ?? "", bySkippingStep2: skipRegistration, controller: self)
    }
    
    open func cancelButtonTapped(inAuthorizationErrorCase isAuthorizationCase: Bool) {
        JRCommonManager.shared.applicationDelegate?.cancelButtonTappedInAuthorizationErrorCase(isAuthorizationCase: isAuthorizationCase, controller: self)
    }
    
    /*
     This should be declared in every ViewController class
     if the same got a xib. Xib should be named same as that of ViewController class.
     */
    open class func nibName() -> String {
        return String(describing: type(of: self))
    }

   open func performFetchingOfCategoryId(_ urlType: String?, forArray itemsArray: [JRItem], andName name: String) -> NSNumber? {
        var categoryId: NSNumber? = nil
        for item in itemsArray {
            if item.urlType == urlType && item.name.contains(find: name){
                categoryId = item.categoryId?.validObjectValue() as? NSNumber
                break
            }
            
            if item.items.count > 0 {
                categoryId = performFetchingOfCategoryId(urlType, forArray: item.items, andName: name)?.validObjectValue() as? NSNumber
                break
            }
        }
        return categoryId
    }

    open func deepLinkedViewControllers() -> [JRBaseVC]? {
        return nil
    }

    //To enable public search iOS 9
    open func configurePublicSearchActivity() {
        let key = urlTypeOfCurrentTopController()
        guard let item = JRCommonHelper.searchActivityItems?[key] as? JRSearchActivityItem else { return }
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: kUTTypeText as String)
        attributeSet.title = item.title
        attributeSet.contentDescription = item.contentDescription

        let activity = NSUserActivity(activityType: "\(Bundle.main.bundleIdentifier ?? "").\(key)")
        activity.userInfo = [
            "url": item.deeplinkUrl ?? ""
        ]
        activity.keywords = Set<String>((item.keywords ?? []).compactMap { $0 })
        activity.expirationDate = Date().addingTimeInterval(TimeInterval(NSTimeIntervalSince1970))
        activity.isEligibleForPublicIndexing = item.isPublic
        activity.isEligibleForHandoff = false
        activity.isEligibleForSearch = item.isPublic
        activity.contentAttributeSet = attributeSet
        userActivity = activity
        activity.becomeCurrent()
    }
    
    private func loadUrl() {
        connect()
    }
    
    private func connect() {
        if isViewContentAlreadyLoaded {
            return
        }
        if urlString == nil {
            ActivityLoader.hideActivityLoader()
            return
        }

        let urlStringWithParams = JRAPIManager.sharedManager().urlByAppendingDefaultParams(urlString) ?? ""

        if !hideActivityIndicator {
            if !shouldHideIndicator {
                ActivityLoader.showActivityLoader(withPoint: .zero)
            } else {
                ActivityLoader.hideActivityLoader()
            }
        }
        isLoading = true
        
        var urlRequest: NSMutableURLRequest? = nil
        let url = URL(string: urlStringWithParams)
        if url != nil {
            if let url = url {
                urlRequest = NSMutableURLRequest(url: url)
            }
        }
        urlRequest?.httpMethod = urlHTTPMethod
        // Set Headers
        if let urlHeaders = urlHeaders {
            let contentType = urlHeaders["Content-Type"]
            let cacheControl = urlHeaders["Cache-Control"]
            let token = urlHeaders["sso_token"]
            let customerId = urlHeaders["user_id"]
            if contentType != nil {
                urlRequest?.setValue(contentType, forHTTPHeaderField: "Content-Type")
            }
            if cacheControl != nil {
                urlRequest?.setValue(cacheControl, forHTTPHeaderField: "Cache-Control")
            }
            if token != nil {
                urlRequest?.setValue(token, forHTTPHeaderField: "sso_token")
            }
            if customerId != nil {
                urlRequest?.setValue(customerId, forHTTPHeaderField: "user_id")
            }
        }
        
        let headers = urlHeaders ?? [:]
        CommonAPIManager.hitRequestFromBaseVC(withType: urlHTTPMethod, url: urlStringWithParams, headers: headers) { [weak self] (jsonDict, response, error) in
            guard let `self` = self else { return }
            DispatchQueue.main.async {
                if let error = error as NSError? {
                    if error.code == JRErrorCodeGlobal || error.code == JRErrorCodeJsonError {
                        //not calling layout view since it is giving crash in grid page
                        self.parseResponseDictionary(jsonDict as? [AnyHashable : Any], withError: error)
                        if let urlCompletionBlock = self.urlCompletionBlock {
                            urlCompletionBlock(false, jsonDict as? [AnyHashable : Any])
                        }
                        return
                    }
                    
                    if (error.code == JRErrorCodeAuthorizationFailed) {
                        self.parseResponseDictionary(jsonDict as? [AnyHashable : Any], withError: error)
                        self.layOutView()
                        if let urlCompletionBlock = self.urlCompletionBlock {
                            urlCompletionBlock(false, jsonDict as? [AnyHashable : Any])
                        }
                        return
                    }
                }
                
                if let jsonDict = jsonDict as? [AnyHashable : Any] {
                    if let statusDict = jsonDict["status"] as? [AnyHashable : Any] {
                        let status = JRStatus.init(dictionary: statusDict)
                        if status.result == "failure" {
                            if !self.disableErrorAlert {
                                JRAlertViewWithBlock.showAlertView(status.message?.title, message: status.message?.message)
                            }
                            self.isLoading = false

                            if let urlCompletionBlock = self.urlCompletionBlock {
                                urlCompletionBlock(false, jsonDict)
                            }
                            return
                        }
                    }
                    self.parseResponseDictionary(jsonDict, withError: nil)
                    self.layOutView()
                }
                else if let error = error as NSError? {
                    if !self.disableErrorAlert {
                        JRAlertViewWithBlock.showError(error)
                    }
                }
                
                self.isLoading = false
                ActivityLoader.hideActivityLoader()
                if let urlCompletionBlock = self.urlCompletionBlock{
                    urlCompletionBlock(error != nil ? false : true, jsonDict as? [AnyHashable: Any])
                }
            }
        }
    }
}

extension JRBaseVC: PublicSearchActivityProtocol {
    @objc open func urlTypeOfCurrentTopController() -> String {
        return urlType
    }
}

extension JRBaseVC: JRNetworkConnectionVCDelegate {
    
}
