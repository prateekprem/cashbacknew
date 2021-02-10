//
//  JRMCOTransactionVM.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 28/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

class JRMCBTransactionInfo {
    private(set) var transAmount  : Int    = 0
    private(set) var transTime    : String = ""
    private(set) var status       : String = ""
    private(set) var userMobileNo : String = ""
    
     init(dict: JRCBJSONDictionary) {
        self.transAmount  = dict.getIntKey("transaction_amount")
        self.transTime    = dict.getStringKey("transaction_time")
        self.status       = dict.getStringKey("status")
        self.userMobileNo = dict.getStringKey("user_mobile_no")
    }
}

class JRMCBPaymentDetailsVM {
    private(set) var transactionsList: [JRMCBTransactionInfo] = []
    
    func removeAllTransactionData() {
        transactionsList.removeAll()
    }
    
    func fetchPaymentDetailsForGame(gameId:Int, stage:String, completion: @escaping (Bool, NSError?) -> Void) {
        var ext = ""
        if JRCashbackManager.shared.config.cbVarient == .merchantApp {
            ext = "/?game_id=\(gameId)&stage=\(stage)&page_size=20"
        }else {
            ext = "?stage=\(stage)&page_size=20"
        }
        let aModel = JRCBApiModel(type: .pathCBMerchGamePmntDetailV1, param: nil, appendUrlExt: ext)
        if let apiURL = aModel.apiUrlString {
            let urlString = String(format: apiURL, gameId)
            aModel.update(urlString: urlString)
        }
        
        JRCBServiceManager.executeAPI(model: aModel) { [weak self] (isSuecess, resp, error) in
            if isSuecess {
                if let response = resp as? JRCBJSONDictionary {
                    let superModel = JRMCOTransactionSModel(dict: response)
                    self?.transactionsList.removeAll()
                    self?.transactionsList = superModel.transactions
                    completion(true, nil)
                    
                } else {
                    completion(false, JRCBServiceManager.genericError)
                }
                
            } else {
                completion(false, error as NSError?)
            }
        }
    }
}
