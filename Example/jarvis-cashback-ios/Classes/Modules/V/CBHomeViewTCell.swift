//
//  CBHomeViewTCell.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 02/01/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import jarvis_cashback_ios

class CBHomeViewTCell: UITableViewCell {
    @IBOutlet weak private var ttlLbl: UILabel!
    @IBOutlet weak private var descLbl: UILabel!
    
    func show(info: CBHomeViewTCellInfo) {
        self.ttlLbl.text = info.title
        descLbl.text = info.desc
    }
}


enum CBHomeViewType: String, CaseIterable {
    case typePostTransaction = "Post transaction"
    case typeCashbackLanding = "Cashback Landing"
    case typeDeepLink        = "Deep Link"
    case typePaytmPoints     = "Points Redemption"
}

enum CBHomeVCType: String {
    case main = "main"
    case deeplink = "deeplink"
}

class CBHomeViewTCellInfo {
    private(set) var type = CBHomeViewType.typePostTransaction
    private(set) var title = ""
    private(set) var desc = ""
    init(cType: CBHomeViewType) {
        self.type = cType
        self.title = type.rawValue
        self.desc = "cashbacksummary"
    }
    
    init(title: String, desc: String) {
        self.title = title
        self.desc = desc
    }
    
    class var list: [CBHomeViewTCellInfo] {
        var mList = [CBHomeViewTCellInfo]()
        for mType in CBHomeViewType.allCases {
            mList.append(CBHomeViewTCellInfo(cType: mType))
        }
        return mList
    }
    
    
    class var dlList: [CBHomeViewTCellInfo] {
        var mList = [CBHomeViewTCellInfo]()
        let mDicts = CBHomeViewTCellInfo.deepLinks
        for dict in mDicts {
            let mInfo = CBHomeViewTCellInfo(title: dict.stringFor(key: "title"),
                                            desc: dict.stringFor(key:"link"))
            mList.append(mInfo)
        }
        return mList
    }
 
    
    private class var deepLinks: [JRCBJSONDictionary] {
        return [
            ["title": "Referrals",
            "link": "paytmmp://cash_wallet?featuretype=vip&screen=referral&tag=REFERRAL"],
            ["title": "Consumer Landing",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=homescreen&showHomeOnBack=false"],
            ["title": "Merchant Landing",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=homescreenMerchant"],
            ["title": "points",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=cashbacksummary&offerType=points"],
            ["title": "Top Offer",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=topoffer&campaignid=8907"],
            ["title": "Offer Details",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=offerdetails&gameid=0000"],
            ["title": "Offer Tag",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=homescreen&offertag=Recharge%20and%20Bill%20payment%20Offers"],
            ["title": "My Scratch Cards",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=myscratchcards"],
            ["title": "SuperCash Campaign",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=supercampaigndetails&campaignid=41709"],
            ["title": "Voucher Details",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=voucherdetails"],
            ["title": "voucher details with voucher code",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=myvoucherdetails&promocode=DF3RZNX27EWLT9E2&siteid=1"],
            ["title": "voucher details | campaigndetails",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=campaigndetails&campaignid=41255"],
            ["title": "Merchant Capaign Details",
             "link": "paytmmp://cash_wallet?featuretype=vip&screen=merchantCampaignDetail&campaignid=67556"],
            ["title": "rewards staging",
             "link": "paytmmp://business-app/ump-web?url=https://ump-staging2.paytm.com/app?redirectUrl=rewards-passbook?src=p4b&channel=consumer_app"],
             ["title": "Merchant Voucher Landing",
              "link": "paytmmp://cash_wallet?featuretype=vip&screen=homescreenMerchant&screentype=voucher"]
        ]
    }
}
