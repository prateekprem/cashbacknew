//
//  JRCBRewardsVM.swift
//  jarvis-cashback-ios
//
//  Created by Prateek Prem on 31/01/20.
//

import Foundation

struct JRCBRewardsVM: Codable {
    let status: Int?
    let error: String?
    let data: DataClass?
}

// MARK: - DataClass
struct DataClass: Codable {
    var title: String { return _title ?? "Rewards & Offers" }
    let summary: [Summary]?
    
    private var _title: String?

    enum CodingKeys: String, CodingKey {
        case _title = "title"
        case summary
    }
}

// MARK: - Summary
public struct Summary: Codable {
   public var categoryType: String?
   let categoryMessage, categoryLabel: String?
   public var amount: Int { return _amount ?? -1 }
   public let icon, deeplink: String?
   public var catType: CBRewardType {
        get {
            if let ctype = categoryType, let mCatType =  CBRewardType(rawValue: ctype) {
                return mCatType
            }
            return .cashback
        }
    }
    
    private var _amount: Int?
    
    enum CodingKeys: String, CodingKey {
        case _amount = "amount"
        case categoryType
        case categoryMessage
        case categoryLabel
        case icon
        case deeplink
    }
}


public enum CBRewardType: String {
    case cashback = "CASHBACK"
    case coin = "PAYTM_FIRST_COINS"
    case sticker = "STICKER"
}

class JRCBRewardItem: JRCBSFItem {
    var categoryType: CBRewardType = .cashback
    override init() {
        super.init()
    }
    override init(dict: JRCBJSONDictionary) {
        super.init(dict: dict)
    }
}
