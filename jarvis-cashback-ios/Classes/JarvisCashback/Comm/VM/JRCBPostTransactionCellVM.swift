//
//  JRCBPostTransactionCellVM.swift
//  jarvis-auth-ios
//
//  Created by Nikita Maheshwari on 19/06/19.
//

import Foundation

public class JRCBPostTransactionCellVM {
    private(set) var imageURl        : String = ""
    private(set) var stFrontDeeplink : String = ""
    private(set) var verticalID      : String = ""
    private(set) var itemID          : String = "0"
    
    public init(imgUrl: String?, sfDeeplink: String?, itemId: Int?, verticalID: String) {
        if let aUrl = imgUrl { self.imageURl = aUrl }
         if let aUrl = sfDeeplink { self.stFrontDeeplink = aUrl }
        
        self.verticalID = verticalID
        let itmId = itemId ?? 0
        self.itemID = "\(itmId)"
        
        let labelsArray: [String : String] = ["event_label": itemID,
                                              "event_label2": verticalID,
                                              "event_label3": ""]
        JRCBAnalytics(screen: .screen_PostOrder, vertical: .vertical_Cashback,
                      eventType: .eventCustom, category: .cat_PostTransaction,
                      action: .act_BannerLoaded, labels: labelsArray).track()
    }
}
