//
//  JRCashbackRouter.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 23/04/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import jarvis_common_ios
import jarvis_cashback_ios
import jarvis_auth_ios


class JRCashbackRouter: JRCashbackProtocol {
    
    var count: Int = 0
    func fetchRefferlLink(_ hashCode: String, completion: @escaping (String?) -> Void) {
        DispatchQueue.global().asyncAfter(deadline: .now()+3) {
            DispatchQueue.main.async {
                self.count = self.count + 1
//                if self.count == 2 {
//                    completion("https://google.com")
//                } else {
//                    completion(nil)
//                }
                 completion("https://google.com")
            }
        }
    }
    
    static var shared : JRCashbackRouter = JRCashbackRouter()
    let homeScreenLayout = JRHomeScreenLayoutGenerator()
    private init() { }
    
    class func initCashback() {
        JRCashbackManager.shared.cashbackDelegate = JRCashbackRouter.shared
        JRCashbackManager.setEnv(delegate: JRCashbackRouter.shared)
    }
    
    func handleDeeplink(_ dic: [AnyHashable : Any]?, isAwaitProcessing signal: Bool) { }
    
    func handleDeeplink(_ urlString: String?, isAwaitProcessing signal: Bool) {
        if urlString == "paytmmp://embed?url=https://paytm.com/recall/cashbacks-detail?digitalcredit" {
            if let url = URL(string: urlString!) {
                UIApplication.shared.open(url, options: [:]) { (success) in
                }
            }
            return
        }
        JRCashbackManager.openWith(deeplink: urlString, navigation: nil, extraParam: nil)
    }
        
    func track(for screenName: String?, verticalName name: String?) {}
    func trackCustomEvent(for screenName: String?, eventName: String?, variables: [AnyHashable : Any]?) {}
}



// MARK: - JRCBEnvironmentDelegate
extension JRCashbackRouter: JRCBEnvironmentDelegate {
    
    // auth
    func cbGetUserId() -> String?       { return LoginAuth.sharedInstance().getUserID() }
    func cbGetSsoToken() -> String?     { return LoginAuth.sharedInstance().getSsoToken()}
    func cbGetUserPicture() -> String?  { return LoginAuth.sharedInstance().getUserPicture() }
    func cbIsSDMerchant() -> Bool       { return LoginAuth.sharedInstance().isSDMerchant()}
    func cbGetMerchantID() -> String?   { return nil }
    func cbGetAuthUMP() -> String?      { return nil }
    
    // common
    func cbAppDefaulNavVC() -> UINavigationController? {
        if let sharedDel = UIApplication.shared.delegate as? AppDelegate {
            return sharedDel.window?.rootViewController?.navigationController
        }
        return nil
    }
    
    func cbRemoteValueFor<T>(key: String) -> T?        { return JRRemoteConfigManager.value(key: key) }
    func cbRemoteStringFor(key: String) -> String?     { return JRRemoteConfigManager.stringFor(key: key) }
    func cbUrlByAppendingDefaultParam(urlStr: String?) -> String? {
        return JRAPIManager.sharedManager().urlByAppendingDefaultParams(urlStr)
    }
    
    func cbConfiguration() -> JRCBConfig {
        return JRCBConfig(env: JRCashbackRouter.cbDefaultEnvironment,
                          verient: .paytm,
                          buildType: JRCashbackRouter.cbBuildType)
    }
    
    func postTransModelsWith(dict: [String : AnyObject], verticalId: String?) -> [JRCBPostTransactionCellVM]  {
        
        homeScreenLayout.homeResponseDictionary = dict

        var bannerModels = [JRCBPostTransactionCellVM]()
        
        let homeLayouts = homeScreenLayout.layouts
        if homeLayouts.count > 0 {
            let mLayout = homeLayouts[0]
            for item in mLayout.items {
                let itemId = item.itemId?.intValue
                let mdl = JRCBPostTransactionCellVM(imgUrl: item.imageUrl, sfDeeplink: item.url,
                                                    itemId: itemId, verticalID: verticalId ?? "")
                bannerModels.append(mdl)
            }
        }
        return bannerModels
    }
    
    
    func cbRedirectToGivenSFItemWith(indx: Int, verticalId: String) {
        guard let lItems = homeScreenLayout.layouts.first?.items, lItems.count > indx else { return }
        let item = lItems[indx]
        let id = item.itemId ?? 0
        
        let labelsArray: [String : String] = ["event_label": id.stringValue,
                                              "event_label2": verticalId,
                                              "event_label3": ""]
        
        JRCashbackManager.fireEvent(labels: labelsArray)
        
        // property: JRViewControllerInputProperties
        JRDeeplinkHandler.shared.handleClickFor(item: item, shouldRoute: true, context: nil, propertiesHandler: { (property) in
            var httpMethod = "GET"
            //if let _ = item.urlType {
                httpMethod = "POST"
            //}
            property.httpMethod = httpMethod
            let origin = "addMoney"
            property.origin = origin
            
        }, viewControllersHandler: {  (viewControllers) in
            if let viewControllers = viewControllers, viewControllers.count > 0 {
                if let firstViewController = viewControllers.first {
                    firstViewController.title = item.name
                }
            }
        })
    }
    
    func cbShowLoaderOn(button: UIButton, shouldRemoveTitle: Bool, defaultBGColor: UIColor) {
        button.showLoader(shouldRemoveTitle: shouldRemoveTitle, defaultBGColor: defaultBGColor)
    }
    
    func cbBackBtnClicked(controller: JRCBMController) {
        
    }
    func openGVOrderSummary(orderId: String){
    }
}



extension JRCashbackRouter {
    class var cbBuildType: JRCashbackBuildType {
        var bType:JRCashbackBuildType = .debug
        #if APPSTORE_BUILD
        bType = .release
        #endif
        return bType
    }
    
    class var cbDefaultEnvironment: JRCashbackEnvironment {
        let val = UserDefaults.standard.integer(forKey: "keySelectedEnvironment")
        let env: JRCashbackEnvironment = val == 2 ? .staging : .production
        return env
    }
}




// just to avoid error..
class JRHomeScreenLayoutGenerator {
    var layouts = [JRLayout]()
    var homeResponseDictionary: [String : Any]!
}
