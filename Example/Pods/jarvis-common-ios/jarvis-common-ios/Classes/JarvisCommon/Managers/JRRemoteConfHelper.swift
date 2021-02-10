//
//  JRRemoteConfHelper.swift
//  Jarvis
//
//  Created by Prakash Jha on 03/08/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class JRRemoteConfHelper: NSObject {
    //-----
    //
    public class var shouldShowWeexPopUpHeader: Bool {
        if let configValue: Bool = JRRemoteConfigManager.value(key: "gamepind_weex_popup_android_header") {
            return configValue
        }
        return true
    }
    
    public class var weexPopUpHeightRatio: Float {
        if let hRatio: Float = JRRemoteConfigManager.value(key: "gamepind_weex_popup_height_ratio"),
            hRatio < 1, hRatio > 0  {
            return hRatio
        }
        return 0.85
    }
    //----
    
    public class var whiteListedMallH5Domains: [String]? {
        var names: [String]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "whiteListedMallH5Domains"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                
                names = jsonDict as? [String]
            } catch {}
        }
        return names
    }
    
    public class var getIoclBaseUrl: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclBaseUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var isNewForgotPwdFlowEnabled: Bool {
        return JRRemoteConfigManager.value(key: "is_new_forgot_pwd_flow_enabled") ?? false
    }
    
    public class var updatesTabsList: [String]? {
        var updatesTabsList: [String]? = nil
        if let tabsList = JRRemoteConfigManager.stringFor(key: "updates_tabs_list") {
            updatesTabsList = tabsList.components(separatedBy: ",")
        }
        return updatesTabsList
    }
    
    public class var weexHomeMallUrl: String? { // unused
        var url: String? = nil
        if let weexMallHomePageUrl = JRRemoteConfigManager.stringFor(key: "mall_homepage") {
            url = weexMallHomePageUrl
        }
        return url
    }
   
    
    public class var useNewInboxFlow : Bool { // unused(pod)
        return JRRemoteConfigManager.value(key: "use_new_inbox_flow") ?? true
    }

    public class var shouldShowLoyaltyInLeft : Bool {
        return JRRemoteConfigManager.value(key: "shouldShowLoyaltyInLeft") ?? false
    }
    
    @objc public class var creditScoreDeepLink: String {
        if let mDeepLink = JRRemoteConfigManager.stringFor(key: "CreditScoreDeepLink")  {
            return mDeepLink
        }
        
        #if DEBUG
        return "paytmmp://weexurl?url=https://dg-static1.paytm.com/weex/creditScore.js"
        #else
        return ""
        #endif
    }
    
    public class var loyaltyCardUrl: String {
        var urlStr: String = "https://digitalproxy.paytm.com/loyalty/v1/loyalty-cards/customer?phonenumber="
        if let str = JRRemoteConfigManager.stringFor(key: "loyaltyCardUrl") {
            urlStr = str
        }
        return urlStr
    }
    
    @objc public class var whiteListedWebViewDomains: String? {
        return JRRemoteConfigManager.stringFor(key: "whiteListedWebViewDomain")
    }
    
    public class var blacklistedWebViewDomains: String? {
        return JRRemoteConfigManager.stringFor(key: "miniapp_global_domain_blacklist")
    }
    
    public class var URLPaytmPostpaid: String? {
        return JRRemoteConfigManager.stringFor(key: "KeyPaytmPostPaid")
    }
    
    public class var userDropPushTime:Double {
        return JRRemoteConfigManager.value(key: "UserDropPushTime") ?? 0
    }
    
    public class var msitePGOrderSummaryURL: String? {
        return JRRemoteConfigManager.stringFor(key: "shopSummary")
    }
    
    
    @objc public class var URLPaytmCashFAQ: String? {
        return JRRemoteConfigManager.stringFor(key: "paytmcashFAQ")
    }
    
    public class var URLFavoriteRemove: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "removeFavourites")
    }
    
    public class var URLFavorite: String? {
        return JRRemoteConfigManager.stringFor(key: "setFavourites")
    }
    
    @objc public class var URLOperatorImage: String? {
        return JRRemoteConfigManager.stringFor(key: "operatorImageUrl")
    }
    
    @objc public class var URLFilteredTransanctionHistory: String? { //Order summary Refund to bank
        return JRRemoteConfigManager.stringFor(key: "FilteredTransactionHistory")
    }
    
    @objc public class var URLOrderSummaryAdWorks: String? {
        return JRRemoteConfigManager.stringFor(key: "summary_page_adwork_url")
    }
    
    public class var URLNotificationsSetting: String? { // Unused
        return JRRemoteConfigManager.stringFor(key: "userPreferences")
    }
    
    public class var URLGetCatalog: String? { // Unused
        // self.URLGetCatalog = String.validString(val: container.string(forKey: "getcatalogurl"))
        return JRRemoteConfigManager.stringFor(key: "flyoutCatalogUrl")
    }
    
    @objc public class var URLRecommendations: String? { // Unused
        return JRRemoteConfigManager.stringFor(key: "recommendations")
    }
    
    public class var URLSearch: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "searchurl")
    }
    
    @objc public class var URLSignIn: String? {
        return JRRemoteConfigManager.stringFor(key: "signin") ?? "https://accounts.paytm.com/oauth2/authorize"
    }
    
    @objc public class var URLSignOut: String? {
        return JRRemoteConfigManager.stringFor(key: "signout") ?? "https://accounts.paytm.com/oauth2/accessToken"
    }
    
    @objc public class var URLAddresses: String? {
        return JRRemoteConfigManager.stringFor(key: "addressesV2")
    }
    
    @objc public class var URLSignUp: String? {
        return JRRemoteConfigManager.stringFor(key: "SignupV2") ?? "https://accounts.paytm.com/v2/api/register"
    }
    
    public class var URLPlaceOrder: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "placeorder")
    }
    
    @objc public class var URLOrderDetail: String? {
        return JRRemoteConfigManager.stringFor(key: "orderdetail")
    }
    @objc public class var URLInsuranceOrderDetail: String? {
        if let result =  JRRemoteConfigManager.stringFor(key: "insuranceOrderSummary"), result.length > 0{
            return result
        }
        return "https://gateway.paytminsurance.co.in/cart/v1/myOrders/"
    }
    
    /* Localiazation keys - STARTS HERE */
    public class var fetchSupportedLanguageListFrequency : Int{ //Number of hours
        if let value: Int =  JRRemoteConfigManager.value(key: "fetch_supported_language_frequency"), value > 0{
            return Int(value)
        }
        return 24
    }
    
    public class var frequencyToUpdateLanguagePackage : Int{
        if let value: Int =  JRRemoteConfigManager.value(key: "frequency_to_update_language_package"), value > 0{
            return Int(value)
        }
        return 24
    }
    
    public class var URLFetchSupportedLanguageList : String {
        if let result =  JRRemoteConfigManager.stringFor(key: "fetch_supported_lang_list_url"), result.length > 0{
            return result
        }
        return "https://digitalapiproxy.paytm.com/localisation/v1/getLanguages"
    }
    
    public class var URLDownloadLanguage : String {
        if let result =  JRRemoteConfigManager.stringFor(key: "download_language_url"), result.length > 0{
            return result
        }
        return "https://digitalapiproxy.paytm.com/localisation/v1/getMessages"
    }
    
    public class var URLUpdateLanguage : String {
        if let result =  JRRemoteConfigManager.stringFor(key: "update_language_url"), result.length > 0{
            return result
        }
        return "https://digitalapiproxy.paytm.com/localisation/v1/getMessages"
    }
    
    public class var isHindiLangEnabled : Bool {
        return JRRemoteConfigManager.value(key: "isHindiLangEnabled") ?? false
    }
    
    /* Localiazation keys - ENDS HERE */
    
    public class var URLmwTimesLot: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "mw_timeslot_url")
    }
    
    public class var cashbackInformationMessage: String? {
        return JRRemoteConfigManager.stringFor(key: "cashbackInfoMessage")
    }
    
    @objc public class var URLGetAllTokens: String? {
        return JRRemoteConfigManager.stringFor(key: "getalltokens")
    }
    @objc public class var URLGetToken: String? {
        return JRRemoteConfigManager.stringFor(key: "gettoken") ?? "https://accounts.paytm.com/oauth2/token"
    }
    @objc public class var URLForgotPassword: String? {
        return JRRemoteConfigManager.stringFor(key: "forgotPassword")
    }
    @objc public class var URLUserInfoUpdation: String? {
        return JRRemoteConfigManager.stringFor(key: "userInfoUpdation")
    }
    @objc public class var URLPhoneAvailability: String? {
        return JRRemoteConfigManager.stringFor(key: "phoneAvailability")
    }
    @objc public class var URLEmailAvailability: String? {
        return JRRemoteConfigManager.stringFor(key: "emailAvailability")
    }
    
    @objc public class var URLChangePassword: String? {
        return JRRemoteConfigManager.stringFor(key: "changePasswordV2")
    }
    @objc public class var URLResetLoginPassword: String? {
        return JRRemoteConfigManager.stringFor(key: "resetLoginPassword")
    }
    @objc public class var URLHelpScreen: String? { // should be in CST
        return JRRemoteConfigManager.stringFor(key: "helpScreenUrl")
    }
    public class var URLLeadOnAppLaunch: String? {
        return JRRemoteConfigManager.stringFor(key: "leadAPIOnAppLaunch")
    }
    public class var URLLeadOnOrderSummary: String? {
        return JRRemoteConfigManager.stringFor(key: "leadAPIOnOrderSummary")
    }
    
    public class var nonAadhaarKYCPointsURL: String? {
        return JRRemoteConfigManager.stringFor(key: "nonAadhaarKycPoints")
    }
    
    public class var isKYCFlowActivated: Bool {
        return JRRemoteConfigManager.value(key: "isKYCFlowActivated") ?? true
    }
    
    public class var canShowRNRPopup: Bool {
        return JRRemoteConfigManager.value(key: "canShowRNRPopup") ?? false
    }
    
    @objc public class var offlinePGEmiShowLogic: String? {
        var offlinePGEmiShow: String = "1,1,1,1" // "QR With Amount, Link with amount, Link without amount, QR Without Amount"
        if let emiLogic: String = JRRemoteConfigManager.stringFor(key: "offlinePGEmiShowLogic") {
            offlinePGEmiShow = emiLogic
        }
        return offlinePGEmiShow
    }
    
    // JRRemoteConfHelper
    @objc public class var URLTermsAndConditions: String? {
        return JRRemoteConfigManager.stringFor(key: "termsAndConditionsUrl")
    }
    @objc public class var URLMallPolicy: String? {
        return JRRemoteConfigManager.stringFor(key: "mall_policy_url")
    }
    @objc public class var URLPrivacyPolicy: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "privacyPolicyUrl")
    }
    @objc public class var URLGetOTP: String? {
        return JRRemoteConfigManager.stringFor(key: "getOTP")
    }
    @objc public class var URLSendVerificationLink: String? {
        return JRRemoteConfigManager.stringFor(key: "emailVerificationLink")
    }
    @objc public class var URLValidatePhone: String? {
        return JRRemoteConfigManager.stringFor(key: "validatePhone")
    }
    
    public class var URLAdWorks: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "URLAdWorks")
    }
    
    
    
    @objc public class var URLForgotPasswordOTP: String? {
        return JRRemoteConfigManager.stringFor(key: "forgotPasswordOTP")
    }
    @objc public class var URLResetPassword: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "resetPassword")
    }
    public class var URLCheckBalance: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "checkBalance")
    }
    public class var URLPaytmCashWalletHelpUrl: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "paytmCashWalletHelpUrl")
    }
    @objc public class var URLPgCancelOrder: String? {
        return JRRemoteConfigManager.stringFor(key: "pgCancel")
    }
        
    @objc public class var PaytmCashProductID: String {
        var productId: String = "19999" // wallet production product Id
        if let prdId = JRRemoteConfigManager.stringFor(key: "PaytmCashProductId") {
            productId = prdId
        }
        return productId
    }
    
    @objc public class var URLUpdateEmailV2: String? {
        return JRRemoteConfigManager.stringFor(key: "updateEmailV2")
    }
    @objc public class var URLUpdatePhoneV2: String? {
        return JRRemoteConfigManager.stringFor(key: "updatePhoneV2")
    }
    @objc public class var URLResendOTPV2: String? {
        return JRRemoteConfigManager.stringFor(key: "profileResendOTPV2")
    }
    @objc public class var URLValidateOTPV2: String? {
        return JRRemoteConfigManager.stringFor(key: "profileValidateOTPV2")
    }
    
    
    
    @objc public class var showStep2InNormalFlow: Bool { // unused
        return JRRemoteConfigManager.value(key: "showStep2") ?? false
    }
    
    @objc public class var showCommingSoonVC: Bool { // unused
        return JRRemoteConfigManager.value(key: "travelBuddyReDirectionToAppUpgrade") ?? false
    }
    
    @objc public class var shouldShowCarousal: Bool {
        return JRRemoteConfigManager.value(key: "showCarousal") ?? false
    }
    @objc public class var shouldShowWalletDisclaimer: Bool { // unused
        return JRRemoteConfigManager.value(key: "walletDisclaimer_show") ?? false
    }
    
    @objc public class var showStep2InTransactionFlow: Bool { // unused
        return JRRemoteConfigManager.value(key: "ShowStep2InTxnFlow") ?? false
    }
    
    public class var homeLaunchAnimationURL: String? {
        return JRRemoteConfigManager.stringFor(key: "keySplashAnimationFileUrl")
    }
    
    @objc public class var URLSocialSignIn: String? {
        return JRRemoteConfigManager.stringFor(key: "socialAuthorizeV2")
    }
    @objc public class var URLSocialConfirmPassword: String? {
        return JRRemoteConfigManager.stringFor(key: "socialConfirmPasswordV2")
    }
    public class var URLTabBarMenu: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "tabMenu")
    }
    public class var walletHomeURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "WalletHome")
    }
    @objc public class var URLWalletSendMoney: String? {
        return JRRemoteConfigManager.stringFor(key: "walletSendMoneyV2")
    }
    
    public class var URLNearByAddMoneyPoint : String { // unused(moved to pod)
        var url: String = "https://kyc.paytm.com/v1/nearby/points?filters=isaddmoney"
        if let tUrl = JRRemoteConfigManager.stringFor(key: "nearByAddMoneyPoint") {
            url = tUrl
        }
        return url
    }
    
    //----Unused---
    //Live Cricket Score
    public class var showLiveCricket: Bool {
        return JRRemoteConfigManager.value(key: "showLiveCricket") ?? false
    }
    public class var liveMatchDLUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "iplLiveMatchDeeplinkIOS")
    }
    public class var upcomingMatchDLUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "iplUpcomingMatchDeeplinkIOS")
    }
    public class var pastMatchDLUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "iplPastMatchDeeplinkIOS")
    }
    //------
}

extension JRRemoteConfHelper {
    public class var URLExpressCheckoutVerify: String? { // unused
        return "https://cart.paytm.com/v1/expresscart/verify"
    }
    
    public class var checkBalanceMID: String? {
        return JRRemoteConfigManager.stringFor(key: "check_balance_mid")
    }
    
    @objc public class var URLOrderHistory: String? {
        return JRRemoteConfigManager.stringFor(key: "myorders")
    }
    
    @objc public class var URLUserAccount: String? {
        return JRRemoteConfigManager.stringFor(key: "userAccount")
    }
    public class var URLOrderSummaryBanner: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "thank_you_page_promotion_banner")
    }
    
    public class var trustListUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "trustListURL")
    }
    
    //Home Anouncements
    public class var announcement: (title : String, url : String)? { // unused
        if let announcementString = JRRemoteConfigManager.stringFor(key: "announcement") {
            let compArray = announcementString.components(separatedBy: "|")
            if compArray.count > 1
            {
                return (title : compArray[0], url : compArray[1])
            }
        }
        
        return nil
    }
    
    public class var isLocalizationEnabled : Bool {
        //return false // We are desabling localisation feature for 7.3.0 as of now
        return JRRemoteConfigManager.value(key: "isSupportedLocalization") ?? true
    }
    
    public class var homeStorefrontUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "homeStoreFrontURL") ?? "https://storefront.paytm.com/v2/h/paytm-homepage"
    }
    
    public class var showMoreUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "showMoreUrl") ?? "https://storefront.paytm.com/v2/h/show-more-icons"
    }
    
    public class var UrlRechargeCategory: String? {
        return JRRemoteConfigManager.stringFor(key: "urlRechargeCategory")
    }
    
    public class var URLGetCatalogV2: String? {
        return JRRemoteConfigManager.stringFor(key: "flyoutCatalogUrl_v2")
    }
    
    @objc public class var URLSearchV2: String? {
        return JRRemoteConfigManager.stringFor(key: "searchurl_v2")
    }
    
    @objc public class var URLSavedCardList: String? {
        return JRRemoteConfigManager.stringFor(key: "SavedCard")
    }
    public class var URLCustomListLayout: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "customListLayoutURL")
    }
    
    @objc public class var paytmCashMaxDigit: Int {
        return JRRemoteConfigManager.value(key: "max_digit_paytmcash") ?? 5
    }
    
    @objc public class var URLLocationInfo: String? {
        return JRRemoteConfigManager.stringFor(key: "getLocation")
    }
    @objc public class var URLTagdevice: String? {
        return JRRemoteConfigManager.stringFor(key: "tagdevice")
    }
    
    //--- Push SDK - Starts Here---
    public class var nativePushSDKURL : String {
        var stagingURL = /*isProdBuild ? */"https://push-registry.paytm.com" /*: "https://prs-staging.paytm.com"*/
        if let str = JRRemoteConfigManager.stringFor(key: "deviceTokenRegisterURL"), str.count > 0 {
            stagingURL = str
        }
        return stagingURL
    }
    
    public class var nativePushSDKInboxFlashURL : String {
        var stagingURL = /*isProdBuild ? */"https://push-inbox.paytm.com" /*: "https://pic-staging.paytm.com"*/
        if let str = JRRemoteConfigManager.stringFor(key: "inboxFlashMessageURL"), str.count > 0 {
            stagingURL = str
        }
        return stagingURL
    }
    //---Push SDK - Ends Here--
    
    
    // Paytm Analytics - Starts Here
    public class var isSignalSDKEnabled : Bool{
        return JRRemoteConfigManager.value(key: "isSignalSDKEnabled") ?? false
    }
    
    public class var isNetworkSDKEnabled : Bool{
        return JRRemoteConfigManager.value(key: "isNetworkSDKEnabled") ?? false
    }
    
    public class var isErrorEventEnabled : Bool { // unused
        return JRRemoteConfigManager.value(key: "isErrorEventEnabled") ?? true
    }
    
    public class var isLatencyEventEnabled : Bool { // unused
        return JRRemoteConfigManager.value(key: "isLatencyEventEnabled") ?? true
    }
    
    public class var isAPITrackCountEventEnabled : Bool{ // unused
        return JRRemoteConfigManager.value(key: "isAPITrackCountEventEnabled") ?? true
    }
    
   public class  var isDAUEventEnabled : Bool{ // unused
        return JRRemoteConfigManager.value(key: "isDAUEventEnabled") ?? true
    }
    
    public class var isSizeAlertEventEnabled : Bool{ // unused
        return JRRemoteConfigManager.value(key: "isSizeAlertEventEnabled") ?? true
    }
        
    public class var URLSignalSDK : String {
        return JRRemoteConfigManager.stringFor(key: "signal_sdk_url") ?? "https://sig.paytm.com/signals/batch"
    }
    
    public class var URLDebugAnalyticsSDK : String {
        return JRRemoteConfigManager.stringFor(key: "debug_analytics_sdk_url") ?? "https://hawkeye-staging.paytm.com/appdebuganalytics/triggers/save"
    }
    
    // JRRemoteConfHelper
    public class var ThresholdDebugAnalytics : Double? { // unused
        return JRRemoteConfigManager.value(key: "app_api_threshold_timeInterval")
    }
    
    public class var networkSDKDispatchIntervalInSeconds : Double {
        if let gtmValue : Double = JRRemoteConfigManager.value(key: "debug_analytics_dispatch_interval"), gtmValue > 0.0{
            return gtmValue
        }
        return 60.0
    }
    
    public class var networkSDKSizeAlertInKb : Double{ // unused
        if let gtmValue : Double = JRRemoteConfigManager.value(key: "debug_analytics_sizeAlertInKb") {
            return gtmValue
        }
        return 100.0
    }
    
    public class var networkSDKSizeAlertInKbforJSONType : Double{ // unused
        if let gtmValue : Double = JRRemoteConfigManager.value(key: "debug_analytics_sizeAlertInKb_json") {
            return gtmValue
        }
        return 50.0
    }
    
    public class var needToSendResponseData : Bool{ // unused
        if let gtmValue : Bool = JRRemoteConfigManager.value(key: "analytics_needToSendResponseData") {
            return gtmValue
        }
        return false
    }
    
    public class var apiCountAndDailyActiveUserSyncInterval : Int { // unused
        if let gtmValue: Int = JRRemoteConfigManager.value(key: "apiCountAndDailyActiveUserSyncInterval"), gtmValue > 0{
            return gtmValue
        }
        return 24
    }
    
    @objc public class var expressCheckoutURL: String? {
        return JRRemoteConfigManager.stringFor(key: "mp_express_checkout_url")
    }
    
    public class var emiWebViewURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "emi_webview_url")
    }
    public class var logoutFromAllDevicesThroughProfilePageURL: String? { // profile
        return JRRemoteConfigManager.stringFor(key: "logoutFromAllDevicesUsingSessionURL")
    }
    public class var logoutFromAllDevicesThroughOTPPageURL: String? { // profile
        return JRRemoteConfigManager.stringFor(key: "logoutFromAllDevicesUsingTokenURL")
    }
    public class var logoutFromAllDevicesTitleLabel: String? { // profile
        return JRRemoteConfigManager.stringFor(key: "logoutFromAllDevicesTitleLabel")
    }
    public class var logoutFromAllDevicesSubTitleLabel: String? { // profile
        return JRRemoteConfigManager.stringFor(key: "logoutFromAllDevicesSubTitleLabel")
    }
    public class var isPDCPromoEnabled: Bool { // unused
        return JRRemoteConfigManager.value(key: "debitCardPromoEnabled") ?? false
    }
    
    public class var UrlSearchWidget: String {
        return String.validString(val: JRRemoteConfigManager.stringFor(key: "search_widget_url")) ?? "https://storefront.paytm.com/v2/h/search-screen"
    }
    
    public class var UrlSearchWidgetNewLayout: String {
        return "https://storefront.paytm.com/v2/h/test-store-1?client=html5&site_id=1&child_site_id=1&platform_version=S2(New)"
    }
    
    @objc public class var URLOrderSummaryBannerV2: String? {
        return JRRemoteConfigManager.stringFor(key: "thank_you_page_promotion_banner_v2")
    }
    @objc public class var URLPostPaymentDeals: String? {
        return JRRemoteConfigManager.stringFor(key: "postPaymentDealsAPI")
    }
    
    @objc public class var URLRUPostOrderFloatingTabBar: String? {
        return JRRemoteConfigManager.stringFor(key: "ruPostOrderFloatingTabBarAPI") ?? "https://storefront.paytm.com/v2/h/post-txn-page-new"
    }
    
    //deal home screen url
    @objc public class var URLDealsHomePage: String? {
        if let str = JRRemoteConfigManager.stringFor(key: "deals_store_front_url") {
            return str
        }
        return "https://storefront.paytm.com/v2/h/deals-for-you"
    }
    
    @objc public class var JRDealCatId: String? { // unused
        
        var productId: String = "5021"
        if let prdId = JRRemoteConfigManager.stringFor(key: "Deals_search_category") {
            productId = prdId
        }
        return productId
    }
    
    public class var DealsBottomTabDictionary: [[String: Any]]? { // unused
        var dict: [[String: Any]]? = nil
        
        
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "dealsBottomBarDict"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                dict = jsonDict as? [[String: AnyObject]]
            } catch {}
        }
        return dict
    }
    
    public class var GiftCardBottomTabDictionary: [[String: Any]]? {
        
        var dict: [[String: Any]]? = nil
        
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "giftCardBottomBarDict"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                dict = jsonDict as? [[String: AnyObject]]
            } catch {}
        }
        return dict
    }
    
    @objc public class var URLSubscribeDeals:String? {
        return "https://apiproxy.paytm.com/v1/deals/proxy/subscribe"
    }
    
    
    // PDP URL
    public class var similarProductsUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "similarProductUrl")
    }
    public class var showPDPMandatoryOffer: Bool { // unused
        return JRRemoteConfigManager.value(key: "showPDPMandatoryOffer") ?? true
    }
    
    public class var URLCheckAvailability: String? {
        return JRRemoteConfigManager.stringFor(key: "checkAvailabilityUrl")
    }
    public class var URLPDPBulkCheckAvailability: String? {
        return JRRemoteConfigManager.stringFor(key: "pdpBulkCheckAvailabilityUrl")
    }
    public class var URLProductInstalationService: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "installationServicesUrl")
    }
    public class var MaxPriceForQuantity: Int {
        return JRRemoteConfigManager.value(key: "maxSellingPriceForQty") ?? 1000
    }
    
    public class var pdpPFAText: [String]? {
        var text: [String]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "pfa_description_text"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                text = jsonDict as? [String]
            } catch {}
        }
        return text
    }
    
    public class var showErrorOnPassbookDownload: Bool { // unused
        return JRRemoteConfigManager.value(key: "show_error_on_stat_download") ?? false
    }
    
    // Deeplink Whitelisted urls
    @objc public class func getWhiteListedDeeplinkUrls() -> [String]? {
        var names: [String]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "whiteListedDeeplinkUrls"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                names = jsonDict as? [String]
            } catch {}
        }
        return names
    }
    
    public class func getEmiTenuresInfos() -> [String]? {
        var names: [String]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "emi_tenures_info"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                names = jsonDict as? [String]
            } catch {}
        }
        return names
    }
    
    // Exchange
    public class var URLExchangeOfferList: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "exchangeOfferList")
    }
    public class var URLExchangeFetchPrice: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "exchangeFetchPrice")
    }
    public class var URLExchangeQuote: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "exchangeQuote")
    }
    public class var URLCheckExchangeAvailability: String? {
        return JRRemoteConfigManager.stringFor(key: "exchangeAvailability")
    }
}

extension JRRemoteConfHelper {
    @objc public class var URLDeleteCard: String? {
        return JRRemoteConfigManager.stringFor(key: "DeleteCard")
    }
    public class var URLSavedCardThumbnail: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "SavedCard_thumbnail")
    }
    @objc public class var URLNotificationCenter_thumbnail: String? {
        return JRRemoteConfigManager.stringFor(key: "NotificationCenter_thumbnail")
    }
    
    @objc public class var URLMyOrdersSearch: String? {
        return JRRemoteConfigManager.stringFor(key: "myorders_search")
    }
    
    public class var bargainButtonText: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "BargainButtonText")
    }
    public class var bargainSubText: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "BargainSubText")
    }
    @objc public class var URLMerchantCall: String? {
        return JRRemoteConfigManager.stringFor(key: "obdCallMerchantUrl")
    }
    @objc public class var URLMerchantSms: String? {
        return JRRemoteConfigManager.stringFor(key: "paymentConfirmationSmsURL")
    }
    
    public class var URLsaveUserPreference : String {
        if let str = JRRemoteConfigManager.stringFor(key: "authPreferences") {
            return str
        }
        return "https://accounts.paytm.com/user/preferences"
    }
    
    public class var forgotPasswordIVRNumber: String? {
        return JRRemoteConfigManager.stringFor(key: "key_forgot_password_ivr")
    }
    
    public class var mmiLocationDistance: String? {
        return JRRemoteConfigManager.stringFor(key: "distanceInSpecificRegionMap")
    }
    
    public class var poweredByNews: String? {
        return JRRemoteConfigManager.stringFor(key: "news_poweredby")
    }
    
    @objc public class var forgetPasswordFraudURL: String? {
        return JRRemoteConfigManager.stringFor(key: "update_fraud_list")
    }
    
    //Loyalty Points Pid
    public class var loyaltyCardPID: String {
        var text: String = ""
        if let loyaltyCardPID = JRRemoteConfigManager.stringFor(key: "loyaltyCardPID") {
            text = loyaltyCardPID
        }
        return text
    }
    
    public class var loyaltyDefaultURL: String {
        var text: String = "https://s3-ap-southeast-1.amazonaws.com/assets.paytm.com/images/catalog/wallet/fallback_card.png"
        if let temp = JRRemoteConfigManager.stringFor(key: "loyaltyDefaultURL") {
            text = temp
        }
        return text
    }
    
    public class var shouldShowChannelRating:Bool{
        return JRRemoteConfigManager.value(key: "shouldShowChannelRating") ?? true
    }
    
    public class var payChannelRNRBaseURL:String?{
        guard let urlStr = JRRemoteConfigManager.stringFor(key: "ChannelBaseUrl") else{ return nil }
        return urlStr
    }
    
    
    public class var pushRegisterDeviceURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "pushRegisterDevice")
    }
    
    public class var isPushSDKEnabled: Bool {
        return JRRemoteConfigManager.value(key: "isPushSDKEnabled") ?? false
    }
    
    public class var logoutIfRequiredURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "logoutIfRequired")
    }
    
    public class var ratesAndChargesUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "ratesAndChargesUrl")
    }
    public class var ratesAndChargesUrl_DebitCard: String? {
        return JRRemoteConfigManager.stringFor(key: "ratesAndChargesForDebitCardUrl")
    }
    
    public class var ProfileComplitionData: [AnyHashable : Any]? {
        var dict: [AnyHashable : Any]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "noKycUserJson"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict: Any = try JSONSerialization.jsonObject(with: data, options: [])
                dict = jsonDict as? [AnyHashable : Any]
            } catch {}
        }
        return dict
    }
    
    // Brand Store URL
    public class var BrandStoreURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "brand_store_url")
    }
    public class var BrandStoreSiteResolver: String? {
        return JRRemoteConfigManager.stringFor(key: "site_resolver_api")
    }
    
    
    // JRRemoteConfHelper
    @objc public class var URLContactUsLabels: String? {
        return JRRemoteConfigManager.stringFor(key: "ContactUsTicketLabels")
    }
    
    @objc public class var URLContactUsCareMessage: String? {
        return JRRemoteConfigManager.stringFor(key: "contact_us_care_message")
    }
    @objc public class var URLValidateRegisterOTP: String? {
        return JRRemoteConfigManager.stringFor(key: "ValidatePhoneV2")
    }
    @objc public class var URLResendOTP: String? {
        return JRRemoteConfigManager.stringFor(key: "ResendOTPV2")
    }
    @objc public class var URLLoginValidateOTP: String? {
        //validate otp method for new login flow
        return JRRemoteConfigManager.stringFor(key: "loginValidateOTP") ?? "https://accounts.paytm.com/login/validate/otp"
    }
    @objc public class var URLLoginResendOTP: String? {
        //resend otp method for new login flow
        return JRRemoteConfigManager.stringFor(key: "loginResendOTP")
    }
    @objc public class var defaultDOB: String? { // unused
        //this is for sign in and sign up step2 pages
        return JRRemoteConfigManager.stringFor(key: "defaultDOB")
    }
    // JRRemoteConfHelper
    @objc public class var URLTwitterConnect: String? {
        return JRRemoteConfigManager.stringFor(key: "URLTwitterConnect")
    }
    public class var URLPushNotificationSettings: String? {
        return JRRemoteConfigManager.stringFor(key: "pushNotificationSettingsNative")
    }
    public class var URLmobileRechargeBanner: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "mobile_recharge_banner")
    }
    
    public class var URLAutomaticLink: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "automaticLink")
    }
    // JRRemoteConfHelper
    public class var URLAutomaticList: String? {// unused
        return JRRemoteConfigManager.stringFor(key: "automaticList")
    }
    @objc public class var URLAutomaticHistory: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "automaticHistory")
    }
    public class var URLTwitterPrefillHashTag: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "twitterPrefillHashTag")
    }
    public class var URLTwitterPrefillMessage: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "twitterPrefillMessage")
    }
    public class var URLBaseCart: String? {
        return JRRemoteConfigManager.stringFor(key: "cartPublicAPI")
    }
    
    public class var URLSearch_base_url: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "search_base_url")   //Grid validation T15621
    }
    // JRRemoteConfHelper
    public class var shouldIncludeHotelLocalities: Bool { // unused
        return JRRemoteConfigManager.value(key: "hotelLocalitiesFilter") ?? false
    }
    
    public class var shouldIncludeHotelType: Bool { // unused
        return JRRemoteConfigManager.value(key: "hotelTypeFilter") ?? false
    }
    public class var URLGetSmartList: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "smartlistUrl")
    }
    
    
    @objc public class var ShowDynamicTrainOrderSummary: Bool { // unused
        return JRRemoteConfigManager.value(key: "isTrainOrderSummaryV2Enable") ?? false
    }
    
    //---Unused
    public class var passcodeExistsURL: String? {
        return JRRemoteConfigManager.stringFor(key: "passcodeExistsURL")
        
    }
    
    public class var passcodeTokenGenerationURL: String? {
        return JRRemoteConfigManager.stringFor(key: "passcodeTokenGenerationURL")
        
    }
    public class var passcodeResetURL: String? {
        return JRRemoteConfigManager.stringFor(key: "passcodeResetURL")
        
    }
    public class var passcodeSetURL: String? {
        return JRRemoteConfigManager.stringFor(key: "passcodeSetURL")
        
    }
    public class var passcodeValidateURL: String? {
        return JRRemoteConfigManager.stringFor(key: "passcodeValidateURL")
        
    }
    //-----
    // JRRemoteConfHelper
}


// MARK: - Mall Only
extension JRRemoteConfHelper {
    public class var signUpCashbackOffer: String? {
        return JRRemoteConfigManager.stringFor(key: "login_promo_text")
    }
    
    public class var forgotPasswordPaytmText: String? {
        return JRRemoteConfigManager.stringFor(key: "reset_password_text")
    }
    
    public class var forgotPasswordPaytmNumber: String? {
        return JRRemoteConfigManager.stringFor(key: "reset_password_number")
    }
}

// MARK: - Profile+Home
extension JRRemoteConfHelper {
    public class var leftPanelSFUrl:String? { // https://catalog.paytm.com/v2/h/flyout
        return JRRemoteConfigManager.stringFor(key: "getLeftFlyoutBanner")
    }
    
    @objc public class var forgotPasswordForLoggedInUser: String? {
        return JRRemoteConfigManager.stringFor(key: "forgotPassword")
    }
    
    public class var myprofileMiniAppDeeplinkUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "myprofileMiniAppDeeplinkUrl")
    }
    
    public class var languageSelectionMiniAppDeeplinkUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "languageSelectionMiniAppDeeplinkUrl")
    }
    
    public class var URLProfilePic: String? {
        return JRRemoteConfigManager.stringFor(key: "profilePic")
    }
    
    public class var closeWalletEnable : Bool { // Edit Profile | Close Wallet
        return JRRemoteConfigManager.value(key: "closewalletenable") ?? false
    }
    
    public class var orderRechargeItemEnable : Bool { // Home Recharge | Order items
        return JRRemoteConfigManager.value(key: "enableRechargeItemOrder") ?? false
    }
    
    
    public class var shouldShowAadhaarWidget: Bool {
        return JRRemoteConfigManager.value(key: "shouldShowAadhaarWidget") ?? false
    }
    
    public class var shouldShowPanWidget: Bool {
        return JRRemoteConfigManager.value(key: "shouldShowPanWidget") ?? false
    }
    
    public class var isMobileUpdated: Bool {
        return JRRemoteConfigManager.value(key: "isMobileUpdated") ?? false
    }
    
    public class var mobileUpdatedURL: String? {
        return JRRemoteConfigManager.value(key: "diyAuthURL")
    }
    
    public class var bargainIdleUserTimeoutSeconds: Int { // unused
        return JRRemoteConfigManager.value(key: "bargainIdleUserTimeoutSeconds") ?? 600
    }
    
    @objc public class var shouldShowPasswordInLoginPage: Bool { // unused
        return JRRemoteConfigManager.value(key: "show_password") ?? false
    }
    public class var URLBusLadiesSeatMessage: String? { // unused
        return JRRemoteConfigManager.value(key: "showLadiesSeatMessage")
    }
    
    
    
    @objc public class var eventOrderSummaryTCUrl:String? {
        return JRRemoteConfigManager.stringFor(key: "URLEventCPTerms")
    }
    
    public class var profileCardUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "ProfileCardUrl")
    }
    
    public class var profileCardAgreedDetailsUrl: String? {
        return JRRemoteConfigManager.stringFor(key: "ProfileCardAgreedDetailsUrl")
    }
    
    public class var fullKYCFlowEnabled: Bool {
        return JRRemoteConfigManager.value(key: "fullKYCFlowEnabled1") ?? true
    }
    
    public class var DisplayProfileCard: Bool {
        return JRRemoteConfigManager.value(key: "DisplayProfileCard") ?? false
    }
    
    public class var URLOrderDetailV2: String? {
        return "https://cart.paytm.com/v2/myOrders/"
    }
    
    public class var isDisplayNameHiddenForKYCUser: Bool {
        return JRRemoteConfigManager.value(key: "hideDisplayNameForKYCUser") ?? false
    }
}



// MARK: - Chat
extension JRRemoteConfHelper {
    public class var contactSyncURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "contactSync")
    }
    public class var contactSearchURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "contactSearch")
    }
    public class var contactRegisterURL: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "contactRegister")
    }
    public class var contactSyncLimitSize: Int32? {
        return JRRemoteConfigManager.value(key: "contactSyncBatchLimit")
    }
    public class var chatDingInitType: String? {
        return JRRemoteConfigManager.stringFor(key: "dtInitDing")
    }
}


extension JRRemoteConfHelper {
    // Contact us
    @objc public class var message4_2: String? {
        return JRRemoteConfigManager.stringFor(key: "orderStatus4_2")
    }
    @objc public class var message4_15: String? {
        return JRRemoteConfigManager.stringFor(key: "orderStatus4_15")
    }
    @objc public class var message4_22: String? {
        return JRRemoteConfigManager.stringFor(key: "orderStatus4_22")
    }
    @objc public class var message16: String? {
        return JRRemoteConfigManager.stringFor(key: "orderStatus16")
    }
    @objc public class var vertical4_2: Bool {
        return JRRemoteConfigManager.value(key: "enableOrder4_2") ?? true
    }
    // JRRemoteConfHelper
    @objc public class var vertical4_15: Bool {
        return JRRemoteConfigManager.value(key: "enableOrder4_15") ?? true
    }
    @objc public class var vertical4_22: Bool {
        return JRRemoteConfigManager.value(key: "enableOrder4_22") ?? true
    }
    @objc public class var vertical16: Bool {
        return JRRemoteConfigManager.value(key: "enableVertical16") ?? true
    }
}

// MARK: - Extra
extension JRRemoteConfHelper {
    // Gamepind
    public class var gamepindBaseURL: String{
        return JRRemoteConfigManager.stringFor(key: "gamepind_prod_detail_url") ?? "https://catalog.paytm.com/v1/mobile/"
    }
    // Others
    public class var URLTermsConditions: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "promoSearchUrl")
    }
    
    @objc public class var URLPaytmLogo: String? {
        return JRRemoteConfigManager.stringFor(key: "paytm_doodle_url")
    }
    public class var signInConsentText: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "sign_in_consent")
    }
    @objc public class var signUpConsentText: String? { // unused
        return JRRemoteConfigManager.stringFor(key: "sign_up_consent")
    }
    
    @objc public class var URLCheckBalanceV2: String? {
        return JRRemoteConfigManager.stringFor(key: "check_user_balance_service")
    }
    @objc public class var URLCheckBalanceV3: String {
        return JRRemoteConfigManager.stringFor(key: "pgWalletBalanceURL") ?? "https://securegw.paytm.in/service/checkUserBalance"
    }
    @objc public class var URLCart: String? {
        return JRRemoteConfigManager.stringFor(key: "cartv4") ?? "https://cart.paytm.com/v4/cart"// Changed "cart" to "cartv4" in 3.16
    }
    
    public class var URLBazaarHomePage: String? {
        return JRRemoteConfigManager.stringFor(key: "bazaar_homepage");
    }
    public class var URLMallHomePage: String? {
        return JRRemoteConfigManager.stringFor(key: "mall_homepage");
    }
    
    @objc public class var URLFetchAmount: String? {
        return JRRemoteConfigManager.stringFor(key: "fetch_bill");
    }
    
    @objc public class var URLValidateWebLoginQRCode: String? {
        return JRRemoteConfigManager.stringFor(key: "validate_code");
    }
    
    @objc public class var URLTimeIntervalTOTP: String? {
        return JRRemoteConfigManager.stringFor(key: "oauthInitConfig");
    }
    
    @objc public class var shouldTOTPAlert: Bool { // unused
        return JRRemoteConfigManager.value(key: "shouldTOTPAlert") ?? false
    }
    
    @objc public class var URLFetchDynamicQRCode: String? { // unused
        if let str = JRRemoteConfigManager.stringFor(key: "QR_INFO") {
            return str
        }
        return "https://trust.paytm.in/wallet-web/getQRCodeInfo"
    }
    @objc public class var URLFetchDynamicQRCodeV2: String {
        return JRRemoteConfigManager.stringFor(key: "pgQRInfoURL") ?? "https://securegw.paytm.in/wallet-web/getQRCodeInfo"
    }
    
    @objc public class var SpeedThresholdBytesPerSecond : Int { // unused
        return JRRemoteConfigManager.value(key: "speedThresholdBytesPerSecond") ?? 10000
    }
    
    public class var URLOfflineDataSync: String? {
        return JRRemoteConfigManager.stringFor(key: "offlineDataSync");
    }
    
    @objc public class var URLFetchBarCode: String? {
        return JRRemoteConfigManager.stringFor(key: "barcodeInfoURL");
    }
    
    public class var showPaytmMallPromoPopup: Bool {
        return JRRemoteConfigManager.value(key: "generic_popup_flag") ?? false
    }
    public class var paytmMallPromoPopupDescription: String? {
        return JRRemoteConfigManager.stringFor(key: "generic_popup_text") //"Flat 550 Cashback on the Paytm Mall App. Promocode: MALL500."
    }
    
    public class var unKnownUrlHandlingDictionary: [String: AnyObject]? {
        //UnknownUrl Type handling
        var dict: [String: AnyObject]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "unknow_url_message_map"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                dict = jsonDict as? [String: AnyObject]
            } catch {}
        }
        return dict
    }
    
    //  let str =  "{\"Recharge\":{\"68869\":{\"n\":\"water\",\"v\":\"utilities\"},\"26\":{\"n\":\"electricity\",\"v\":\"utilities\"}, \"13\":{\"n\":\"gas\",\"v\":\"utilities\"}},\"utility\":{\"68869\":{\"n\":\"water\",\"v\":\"utilities\"},\"26\":{\"n\":\"electricity\",\"v\":\"utilities\"}, \"13\":{\"n\":\"gas\",\"v\":\"utilities\"}}}"
    
    @objc public class var categoryMapForGA: [String: AnyObject]? {
        var map: [String: AnyObject]? = nil
        if let jsonString  = JRRemoteConfigManager.stringFor(key: "categorymap"), let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                let jsonDict = try JSONSerialization.jsonObject(with: data, options: .mutableLeaves)
                map = jsonDict as? [String: AnyObject]
            } catch {}
        }
        return map
    }
    
    
    // Wallet
    public class var isPayVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isPayVisibleiOS") ?? true
    }
    public class var isBetaVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isBetaForBankVisibleiOS") ?? true
    }
    public class var isMoneyTransferVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "moneyTransferIOS_V60") ?? true
    }
    public class var isAddMoneyVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isAddMoneyVisibleiOS") ?? true
    }
    public class var isPassbookVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isPassbookVisibleiOS") ?? true
    }
    public class var isAcceptPaymentVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isAcceptPaymentVisibleiOS") ?? true
    }
    public class var isScanVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isScanVisibleiOS") ?? true
    }
    @objc public class var isSendMoneyToBankVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isSendMoneyToBankVisibleiOS") ?? true
    }
    @objc public class var isAddMoneyInPassbookVisible: Bool { // unused
        return JRRemoteConfigManager.value(key: "isAddMoneyInPassbookVisibleiOS") ?? true
    }
    

    // P2P and P2M
    
    public class var p2mSFSDKURL: String {
        return JRRemoteConfigManager.value(key: "p2m_sfBannerURL") ?? "https://storefront.paytm.com/v2/h/scan-pay-post-txn-page"
    }

    public class var p2pSFSDKURL: String {
        return JRRemoteConfigManager.value(key: "p2p_p2m_sfBannerURL") ?? "https://storefront.paytm.com/v2/h/scan-pay-post-txn-page-p2p"
    }
        
    @objc public class var PaytmPaymentBankProductID: String {
        var productId: String = "89987756" // bank production product id
        if let paytmPaymentBankProductIDExist = JRRemoteConfigManager.stringFor(key: "paytmPaymentBankProductID") {
            productId = paytmPaymentBankProductIDExist
        }
        return productId
    }
}


extension JRRemoteConfHelper {
    public class var getIoclBaseUrlV2: String {
        var stateString = "https://transportation.paytm.com/iocl/v2"
        if let str = JRRemoteConfigManager.stringFor(key: "ioclBaseUrlV2") {
            stateString = str
        }
        return stateString
    }
    
    public class var getFuelWalletPath: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclHomeUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var getEnrollUserPath: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclRegisterUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var getRedeemPonitsPath: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclRedeemOTPUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var getFuelWalletHistoryPath: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclRedeemHistoryUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var getUserInfoPath: String {
        var stateString = ""
        if let str = JRRemoteConfigManager.stringFor(key: "ioclUserInfoUrl") {
            stateString = str
        }
        return stateString
    }
    
    public class var isLogLaunchOptionsOnHawkEye: Bool {
        if JRRemoteConfigManager.stringFor(key: "log_launch_options_on_hawkeye") != nil {
            return true
        }
        return false
    }
    
}

// MARK: - Insurance OMS Urls

extension JRRemoteConfHelper {
    public class var getInsuranceCheckoutUrl: String {
        var checkOutUrl: String = "https://paytm.com/api/v1/insurance/oms/checkout"
        if let url: String = JRRemoteConfigManager.stringFor(key: "insuranceCheckout"), !url.isEmpty {
            checkOutUrl = url
        }
        checkOutUrl = JRAPIManager.sharedManager().urlByAppendingDefaultParamsWithoutWalletAndSSOToken(checkOutUrl) ?? checkOutUrl
        return (checkOutUrl + "&client_id=\(GlobalConstants.JRClientID)")
    }
    
    public class var getInsuranceCartVerifyUrl: String {
        var verifyUrl: String = "https://paytm.com/api/v1/insurance/oms/verify"
        if let url: String = JRRemoteConfigManager.stringFor(key: "insuranceVerifyCart"), !url.isEmpty {
            verifyUrl = url
        }
        verifyUrl = JRAPIManager.sharedManager().urlByAppendingDefaultParams(verifyUrl) ?? verifyUrl
        return verifyUrl
    }
}

extension JRRemoteConfHelper {
    public class var insuranceFillnBuyBrokingList: String {
       let defaultBrokingList: String = "12"
       return JRRemoteConfigManager.value(key: "insuranceFillnBuyBrokingList") ?? defaultBrokingList
    }
}
