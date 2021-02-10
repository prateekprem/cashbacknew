//
//  JRPPUtilities.swift
//  Jarvis
//
//  Created by Pankaj Singh on 27/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

// MARK: - Utilities Methods

public class JRPCUtilities {
    
    class func addBlurEffect(navController: UINavigationController?) {
        if let bounds: CGRect = navController?.view.bounds {
            navController?.view.viewWithTag(JRPCConstants.kPCBlurViewTag)?.removeFromSuperview()
            let blurView: UIView = UIView(frame: bounds)
            blurView.tag = JRPCConstants.kPCBlurViewTag
            blurView.backgroundColor = UIColor.clear
            navController?.view.addSubview(blurView)
            UIView.animate(withDuration: 0.6) {
                blurView.backgroundColor = UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 0.5)
            }
        }
    }
    
    public class func generateH5OrderDetailLink(orderId:String,pgmid:String) -> String {
    
        let param = "?orderId=\(orderId)&pgmId=\(pgmid)"
        let path = JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCPaytmMerchantOrderSummary) ?? JRPCConstants.kDefaultPaytmMerchantOrderSummary
        let sParam = ["pullRefresh":false,"canPullDown":false,"showTitleBar":false]
        let allParam :[String : Any] = ["params":param,"path":path,"sparams":sParam]
        let paramJson = allParam.json.toBase64()
        let aid = JRCBCommonBridge.remoteStringFor(key: "AID") ?? "109200364bd9adad098ce67c643bade349cd01d5"
        return "paytmmp://mini-app?aId=\(aid)&data=\(paramJson)&url=https://paytm.com"
    }
    
    class func removeBlurEffect(navController: UINavigationController?) {
        navController?.view.viewWithTag(JRPCConstants.kPCBlurViewTag)?.removeFromSuperview()
    }
    
    class func change(dateString: String, inputFormat: String = "yyyy-MM-dd HH:mm:ss", outputFormat: String = "h:mm a,d MMM yyyy") -> String? {
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = inputFormat
        if let date: Date = dateFormatter.date(from: dateString) {
            
            dateFormatter.dateFormat = outputFormat
            let result: String = dateFormatter.string(from: date)
            return result
        }
        return nil
    }
    
    class func generateFormattedStringWithSeparator(_ exValue:String?) -> String {
        guard let exValue = exValue else {
            return JRPCConstants.kPCInvalidCoinBalance
        }
        let isNegative = exValue.isPCNegativeNumber
        var inputValue = exValue
        inputValue = inputValue.getPCDigitsWithDecimal
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale.init(identifier: "en_IN")
        fmt.maximumFractionDigits = 2
        if let intVal: Int = Int(inputValue), let result = fmt.string(from: NSNumber(value: intVal)) {
            if isNegative {
                return "- " + result
            }
            return result
        }
        if let doubleValue = Double(inputValue), let result = fmt.string(from: NSNumber(value: doubleValue)){
            if isNegative {
                return "- " + result
            }
            return result
        }
        return exValue
    }
    
    //GTM Helpers
    
    class func getCheckBalanceURL() -> String {
        if JRPCUtilities.isMerchantInvokeFromConsumer() {
            return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCMerchantCheckBalanceGTMKey) ?? JRPCConstants.kDefaultMerchantCheckBalanceAPI
        }
        return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCCheckBalanceGTMKey) ?? JRPCConstants.kDefaultCheckBalanceAPI
    }
    
    class func getTransactionListURL() -> String {
        
        return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCPassbookGTMKey) ?? JRPCConstants.kDefaultPassbookAPI
    }
    
    class func isRedeemFlowEnabled() -> Bool {
        return JRCBCommonBridge.remoteValueFor(key: JRPCConstants.kPCIsRedeemEnGTMKey) ?? JRPCConstants.kDefaultIsReedemFlowEnabled
    }
    
    class func getRedeemCoinLimit() -> String {
        return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCRedeemLimitGTMKey) ?? JRPCConstants.kDefaultRedeemCoinValue
    }
    
    class func getRewardsURL() -> String {
        if JRPCUtilities.isMerchantInvokeFromConsumer() {
            return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCMerchantRewardsGTMKey) ?? JRPCConstants.kDefaultMerchantRewardsAPI
        }
        return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCRewardsGTMKey) ?? JRPCConstants.kDefaultRewardsAPI
        
        
    }
    
    class func getCheckoutUrl() -> String {
        return JRCBCommonBridge.remoteStringFor(key: JRPCConstants.kPCCheckoutGTMKey) ?? JRPCConstants.kDefaultCheckOutAPI
    }
    
    class func isMerchantInvokeFromConsumer() -> Bool{
        if JRCBManager.userMode == .Merchant && JRCashbackManager.shared.config.cbVarient != .merchantApp {
            return true
        }
        return false
    }
    
    //GA
    
   public class func trackCustomEventForPaytmCoins(screenName: JRPCScreens?, eventAction: String?,  label1Val: String?, label2Val: String?) {
        var pcScreenName: String = ""
        var eventName: String = ""
        var variableDict: [String: Any] = [String: Any]()
        if let screen = screenName {
            pcScreenName = screen.rawValue
        }
        variableDict[JRPCGAEventVariableKeys.eventCategoryKey.rawValue] =  JRPCGAEventVariableKeys.eventCategoryValue.rawValue
        if let eAction = eventAction {
            variableDict[JRPCGAEventVariableKeys.eventActionKey.rawValue] = eAction
        }
        if let label1Text = label1Val {
            variableDict[JRPCGAEventVariableKeys.eventLabelKey.rawValue] = label1Text
        }
        if let label2Text = label2Val {
            variableDict[JRPCGAEventVariableKeys.eventLabel2Key.rawValue] = label2Text
        }
        variableDict[JRPCGAEventVariableKeys.verticalNameKey.rawValue] = JRPCGAEventVariableKeys.verticalNameValue.rawValue
        variableDict[JRPCGAEventVariableKeys.userIdKey.rawValue] =  JRCOAuthWrapper.usrIdEitherBlank
        
        eventName = JRPCGAEventVariableKeys.eventName.rawValue
        JRCashbackManager.shared.cashbackDelegate?.trackCustomEvent(for: pcScreenName,
        eventName: eventName,
        variables: variableDict)
    }
}

// MARK: - Generic Protocols

protocol JRPCAddRemoveShadowViewDelegate: class {
    func addShadowView()
    func removeShadowView()
}

extension JRPCAddRemoveShadowViewDelegate {
    func removeShadowView() {
        if let controller: UIViewController = (self as? UIViewController) {
            JRPCUtilities.removeBlurEffect(navController: controller.navigationController)
        }
    }
    func addShadowView() {
        if let controller: UIViewController = (self as? UIViewController) {
            JRPCUtilities.addBlurEffect(navController: controller.navigationController)
        }
    }
}

// MARK: - Constants
struct JRPCConstants {
    static let kPCBlurViewTag: Int = 7777771
    static let kPCErrorMessageCode: Int = 9999991
    static let kPCInvalidCoinBalance: String = "--"
    static let kShowMorePaytmCoinView: String = "isPaytmCoinInfoViewShown"
    
    //GTM keys
    static let kPCCheckBalanceGTMKey: String = "paytmCoinsCheckBalance"
    static let kPCPassbookGTMKey: String = "paytmCoinsPassbook"
    static let kPCIsRedeemEnGTMKey: String = "paytmCoinsIsRedeemFlowEnabled"
    static let kPCRedeemLimitGTMKey: String = "paytmCoinsRedeemLimit"
    static let kPCRewardsGTMKey: String = "paytmCoinsGetRewards"
    static let kPCCheckoutGTMKey: String = "paytmCoinsCheckout"
    static let kPCMerchantRewardsGTMKey: String = "paytmCoinsMerchantGetRewards"
    static let kPCMerchantCheckBalanceGTMKey: String = "paytmCoinsMerchantCheckBalance"
    static let kPCPaytmMerchantOrderSummary :String = "paytmMerchantOrderSummary"



    
    //GTM Default Values
    static let kDefaultCheckBalanceAPI: String = "https://securegw.paytm.in/fund-service/fundproxy/loyaltypoints/v1/checkbalance"
    static let kDefaultPassbookAPI: String = "https://securegw.paytm.in/fund-service/fundproxy/loyaltypoints/v1/passbook"
    static let kDefaultIsReedemFlowEnabled: Bool = false
    static let kDefaultRedeemCoinValue: String = "1000"
    static let kDefaultRewardsAPI: String = "https://catalog.paytm.com/v1/g/deals-store/deals-rewards?attributes=all"
    static let kDefaultCheckOutAPI: String = "https://ffwallet.paytm.com/v1/order/checkout?withdraw=1&skip_payment=1"
    //
    static let kDefaultMerchantCheckBalanceAPI: String = "https://dashboard.paytm.com/api/v1/loyaltypoints/checkBalance"
    static let kDefaultMerchantRewardsAPI: String = "https://catalog.paytm.com/v1/g/deals-store/deals_rewards1?attributes=all"
    static let kDefaultPaytmMerchantOrderSummary: String = "/myorders/points-redemption/order-summary"
    

}

class JRPCNetworkHandler {
    
    class func networkReachableError() -> NSError {
        return NSError(domain: "jr_ac_noInternetMsg".localized, code: 5001,
                       userInfo: ["NSLocalizedDescription": "jr_ac_noInternetMsg".localized])
    }
    
    class func unknownError() -> NSError {
        return NSError(domain: "jr_pp_kdefaultErrorMsg".localized, code: 5002,
                       userInfo: ["NSLocalizedDescription": "jr_pp_kdefaultErrorMsg".localized])
    }
    
    class func fetchBalanceError() -> NSError {
        return NSError(domain: "jr_pp_kfetchBalanceError".localized, code: 5003,
                       userInfo: ["NSLocalizedDescription": "jr_pp_kfetchBalanceError".localized])
    }
    
    class func requestNotValid() -> NSError {
        return NSError(domain: "jr_pp_kdefaultErrorMsg".localized, code: 9999,
                       userInfo: ["NSLocalizedDescription": "jr_pp_kdefaultErrorMsg".localized])
    }
}


// MARK: - Extensions


extension UIView {
    // MARK: - Get View Instance
    class func instanceFromPCNib<T: UIView>(type: T.Type) -> T {
        let view: T =   UINib(nibName: String(describing: self), bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[0] as! T
        return view
    }
}

extension String {
    var isPCNegativeNumber: Bool {
        return (self.first == "-")
    }
    
    var getPCDigitsWithDecimal: String {
        return components(separatedBy: CharacterSet(charactersIn: "0123456789.").inverted)
            .joined()
    }
}

extension UIViewController {
    
    //Storyboard Identifier
    
    static var storyboardPCIdentifier: String {
        return String(describing: self)
    }
    
    //Get ViewController Instance
    
    public class func instanceFromStoryboardPC<T: UIViewController>(storyBoardName: String, type: T.Type) -> T {
        let storyboard: UIStoryboard = UIStoryboard(name: storyBoardName, bundle: Bundle.cbBundle)
        let controller: T = storyboard.instantiateViewController(withIdentifier: self.storyboardPCIdentifier) as! T
        return controller
    }
    
}

extension UIView {
    
    func createDashedLine(from point1: CGPoint, to point2: CGPoint, color: UIColor = .white, strokeLength: NSNumber = 5, gapLength: NSNumber = 3, width: CGFloat = 2) {
        let shapeLayer = CAShapeLayer()
        
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.lineWidth = width
        shapeLayer.lineDashPattern = [strokeLength, gapLength]
        
        let path = CGMutablePath()
        path.addLines(between: [point1, point2])
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
}


// MARK: - Enums

public enum JRPCScreens: String {
    case paytmPassbook = "/paytm_passbook"
    case paytmCoinsPassbook = "/paytm_coins_passbook"
    case paytmCoinsCatalog = "/paytm_coins_catalog"
}

public enum JRPCGAEvents: String {
    case redeemsClicked = "coins_passbook_redeem_clicked"
    case passbookClicked = "coins_passbook_clicked"
    case knowMoreClicked = "coins_know_more_clicked"
    case transactionDetailClicked = "coins_passbook_detail_clicked"
    case coinsRedemptionClicked = "coins_redemption_clicked"
    case coinsRedemptionInsufficientBalance = "coins_redemption_insufficient_balance"
}

public enum JRPCGAEventVariableKeys: String {
    
    case eventCategoryKey = "event_category"
    case eventActionKey = "event_action"
    case eventLabelKey = "event_label"
    case eventLabel2Key = "event_label2"
    case userIdKey = "user_id"
    case verticalNameKey = "vertical_name"
    case eventName = "custom_event"
    case eventCategoryValue = "paytm_coins"
    case verticalNameValue = "cashback"
    
}
