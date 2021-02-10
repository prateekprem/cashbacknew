//
//  JRCashbackManager.swift
//  Jarvis
//
//  Created by nasib ali on 21/05/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit
@_exported import jarvis_utility_ios

@available(*, deprecated, message: "")
public protocol JRCBReloadTableProtocol: class { // should be removed now.
    @available(*, deprecated, message: "")
    func reloadToUpdateHeight()
}

@objc public enum PostTransactionType: Int {
    case order = 0
    case p2p
    case p2m
    case upi
    case none
    
    var name: String {
        switch self {
        case .order : return "order"
        case .p2p   : return "p2p"
        case .p2m   : return "p2m"
        case .upi   : return "upi"
        case .none  : return ""
        }
    }
    
    init?(string: String) {
        switch string.lowercased() {
        case "order":
            self.init(rawValue:0)
        case "p2p":
            self.init(rawValue:1)
        case "p2m":
            self.init(rawValue:2)
        case "upi":
            self.init(rawValue:3)
        default:
            self.init(rawValue:0)
        }
    }
}

@objc public class JRCashbackManager: NSObject {
    public static var shared: JRCashbackManager = JRCashbackManager()
    public var cashbackDelegate: JRCashbackProtocol?
    fileprivate(set) var cbEnvDelegate : JRCBEnvironmentDelegate!
    private(set) var config = JRCBConfig()
    public var shouldMock = false
    
    private override init() {
        super.init()
        self.cbEnvDelegate = self
    }
    
    public class func openLandingWith(navigation: UINavigationController?) {
        JRCBScreenRouter.openCashbackOn(navVC: navigation)
    }
    
    public class func openPoints(landingType: PointsLandingType,navigationController: UINavigationController?,mid:String? = nil) {
        
        JRCBManager.shareInstance.mid = mid
        JRCBScreenRouter.openPoints(landingType: landingType, navVC: navigationController)
    }
    
    public class func openReferral(info: [AnyHashable: Any],navigationController: UINavigationController?) {
        JRCBScreenRouter.openReferral(info: info, navVC: navigationController)
    }
       
    public class func openWith(deeplink: [AnyHashable: Any]?, navigation: UINavigationController?) {
        JRCBScreenRouter.handle(deeplink:deeplink, navVC: navigation)
    }
    
    public class func openWith(deeplink: String?, navigation: UINavigationController?,
                               extraParam: JRCBJSONDictionary?) {
           JRCBScreenRouter.handle(deeplink: deeplink, navVC: navigation, extraParam: extraParam)
    }
    
    @objc public static func isPostTransactionEnabled(offerId : NSNumber?, categoryId : NSNumber?) -> Bool {
        var offerTypeId: Int = 0
        guard let offersList = JRCBRemoteConfig.postTxtOfferIds else { return false }
        
        if let categoryId = categoryId, categoryId.intValue != 0 {
            if let offerId = JRCBManager.categoryIdOfferTypeIdDic[categoryId.intValue] {
                offerTypeId = offerId
            }
            
        } else if let offerId = offerId, offerId.intValue != 0 {
            offerTypeId = offerId.intValue
        }
        return (offersList.contains(offerTypeId) && JRCBRemoteConfig.cashbackFeature.boolValue())
    }
    
    public class func setEnv(delegate: JRCBEnvironmentDelegate) {
        JRCashbackManager.shared.cbEnvDelegate = delegate
        JRCashbackManager.shared.config = JRCashbackManager.shared.cbEnvDelegate.cbConfiguration()
        if JRCashbackManager.shared.config.cbVarient == .merchantApp {
            JRCBManager.userMode = .Merchant
        }
    }
    
    // don't call it from delegate methods, it will cycling
    public class func fireEvent(labels: [String : String]) {
        JRCBAnalytics(screen: .screen_PostOrder, vertical: .vertical_Cashback,
                      eventType: .eventCustom, category: .cat_PostTransaction,
                      action: .act_BannerClicked, labels: labels).track()
    }
    
    public static func getCBUserMerchantId(completion: ((Bool, String) -> Void)?) {
        guard let mBlock = completion else { return }
        JRCBServices.getUserMerchantId { (status, mId) in
            mBlock(status, mId)
        }
    }
}


// MARK: - JRCBEnvironmentDelegate
extension JRCashbackManager: JRCBEnvironmentDelegate {
    public func cbGetUserId() -> String?      { return nil }
    public func cbGetSsoToken() -> String?    { return nil }
    public func cbGetUserPicture() -> String? { return nil }
    public func cbIsSDMerchant() -> Bool      { return false }
    public func cbGetMerchantID() -> String?  { return nil }
    public func cbGetAuthUMP() -> String?     { return nil }
    
    // common
    public func cbAppDefaulNavVC() -> UINavigationController? { return nil }
    public func cbRemoteValueFor<T>(key: String) -> T?        { return nil }
    public func cbRemoteStringFor(key: String) -> String?     { return nil }
    
    // common
    public func cbUrlByAppendingDefaultParam(urlStr: String?) -> String? { return urlStr }
    public func cbConfiguration() -> JRCBConfig { return JRCBConfig(buildType: .debug) }
    public func postTransModelsWith(dict: [String : AnyObject], verticalId: String?) -> [JRCBPostTransactionCellVM] {
        return [JRCBPostTransactionCellVM]()
    }
    
    public func cbRedirectToGivenSFItemWith(indx: Int, verticalId: String) { }
    public func cbShowLoaderOn(button: UIButton, shouldRemoveTitle: Bool, defaultBGColor: UIColor) {}
    public func cbBackBtnClicked(controller: JRCBMController) { }
    public func openGVOrderSummary(orderId: String)  {}
}
