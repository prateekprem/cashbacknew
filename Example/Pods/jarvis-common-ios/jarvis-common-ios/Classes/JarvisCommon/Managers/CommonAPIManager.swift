//
//  CommonAPIManager.swift
//  NetworkDemo
//
//  Created by Abhinav Kumar Roy on 28/11/18.
//  Copyright © 2018 Abhinav Roy. All rights reserved.
//

import UIKit
import jarvis_network_ios
import jarvis_utility_ios

public enum CommonAPI : JRRequest{
    case notificationSettings(url : String, settings : [AnyHashable : Any], methodType : String)
    case termsAndConditions(url: String)
    case urlGetUserAccountForSsoToken(url: String)
    case urlGetCheckPANCard(url: String, ssoToken: String)
    case urlGetFetchUserV2API(url: String)
    case urlGetFetchOTPRefreshInterval(url: String)
    case urlGetLoadBarCodeDataForeEANID(url: String)
    case loadMoreOrdersFor(url: String)
    case urlPostForgotPasswordAlert(url: String, params: [AnyHashable: Any])
    case urlPostCheckUserSubscriptionStatus(url: String)
    case urlPostLoadDynamicQRCodeData(url: String, params: [AnyHashable: Any])
    case urlPostLoginWebWithQRCodeId(url: String, params: [AnyHashable: Any])
    case urlPostResendOTP(url: String, params: [AnyHashable: Any])
    case urlPostValidateOTP(url: String, params: [AnyHashable: Any])
    case urlPostDeleteCardByID(url: String)
    case urlPostSavedCardDetail(url: String)
    case urlPostDataWithWalletLedger(url: String, params: [AnyHashable: Any])
    case urlPostLoadDataWithWallet(url: String, params: [AnyHashable: Any],timeOut:Double)
    case urlPostLoadOtpForShareOtp(url: String, params: [AnyHashable: Any])
    case urlPostloadDataWithPostParams(url: String, params: [AnyHashable: Any])
    case urlPutUpdateUserInfo(url: String, params: [AnyHashable: Any])
    case urlPutUpdateMobile(url: String, params: [AnyHashable: Any])
    case urlPutUpdateEmail(url: String, params: [AnyHashable: Any])
    case getPushDetails(url:String, params:[AnyHashable:Any], headers:[String:String])
    case validatePushtransaction(url:String, params:[AnyHashable:Any], headers:[String:String])
    case withdrawMoney(url:String, params:[AnyHashable:Any], headers:[String:String])
    case trustListApi(url:String, params:[AnyHashable:Any], headers:[String:String])
    case orderSummaryLead(url: String)
    case appLaunchLead(url: String)
    case updateCache(url: String)
    case TOTPRequest(url: String, method: String, body: [AnyHashable :Any], headers: [String : String])
    case genericPNService(url: String, method: String, body: [AnyHashable :Any], headers: [String : String])
    case fetchSiteIdInformation(url: String)
    case resetLoginPassword(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String])
    case callChangePasswordAPI(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String])
    case forgotPasswordClicked(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String])
    case bankDataRequest(url: String,requestType: JRHTTPMethod, params: [String : Any], header: [String : String], defautlJsonParams: [String : Any])
    case urlVariableSetupPANCard(url: String, ssoToken: String, httpMethod: String, params: [AnyHashable: Any])
    case urlGetAllTokens
    case fetchShoppingCart(path:String, postData:[AnyHashable : Any], timeOut: Double)
    case fetchShoppingCartForNewDigitalCatalog(path:String, postData:[AnyHashable : Any])
    case fetchCouponDetails(path:String)
    case loadDataForCheckoutCall(path:String, postData:[AnyHashable : Any])
    case loadIndictivePlanCategoryNamesForType(path:String)
    case requestServerWithURLString(path:String)
    case getUserPlan(path:String, postData:[AnyHashable : Any])
    case loadDataForGiftCardCheckoutCall(path:String, postData:[AnyHashable : Any])
    case fetchLayoutDetails(type: String, url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String]?)
    case requestFromBaseVC(type: String, url: String,  headers: [String : String])
    case logoutFromAllDevicesViaOTPPage(type: String, url: String,  params:Any, headers: [String : String])
    case logoutFromAllDevicesViaProfilePage(type: String, url: String,  params:Any, headers: [String : String])
    case hitOTPManagerAPI(type: String, url: String,  params:Any, headers: [String : String])
    case pgCancelOrder(url:String, params: Any, headers:[String:String])
    case pgCloseOrder(url:String, params: Any, headers:[String:String])
    case performCommonPostAPI(url:String, headers: [String: String], bodyParams: [String: Any],timeout:Double?)
    case performCommonGetAPI(url:String, headers: [String: String])
    case performUserProfileCardAPI(url: String, header: [String: String], bodyParams: [String: Any])
    case hitAPIFromHomeVC(url:String)
    case hitAPIForUATag(url:String, type:String?, headers:[String: String], bodyParams:[String: Any])
    case hitProductDetails(url: String, headers: [String:String])
    case hitGetSimilarProducts(url: String)
    case hitGetSellerRating(url : String)
    case hitGetProductPromoDetail(url : String, headers : [String : String])
    case hitGetProductWishListDetail(url : String)
    case hitGetProductFavouriteDetail(url : String)
    case hitSendProductFavouriteDetail(url: String, headers : [String : String], bodyParams : [AnyHashable : Any])
    case hitGetShippingCharge(url: String, headers : [String : String], bodyParams : [AnyHashable : Any])
    case hitGetOtherSellerAuthorizedDetail(url : String, headers : [String : String])
    case hitFetchOffersForRecharge(url : String)
    case hitDeleteRecentListForConfig(url: String, headers : [String : String], body : [AnyHashable : Any])
    case hitApiDealsSubscribe(url: String, headers : [String : String], body : [AnyHashable : Any], vertical : JRVertical, userFacing: JRUserFacing)
    case hitFetchAmountForMobileBill(url : String, headers : [String : String], body : [AnyHashable : Any], vertical : JRVertical, userFacing : JRUserFacing)
    case hitApiOrderDetail(url : String, headers : [String : String]?, body : [AnyHashable : Any]?, vertical : JRVertical, userFacing : JRUserFacing)
    case hitResendOTPForForgotPassword(url: String, headers : [String : String], body : [AnyHashable : Any])
    case hitValidateForgotPasswordOTP(url: String, headers : [String : String], body : [AnyHashable : Any])
    case hitSaveUserPreference(url: String, headers: [String : String], body: [AnyHashable : Any])
    case hitApiToFetchConvenienceFee(url: String, additionalHeaders: [String: String], body: [AnyHashable : Any])
    case hitApiToFetchTags(url: String, headers: [String: String], body: [AnyHashable : Any])
}

//MARK: Common Config
public extension CommonAPI{
    
    var exculdeErrorCodes: Set<Int> {
        switch self {
        case .urlGetUserAccountForSsoToken: return []
        case .getPushDetails(_,_,_): return []
        case .validatePushtransaction(_,_,_): return []
        case .withdrawMoney(_,_,_): return []
        case .trustListApi(_,_,_): return []
        case .notificationSettings(_, _, _): return []
        case .termsAndConditions(_): return []
        case .updateCache(_): return []
        case .orderSummaryLead(_): return []
        case .TOTPRequest(_, _, _, _): return []
        case .genericPNService(_, _, _, _): return []
        case .fetchSiteIdInformation(_): return []
        case .appLaunchLead(_): return [JRHTTPErrorCodes.all.rawValue]
        case .resetLoginPassword(_, _, _): return []
        case .callChangePasswordAPI(_, _, _): return []
        case .forgotPasswordClicked(_, _, _): return []
        case .performCommonPostAPI: return []
        case .performCommonGetAPI: return []
        case .performUserProfileCardAPI: return []
        case .bankDataRequest: return []
        case .urlGetAllTokens: return []
        case .fetchShoppingCart: return []
        case .fetchShoppingCartForNewDigitalCatalog: return []
        case .fetchCouponDetails: return []
        case .loadDataForCheckoutCall: return []
        case .loadIndictivePlanCategoryNamesForType: return []
        case .requestServerWithURLString: return []
        case .getUserPlan: return []
        case .loadDataForGiftCardCheckoutCall: return []
        case .fetchLayoutDetails: return []
        case .requestFromBaseVC(_, _, _): return []
        case .logoutFromAllDevicesViaOTPPage(_, _, _, _): return []
        case .logoutFromAllDevicesViaProfilePage(_, _, _, _): return []
        case .hitOTPManagerAPI(_, _, _, _): return []
        case .hitAPIFromHomeVC(_): return []
        case .pgCancelOrder(_, _, _): return []
        case .hitAPIForUATag(_,_,_,_): return []
        case .hitProductDetails(_, _): return []
        case .hitGetSimilarProducts(_): return []
        case .hitGetSellerRating(_): return []
        case .hitGetProductPromoDetail(_,_): return []
        case .hitGetProductWishListDetail(_): return []
        case .hitGetProductFavouriteDetail(_): return []
        case .hitSendProductFavouriteDetail(_, _, _): return []
        case .hitGetShippingCharge(_,_,_): return []
        case .hitGetOtherSellerAuthorizedDetail(_,_): return []
        case .hitFetchOffersForRecharge(_): return []
        case .hitDeleteRecentListForConfig(_,_,_): return []
        case .hitApiDealsSubscribe(_,_,_,_,_): return []
        case .hitFetchAmountForMobileBill(_,_,_,_,_): return []
        case .hitResendOTPForForgotPassword(_,_,_): return []
        case .hitValidateForgotPasswordOTP(_,_,_): return []
        case .hitSaveUserPreference(_,_,_): return []
        case .hitApiToFetchConvenienceFee(_,_,_): return []
        case .hitApiToFetchTags(_,_,_): return []
        default: return []
        }
    }
    
    var baseURL: String? {
        switch self{
        case .notificationSettings(let url, _, _): return url
        case .termsAndConditions(let url): return url
        case .getPushDetails(let url,_,_): return url
        case .validatePushtransaction(let url,_,_): return url
        case .withdrawMoney(let url,_,_): return url
        case .trustListApi(let url,_,_): return url
        case .orderSummaryLead(let url): return url
        case .appLaunchLead(let url): return url
        case .updateCache(let url): return url
        case .TOTPRequest(let url, _, _, _): return url
        case .genericPNService(let url, _, _, _): return url
        case .fetchSiteIdInformation(let url): return url
        case .resetLoginPassword(let url, _, _): return url
        case .callChangePasswordAPI(let url, _, _): return url
        case .forgotPasswordClicked(let url, _, _) : return url
        case .bankDataRequest(let url,_,_,_,_): return url
        case .urlGetUserAccountForSsoToken(let url): return url
        case .urlGetFetchUserV2API(let url): return url
        case .urlGetFetchOTPRefreshInterval(let url): return url
        case .urlGetLoadBarCodeDataForeEANID(let url): return url
        case .urlPostDeleteCardByID(let url): return url
        case .urlPostSavedCardDetail(let url): return url
        case .loadMoreOrdersFor(let url): return url
        case .urlGetCheckPANCard(let url, _): return url
        case .urlPutUpdateUserInfo(let url, _): return url
        case .urlPutUpdateMobile(let url, _): return url
        case .urlPutUpdateEmail(let url, _): return url
        case .urlPostForgotPasswordAlert(let url, _): return url
        case .urlPostCheckUserSubscriptionStatus(let url): return url
        case .urlPostLoadDynamicQRCodeData(let url, _): return url
        case .urlPostLoginWebWithQRCodeId(let url, _): return url
        case .urlPostResendOTP(let url, _): return url
        case .urlPostValidateOTP(let url, _): return url
        case .urlPostDataWithWalletLedger(let url, _): return url
        case .urlPostLoadDataWithWallet(let url, _, _): return url
        case .urlPostLoadOtpForShareOtp(let url, _): return url
        case .urlPostloadDataWithPostParams(let url, _): return url
        case .urlVariableSetupPANCard(let url, _, _, _): return url
        case .urlGetAllTokens: return JRCommonRemoteConfigClient.URLGetAllTokens
        case .fetchShoppingCart(let path, _, _): return path
        case .fetchShoppingCartForNewDigitalCatalog(let path, _): return path
        case .fetchCouponDetails(let path): return path
        case .loadDataForCheckoutCall(let path,_): return path
        case .loadIndictivePlanCategoryNamesForType(let path): return path
        case .requestServerWithURLString(let path): return path
        case .getUserPlan(let path, _): return path
        case .loadDataForGiftCardCheckoutCall(let path, _): return path
        case .fetchLayoutDetails(_, let url, _, _): return url
        case .requestFromBaseVC(_, let url, _): return url
        case .logoutFromAllDevicesViaOTPPage(_, let url, _, _): return url
        case .logoutFromAllDevicesViaProfilePage(_, let url, _, _): return url
        case .hitOTPManagerAPI(_, let url, _, _): return url
        case .pgCancelOrder(let url, _, _): return url
        case .pgCloseOrder(let url, _, _): return url
        case .performCommonPostAPI(let url, _, _,_): return url
        case .performCommonGetAPI(let url, _): return url
        case .performUserProfileCardAPI(let url, _, _): return url
        case .hitAPIFromHomeVC(let url): return url
        case .hitAPIForUATag(let url,_,_,_): return url
        case .hitProductDetails(let url, _): return url
        case .hitGetSimilarProducts(let url): return url
        case .hitGetSellerRating(let url): return url
        case .hitGetProductPromoDetail(let url,_): return url
        case .hitGetProductWishListDetail(let url): return url
        case .hitGetProductFavouriteDetail(let url): return url
        case .hitSendProductFavouriteDetail(let url, _, _): return url
        case .hitGetShippingCharge(let url,_,_): return url
        case .hitGetOtherSellerAuthorizedDetail(let url, _): return url
        case .hitFetchOffersForRecharge(let url): return url
        case .hitDeleteRecentListForConfig(let url, _, _): return url
        case .hitApiDealsSubscribe(let url,_,_,_,_): return url
        case .hitFetchAmountForMobileBill(let url,_,_,_,_): return url
        case .hitApiOrderDetail(let url,_,_,_,_): return url
        case .hitResendOTPForForgotPassword(let url,_,_): return url
        case .hitValidateForgotPasswordOTP(let url,_,_): return url
        case .hitSaveUserPreference(let url,_,_): return url
        case .hitApiToFetchConvenienceFee(let url,_,_): return url
        case .hitApiToFetchTags(let url,_,_): return url
        }
    }
    
    var path: String? {
        switch self{
        case .notificationSettings(_, _, _): return nil
        case .termsAndConditions(_): return nil
        case .urlGetUserAccountForSsoToken: return nil
        case .urlGetCheckPANCard: return nil
        case .urlGetFetchUserV2API: return nil
        case .urlGetFetchOTPRefreshInterval: return nil
        case .urlGetLoadBarCodeDataForeEANID: return nil
        case .loadMoreOrdersFor: return nil
        case .urlPutUpdateUserInfo: return nil
        case .urlPutUpdateMobile: return nil
        case .urlPutUpdateEmail: return nil
        case .urlPostForgotPasswordAlert: return nil
        case .urlPostCheckUserSubscriptionStatus: return nil
        case .urlPostLoadDynamicQRCodeData: return nil
        case .urlPostLoginWebWithQRCodeId: return nil
        case .urlPostResendOTP: return nil
        case .urlPostValidateOTP: return nil
        case .urlPostDeleteCardByID: return nil
        case .urlPostSavedCardDetail: return nil
        case .urlPostDataWithWalletLedger: return nil
        case .urlPostLoadDataWithWallet: return nil
        case .urlPostLoadOtpForShareOtp: return nil
        case .urlPostloadDataWithPostParams: return nil
        case .urlVariableSetupPANCard: return nil
        case .getPushDetails(_,_,_): return nil
        case .validatePushtransaction(_,_,_): return nil
        case .withdrawMoney(_,_,_): return nil
        case .trustListApi(_,_,_): return nil
        case .orderSummaryLead(_): return nil
        case .appLaunchLead(_): return nil
        case .updateCache(_): return nil
        case .TOTPRequest(_,_,_,_): return nil
        case .genericPNService(_,_,_,_): return nil
        case .fetchSiteIdInformation(_): return nil
        case .resetLoginPassword(_, _, _): return nil
        case .callChangePasswordAPI(_, _, _): return nil
        case .forgotPasswordClicked(_, _, _): return nil
        case .performCommonPostAPI: return nil
        case .performCommonGetAPI: return nil
        case .bankDataRequest : return nil
        case .urlGetAllTokens: return nil
        case .fetchShoppingCart: return nil
        case .fetchShoppingCartForNewDigitalCatalog: return nil
        case .fetchCouponDetails: return nil
        case .loadDataForCheckoutCall: return nil
        case .loadIndictivePlanCategoryNamesForType: return nil
        case .requestServerWithURLString: return nil
        case .getUserPlan: return nil
        case .loadDataForGiftCardCheckoutCall: return nil
        case .fetchLayoutDetails: return nil
        case .requestFromBaseVC(_, _, _): return nil
        case .logoutFromAllDevicesViaOTPPage(_,_, _, _): return nil
        case .logoutFromAllDevicesViaProfilePage(_,_, _, _): return nil
        case .hitOTPManagerAPI(_,_, _, _): return nil
        case .pgCancelOrder(_, _, _): return nil
        case .pgCloseOrder(_, _, _): return nil
        case .performUserProfileCardAPI: return nil
        case .hitAPIFromHomeVC(_): return nil
        case .hitAPIForUATag(_,_,_,_): return nil
        case .hitProductDetails(_, _): return nil
        case .hitGetSimilarProducts(_): return nil
        case .hitGetSellerRating(_): return nil
        case .hitGetProductPromoDetail(_,_): return nil
        case .hitGetProductWishListDetail(_): return nil
        case .hitGetProductFavouriteDetail(_): return nil
        case .hitSendProductFavouriteDetail(_, _, _): return nil
        case .hitGetShippingCharge(_,_,_): return nil
        case .hitGetOtherSellerAuthorizedDetail(_,_): return nil
        case .hitFetchOffersForRecharge(_): return nil
        case .hitDeleteRecentListForConfig(_,_,_): return nil
        case .hitApiDealsSubscribe(_,_,_,_,_): return nil
        case .hitFetchAmountForMobileBill(_,_,_,_,_): return nil
        case .hitApiOrderDetail(_,_,_,_,_): return nil
        case .hitResendOTPForForgotPassword(_,_,_): return nil
        case .hitValidateForgotPasswordOTP(_,_,_): return nil
        case .hitSaveUserPreference(_,_,_): return nil
        case .hitApiToFetchConvenienceFee(_,_,_): return nil
        case .hitApiToFetchTags(_,_,_): return nil
        }
    }
    
    var httpMethod: JRHTTPMethod {
        switch self{
        case .notificationSettings(_, _, let methodType): return JRHTTPMethod(rawValue: methodType) ?? .get
        case .urlGetUserAccountForSsoToken: return .get
        case .urlGetCheckPANCard: return .get
        case .urlGetFetchUserV2API: return .get
        case .urlGetFetchOTPRefreshInterval: return .get
        case .urlGetLoadBarCodeDataForeEANID: return .get
        case .loadMoreOrdersFor: return .get
        case .urlPutUpdateUserInfo: return .put
        case .urlPutUpdateMobile: return .put
        case .urlPutUpdateEmail: return .put
        case .urlPostForgotPasswordAlert: return .post
        case .urlPostCheckUserSubscriptionStatus: return .post
        case .urlPostLoadDynamicQRCodeData: return .post
        case .urlPostLoginWebWithQRCodeId: return .post
        case .urlPostResendOTP: return .post
        case .urlPostValidateOTP: return .post
        case .urlPostDeleteCardByID: return .post
        case .urlPostSavedCardDetail: return .post
        case .urlPostDataWithWalletLedger: return .post
        case .urlPostLoadDataWithWallet: return .post
        case .urlPostLoadOtpForShareOtp: return .post
        case .urlPostloadDataWithPostParams: return .post
        case .urlVariableSetupPANCard(_, _, let httpMethod, _):
            if httpMethod.lowercased() == "delete" {
                return .delete
            } else if httpMethod.lowercased() == "put" {
                return .put
            }
            else if httpMethod.lowercased() == "patch" {
                return .patch
            } else {
                return .post
            }
        case .getPushDetails(_,_,_): return .post
        case .validatePushtransaction(_,_,_): return .post
        case .withdrawMoney(_,_,_): return .post
        case .trustListApi(_,_,_): return .post
        case .TOTPRequest(_, let methodType, _, _): return JRHTTPMethod(rawValue: methodType) ?? .post
        case .genericPNService(_, let methodType, _, _): return JRHTTPMethod(rawValue: methodType) ?? .get
        case .termsAndConditions(_): return .get
        case .orderSummaryLead(_): return .get
        case .appLaunchLead(_): return .get
        case .updateCache(_): return .get
        case .fetchSiteIdInformation(_): return .get
        case .bankDataRequest(_,let method,_, _,_): return method
        case .resetLoginPassword(_,_,_): return .post
        case .callChangePasswordAPI(_,_,_): return .post
        case .forgotPasswordClicked(_,_,_): return .post
        case .performCommonPostAPI: return .post
        case .urlGetAllTokens: return .get
        case .fetchShoppingCart: return .post
        case .fetchShoppingCartForNewDigitalCatalog: return .post
        case .fetchCouponDetails: return .get
        case .loadDataForCheckoutCall: return .post
        case .loadIndictivePlanCategoryNamesForType: return .get
        case .requestServerWithURLString: return .get
        case .getUserPlan: return .post
        case .loadDataForGiftCardCheckoutCall: return .post
        case .fetchLayoutDetails(let type, _, _, _): return JRHTTPMethod(rawValue: type) ?? .get
        case .requestFromBaseVC(let type, _, _): return JRHTTPMethod(rawValue: type) ?? .get
        case .logoutFromAllDevicesViaOTPPage(let type,_, _, _): return JRHTTPMethod(rawValue: type) ?? .post
        case .logoutFromAllDevicesViaProfilePage(let type,_, _, _): return JRHTTPMethod(rawValue: type) ?? .delete
        case .hitOTPManagerAPI(let type,_, _, _): return JRHTTPMethod(rawValue: type) ?? .post
        case .pgCancelOrder(_, _, _): return .post
        case .pgCloseOrder(_, _, _): return .post
        case .performUserProfileCardAPI: return .post
        case .hitAPIFromHomeVC(_): return .get
        case .hitAPIForUATag(_,_,_,_): return .post
        case .performCommonGetAPI: return .get
        case .hitApiOrderDetail(_,_,_,_,_): return .get
        case .hitProductDetails(_, _): return .get
        case .hitGetSellerRating(_): return .get
        case .hitGetProductPromoDetail(_,_): return .get
        case .hitGetProductWishListDetail(_): return .get
        case .hitGetProductFavouriteDetail(_): return .get
        case .hitGetOtherSellerAuthorizedDetail(_,_): return .get
        case .hitFetchOffersForRecharge(_): return .get
        case .hitGetSimilarProducts(_): return .post
        case .hitSendProductFavouriteDetail(_, _, _): return .post
        case .hitGetShippingCharge(_,_,_): return .post
        case .hitDeleteRecentListForConfig(_,_,_): return .post
        case .hitApiDealsSubscribe(_,_,_,_,_): return .post
        case .hitFetchAmountForMobileBill(_,_,_,_,_): return .post
        case .hitResendOTPForForgotPassword(_,_,_): return .post
        case .hitValidateForgotPasswordOTP(_,_,_): return .post
        case .hitSaveUserPreference(_,_,_): return .put
        case .hitApiToFetchConvenienceFee(_,_,_): return .post
        case .hitApiToFetchTags(_,_,_): return .get
        }
    }
    
    var dataType: JRDataType {
        switch self{
        case .notificationSettings(_, _, _): return .Json
        case .termsAndConditions(_): return .Json
        case .orderSummaryLead(_): return .Json
        case .updateCache(_): return .Json
        case .TOTPRequest(_,_,_,_): return .Json
        case .genericPNService(_,_,_,_): return .Json
        case .fetchSiteIdInformation(_): return .Json
        case .performCommonPostAPI: return .Json
        case .performCommonGetAPI: return .Json
        case .bankDataRequest: return .Json
        case .appLaunchLead(_): return .Data
        case .getPushDetails(_,_,_): return .Json
        case .validatePushtransaction(_,_,_): return .Json
        case .withdrawMoney(_,_,_): return .Json
        case .trustListApi(_,_,_): return .Json
        case .resetLoginPassword(_, _, _): return .Json
        case .callChangePasswordAPI(_, _, _): return .Json
        case .forgotPasswordClicked(_, _, _) : return .Json
        case .loadMoreOrdersFor(_):return .Json
        case .urlGetUserAccountForSsoToken: return .Json
        case .urlGetCheckPANCard: return .Json
        case .urlGetFetchUserV2API: return .Json
        case .urlGetFetchOTPRefreshInterval: return .Json
        case .urlGetLoadBarCodeDataForeEANID: return .Json
        case .urlPutUpdateUserInfo: return .Json
        case .urlPutUpdateMobile: return .Json
        case .urlPutUpdateEmail: return .Json
        case .urlPostForgotPasswordAlert: return .Json
        case .urlPostCheckUserSubscriptionStatus: return .Json
        case .urlPostLoadDynamicQRCodeData: return .Json
        case .urlPostLoginWebWithQRCodeId: return .Json
        case .urlPostResendOTP: return .Json
        case .urlPostValidateOTP: return .Json
        case .urlPostDeleteCardByID: return .Json
        case .urlPostSavedCardDetail: return .Json
        case .urlPostDataWithWalletLedger: return .Json
        case .urlPostLoadDataWithWallet: return .Json
        case .urlPostLoadOtpForShareOtp: return .Json
        case .urlPostloadDataWithPostParams: return .Json
        case .urlVariableSetupPANCard: return .Json
        case .urlGetAllTokens: return .Json
        case .fetchShoppingCart: return .Json
        case .fetchShoppingCartForNewDigitalCatalog: return .Json
        case .fetchCouponDetails: return .Json
        case .loadDataForCheckoutCall: return .Json
        case .loadIndictivePlanCategoryNamesForType: return .Json
        case .requestServerWithURLString: return .Json
        case .getUserPlan: return .Json
        case .loadDataForGiftCardCheckoutCall: return .Json
        case .fetchLayoutDetails: return .Json
        case .requestFromBaseVC(_, _, _): return .Json
        case .logoutFromAllDevicesViaOTPPage(_, _, _, _): return .Json
        case .logoutFromAllDevicesViaProfilePage(_,_, _, _): return .Json
        case .hitOTPManagerAPI(_,_, _, _): return .Json
        case .pgCancelOrder(_, _, _): return .Json
        case .pgCloseOrder(_, _, _): return .Json
        case .performUserProfileCardAPI: return .Json
        case .hitAPIFromHomeVC(_): return .Json
        case .hitAPIForUATag(_,_,_,_): return .Json
        case .hitProductDetails(_, _): return .Json
        case .hitGetSimilarProducts(_): return .Json
        case .hitGetProductPromoDetail(_,_): return .Json
        case .hitGetProductWishListDetail(_): return .Json
        case .hitGetProductFavouriteDetail(_): return .Json
        case .hitSendProductFavouriteDetail(_, _, _): return .Json
        case .hitGetShippingCharge(_,_,_): return .Json
        case .hitGetOtherSellerAuthorizedDetail(_,_): return .Json
        case .hitFetchOffersForRecharge(_): return .Json
        case .hitDeleteRecentListForConfig(_,_,_): return .Json
        case .hitApiDealsSubscribe(_,_,_,_,_): return .Json
        case .hitFetchAmountForMobileBill(_,_,_,_,_): return .Json
        case .hitApiOrderDetail(_,_,_,_,_): return .Json
        case .hitGetSellerRating(_): return .Data
        case .hitResendOTPForForgotPassword(_,_,_): return .Json
        case .hitValidateForgotPasswordOTP(_,_,_): return .Json
        case .hitSaveUserPreference(_,_,_): return .Json
        case .hitApiToFetchConvenienceFee(_,_,_): return .Data
        case .hitApiToFetchTags(_,_,_): return .Json
        }
    }
    
    var requestType: JRHTTPRequestType {
        switch self{
        case .notificationSettings(_, let body, _): return jsonPrettyPrintedRequestType(forBody: body)
        case .TOTPRequest(_, _, let body, _): return jsonPrettyPrintedRequestType(forBody: body)
        case .genericPNService(_, _, let body, _): return jsonPrettyPrintedRequestType(forBody: body)
        case .termsAndConditions(_): return jsonEncodedRequestType()
        case .orderSummaryLead(_): return jsonEncodedRequestType()
        case .appLaunchLead(_): return jsonEncodedRequestType()
        case .updateCache(_): return jsonEncodedRequestType()
        case .fetchSiteIdInformation(_): return jsonEncodedRequestType()
        case .loadMoreOrdersFor(_): return jsonEncodedRequestType()
        case .urlGetUserAccountForSsoToken: return jsonEncodedRequestType()
        case .urlGetFetchUserV2API: return jsonEncodedRequestType()
        case .urlGetFetchOTPRefreshInterval: return jsonEncodedRequestType()
        case .urlGetLoadBarCodeDataForeEANID: return jsonEncodedRequestType()
        case .urlGetCheckPANCard: return jsonEncodedRequestType()
        case .urlPostCheckUserSubscriptionStatus: return jsonEncodedRequestType()
        case .urlPostDeleteCardByID: return jsonEncodedRequestType()
        case .urlPostSavedCardDetail: return jsonEncodedRequestType()
        case .urlPutUpdateUserInfo(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPutUpdateMobile(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPutUpdateEmail(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostForgotPasswordAlert(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostLoadDynamicQRCodeData(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostLoginWebWithQRCodeId(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostResendOTP(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostValidateOTP(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostDataWithWalletLedger(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostLoadDataWithWallet(_, let params,_): return jsonEncodedRequestType(forBody: params)
        case .urlPostLoadOtpForShareOtp(_, let params): return jsonEncodedRequestType(forBody: params)
        case .urlPostloadDataWithPostParams(_, let params): return jsonEncodedRequestType(forBody: params)
        case .getPushDetails(_, let params,_): return jsonPrettyPrintedRequestType(forBody: params)
        case .validatePushtransaction(_, let params,_): return jsonPrettyPrintedRequestType(forBody: params)
        case .withdrawMoney(_, let params,_): return jsonPrettyPrintedRequestType(forBody: params)
        case .trustListApi(_, let params,_): return jsonPrettyPrintedRequestType(forBody: params)
        case .resetLoginPassword(_, let bodyDict, _): return jsonPrettyPrintedRequestType(forBody: bodyDict)
        case .callChangePasswordAPI(_, let bodyDict, _): return jsonPrettyPrintedRequestType(forBody: bodyDict)
        case .forgotPasswordClicked(_, let bodyDict, _): return jsonPrettyPrintedRequestType(forBody: bodyDict)
        case .bankDataRequest(_,_,let params, _,_): return jsonEncodedRequestType(forBody: params)
        case .urlVariableSetupPANCard(_, _, _, let params): return jsonEncodedRequestType(forBody: params)
        case .urlGetAllTokens: return urlEncodingRequestType(forUrlParams: CommonAPI.defaultParamsWithSiteID(for: "\(self.baseURL ?? "")\(self.path ?? "")"))
        case .fetchShoppingCart(_, let params, _): return jsonPrettyPrintedRequestType(forBody: params)
        case .fetchShoppingCartForNewDigitalCatalog(_, let params): return jsonPrettyPrintedRequestType(forBody: params)
        case .fetchCouponDetails: return .request
        case .loadDataForCheckoutCall(_, let params): return jsonPrettyPrintedRequestType(forBody: params)
        case .loadIndictivePlanCategoryNamesForType: return .request
        case .requestServerWithURLString: return .request
        case .getUserPlan(_, let params): return jsonPrettyPrintedRequestType(forBody: params)
        case .loadDataForGiftCardCheckoutCall(_, let params): return jsonPrettyPrintedRequestType(forBody: params)
        case .fetchLayoutDetails(_, _, _, _): return jsonPrettyPrintedRequestType()
        case .hitApiOrderDetail(_,_,_,_,_): return jsonPrettyPrintedRequestType()
        case .requestFromBaseVC(_, _, _): return jsonPrettyPrintedRequestType()
        case .performCommonGetAPI: return jsonPrettyPrintedRequestType()
        case .logoutFromAllDevicesViaOTPPage(_, _, let params, _): return jsonPrettyPrintedRequestType(forBody: params)
        case .logoutFromAllDevicesViaProfilePage(_,_, let params, _): return jsonPrettyPrintedRequestType(forBody: params)
        case .hitOTPManagerAPI(_,_, let params, _): return jsonPrettyPrintedRequestType(forBody: params)
        case .pgCancelOrder(_, let params, _): return jsonStringEncodedRequestType(forBody: params)
        case .pgCloseOrder(_, let params, _): return jsonStringEncodedRequestType(forBody: params)
        case .performCommonPostAPI(_, _, let params, _): return jsonPrettyPrintedRequestType(forBody: params)
        case .performUserProfileCardAPI(_, _, let params): return jsonPrettyPrintedRequestType(forBody: params)
        case .hitAPIFromHomeVC(_): return jsonPrettyPrintedRequestType()
        case .hitAPIForUATag(_,_,_,let body): return jsonPrettyPrintedRequestType(forBody: body)
        case .hitProductDetails(_,_): return jsonEncodedRequestType()
        case .hitGetSimilarProducts(_): return jsonEncodedRequestType()
        case .hitGetProductPromoDetail(_,_): return jsonEncodedRequestType()
        case .hitGetProductWishListDetail(_): return jsonEncodedRequestType()
        case .hitGetProductFavouriteDetail(_): return jsonEncodedRequestType()
        case .hitGetOtherSellerAuthorizedDetail(_,_): return jsonEncodedRequestType()
        case .hitFetchOffersForRecharge(_): return jsonEncodedRequestType()
        case .hitSendProductFavouriteDetail(_, _, let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitGetShippingCharge(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitDeleteRecentListForConfig(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitApiDealsSubscribe(_,_,let bodyParams,_,_): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitFetchAmountForMobileBill(_,_,let bodyParams,_,_): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitGetSellerRating(_): return .request
        case .hitResendOTPForForgotPassword(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitValidateForgotPasswordOTP(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitSaveUserPreference(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitApiToFetchConvenienceFee(_,_,let bodyParams): return jsonPrettyPrintedRequestType(forBody: bodyParams)
        case .hitApiToFetchTags(_,_, _): return .request
        }
    }
    
    var headers: JRHTTPHeaders? {
        switch self{
        case .getPushDetails(_, _,let headers): return headers
        case .validatePushtransaction(_, _,let headers): return headers
        case .withdrawMoney(_, _,let headers): return headers
        case .trustListApi(_, _,let headers): return headers
        case .orderSummaryLead(_):
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                return ["sso_token": ssoToken]
            }
            return nil
        case .appLaunchLead(_):
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                return ["sso_token": ssoToken]
            }
            return nil
        case .TOTPRequest(_, _, _, let headers): return headers
        case .genericPNService(_, _, _, let headers): return headers
        case .notificationSettings(_, _, _): return nil
        case .termsAndConditions(_): return nil
        case .resetLoginPassword(_, _, let headerDict): return headerDict
        case .callChangePasswordAPI(_, _, let headerDict): return headerDict
        case .forgotPasswordClicked(_, _, let headerDict) : return headerDict
        case .bankDataRequest(_,_,_, let header,_): return header
        case .urlGetCheckPANCard(_, let ssoToken):
            return ["Content-Type": "application/json", "session_token": ssoToken, "Authorization": GlobalConstants.JRAuthorizationCode]
        case .urlGetFetchUserV2API:
            var headers = [String: String]()
            headers["Authorization"] = GlobalConstants.JRAuthorizationCode
            headers["verification_type"] = "oauth_token"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["data"] = ssoToken
            }
            return headers
        case .urlPutUpdateUserInfo:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = GlobalConstants.JRAuthorizationCode
            headers["client_id"] = GlobalConstants.JRClientID
            headers["client_secret"] = GlobalConstants.JRClientSecret
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
            }
            
            return headers
        case .urlPostloadDataWithPostParams:
            return ["Content-Type": "application/json", "Authorization": GlobalConstants.JRAuthorizationCode]
        case .urlPostForgotPasswordAlert:
            return ["Content-Type": "application/json", "Authorization": GlobalConstants.JRAuthorizationCode]
        case .urlPostLoadOtpForShareOtp:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = GlobalConstants.JRAuthorizationCode
            headers["client_id"] = GlobalConstants.JRClientID
            headers["client_secret"] = GlobalConstants.JRClientSecret
            headers["version"] = "2"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getWalletToken() {
                headers["session_token"] = ssoToken
            }
            
            return headers
        case .urlPostLoadDataWithWallet(let url, _,_):
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = GlobalConstants.JRAuthorizationCode
            headers["tokentype"] = "OAUTH"
            headers["x-wallet-content-hash"] = "## HASH ##"
            headers["x-wallet-content-hmac"] = "## HMAC VALUE ##"
            headers["x-wallet-content-hmac-algo"] = "HmacSHA256"
            headers["x-wallet-content-length"] = "## CONTENT LENGTH ##"
            headers["x-wallet-content-nonce"] = "1356680630495"
            headers["x-wallet-content-unix-date"] = "1356680630495"
            
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
                headers["ssotoken"] = ssoToken
            }
            
            if !url.contains(find: "checkUserBalance") {
                headers["is_admin"] = "false"
                headers["ssoid"] = "13000017"
            }
            
            return headers
        case .urlPostDataWithWalletLedger:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
                headers["ssotoken"] = ssoToken
            }
            
            return headers
        case .urlPostSavedCardDetail:
            return ["Content-Type": "application/json"]
        case .urlPostDeleteCardByID:
            return ["Content-Type": "application/json"]
        case .urlPutUpdateEmail:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
            }
            return headers
        case .urlPutUpdateMobile:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
            }
            return headers
        case .urlPostValidateOTP:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
            }
            return headers
        case .urlPostResendOTP:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            headers["session_token"]  = JRCommonManager.shared.applicationDelegate?.getSSOToken() ?? ""
            return headers
        case .urlPostLoginWebWithQRCodeId:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            headers["Authorization"] = GlobalConstants.JRAuthorizationCode
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["session_token"] = ssoToken
            }
            return headers
        case .urlPostLoadDynamicQRCodeData:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
                headers["ssotoken"] = ssoToken
            }
            return headers
        case .urlGetLoadBarCodeDataForeEANID:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
                headers["ssotoken"] = ssoToken
            }
            return headers
        case .urlPostCheckUserSubscriptionStatus:
            var headers = [String: String]()
            headers["Content-Type"] = "application/json"
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
                headers["ssotoken"] = ssoToken
            }
            return headers
        case .urlGetAllTokens:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/x-www-form-urlencoded",
                           "Authorization":GlobalConstants.JRAuthorizationCode]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["access_token"] = ssoToken
            }
            return headers
        case .fetchShoppingCart:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/json"]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
            }
            if let walletToken = JRCommonManager.shared.applicationDelegate?.getWalletToken() {
                headers["wallet_token"] = walletToken
            }
            return headers
            
        case .fetchShoppingCartForNewDigitalCatalog:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/json"]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
            }
            return headers
            
        case .fetchCouponDetails: return nil
        case .loadMoreOrdersFor: return nil
        case .loadDataForCheckoutCall:
            var headers = ["Accept":"application/json",
                           "Content-Type":"application/json"]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
            }
            if let walletToken = JRCommonManager.shared.applicationDelegate?.getWalletToken() {
                headers["wallet_token"] = walletToken
            }
            return headers
            
        case .loadIndictivePlanCategoryNamesForType:
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                return ["sso_token": ssoToken];
            }
            return nil
            
        case .requestServerWithURLString:
            var headers: [String:String] = ["Accept":"application/json",
                                            "Content-Type":"application/json"]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() {
                headers["sso_token"] = ssoToken
            }
            if let walletToken = JRCommonManager.shared.applicationDelegate?.getWalletToken() {
                headers["wallet_token"] = walletToken
            }
            return headers
            
        case .getUserPlan:
            let headers: [String:String] = ["Accept":"application/json",
                                            "Content-Type":"application/json"]
            
            return headers
        case .loadDataForGiftCardCheckoutCall:
            let headers: [String:String] = ["Accept":"application/json",
                                            "Content-Type":"application/json"]
            return headers
        case .fetchLayoutDetails(_, _, _, let headerDict): return headerDict
        case .requestFromBaseVC(_, _, let headers): return headers
        case .logoutFromAllDevicesViaOTPPage(_, _, _, let headers): return headers
        case .logoutFromAllDevicesViaProfilePage(_, _, _, let headers): return headers
        case .hitOTPManagerAPI(_, _, _, let headers): return headers
        case .performCommonPostAPI(_, let headers, _, _): return headers
        case .performCommonGetAPI(_, let headers): return headers
        case .performUserProfileCardAPI(_, let headers, _): return headers
        case .hitAPIForUATag(_,_,let headers,_): return headers
        case .hitProductDetails(_, let headers): return headers
        case .hitGetProductPromoDetail(_, let headers): return headers
        case .hitSendProductFavouriteDetail(_, let headers, _): return headers
        case .hitGetShippingCharge(_, let headers, _): return headers
        case .hitGetOtherSellerAuthorizedDetail(_,let headers): return headers
        case .hitDeleteRecentListForConfig(_,let headers, _): return headers
        case .hitApiDealsSubscribe(_,let headers,_,_,_): return headers
        case .hitFetchAmountForMobileBill(_, let headers, _,_,_): return headers
        case .hitResendOTPForForgotPassword(_, let headers, _): return headers
        case .hitValidateForgotPasswordOTP(_,let headers,_): return headers
        case .hitSaveUserPreference(_, let headers, _): return headers
        case .hitApiToFetchConvenienceFee(_, let headerDict, _):
            var headers: [String:String] = ["Accept":"application/json","Content-Type":"application/json"]
            if let ssoToken = JRCommonManager.shared.applicationDelegate?.getSSOToken() { headers["sso_token"] = ssoToken }
            if !headerDict.isEmpty {
                for (key, value) in headerDict {
                    headers[key] = value
                }
            }
            return headers
        case .hitApiToFetchTags(_, _, _):
            if JRCommonManager.shared.moduleConfig.environment == .staging {
                return ["AUTHORIZATION_VALUE": "Basic bWFya2V0LWlvcy1hcHAtc3RhZzo5YTA3MTc2Mi1hNDk5LTRiZDktOTE0YS00MzYxZTdjM2Y0YmM="]
            }
            return ["AUTHORIZATION_VALUE": "Basic bWFya2V0LWlvcy1hcHA6OWEwNzE3NjItYTQ5OS00YmQ5LTkxNGEtNDM2MWU3YzNmNGJj"]
        default: return nil
        }
    }
    
    var defautlURLParams: JRParameters? {
        return [:]
    }
    
    var defautlJsonParams: JRParameters? {
        switch self{
        case .bankDataRequest(_,_,_, _,let defautlJsonParams): return defautlJsonParams
        default:  return [:]
        }
    }
    
    var defautlHeaderParams: JRHTTPHeaders? {
        return [:]
    }
    
    
    
    var verticle: JRVertical {
        switch self{
        case .notificationSettings(_, _, _): return JRVertical.common
        case .termsAndConditions(_): return JRVertical.common
        case .orderSummaryLead(_): return JRVertical.common
        case .appLaunchLead(_): return JRVertical.common
        case .updateCache(_): return JRVertical.common
        case .TOTPRequest(_, _, _, _): return JRVertical.common
        case .genericPNService(_, _, _, _): return JRVertical.common
        case .fetchSiteIdInformation(_): return JRVertical.common
        case .resetLoginPassword(_, _, _): return JRVertical.common
        case .callChangePasswordAPI(_, _, _): return JRVertical.common
        case .forgotPasswordClicked(_, _, _): return JRVertical.common
        case .bankDataRequest: return JRVertical.common
        case .getPushDetails(_,_,_): return JRVertical.common
        case .validatePushtransaction(_,_,_): return JRVertical.common
        case .withdrawMoney(_,_,_): return JRVertical.common
        case .trustListApi(_,_,_): return JRVertical.common
        case .urlGetAllTokens: return JRVertical.profile
        case .fetchShoppingCart: return JRVertical.common
        case .fetchShoppingCartForNewDigitalCatalog: return JRVertical.common
        case .fetchCouponDetails: return JRVertical.common
        case .loadDataForCheckoutCall: return JRVertical.common
        case .loadIndictivePlanCategoryNamesForType: return JRVertical.common
        case .requestServerWithURLString: return JRVertical.common
        case .getUserPlan: return JRVertical.common
        case .loadDataForGiftCardCheckoutCall: return JRVertical.common
        case .fetchLayoutDetails: return JRVertical.common
        case .urlGetUserAccountForSsoToken: return JRVertical.common
        case .urlGetCheckPANCard: return JRVertical.common
        case .urlGetFetchOTPRefreshInterval: return JRVertical.common
        case .urlGetLoadBarCodeDataForeEANID: return JRVertical.common
        case .urlGetFetchUserV2API: return JRVertical.profile
        case .urlPostLoadOtpForShareOtp: return JRVertical.profile
        case .loadMoreOrdersFor: return JRVertical.cst
        case .urlPutUpdateUserInfo: return JRVertical.common
        case .urlPutUpdateMobile: return JRVertical.common
        case .urlPutUpdateEmail: return JRVertical.common
        case .urlPostForgotPasswordAlert: return JRVertical.common
        case .urlPostCheckUserSubscriptionStatus: return JRVertical.common
        case .urlPostLoadDynamicQRCodeData: return JRVertical.common
        case .urlPostLoginWebWithQRCodeId: return JRVertical.common
        case .urlPostResendOTP: return JRVertical.common
        case .urlPostValidateOTP: return JRVertical.common
        case .urlPostDeleteCardByID: return JRVertical.common
        case .urlPostSavedCardDetail: return JRVertical.common
        case .urlPostDataWithWalletLedger: return JRVertical.common
        case .urlPostLoadDataWithWallet: return JRVertical.common
        case .urlPostloadDataWithPostParams: return JRVertical.common
        case .urlVariableSetupPANCard: return JRVertical.common
        case .requestFromBaseVC(_, _, _): return JRVertical.common
        case .logoutFromAllDevicesViaOTPPage(_, _, _, _): return JRVertical.common
        case .logoutFromAllDevicesViaProfilePage(_,_, _, _): return JRVertical.common
        case .hitOTPManagerAPI(_,_, _, _): return JRVertical.common
        case .pgCancelOrder(_, _, _): return JRVertical.common
        case .pgCloseOrder(_, _, _): return JRVertical.common
        case .performCommonPostAPI, .performCommonGetAPI: return .common
        case .performUserProfileCardAPI: return JRVertical.common
        case .hitAPIFromHomeVC(_): return JRVertical.common
        case .hitAPIForUATag(_,_,_,_): return JRVertical.common
        case .hitProductDetails(_,_): return JRVertical.common
        case .hitGetSimilarProducts(_): return JRVertical.common
        case .hitGetSellerRating(_): return JRVertical.common
        case .hitGetProductPromoDetail(_,_): return JRVertical.common
        case .hitGetProductWishListDetail(_): return JRVertical.common
        case .hitGetProductFavouriteDetail(_): return JRVertical.common
        case .hitSendProductFavouriteDetail(_,_,_): return JRVertical.common
        case .hitGetShippingCharge(_,_,_): return JRVertical.common
        case .hitGetOtherSellerAuthorizedDetail(_,_): return JRVertical.common
        case .hitFetchOffersForRecharge(_): return JRVertical.common
        case .hitDeleteRecentListForConfig(_,_,_): return JRVertical.common
        case .hitApiDealsSubscribe(_,_,_,let vertical,_): return vertical
        case .hitFetchAmountForMobileBill(_,_,_,let vertical,_): return vertical
        case .hitApiOrderDetail(_,_,_,let vertical,_): return vertical
        case .hitResendOTPForForgotPassword(_,_,_): return JRVertical.common
        case .hitValidateForgotPasswordOTP(_,_,_): return JRVertical.common
        case .hitSaveUserPreference(_,_,_): return JRVertical.common
        case .hitApiToFetchConvenienceFee(_,_,_): return JRVertical.common
        case .hitApiToFetchTags(_,_,_): return JRVertical.common
        }
    }
    
    var isUserFacing: JRUserFacing {
        switch self{
        case .getPushDetails(_,_,_): return JRUserFacing.userFacing
        case .validatePushtransaction(_,_,_): return JRUserFacing.userFacing
        case .withdrawMoney(_,_,_): return JRUserFacing.userFacing
        case .trustListApi(_,_,_): return JRUserFacing.silent
        case .notificationSettings(_, _, _): return JRUserFacing.userFacing
        case .termsAndConditions(_): return JRUserFacing.silent
        case .orderSummaryLead(_): return JRUserFacing.silent
        case .appLaunchLead(_): return JRUserFacing.silent
        case .resetLoginPassword(_, _, _): return JRUserFacing.userFacing
        case .callChangePasswordAPI(_, _, _): return JRUserFacing.userFacing
        case .forgotPasswordClicked(_,_,_): return JRUserFacing.userFacing
        case .performCommonPostAPI: return JRUserFacing.userFacing
        case .performCommonGetAPI: return JRUserFacing.userFacing
        case .bankDataRequest: return JRUserFacing.userFacing
        case .updateCache(_): return JRUserFacing.silent
        case .TOTPRequest(_, _, _, _): return JRUserFacing.silent
        case .genericPNService(_, _, _, _): return JRUserFacing.silent
        case .fetchSiteIdInformation(_): return JRUserFacing.silent
        case .urlGetAllTokens: return JRUserFacing.silent
        case .fetchShoppingCart: return JRUserFacing.userFacing
        case .fetchShoppingCartForNewDigitalCatalog: return JRUserFacing.userFacing
        case .fetchCouponDetails: return JRUserFacing.userFacing
        case .loadDataForCheckoutCall: return JRUserFacing.userFacing
        case .loadIndictivePlanCategoryNamesForType: return JRUserFacing.userFacing
        case .requestServerWithURLString: return JRUserFacing.userFacing
        case .getUserPlan: return JRUserFacing.userFacing
        case .loadDataForGiftCardCheckoutCall: return JRUserFacing.userFacing
        case .fetchLayoutDetails: return JRUserFacing.silent
        case .urlGetUserAccountForSsoToken: return JRUserFacing.userFacing
        case .urlGetCheckPANCard: return JRUserFacing.silent
        case .urlGetFetchUserV2API: return JRUserFacing.silent
        case .urlPostLoadOtpForShareOtp: return JRUserFacing.silent
        case .loadMoreOrdersFor: return JRUserFacing.userFacing
        case .requestFromBaseVC(_, _, _): return JRUserFacing.userFacing
        case .logoutFromAllDevicesViaOTPPage(_, _, _, _): return JRUserFacing.userFacing
        case .logoutFromAllDevicesViaProfilePage(_,_, _, _): return JRUserFacing.userFacing
        case .hitOTPManagerAPI(_,_, _, _): return JRUserFacing.userFacing
        case .pgCancelOrder(_, _, _): return JRUserFacing.silent
        case .pgCloseOrder(_, _, _): return JRUserFacing.silent
        case .performUserProfileCardAPI: return JRUserFacing.silent
        case .hitAPIFromHomeVC(_): return JRUserFacing.silent
        case .hitAPIForUATag(_,_,_,_): return JRUserFacing.silent
        case .hitProductDetails(_,_): return JRUserFacing.userFacing
        case .hitGetSimilarProducts(_): return JRUserFacing.silent
        case .hitGetSellerRating(_): return JRUserFacing.silent
        case .hitGetProductPromoDetail(_,_): return JRUserFacing.silent
        case .hitGetProductWishListDetail(_): return JRUserFacing.silent
        case .hitGetProductFavouriteDetail(_): return JRUserFacing.userFacing
        case .hitSendProductFavouriteDetail(_,_,_): return JRUserFacing.userFacing
        case .hitGetShippingCharge(_,_,_): return JRUserFacing.silent
        case .hitGetOtherSellerAuthorizedDetail(_,_): return JRUserFacing.silent
        case .hitFetchOffersForRecharge(_): return JRUserFacing.silent
        case .hitDeleteRecentListForConfig(_,_,_): return JRUserFacing.silent
        case .hitApiDealsSubscribe(_,_,_,_,let userFacing): return userFacing
        case .hitFetchAmountForMobileBill(_,_,_,_,let userFacing): return userFacing
        case .hitApiOrderDetail(_,_,_,_,let userFacing): return userFacing
        case .hitResendOTPForForgotPassword(_,_,_): return JRUserFacing.userFacing
        case .hitValidateForgotPasswordOTP(_,_,_): return JRUserFacing.userFacing
        case .hitSaveUserPreference(_,_,_): return JRUserFacing.silent
        case .hitApiToFetchConvenienceFee(_,_,_): return JRUserFacing.silent
        case .hitApiToFetchTags(_, _, _): return JRUserFacing.silent
        default: return JRUserFacing.none
        }
    }
    
    var timeoutInterval: JRTimeout? {
        switch self{
        case .termsAndConditions(_): return .sixty
        case .urlGetAllTokens: return .sixty
        case .fetchShoppingCart(_, _, let apiTimeOut): return JRTimeout.init(timeoutValue: apiTimeOut)
        case .fetchShoppingCartForNewDigitalCatalog: return .oneEighty
        case .fetchCouponDetails: return .sixty
        case .loadDataForCheckoutCall: return .oneEighty
        case .requestServerWithURLString: return .oneEighty
        case .getUserPlan: return .oneEighty
        case .loadDataForGiftCardCheckoutCall: return .oneEighty
        case .urlPutUpdateUserInfo: return .oneEighty
        case .urlPostloadDataWithPostParams: return .oneEighty
        case .urlPostCheckUserSubscriptionStatus: return .thirty
        case .urlPostLoadDataWithWallet( _, _, let timeOut): return JRTimeout.init(timeoutValue: timeOut)
        case .urlPostLoadDynamicQRCodeData: return JRTimeout.init(timeoutValue: JRCommonRemoteConfigClient.QRInfoNetworkTimeout)
        case .performCommonPostAPI(_, _, _, let timeOut):
            if let timeOut = timeOut{
                return JRTimeout.init(timeoutValue: timeOut)
            }
            return .oneEighty
        default: return nil
        }
    }
    
    var bypassNetworkCheck: Bool {
        switch self {
        case .urlPostLoadDataWithWallet, .urlPostLoadDynamicQRCodeData:
            return true
        default:
            return false
        }
    }
    
    var printDebugLogs: Bool {
        return true
    }
}

//MARK: Utilities
public extension CommonAPI{
    
    func jsonPrettyPrintedRequestType(forBody body : Any? = nil, andUrlParams params : [String : Any]? = nil) -> JRHTTPRequestType{
        return .requestParameters(bodyParameters: body, bodyEncoding: .jsonEncoding(bodyEncodingStyle: .jsonEncodedWithOptions(options: .prettyPrinted)), urlParameters: params)
    }
    
    func jsonEncodedRequestType(forBody body : [AnyHashable : Any]? = nil) -> JRHTTPRequestType{
        return .requestParameters(bodyParameters: body, bodyEncoding: .jsonEncoding(bodyEncodingStyle: .jsonEncoded), urlParameters: nil)
    }
    
    func urlEncodingRequestType(forUrlParams params : [String : Any]?) -> JRHTTPRequestType{
        return .requestParameters(bodyParameters: nil, bodyEncoding: .urlEncoding, urlParameters: params)
    }
    
    func jsonStringEncodedRequestType(forBody body : Any? = nil) -> JRHTTPRequestType{
        return .requestParameters(bodyParameters: body, bodyEncoding: .jsonEncoding(bodyEncodingStyle: .stringEncoded), urlParameters: nil)
    }
    
    /**
     Helper method that returns a dictionary that contains all default parameters along the Site ID
     */
    private static func defaultParamsWithSiteID(for url:String) -> [String:String] {
        
        var castedDic = [String: String]()
        if let siteIDParams = JRAPIManager.sharedManager().defaultParamsWithSiteIDs(for: url) {
            //Convert to [String:String]
            siteIDParams.forEach { castedDic["\($0.0)"] = "\($0.1)" }
        }
        return castedDic
    }
}

//MARK: Service hits
@objcMembers public class CommonAPIManager: NSObject {
    
    public static func hitTermsAndConditions(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.termsAndConditions(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func getPushDetails(url:String, headers:[String:String],params:[String:Any], handler:@escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.getPushDetails(url:url, params:params, headers:headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    public static func validatePushtransaction(url:String, headers:[String:String],params:[String:Any], handler:@escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.validatePushtransaction(url:url, params:params, headers:headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    public static func withdrawMoney(url:String, headers:[String:String],params:[String:Any], handler:@escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.validatePushtransaction(url:url, params:params, headers:headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    public static func trustListApi(url:String, headers:[String:String],params:[String:Any], handler:@escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.trustListApi(url:url, params:params, headers:headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    public static func hitOrderSummaryLead(withUrl url: String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.orderSummaryLead(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    //JRAccount Manager
    public static func loadUserAccountForSsoToken(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlGetUserAccountForSsoToken(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func setupPANCardForSSOToken(withUrl url : String, ssoToken: String, params: [AnyHashable: Any], httpMethod: String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlVariableSetupPANCard(url: url, ssoToken: ssoToken, httpMethod: httpMethod, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func checkPANCardForSSOToken(withUrl url : String, ssoToken: String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlGetCheckPANCard(url: url, ssoToken: ssoToken)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func fetchUserV2APIWithFetchStrategy(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlGetFetchUserV2API(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func updateUserInformation(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPutUpdateUserInfo(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loadDataWithPostParams(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostloadDataWithPostParams(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func fetchOTPRefreshInterval(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlGetFetchOTPRefreshInterval(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loadOtpForShareOtp(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostLoadOtpForShareOtp(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loadDataWithWalletPostParam(withUrl url : String, params: [AnyHashable: Any], timeOut:Double, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostLoadDataWithWallet(url: url, params: params, timeOut: timeOut)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func getDataWithWalletLedgerPostParams(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostDataWithWalletLedger(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func getSavedCardDetail(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostSavedCardDetail(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func deleteCardByID(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostDeleteCardByID(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func updateEmail(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPutUpdateEmail(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func updateMobile(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPutUpdateMobile(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func validateOTP(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostValidateOTP(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func resendOTP(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostResendOTP(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loginWebWithQRCodeId(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostLoginWebWithQRCodeId(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loadDynamicQRCodeData(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostLoadDynamicQRCodeData(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func loadBarCodeData(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlGetLoadBarCodeDataForeEANID(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func checkUserSubscriptionStatus(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostCheckUserSubscriptionStatus(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func forgotPasswordAlert(withUrl url : String, params: [AnyHashable: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.urlPostForgotPasswordAlert(url: url, params: params)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    //Common
    public static func reachabilityError() -> NSError {
        return JRNetworkUtility.reachabilityError()
    }
    
    @objc public static func callResetLoginPasswordAPI(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String], handler: @escaping JRNetworkRouterCompletion) {
        
        let requestAPI = CommonAPI.resetLoginPassword(url: url, bodyDict: bodyDict, headerDict: headerDict)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func hitAppLaunchLead(withUrl url: String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.appLaunchLead(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func callChangePasswordAPI(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String], handler: @escaping JRNetworkRouterCompletion) {
        
        let requestAPI = CommonAPI.callChangePasswordAPI(url: url, bodyDict: bodyDict, headerDict: headerDict)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func hitTOPTRequest(withUrlString urlString: String, httpMethod method : String, requestBody body: [AnyHashable : Any], requestHeaders headers : [String : String], handler : @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.TOTPRequest(url: urlString, method: method, body: body, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func forgotPasswordClicked(url: String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String], handler: @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.forgotPasswordClicked(url: url, bodyDict: bodyDict, headerDict: headerDict)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func getAllActiveTokens(withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.urlGetAllTokens
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func fetchShoppingCart(withpath path:String, postDataDic postData : [AnyHashable : Any],apiTimeOut : Double, andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        var timeOut : Double = 300.0
        if apiTimeOut > 0 {
            timeOut = apiTimeOut
        }
        let requestAPI = CommonAPI.fetchShoppingCart(path:path, postData:postData, timeOut:timeOut)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func fetchShoppingCartForNewDigitalCatalog(withpath path:String, postDataDic postData : [AnyHashable : Any], andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.fetchShoppingCartForNewDigitalCatalog(path:path, postData:postData)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func fetchCouponDetails(withpath path:String, andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.fetchCouponDetails(path:path)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func loadDataForCheckoutCall(withpath path:String, postDataDic postData : [AnyHashable : Any], andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.loadDataForCheckoutCall(path:path, postData:postData)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func requestServerWithURLString(withpath path:String,andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.requestServerWithURLString(path:path)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func getUserPlan(withpath path:String, postDataDic postData : [AnyHashable : Any], andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.getUserPlan(path:path, postData:postData)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func loadDataForGiftCardCheckoutCall(withpath path:String, postDataDic postData : [AnyHashable : Any], andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.loadDataForGiftCardCheckoutCall(path:path, postData:postData)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    
    @objc public static func loadIndictivePlanCategoryNamesForType(withpath path:String, andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.loadIndictivePlanCategoryNamesForType(path:path)
        if requestAPI.baseURL != nil || requestAPI.path != nil {
            let router = JRRouter<CommonAPI>()
            router.request(type: JRDataType.self, requestAPI, completion: handler)
        }
    }
    
    @objc public static func fetchLayoutDetails(withType type:String, url:String?, bodyDict: [AnyHashable: Any]?, headerDict: [String: String]?, andCompletionHandler handler : @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.fetchLayoutDetails(type: type, url: url, bodyDict: bodyDict, headerDict: headerDict)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    @objc public static func hitRequestFromBaseVC(withType type: String, url: String,  headers: [String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.requestFromBaseVC(type: type, url: url, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func logoutFromAllDevicesThroughProfilePage(withType type: String, url: String, params:Any, headers: [String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.logoutFromAllDevicesViaProfilePage(type: type, url: url, params: params, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func logoutFromAllDevicesThroughOTPPage(withType type:String, url:String, params:Any, headers:[String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.logoutFromAllDevicesViaOTPPage(type: type, url: url, params:params, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitOTPManagerAPI(withType type:String, url:String, params:Any, headers:[String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitOTPManagerAPI(type: type, url: url, params:params, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func hitPgCanceOrder(withUrl url:String, headers: [String:String],params: Any , handler: @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.pgCancelOrder(url: url, params: params, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    public static func hitPgCloseOrder(withUrl url:String, headers: [String:String],params: Any , handler: @escaping JRNetworkRouterCompletion){
        
        let requestAPI = CommonAPI.pgCloseOrder(url: url, params: params, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    
    @objc public static func sessionTimedOutError() -> NSError? {
        return JRNetworkUtility.sessioTimedOutError()
    }
    
    @objc public static func sessioTimedOutError() -> NSError? {
        return JRNetworkUtility.sessioTimedOutError()
    }
    
    @objc public static func someThingWentWrongError() -> NSError? {
        return JRNetworkUtility.someThingWentWrongError()
    }
    
    @objc public static func performCommonPostAPI(url: String, headers: [String: String], bodyParams: [String: Any], withCompletionHandler handler : @escaping (_ data: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let requestAPI = CommonAPI.performCommonPostAPI(url: url, headers: headers, bodyParams: bodyParams, timeout:nil)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI) { (responseObject, response, error) in
            DispatchQueue.main.async {
                if let jsonData = responseObject as? [String : Any] {
                    handler(jsonData, response, error)
                }
            }
        }
    }
    
    @objc public static func performCommonPostAPIWithTimeOut(url: String, headers: [String: String], bodyParams: [String: Any], timeOut:Double, withCompletionHandler handler : @escaping (_ data: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let requestAPI = CommonAPI.performCommonPostAPI(url: url, headers: headers, bodyParams: bodyParams, timeout:timeOut)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI) { (responseObject, response, error) in
            DispatchQueue.main.async {
                if let jsonData = responseObject as? [String : Any] {
                    handler(jsonData, response, error)
                }else{
                    handler(nil, response, error)
                }
            }
        }
    }
    
    @objc public static func performCommonGetAPI(url: String, headers: [String: String], withCompletionHandler handler : @escaping (_ data: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let requestAPI = CommonAPI.performCommonGetAPI(url: url, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI) { (responseObject, response, error) in
            DispatchQueue.main.async {
                if let jsonData = responseObject as? [String : Any] {
                    handler(jsonData, response, error)
                }
            }
        }
    }
    
    public static func performUserProfileCardAPI(urlStr: String, headers: [String: String], bodyParams: [String: Any], withCompletionHandler handler : @escaping (_ data: [String: Any]?, _ response: URLResponse?, _ error: Error?) -> Void) {
        
        let requestAPI = CommonAPI.performUserProfileCardAPI(url: urlStr, header: headers, bodyParams: bodyParams)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI) { (responseObject, response, error) in
            DispatchQueue.main.async {
                if let jsonData = responseObject as? [String : Any] {
                    handler(jsonData, response, error)
                }
            }
        }
    }
    
    public static func hitAPIFromHomeVC(withURL url:String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitAPIFromHomeVC(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    public static func hitAPIForUATag(withURL url:String, type:String?, headers:[String: String], bodyParams:[String: Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitAPIForUATag(url: url, type: type, headers: headers, bodyParams: bodyParams)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self , requestAPI, completion: handler)
    }
    
    @objc public static func hitProductDetails(withUrl url : String, headers: [String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitProductDetails(url: url, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetSimilarProducts(withUrl url: String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetSimilarProducts(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetSellerRating(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetSellerRating(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetProductPromoDetail(withUrl url : String, andHeaders headers : [String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetProductPromoDetail(url: url, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetProductWishListDetail(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetProductWishListDetail(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetProductFavouriteDetail(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetProductFavouriteDetail(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitSendPostFavouritesDetail(withUrl url : String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitSendProductFavouriteDetail(url: url, headers: headers, bodyParams: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetShippingCharge(withUrl url : String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetShippingCharge(url: url, headers: headers, bodyParams: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitGetOtherSellerAuthorizedDetail(withUrl url : String, headers : [String : String], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitGetOtherSellerAuthorizedDetail(url: url, headers: headers)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitFetchOffersForRecharge(withUrl url : String, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitFetchOffersForRecharge(url: url)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitDeleteRecentListForConfig(withUrl url : String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitDeleteRecentListForConfig(url: url, headers: headers, body: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitApiDealsSubscribe(withUrl url : String, headers : [String : String], body : [AnyHashable : Any],vertical : JRVertical, userFacing : Int, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        var userFacingEnum : JRUserFacing = .none
        if let ufe = JRUserFacing(rawValue: userFacing){
            userFacingEnum = ufe
        }
        let requestAPI = CommonAPI.hitApiDealsSubscribe(url: url, headers: headers, body: body, vertical: vertical, userFacing: userFacingEnum)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitFetchAmountForMobileBill(url: String, headers : [String : String], body : [AnyHashable : Any], vertical : JRVertical, userFacing : Int, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        var userFacingEnum : JRUserFacing = .none
        if let ufe = JRUserFacing(rawValue: userFacing){
            userFacingEnum = ufe
        }
        let requestAPI = CommonAPI.hitFetchAmountForMobileBill(url: url, headers: headers, body: body, vertical: vertical, userFacing: userFacingEnum)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitApiOrderDetail(url: String, headers : [String : String]?, body : [AnyHashable : Any]?, vertical : JRVertical, userFacing : Int, withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        var userFacingEnum : JRUserFacing = .none
        if let ufe = JRUserFacing(rawValue: userFacing){
            userFacingEnum = ufe
        }
        let requestAPI = CommonAPI.hitApiOrderDetail(url: url, headers: headers, body: body, vertical: vertical, userFacing: userFacingEnum)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitResendOTPForForgotPassword(url: String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitResendOTPForForgotPassword(url: url, headers: headers, body: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitValidateForgotPasswordOTP(url: String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitValidateForgotPasswordOTP(url: url, headers: headers, body: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitSaveUserPreference(forUrl url : String, headers : [String : String], body : [AnyHashable : Any], withCompletionHandler handler : @escaping JRNetworkRouterCompletion){
        let requestAPI = CommonAPI.hitSaveUserPreference(url: url, headers : headers, body: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
    
    @objc public static func hitApiToFetchConvenienceFee(forUrl url: String, additionalHeaders: [String:String], body: [AnyHashable:Any], withCompletionHandler handler: @escaping JRNetworkRouterCompletion) {
        let requestAPI = CommonAPI.hitApiToFetchConvenienceFee(url: url, additionalHeaders: additionalHeaders, body: body)
        let router = JRRouter<CommonAPI>()
        router.request(type: JRDataType.self, requestAPI, completion: handler)
    }
}


