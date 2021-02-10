//
//  JRSFViewModel.swift
//  jarvis-cashback-ios_Example
//
//  Created by Prakash Jha on 01/07/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import jarvis_storefront_ios
import jarvis_cashback_ios

class JRSFViewModel: SFLayoutPresentDelegate {
    private(set) var floatTabbar : SFFloatingTabView?
    
    static let kSFPathPaytmHome  = "https://storefront.paytm.com/v2/h/post-txn-page-new?client=iosapp&version=8.11.8&child_site_id=1&site_id=1&lang_id=1"
    class var sfBasicParam: JRCBJSONDictionary {
        return ["deviceIdentifier":"Apple-iPhone-5BAD78A4-9904-4465-A4AB-9C919A0835CD",
                "language":"en-IN", "locale":"en-IN", "version":"8.11.6",
                "client":"iosapp"]
    }
    
    
    func fetchDataFromAPI(completion: ((_ success: Bool) -> Void)?) {
        let container = SFContainer(appType: .other, verticalName: "cashback", delegate: self, dataSource: nil)
        
        let aHeader : [String : String] = ["Cache-Control": "no-cache","Content-Type": "application/json",
                                           "x-app-rid": "B26769F7-B6B7-40E8-AEC4-76A72669DCCA:1580713596:01:006"]
        
        container.loadSFApiWith(url: JRSFViewModel.kSFPathPaytmHome, vertical: .payments, headers: aHeader, body : JRSFViewModel.sfBasicParam as! [String : String]) { [weak self] (success, resp, err) in
            DispatchQueue.main.async {
                if success {
                    self?.floatTabbar = container.getFloatingTabView()
                }
                completion?(success)
            }
        }
    }
    
    func sfDidClickFloatingTabItem(_ item: SFLayoutItem) { }
}
