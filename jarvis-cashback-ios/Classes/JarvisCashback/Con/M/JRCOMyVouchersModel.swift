//
//  JRCOMyVouchersModel.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 02/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import Foundation

struct JRCOMyVoucherResponseModel: Codable {
    var response: JRCOMyVouchersModel?
    var error: [JRCOErrorModel]?
    var status: Int?
}

struct JRCOMyVouchersModel: Codable {
    var voucherList: [JRCOVoucherListModel]?
    var hasExpiredOffers: Bool?
    var isNext: Bool?
}

struct JRCOVoucherListModel: Codable {
    var title: String?
    var savingsText: String?
    var expireSoon: Bool?
    var promocode: String?
    var displayCode: String?
    var usageText: String?
    var icon: String?
    var siteId: Int?
    var bgImage: String?
    var client: String?
    var redemptionType: String?

}

struct JRCOErrorModel: Codable {
    var code: String?
    var messsage: String?
}

// MARK :- My Voucher Filter Model
struct JRCOMyVoucherFilterModel: Codable {
    var facets: [JRCOFilterItemModel]?
    var error: [JRCOErrorModel]?
    var status: Int?
}

struct JRCOFilterItemModel: Codable {
    var field: String?
    var displayName: String?
    var displayFilterType: String?
    var items: [JRCOFilterListModel]?
}

struct JRCOFilterListModel: Codable {
    var fieldValue: String?
    var displayName: String?
    var id: Int?
    var count: Int?
}


// MARK :- My Voucher Detail Model
struct JRCOMyVoucherDetailResponse: Codable {
    var response: JRCOMyVoucherDetailModel?
    var error: [JRCOErrorModel]?
    var status: Int?
}

struct JRCOMyVoucherDetailModel: Codable {
    var savingsText: String?
    var promocode: String?
    var usageText: String?
    var icon: String?
    var descriptionText: String?
    var cta: String?
    var termsUrl: String?
    var status: String?
    var validity: String?
    var deeplink: String?
    var isExpireSoon: Bool?
    var bgImage: String?
    var earnedForText: String?
    var title: String?
    var redemptionType: String?
    var validFrom: String?
    var validUpto: String?
    var secret: String?
    var winningText: String?
    var termsText: String?
    var redemptionTermsText: String?

}

// Terms and condition for promocodes
struct JRCOPromoTnC: Codable {
    var terms: String?
    var promocode: String?
    var siteId: Int?
    var termsTitle: String?
}

