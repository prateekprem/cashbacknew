//
//  Jarvis
//
//  Created by Siddharth Suneel on 18/01/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class DealDataModel {
    private(set) var deal_voucher_code : String = ""
    private(set) var deal_icon : String = ""
    private(set) var tnc_model : JRCOTNCModel = JRCOTNCModel(dict: [:])
    private(set) var deal_text : String = ""
    private(set) var deal_usage_text : String = ""
    private(set) var display_valid_from : String = ""
    private(set) var display_valid_upto : String = ""
    private(set) var secret: String = ""
    
    init(dict: JRCBJSONDictionary) {
        self.deal_voucher_code = dict.getStringKey("deal_voucher_code")
        self.deal_icon = dict.getStringKey("deal_icon")
        self.secret = dict.getStringKey("secret")
        
        let deal_valid_from = dict.getStringKey("deal_valid_from")
        let deal_expiry = dict.getStringKey("deal_expiry")
        self.display_valid_from = JRCOUtils.getDateForDealsAndCrossPromo(inputDate:deal_valid_from)
        self.display_valid_upto = JRCOUtils.getDateForDealsAndCrossPromo(inputDate:deal_expiry)
        
        let deal_terms = dict.getStringKey("deal_terms")
        self.tnc_model = JRCOTNCModel(termsTitle: "jr_ac_termsNConditions".localized, termsDescription: deal_terms)
        self.deal_text = dict.getStringKey("deal_text")
        self.deal_usage_text = dict.getStringKey("deal_usage_text")
    }
}


public class JRCBBaseDataModel {
    public init(dict: JRCBJSONDictionary) {
        guard let mDict = dict["data"] as? JRCBJSONDictionary else {
            self.parse(dict: dict)
            return
        }
        self.parse(dict: mDict)
    }
    
    func parse(dict: JRCBJSONDictionary) {
    }
}

class JRMCOTransactionSModel: JRCBBaseDataModel {
    private(set) var oldest_txn_time : String = ""
    private(set) var is_next: Bool = false
    private(set) var transactions: [JRMCBTransactionInfo] = []
    
    override func parse(dict: JRCBJSONDictionary) {
        super.parse(dict: dict)
        if let transactionArray = dict.getArrayKey("transactions") as? [[String : Any]] {
            for trDict in transactionArray {
                let trInfo = JRMCBTransactionInfo(dict: trDict)
                transactions.append(trInfo)
            }
        }
        is_next = dict.getBoolForKey("is_next")
        oldest_txn_time = dict.getStringKey("oldest_txn_time")
    }
}


public class JRMCONewOfferSModel: JRCBBaseDataModel {
    public private(set) var page_offset:String = ""
    public private(set) var is_next:Bool = false
    public private(set) var campaignsViewModel:[JRMCONewOfferViewModel] = []

    override func parse(dict: JRCBJSONDictionary) {
        super.parse(dict: dict)
        
        if let campaignArray = dict.getArrayKey("campaigns") as? [JRCBJSONDictionary] {
            for campaignDict in campaignArray {
                let merchantNewOfferVMObj = JRMCONewOfferViewModel(dict: campaignDict)
                campaignsViewModel.append(merchantNewOfferVMObj)
            }
        }
        is_next = dict.getBoolForKey("is_next")
        page_offset = dict.getStringKey("page_offset")
    }
}


class JRMCOMyOfferSModel: JRCBBaseDataModel {
    private(set) var is_next = false
    private(set) var hasExpiredOffers = false
    private(set) var supercashList:[JRMCOMyOfferViewModel] = []
   
    override func parse(dict: JRCBJSONDictionary) {
        super.parse(dict: dict)
        
        let offersArray = dict.getArrayKey("supercash_list")
        for offer in offersArray{
            if let cashbackOffer = offer as? [String:Any]{
                let offerVMObj = JRMCOMyOfferViewModel(dict:cashbackOffer)
                supercashList.append(offerVMObj)
            }
        }
        is_next = dict.getBoolForKey("is_next")
        hasExpiredOffers = dict.getBoolForKey("has_expired_offers")
    }
}
