//
//  JRCBManager.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 24/12/19.
//

import Foundation

typealias JRCBVMCompletion = (_ success: Bool, _ errMsg: String?) -> Swift.Void
typealias JRCBDeeplinkVMCompletion = (_ success: Bool, _ errMsg: String?, _ deeplinkURL: String?) -> Swift.Void

@objc public enum PointsLandingType: Int {
    case passbook
    case redeem
    case merchantRedeem
}

enum CBConsumerType : Int {
    case Customer = 1
    case Merchant
    case None
}

enum JRCBResponseStatus: Int {
    case stNotStarted = 0
    case stInprogress = 1
    case stError      = 2
    case stSuccess    = 3
}

public class JRCBManager {
    static var categoryIdOfferTypeIdDic: [Int:Int] = [
        17:1, //Mobile Recharge
        21:1,
        5:1,
        9:1,
        18:2, //DTH Recharge
        6:2,
        77409:3, //Metro Recharge
        28:3,
        26:4, //Electricity Bill
        46007:15, //Fee Payment
        37217:16, //Loan EMI Payment
        107730:17, //Municipal Payment
        64739:19, //Insurance Payment
        19:20, //Data Card Recharge
        7:20,
        23:20,
        11:20,
        68869:21, //Water Bill Pay
        78640:22, //Gas Bill Pay
        13:22,
        75505:24, //Broadband Bill Pay
        100253:25, //Toll Tah Recharge
        80491:26, //Movie Tickets
        82653:27, //Train Tickets
        25173:28, //Bus Tickets
        69089:29, //Flight Tickets
        132935:35, //Donations
        101950:36, //Apartments
        156705:37 //Credit Card
        
        //5,6,7 - UPI
        //38 - P2B
        //39 - Gift Voucher
        
    ]
    
    static var isMerchantSupported : Bool {
        get {
            let enable = JRCBRemoteConfig.kCBMerchantActiveIOS.boolValue(defaultVal: true)
            return JRCOAuthWrapper.isSDMerchant && enable
        }
    }
    
    static var userMode : CBConsumerType = .Customer
    
    static var profileImageUrl: String {
        get {
            if let imgNm = JRCOAuthWrapper.profilePic,
                !imgNm.trimmingCharacters(in: CharacterSet.whitespaces).isEmpty { return imgNm }
            return ""
        }
    }
    
    static let shareInstance = JRCBManager()
    private init() {}
    
    private var postTxnManager: JRCBPostTxnManager?
    var mid: String?
    
    public class func fetchCashbackAmount(completion: @escaping (_ items: [Summary]?, _ errStr: String?) -> Void) {
        JRCBServices.fetchLandingCBCoins { (success, reward, error) in
            if success, let rew = reward, let data = rew.data, let items = data.summary, items.count > 0 {
                completion(items, nil)
            } else {
                completion(nil, error ?? "Something wrong")
            }
        }
    }
    
    public static func addBannerWith(param: JRCBPostTxnBannerParams, delegate: JRCBPostTxnBannerDelegate) {
        if !param.isValid { return }
        let postTxnManager = JRCBPostTxnManager()
        postTxnManager.addBannerWith(param: param, delegate: delegate)
        JRCBManager.shareInstance.postTxnManager = postTxnManager
    }
    
    // 
    func clearPostTxnObject() {
        self.postTxnManager = nil
    }
}

//MARK: Flash Popup
extension JRCBManager {
    
    static let kKeyTxnId = "transactionId"
    static let kKeyOrderId = "orderId"
    static let kKeyPgTxnId = "pgTransactionId"
    static let kKeyUpiTxnId = "upiTransactionId"
    static let kKeyWalletTxnId = "walletTransactionId"
    static let kVerticalId = "verticalId"
    static let kTxnType = "transactionType"
    static let kCategoryId = "categoryId"
    static let kMerchantCat = "merchantCategory"
    static let kOfferIds = "offerIds"
    
    static let kKeyEventType = "eventType"

    static let kKeySFUrl = "storeFrontUrl"
    static let kEventPostTransaction = "POSTTRANSACTION"
    
    class var kCBSFTabUniqueID: String {
        return "Cashback"
    }
    
    static public func flashBannerWith(delegate: JRCBPostTxnBannerDelegate?) {
        let paramDict = ["eventType": "APP_OPEN"]
        eventOfferAPI(param: paramDict, delegate: delegate)
    }
    
    static public func handleCashabckAnimation(jsonDict: [String: Any], delegate: JRCBPostTxnBannerDelegate?) -> (Bool, String, [String: Any]) {
        guard let aDelegte = delegate else {
            return (false, "Delegate Not Passed", [:])
        }
        
        if let sfURL = jsonDict[kKeySFUrl] as? String, !sfURL.isEmpty {
            //Handling of SF Floating bottom bar
            return (true, "", [kKeySFUrl: sfURL])
        }
        
        guard let eventType = jsonDict[kKeyEventType] as? String, !eventType.isEmpty else {
            return (false, "", [:])
        }
        
        guard let jsonDataDict = jsonDict["data"] as? [String: Any] else {
            return (false, "json object of data not available", [:])
        }
        
        if eventType == kEventPostTransaction {
            //Handling of post transaction
            let orderId = jsonDataDict.getStringKey(kKeyOrderId)
            let pgTrnsId = jsonDataDict.getStringKey(kKeyPgTxnId)
            let upiTrnsId = jsonDataDict.getStringKey(kKeyUpiTxnId)
            let walletTrnsId = jsonDataDict.getStringKey(kKeyWalletTxnId)
            if orderId.isEmpty, pgTrnsId.isEmpty, upiTrnsId.isEmpty, walletTrnsId.isEmpty {
                return (false, "Transaction Id's are empty", [:])
            } else {
                let txnIDs = JRCBPostTxnID(orderID: orderId, pgTransactionID: pgTrnsId, upiTransactionID: upiTrnsId, walletTransactionID: walletTrnsId)
                
                let verticalId = jsonDataDict.getStringKey(kVerticalId)
                let categoryId = jsonDataDict.stringFor(key: kCategoryId)
                let merchntCat = jsonDataDict.getStringKey(kMerchantCat)
                
                let txnType = jsonDataDict.getStringKey(kTxnType)
                let postTxnType = (PostTransactionType(string: txnType) ?? PostTransactionType(rawValue: 0))!
                
                var intOfferIds: [NSNumber]?
                if let offrIds = jsonDataDict[kOfferIds] as? [String] {
                    intOfferIds = offrIds.map { NSNumber(value: Int($0) ?? 0) }
                }
               
                
                let aParam = JRCBPostTxnBannerParams.paramWith(txnIds: txnIDs, transType: postTxnType, verticalID: verticalId, categoryID: categoryId, merchantCat: merchntCat, offerIds: intOfferIds)
                
                JRCBManager.addBannerWith(param: aParam, delegate: aDelegte)
            }
            
            
            
        } else {
            //Handling of Scratch Card H5 animation
//            var paramsDict = [kKeyEventType: eventType]
//            if let evntId = jsonDict[kKeyEventId] as? String {
//                paramsDict[kKeyEventId] = evntId
//            }
//            if let evntVal = jsonDict[kKeyEventVal] as? String {
//                paramsDict[kKeyEventVal] = evntVal
//            }
            
            eventOfferAPI(param: jsonDataDict, delegate: delegate)
            
        }
        
        return (false, "", [:])
    }
    
    static func eventOfferAPI(param: JRCBJSONDictionary, delegate: JRCBPostTxnBannerDelegate?) {
        JRCBServices.fetchAppOpenData(param: param) { (success, response, err) in
            if let mResp = response {
                let superData = JRCBPostTxnSuperModel(dict: mResp)
                if superData.status == 1, let mTransData = superData.data {
                    DispatchQueue.main.async {
                        JRCBPostTxnManager.showPostTransViewWith(transInfo: mTransData, delegate: delegate, triggerType: .appOpen)
                    }
                } else {
                    delegate?.cbDidFailToPresentAniation() //Error Case
                }
                
            } else {
                delegate?.cbDidFailToPresentAniation() //Error Case
            }
        }
    }
    
}


extension JRCBManager {
    public class func presentActivateOfferVC(onController: UIViewController, object: Any) {
        let vc = JRMCOActivateOfferVC.instance(viewModel: object)
        vc.isPresented = true
        onController.present(vc, animated: true, completion: nil)
    }   
}
