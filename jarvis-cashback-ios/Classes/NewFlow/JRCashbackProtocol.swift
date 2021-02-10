//
//  JRCODeeplinkHandler.swift
//  Jarvis
//
//  Created by nasib ali on 16/05/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

public protocol JRCashbackProtocol: Any {
    func handleDeeplink(_ dic: [AnyHashable: Any]?, isAwaitProcessing signal: Bool)
    func handleDeeplink(_ urlString: String?, isAwaitProcessing signal: Bool)
    func track(for screenName: String?, verticalName name: String?)
    func trackCustomEvent(for screenName:String?, eventName: String?, variables:[AnyHashable : Any]?)
   
    // no need to integrate if ok to hit via network library..
    func executeAPI<T: Codable>(type: T.Type?, model: JRCBApiModel, isJson: Bool, completion: @escaping JRCBServiceBlock)
    func fetchRefferlLink(_ hashCode: String, completion: @escaping (_ url:String?) -> Void)
 }

public extension JRCashbackProtocol {
    func executeAPI<T: Codable>(type: T.Type?, model: JRCBApiModel, isJson: Bool, completion: @escaping JRCBServiceBlock) {
        JRCBServiceManager.hitAPI(type: type, model: model,isJson: isJson, completion: completion)
    }
}


public protocol JRCBEnvironmentDelegate {
    // auth
    func cbGetUserId() -> String?
    func cbGetSsoToken() -> String?
    func cbGetUserPicture() -> String?
    func cbIsSDMerchant() -> Bool
    func cbGetMerchantID() -> String?
    func cbGetAuthUMP() -> String?
    
    // common
    func cbAppDefaulNavVC() -> UINavigationController?
    func cbRemoteValueFor<T>(key: String) -> T?
    func cbRemoteStringFor(key: String) -> String?
    func cbUrlByAppendingDefaultParam(urlStr: String?) -> String?

    func cbConfiguration() -> JRCBConfig
  
    func postTransModelsWith(dict: [String : AnyObject], verticalId: String?) -> [JRCBPostTransactionCellVM]
    func cbRedirectToGivenSFItemWith(indx: Int, verticalId: String)
    
    func cbShowLoaderOn(button: UIButton, shouldRemoveTitle: Bool, defaultBGColor: UIColor)
    func cbBackBtnClicked(controller: JRCBMController)
    func openGVOrderSummary(orderId: String)
}

public enum JRCBMController {
    case newofferDetail
    case myOfferDetail
}



