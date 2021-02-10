//
//  JRCBVoucherDetailInput.swift
//  FBSDKCoreKit
//
//  Created by Prakash Jha on 31/07/20.
//

import Foundation

enum JRCBVDealDetailType: String {
    case voucher = "Voucher"
    case deal = "Deal"
}

struct JRCBVoucherDetailInput {
    private(set) var detailType: JRCBVDealDetailType = .voucher
    private(set) var promocode: String?
    private(set) var siteID: Int = 0
    private(set) var scratchId : String?
    private(set) var clientId : String?
    private(set) var type : String?
    private(set) var callAPI = false
    
    // deal
    init(scratchId: String?) {
        self.detailType = .deal
        self.scratchId = scratchId
        self.callAPI = true
    }
    
    // voucher
    init(promoCode: String?, site_id: Int, client_id: String? = "", type: String = "") {
        self.promocode = promoCode
        self.siteID = site_id
        self.callAPI = true
        self.clientId = client_id
        self.type = type
    }
    
    init() {}
    
}


extension JRCBVoucherDetailInput {
    func detailVC() -> JRCBBaseVC {
            let vc = JRCBDeelsNVoucherDetailVC.newInstance
            vc.set(input: self)
            return vc
    }
    
    static func detailVCWith(scratchId: String) -> (vc: UIViewController, push: Bool) {
            let input = JRCBVoucherDetailInput(scratchId: scratchId)
            return (input.detailVC(), true)
    }
    
    static func detailVCWith(siteID: String?, promoCode: String?, model: Any?) -> UIViewController {
        if model == nil {
            var mSiteId = 0
            if let sId = siteID { mSiteId = Int(sId) ?? 0 }
            let input = JRCBVoucherDetailInput(promoCode: promoCode, site_id: mSiteId)
            return input.detailVC()
        }
        
            let vc = JRCBDeelsNVoucherDetailVC.newInstance
            vc.updateWith(dealModel: model)
            return vc
    }
}
