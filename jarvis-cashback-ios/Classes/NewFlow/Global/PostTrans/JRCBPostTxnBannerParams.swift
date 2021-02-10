//
//  JRCBPostTxnBannerParams.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 27/12/19.
//

import Foundation

public struct JRCBPostTxnID {
    public private(set) var orderID             : String?
    public private(set) var pgTransactionID     : String?
    public private(set) var upiTransactionID    : String?
    public private(set) var walletTransactionID : String?
    
    var transID: String {
        if let tId = orderID { return tId }
        if let tId = pgTransactionID { return tId }
        if let tId = upiTransactionID { return tId }
        if let tId = walletTransactionID { return tId }
        return ""
    }
    
    public static func idsWith(orderId: String?, pgTransId: String?,
                                 upiTransId: String?, walletTransId: String?) -> JRCBPostTxnID {
        return JRCBPostTxnID(orderID: orderId, pgTransactionID: pgTransId,
                             upiTransactionID: upiTransId,
                             walletTransactionID: walletTransId)
    }
}

public struct JRCBPostTxnBannerParams {
    public private(set) var txnIds     : JRCBPostTxnID
    public private(set) var transType  : PostTransactionType
    public private(set) var verticalID : String
    public private(set) var categoryID : String
    public private(set) var merchantCat: String
    public private(set) var offerIds   : [NSNumber]?
    private var mTxnId : String
    
    var isValid: Bool {
        guard !mTxnId.isEmpty else { return false }
        return self.isPostTransactionEnabled()
    }
    
    
    public static func paramWith(txnIds: JRCBPostTxnID, transType: PostTransactionType,
                                 verticalID: String, categoryID: String,
                                 merchantCat: String, retryAttempt: String = "0",
                                 offerIds: [NSNumber]? = nil) -> JRCBPostTxnBannerParams {
        
        return JRCBPostTxnBannerParams(txnIds: txnIds, transType: transType,
                                       verticalID: verticalID, categoryID: categoryID,
                                       merchantCat: merchantCat, offerIds: offerIds, mTxnId: txnIds.transID)
    }
    
    @available(*, deprecated, message: "use JRCBPostTxnID to pass multi-ids")
    public static func paramWith(transID: String, transType: PostTransactionType,
                                 verticalID: String, categoryID: String,
                                 merchantCat: String, retryAttempt: String = "0", offerIds: [NSNumber]? = nil) -> JRCBPostTxnBannerParams {
        
        let postTxnIds = JRCBPostTxnID(orderID: transID, pgTransactionID: nil,
                                       upiTransactionID: nil, walletTransactionID: nil)
        return JRCBPostTxnBannerParams.paramWith(txnIds: postTxnIds, transType: transType,
                                                 verticalID: verticalID, categoryID: categoryID,
                                                 merchantCat: merchantCat, offerIds: offerIds)
    }
    
    func getPostTransDetail(retryAttempt: String, completion: ((JRCBPostTxnSuperModel?, String) -> Void)?) { // add completion block

        guard let mBlock = completion else {
            return
        }
        
        if JRCashbackManager.shared.shouldMock { // Mock...
            if let mResp = JRCBMockUtils.kJRCBPostTransMockFile.getDictFromBundle().dict {
                let postTransInfo = JRCBPostTxnSuperModel(dict: mResp)
                mBlock(postTransInfo, "")
                return
            }
        }
        
        var params = self.urlParams
        params["retryAttempt"] = retryAttempt
        let mParam : [String : Any]? = params
        
        let apiModel = JRCBApiModel(type: JRCBApiType.pathV4PostTxnAsync, param: mParam, appendUrlExt: "")
        JRCBServiceManager.execute(apiModel: apiModel) { (success, resp, err) in
            // parse here..
            if let mResp = resp {
                let postTransData = JRCBPostTxnSuperModel(dict: mResp)
                 mBlock(postTransData, "")
            } else if let mErr = err {
                mBlock(nil, mErr.localizedDescription)
                
            } else {
                // default handling..
                 mBlock(nil, "something went wrong.")
            }
        }
    }
    
    
    private var urlParams : [String : Any] {
        var params : [String : Any] = ["txn_id": self.mTxnId,
                                       "user_id": JRCOAuthWrapper.usrIdEitherBlank,
                                       "transaction_type" : transType.name]
        switch transType {
        case .order:
            if verticalID.count > 0 { params["vertical_id"] = verticalID }
            if categoryID.count > 0 { params["category_id"] = categoryID }
        case .p2m:
            if merchantCat.count > 0 { params["merchant_category"] = merchantCat }
        default: print("nothing")
        }
        return params
    }
 
}


private extension JRCBPostTxnBannerParams {
    private func isPostTransactionEnabled() -> Bool {
        #if DEBUG
        return true
        #else
    
        var catID: NSNumber? = nil
        if let myInteger = Int(self.categoryID) {
            catID = NSNumber(value:myInteger)
        }
    
        var offerTypeId: Int = 0
        var isOfferIdExist = false
        guard let offersList = JRCBRemoteConfig.postTxtOfferIds else { return false }
        if let catID = catID, catID.intValue != 0 {
            if let offerId = JRCBManager.categoryIdOfferTypeIdDic[catID.intValue] {
                offerTypeId = offerId
            }
        }
        
        if offerTypeId != 0 {
            return (offersList.contains(offerTypeId) && JRCBRemoteConfig.cashbackFeature.boolValue())
            
        } else if let offerIds = self.offerIds {
            for offerId in offerIds where offerId.intValue != 0 {
                offerTypeId = offerId.intValue
                isOfferIdExist = (offersList.contains(offerTypeId) && JRCBRemoteConfig.cashbackFeature.boolValue())
                if isOfferIdExist {
                    return true
                }
            }
        }
        return isOfferIdExist
        #endif
    }
}
