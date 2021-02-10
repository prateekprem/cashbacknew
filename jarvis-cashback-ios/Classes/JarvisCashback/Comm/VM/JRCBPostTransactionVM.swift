//
//  JRCBTransactionVM.swift
//  jarvis-auth-ios
//
//  Created by Rahul Kamra on 12/06/19.
//

import UIKit

class JRCBPostTransactionVM {
    private(set) var postTransactionCellVM = [JRCBPostTransactionCellVM]()
    private(set) var postTransactionState: PostTransactionStates = .shimmer
    private(set) var transactionId : String = ""
    private(set) var transType : PostTransactionType = .none
    private(set) var verticalID : String?
    private(set) var categoryID:String?
    private(set) var merchantCat:String?
    
    init() { }

    func setRequiredParams(transactionID: String, transactionType: PostTransactionType,
                           verticalID: String, categoryID: String, merchantCat: String) {
        self.transactionId = transactionID
        self.transType = transactionType
        self.verticalID = verticalID
        self.categoryID = categoryID
        self.merchantCat = merchantCat
    }

    func getUrlParams() -> [String : Any] {
        
        var params : [String : Any] = ["txn_id": transactionId,
                                       "user_id": JRCOAuthWrapper.usrIdEitherBlank,
                                       "transaction_type" : transType.name]
        switch transType {
        case .order:
            if let vertID = verticalID,vertID.count > 0 {
                params["vertical_id"] = vertID
            }
            if let catID = categoryID, catID.count > 0 {
                params["category_id"] = catID
            }
        case .p2m:
            if let merCat = merchantCat, merCat.count>0 {
                params["merchant_category"] = merCat
            }
        default: print("nothing")
        }
        return params
    }
    
    func getNumberOfItemsInSection(section: Int) -> Int {
        if postTransactionState == .scratchState {
            return postTransactionCellVM.count
        }
        return 1
    }

    func fetchStoreFrontData(completion : @escaping (Bool) -> Void) {
        JRCBServices.serviceFetchStorefrontData {[weak self] (data, error) in
            if let aData = data as [String : AnyObject]? {
                let banners = JRCashbackManager.shared.cbEnvDelegate.postTransModelsWith(dict: aData, verticalId: self?.verticalID)
                if let item = banners.first {
                    self?.postTransactionCellVM.append(item)
                }
                completion(true)
                
            } else {
                completion(false)
            }
        }
    }
}
