//
//  JRAPIManager.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 08/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit
import AdSupport
import jarvis_utility_ios
import jarvis_network_ios
import WebKit

public let kSsoToken: String = "sso_token"
public let kwalletToken: String = "wallet_token"
public let kTokenType: String = "token_type"
public let kVersion: String = "version"
public let kClient: String = "client"
public let kDeviceIdentifier: String = "deviceIdentifier"
public let kLatitude: String = "lat"
public let kLongitude: String = "long"
public let kDeviceManufacturer: String = "deviceManufacturer"
public let kDeviceName: String = "deviceName"
public let kOsVersion: String = "osVersion"
public let kNetworkType: String = "networkType"
public let kLanguage: String = "language"
public let kChannelForDigitalCatalog: String = "channel"
public let kLocale: String = "locale"
public let kLangId: String = "lang_id"
public let kUserAgent: String = "User-Agent"
public let kChannelIPhone: String = "B2C_IPHONE"


public class JRAPIManager: NSObject {
    fileprivate static let sharedInstance = JRAPIManager()
    
    public let siteIdDefault: Int
    public let childSiteIdDefault: Int
    
    public var sessionId: String?
    @objc public var version: String?
    @objc public var client: String?
    @objc public var deviceIdentifier: String?
    
    private var wkWebView: WKWebView?
    private let kPersistentDefaultUAKey = "default_persistent_user_agent"
    
    public var userAgent: String? {
        get {
            if internalUserAgent == nil {
                fetchUserAgent(completion: nil)
                return getDefaultUA()
            }
            return internalUserAgent
        }
    }
    @objc public var referrerValue: String {
        return UserDefaults.standard.string(forKey: "AdwordsReferrerKey") ?? "";
    }
    fileprivate var internalUserAgent: String?
    
    fileprivate var osVersion: String?
    
    @objc class public func sharedManager() -> JRAPIManager {
        return sharedInstance
    }
    
    override public init() {
        
        version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        
        //client
        
        if JRCommonManager.shared.moduleConfig.varient == .mall{
            client = "mall-iosapp"
        }else{
            client = "iosapp"
        }
        //site id
        if JRCommonManager.shared.moduleConfig.varient == .mall{
            siteIdDefault = 2
            childSiteIdDefault = 6
        }else{
            siteIdDefault = 1
            childSiteIdDefault = 1
        }
        
        //Storing UUID in Keychain!!,just because paytm team wants it to be same for one-user one device
        //Since in previous cases , the UUIDString was getting altered ,on deletion and reinstallation of the app.As a fix we are storing it in Keychain..
        let uniqueId = JRUtility.savedDeviceId()
       /* if let id = FXKeychain.default().object(forKey: JRUUID) as? String {
            uniqueId = id
        } else {
            uniqueId = UIDevice.current.identifierForVendor?.uuidString
            FXKeychain.default().setObject(uniqueId, forKey: JRUUID)
        }*/
        
        let model = UIDevice.current.model
       // if let uniqueId = uniqueId {
            deviceIdentifier = "Apple" + "-\(model)-\(uniqueId)"
      //  }
        osVersion = UIDevice.current.systemVersion
        super.init()
        sessionId = self.uniqueSessionId()
    }
    
    fileprivate func uniqueSessionId() -> String? {
        
        return NSUUID().uuidString
    }
    
    fileprivate func appendParams(params: String, inUrl url: String, encode: Bool) -> String {
        // In case if the url contains "?" then remove "?" from params. url already has some query params.
        var params: String = params
        if url.range(of: "?") != nil {
            params = params.replacingOccurrences(of: "?", with: "&")
        }
        
        var finalURL: String!
        if encode {
            finalURL = url
            
            // Check if the url needs encoding. Encoding without check will lead to double encoding. Expecting a url string.
            if URL(string: url) == nil, let encodedUrl = url.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) {
                finalURL = encodedUrl
            }
            
            // Encode the params before appending.
            finalURL.append(params.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        } else {
            // Encode the params before appending. Ideally we should not be encoding the params as the encode is false but a few verticals (hotels) has stopped functioning. It will bring back the chances of double encoding but we need to wait until verticals make necessary changes.
            finalURL = url.appending(params.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
        }
        
        //CAI-5957: Adding Localization query params in every API
        //Check if catalog append lang_id
        if (finalURL.contains("https://catalog.paytm.com/") || finalURL.contains("https://storefront.paytm.com/")) && !finalURL.contains(kLangId){
            if let locale = LanguageManager.shared.getCurrentLocale(), let langCode = locale.languageCode{
                let paramToAppend: String = "&" + kLangId + "=" +  "\(JRUtility.getLangId(forLangCode : langCode + "-IN"))"
                finalURL = finalURL.appending(paramToAppend.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }else{
                let paramToAppend: String = "&" + kLangId + "=" + "\(JRUtility.getLangId(forLangCode : "en-IN"))"
                finalURL = finalURL.appending(paramToAppend.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? "")
            }
        }
        
        return finalURL
    }
    
    // Appending Site ID and Child Site ID
    fileprivate func defaultParamsWithSiteID(urlString:String?) -> String? {
        var defaultPrms:String?
        if let urlString = urlString, var defaultParam = defaultParams(encode: false)  {
            if apiRequiresSiteIds(urlString) {
                let siteIds: [AnyHashable : Any] = siteIdParams()
                let urlLowerCased: String = urlString.lowercased()
                for (key, value) in siteIds {
                    if let key = key as? String, urlLowerCased.contains(key.lowercased()) == false {
                        defaultParam += "&\(key)=\(value)"
                    }
                }
            }
            
            defaultPrms = defaultParam
        }
        
        return defaultPrms
    }
    
    public func defaultParamsDictionary() -> [AnyHashable:Any] {
        var params = [AnyHashable:Any]()
        params[kVersion] = version ?? ""
        params[kClient] = client ?? ""
        params[kDeviceIdentifier] = deviceIdentifier ?? ""
        params[kDeviceManufacturer] = "Apple"
        params[kDeviceName] = JRUtility.platformString
        params[kOsVersion] = osVersion ?? ""
        
        //CAI-5957: Adding Localization query params in every API
        if let locale = LanguageManager.shared.getCurrentLocale(), let langCode = locale.languageCode{
            params[kLocale] = langCode + "-IN"
            params[kLanguage] = langCode + "-IN"
        }else{
            params[kLocale] = "en-IN"
            params[kLanguage] = "en-IN"
        }
        
        params[kNetworkType] = Reachability()?.userSelectedNetworkType() ?? ""
        
        if let locationInfo = JRLocationManager.shared.currentLocationInfo {
            if let lat = locationInfo["lat"] as? Double {
                params[kLatitude] = lat
                
            }
            
            if let long = locationInfo["long"] as? Double {
                params[kLongitude] = long
            }
        }
        
        return params
    }
    
    public func fundTrnasferParamDictionary() -> [AnyHashable : Any] {
        var params: [AnyHashable:Any] = [AnyHashable:Any]()
        params[kClient] = client ?? ""
        params[kDeviceIdentifier] = deviceIdentifier ?? ""
        params[kDeviceManufacturer] = "Apple"
        params[kDeviceName] = JRUtility.platformString
        if let ip = JRUtility.getIPAddressForCellOrWireless() {
            params["ipAddress"] = ip
        }else {
            params["ipAddress"] = "127.0.0.1"
        }
        params[kLanguage] = "en-IN"
        params[kLatitude] = "0"
        params[kLongitude] = "0"
        if let locationInfo = JRLocationManager.shared.currentLocationInfo {
            if let lat = locationInfo["lat"] as? Double {
                params[kLatitude] = "\(lat)"
            }
            
            if let long = locationInfo["long"] as? Double {
                params[kLongitude] = "\(long)"
            }
        }
        params["location"] = JRCommonUtility.getLocationString() //address
        params[kNetworkType] = Reachability()?.userSelectedNetworkType() ?? ""
        params[kOsVersion] = osVersion ?? ""
        params[kVersion] = version ?? ""
        params[kUserAgent] = kChannelIPhone
        return params
    }
    
    public func siteIdParams() -> [AnyHashable:Any] {
        var params = [AnyHashable:Any]()
        params["site_id"] = JRCommonManager.shared.applicationDelegate?.getSiteId() ?? siteIdDefault
        params["child_site_id"] = JRCommonManager.shared.applicationDelegate?.getChildSiteId() ?? childSiteIdDefault
        return params
    }
    
    public func defaultParams(encode: Bool) -> String? {
        var defaultParams: String = "?"
        let params: [AnyHashable : Any] = defaultParamsDictionary()
        for (key, value) in params {
            if defaultParams.length > 1 {
                defaultParams.append("&")
            }
            defaultParams.append("\(key)=\(value)")
        }
        
        return encode ? defaultParams.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) : defaultParams
    }
    
    public func apiRequiresSiteIds(_ url: String) -> Bool {
        var requires: Bool = false
        
        let domains: [String] = siteIdDependentAPIDomains()
        let urlLowerCased: String = url.lowercased()
        for domain in domains {
            if urlLowerCased.contains(domain.lowercased()) {
                requires = true
                break
            }
        }
        return requires
    }
    
    
    /// Returns the default params dictionary along with siteID paramaters if applicable
    ///
    /// - Parameter urlString: urlString to check if the url requires siteIDs
    public func defaultParamsWithSiteIDs(for urlString:String?) ->[AnyHashable:Any]? {
        guard let urlString = urlString else {
            return nil
        }
        
        var params: [AnyHashable : Any] = defaultParamsDictionary()
        if apiRequiresSiteIds(urlString) {
            let siteIds: [AnyHashable : Any] = siteIdParams()
            params += siteIds
        }
        return params
    }
    
    public func siteIdDependentAPIDomains() -> [String] {
        var domains: [String] = [String]()
        domains.append("cart")
        domains.append("search")
        domains.append("promosearch")
        domains.append("middleware.paytmmall.com")
        domains.append("exchange-productservice.paytmmall.com")
        domains.append("storefront.paytm.com")
        if JRCommonManager.shared.moduleConfig.varient == .mall{
            domains.append("product_codes")
        }else{
            domains.append("catalog")
            domains.append("hotels")
        }
        
        return domains
    }
    
    public func isURLContainsDefaultParams(_ url: String?) -> Bool {
        return url?.range(of: kDeviceIdentifier)?.lowerBound != nil
    }
    
    public func containsSSOToken(url: String?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return url.range(of: kSsoToken)?.lowerBound != nil
    }
    
    public func containsWalletToken(url: String?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return url.range(of: kwalletToken)?.lowerBound != nil
    }
    
    public func containsTokenType(url: String?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return url.range(of: kTokenType)?.lowerBound != nil
    }
    
    public func containsLocale(url: String?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return url.range(of: kLocale)?.lowerBound != nil
    }
    
    public func containsChannel(url: String?) -> Bool {
        guard let url = url else {
            return false
        }
        
        return url.range(of: kChannelForDigitalCatalog)?.lowerBound != nil
    }
    
    @objc public func urlByAppendingDefaultParams(_ url: String?, encoded encode: Bool) -> String? {
        if !isURLContainsDefaultParams(url) {
            let defaultParam: String? = defaultParamsWithSiteID(urlString: url)
            if let defaultParam = defaultParam, let url = url {
                return appendParams(params: defaultParam, inUrl: url, encode: encode)
            }
        }
        return url
    }
    
    @objc public func urlByAppendingDefaultParams(_ url: String?) -> String? {
        return urlByAppendingDefaultParams(url, encoded: true)
    }
    
    public func urlByAppendingDefaultParamsForUPI(_ url: String?) -> String? {
        
        func getLanguageCodeForSelectedLanguage() -> String {
            if let locale = LanguageManager.shared.getCurrentLocale(), let langCode = locale.languageCode{
                return langCode.replacingOccurrences(of: "-IN", with: "")
            }
            return "en"
        }
        
        if let urlStr = url, var urlStringWithParams = urlByAppendingDefaultParams(urlStr) {
            if urlStringWithParams.range(of: "languages")?.lowerBound == nil {
                let language: String = getLanguageCodeForSelectedLanguage()
                urlStringWithParams =  urlStringWithParams + String(format: "&languages=%@", language)
            }
            return urlStringWithParams
        }
        return nil
    }
    
    @objc public func urlByAppendingOtherParamForDigitalCatalog(_ url: String?) -> String? {
        if !isURLContainsDefaultParams(url) {
            var defaultParam: String? = defaultParamsWithSiteID(urlString: url)
            if defaultParam != nil {
                if false == containsLocale(url: defaultParam){
                    if let regionCode = Locale.current.regionCode, let languageCode = Locale.current.languageCode {
                        defaultParam = defaultParam! + "&\(kLocale)=\(languageCode)-\(regionCode)"
                    }
                }
                if false == containsChannel(url: defaultParam) {
                    defaultParam = defaultParam! + "&\(kChannelForDigitalCatalog)=ios"
                }
                return appendParams(params: defaultParam!, inUrl: url ?? "", encode: true)
            }
            
            
        }
        return url
        
    }
    
    @objc public func urlByAppendingSSOtoken(_ url: String?) -> String? {
        var params: String? = nil
        if false == containsSSOToken(url: url), let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
            params = String(format: "?%@=%@", kSsoToken, ssoToken)
        }
        
        if let params = params, let url = url {
            return appendParams(params: params, inUrl: url, encode: true)
        } else {
            return url
        }
    }
    
    @objc public func urlByAppendingDefaultParamsWithSSOToken(_ url: String?) -> String? {
        var params: String? = nil
        if false == isURLContainsDefaultParams(url) {
            params = defaultParamsWithSiteID(urlString: url)
        }
        
        if false == containsSSOToken(url: url), let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken(){
            if params == nil {
                params = String(format: "?%@=%@", kSsoToken, ssoToken)
            } else {
                params?.append(String(format: "&%@=%@", kSsoToken, ssoToken))
            }
        }
        if let params = params, let url = url {
            return appendParams(params: params, inUrl: url, encode: true)
        } else {
            return url
        }
    }
    
    @objc public func urlByUpdatingSSOToken(_ url: String?, handler: ((_ url: String?) -> Void)?) {
        if let url = url {
            do {
                let regex: NSRegularExpression = try  NSRegularExpression(pattern: String(format: "%@=(.*)&", kSsoToken), options: .caseInsensitive)
                
                regex.enumerateMatches(in: url, options: .reportCompletion, range:NSMakeRange(0, url.length)) { (match: NSTextCheckingResult?, flags: NSRegularExpression.MatchingFlags, stop: UnsafeMutablePointer<ObjCBool>) -> Void in
                    
                    if let match = match, match.numberOfRanges > 0 {
                        
                        
                        let insideString: String = (url as NSString).substring(with: match.range(at: 0))
                        if let token = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                            let newsso: String = kSsoToken + "=" + token + "&"
                            
                            let result: String  = url.replacingOccurrences(of: insideString, with: newsso)
                            handler?(result)
                            return
                        }
                        handler?(nil)
                        return
                    }
                }
            }
            catch {
                
            }
        }
    }
    
    
    @objc public func urlByAppendingDefaultParamsWithWalletTokenAndSSOToken(_ url: String?) -> String? {
        var params: String? = nil
        if false == isURLContainsDefaultParams(url) {
            params = defaultParamsWithSiteID(urlString: url)
        }
        
        var appendTokenType: Bool = false
        if false == containsWalletToken(url: url), let walletToken = JRCommonManager.shared.applicationDelegate?.getWalletToken(){
            if params == nil {
                params = String(format: "?%@=%@", kwalletToken, walletToken)
            } else {
                params?.append(String(format: "&%@=%@", kwalletToken, walletToken))
            }
            appendTokenType = true
        }
        
        if false == containsSSOToken(url: url), let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
            if params == nil {
                params = String(format: "?%@=%@", kSsoToken, ssoToken)
            } else {
                params?.append(String(format: "&%@=%@", kSsoToken, ssoToken))
            }
            appendTokenType = true
        }
        
        if appendTokenType, false == containsTokenType(url: url) {
            if params == nil {
                params = String(format: "?%@=%@", kTokenType, "oauth")
            } else {
                params?.append(String(format: "&%@=%@", kTokenType, "oauth"))
            }
        }
        
        if let params = params, let url = url {
            return appendParams(params: params, inUrl: url, encode: true)
        } else {
            return url
        }
    }
    
    @objc public func urlByAppendingDefaultParamsWithoutWalletAndSSOToken(_ url: String?) -> String? {
        var params: String? = nil
        if false == isURLContainsDefaultParams(url) {
            params = defaultParamsWithSiteID(urlString: url)
        }
        
        if false == containsTokenType(url: url) {
            if params == nil {
                params = String(format: "?%@=%@", kTokenType, "oauth")
            } else {
                params?.append(String(format: "&%@=%@", kTokenType, "oauth"))
            }
        }
        
        if let params = params, let url = url {
            return appendParams(params: params, inUrl: url, encode: true)
        } else {
            return url
        }
    }
    
    @objc public func urlByAppendingDefaultParamsWithWalletToken(_ url: String?) -> String? {
        var params: String? = nil
        if false == isURLContainsDefaultParams(url) {
            params = defaultParamsWithSiteID(urlString: url)
        }
        
        if false == containsWalletToken(url: url), let walletToken = JRCommonManager.shared.applicationDelegate?.getWalletToken() {
            if params == nil {
                params = String(format: "?%@=%@", kwalletToken, walletToken)
            } else {
                params?.append(String(format: "&%@=%@", kwalletToken, walletToken))
            }
        }
        
        if let params = params, let url = url {
            return appendParams(params: params, inUrl: url, encode: true)
        } else {
            return url
        }
    }
    
    @objc public func urlByAppendingProductImageSizeAndQualityToUrl(_ url: String?) -> String? {
        var url: String? = url
        url = urlByAppendingDefaultParamsWithSSOToken(url)
        
        var height: CGFloat = JRSwiftConstants.windowHeigth
        var width: CGFloat = JRSwiftConstants.windowWidth
        if UIScreen.main.scale == 2.0 {
            width *= 2
            height *= 2
        }
        if url?.range(of: "?")?.lowerBound != nil  {
            return url?.appending(String(format: "&resolution=%dx%d&quality=high", width, height))
        }
        return url?.appending(String(format: "?resolution=%dx%d&quality=high", width, height))
    }
    
    @objc public func getIDFAIdentifier()-> String?{
        // Check if Advertising Tracking is Enabled
        if ASIdentifierManager.shared().isAdvertisingTrackingEnabled {
            // Set the IDFA
            return ASIdentifierManager.shared().advertisingIdentifier.uuidString
        }
        return nil
    }
    
    /*
     * append fetch strategy
     */
    @objc public func urlByAppendingFetchStrategy( _ url: String? ,fetchParam: String ) -> String?{
        if let urlStr = url{
            var urlStrate: String = urlStr
            if urlStr.range(of: "fetch_strategy")?.lowerBound == nil && !fetchParam.isEmpty {
                urlStrate =  urlStr + String(format: "?fetch_strategy=%@", fetchParam)
            }
            return urlByAppendingDefaultParams(urlStrate)
        }
        return ""
    }
}


//MARK: user agent methods
extension JRAPIManager {
    public func fetchUserAgent(completion: ((String?)->Void)?) {
        guard let ua = internalUserAgent else {
            extractUserAgent {[weak self] (uaStr) in
                guard let weakSelf = self else {
                    return
                }
                weakSelf.internalUserAgent = uaStr
                if uaStr !=  nil {
                    UserDefaults.standard.set(uaStr!, forKey: weakSelf.kPersistentDefaultUAKey)
                }
                completion?(uaStr)
            }
            return
        }
        completion?(ua)
    }
    
    private func extractUserAgent(completion: ((String?)->Void)?) {
        DispatchQueue.main.async {
            if self.wkWebView == nil {
                self.wkWebView = WKWebView()
            }
            self.wkWebView?.evaluateJavaScript("navigator.userAgent", completionHandler: {[weak self] (userAgent, error) in
                completion?(userAgent as? String)
                self?.wkWebView = nil
            })
        }
    }
    
    private func getDefaultUA()-> String {
        guard let persistentUA = UserDefaults.standard.string(forKey: kPersistentDefaultUAKey) else {
            let iOSVersion = UIDevice.current.systemVersion.replacingOccurrences(of: ".", with: "_")
            return "Mozilla/5.0 (iPhone; CPU iPhone OS \(iOSVersion) like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Mobile"
        }
        return persistentUA
    }
}
