//
//  JRCBPointListInfo.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 24/07/20.
//

import Foundation

class JRCBPointListSection {
    let sTitle: String
    private(set) var sList = [JRCBPointListInfo]()
    
    init(title: String, list: [JRCBPointListInfo]) {
        self.sTitle = title
         self.sList = list
    }
    
    func append(list: [JRCBPointListInfo]) {
        self.sList = self.sList + list
    }
}

class JRCBPointListInfo {
    private(set) var title: String = ""
    private(set) var valueStr: String = ""
    private(set) var offerIconImage: String = "" // left
    private(set) var rightIconImage: String = ""
    private var createdAt: Date = Date()
    private(set) var cellDTime: String = ""
    private(set) var secDTime: String = ""
    private(set) var redumInfo: JRCBRedumptionScratchCard?
    private(set) var isPending: Bool  = false
    
    init(dict: JRCBJSONDictionary) {
        self.title = dict.stringFor(key: "earnedForText")
        
         self.rightIconImage = dict.stringFor(key: "cashbackDestinationIconUrl")
        self.redumInfo = JRCBRedumptionScratchCard(dict: dict)
        if let createdAtV = dict["createdAt"] as? Int64, createdAtV > 0 {
            self.createdAt = Date(timeIntervalSince1970: TimeInterval(createdAtV/1000))
        }
        
        if let redMetaData = self.redumInfo?.redemMetedata {
            self.isPending = self.redumInfo!.status != .stRedeemed
            if redMetaData.redemptionType == .rCoins {
                valueStr = redMetaData.amount.cleanValue
                self.rightIconImage = ""
            } else {
                valueStr = JRCBConstants.Symbol.kRupee + "\(redMetaData.amount.cleanValue)"
            }
        }
        if let srcMetaData = self.redumInfo?.sourceMetedata {
            self.offerIconImage = srcMetaData.offerIconUrl
        }
        self.calculateDtDisplay()
    }
    
    private func calculateDtDisplay() {
        self.cellDTime = createdAt.displayStrIn(format: "dd MMMM")
        self.secDTime = createdAt.displayStrIn(format: "MMMM yyyy")
    }
}


