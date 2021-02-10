//
//  JRCBScreenRouter.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 20/01/20.
//

import UIKit

protocol JRCBScreenRouterDelegate {
    func screenRouterHostNavVC() -> UINavigationController?
    func screenRouterHostVC() -> UIViewController?
}

class JRCBScreenRouter {
    private(set) var rDelegate : JRCBScreenRouterDelegate?
    init(delegate: JRCBScreenRouterDelegate?) {
        self.rDelegate = delegate
    }
}


// MARK: - All Class(Independent Methods)
extension JRCBScreenRouter {
    class func openCashbackOn(navVC: UINavigationController?) {
        var navC: UINavigationController? = JRCBCommonBridge.defaultNavVC
        if let pNavVC = navVC { navC = pNavVC }
        let landingVC = JRCBLandingVC.newInstance
        navC?.pushViewController(landingVC, animated: true)
    }
    
    class func openPoints(landingType: PointsLandingType, navVC: UINavigationController?) {
        var navC: UINavigationController? = JRCBCommonBridge.defaultNavVC
        if let pNavVC = navVC {
            navC = pNavVC
        }
        switch landingType {
        case .passbook:
             let passbookVC = JRPCTransactionVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRPCTransactionVC.self)
             passbookVC.tabBarController?.tabBar.isHidden = true
             passbookVC.hidesBottomBarWhenPushed = true
             navC?.pushViewController(passbookVC, animated: true)
            
        case .redeem:
            let redeemVC = JRPCRedeemPointsVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRPCRedeemPointsVC.self)
            redeemVC.tabBarController?.tabBar.isHidden = true
            redeemVC.hidesBottomBarWhenPushed = true
            navC?.pushViewController(redeemVC, animated: true)
         case .merchantRedeem:
            let redeemVC = JRPCRedeemPointsVC.instanceFromStoryboardPC(storyBoardName: "JRPaytmCoins", type: JRPCRedeemPointsVC.self)
            redeemVC.tabBarController?.tabBar.isHidden = true
            redeemVC.hidesBottomBarWhenPushed = true
            navC?.pushViewController(redeemVC, animated: true)
            JRCBManager.userMode = .Merchant
        }
    }
    
    class func openReferral(info: [AnyHashable: Any], navVC: UINavigationController?) {
        var navC: UINavigationController? = JRCBCommonBridge.defaultNavVC
        if let pNavVC = navVC {
            navC = pNavVC
        }
        
        let tag = info.getOptionalStringForKey("tag")
        let utmSource = info.getOptionalStringForKey("utm_source")
        let viewController = CBReferralLandingViewController.newInstanse(tag: tag, utmSource: utmSource)
        viewController.tabBarController?.tabBar.isHidden = true
        viewController.hidesBottomBarWhenPushed = true
        navC?.pushViewController(viewController, animated: true)
    }
 
    class func handle(deeplink:[AnyHashable: Any]?, navVC : UINavigationController?) {
        guard let mDlDict = deeplink as? JRCBJSONDictionary else { return }
        let dlInfo = JRCBDeepLinkInfo(dict: mDlDict)
        JRCBScreenRouter.handle(dlInfo: dlInfo, navVC: navVC)
    }
    
    class func handle(deeplink: String?, navVC : UINavigationController?, extraParam: JRCBJSONDictionary?) {
        guard let mdlStr = deeplink else { return }
        let dlInfo = JRCBDeepLinkInfo(urlS: mdlStr, param: extraParam)
        JRCBScreenRouter.handle(dlInfo: dlInfo, navVC: navVC)
    }
    
    private class func handle(dlInfo: JRCBDeepLinkInfo, navVC : UINavigationController?) {
        var navVContr: UINavigationController? = JRCBCommonBridge.defaultNavVC
        if let pNavVC = navVC {
            navVContr = pNavVC
        }
        
        let mConfig = dlInfo.nextVCConfig
        if let vc = mConfig.vc {
            if mConfig.shuldPush {
                JRCBScreenRouter.push(vc: vc, toNav: navVContr, byPoping: dlInfo.shouldPopToRoot)
               
            } else {
                vc.isPresented = true
                vc.modalPresentationStyle = .overCurrentContext
                navVContr?.present(vc, animated: false, completion: nil)
            }
        }
    }
    
    class func push(vc: UIViewController, toNav: UINavigationController?, byPoping: Bool) {
        guard let navigation = toNav else { return }
        if navigation.viewControllers.count > 0, byPoping {
            var allVCs = navigation.viewControllers
            allVCs = [allVCs[0], vc]
            navigation.setViewControllers(allVCs, animated: true)
            
        } else {
            navigation.pushViewController(vc, animated: true)
        }
    }
}
