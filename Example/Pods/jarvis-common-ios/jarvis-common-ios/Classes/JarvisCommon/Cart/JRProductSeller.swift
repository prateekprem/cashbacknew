//
//  JRProductSeller.swift
//  Jarvis
//
//  Created by Santosh Kumar Sahoo on 7/1/17.
//  Copyright © 2017 One97. All rights reserved.
//

import UIKit
/*
 {
    "name":"Sai Telecom",
    "id":100155,
    "offer_text":null,
    "offer_price":29100,
    "actual_price":35500,
    "discount":"18%",
    "totalScore":-29100,
    "product_id":46524680,
    "url":"https://catalog-staging.paytm.com/v1/p/samsung-a7-2016-edition-black-MOBSAMSUNG-A7-2SAI-1001553A21B0BD",
    "seourl":"https://catalog-staging.paytm.com/v1/p/samsung-a7-2016-edition-black-MOBSAMSUNG-A7-2SAI-1001553A21B0BD",
    "newurl":"https://catalog-staging.paytm.com/samsung-a7-2016-edition-black-CMPLXMOBSAMSUNG-A7-2DMV-3552681CCE88B-pdp?product_id=46524680",
    "exist":true,
    "applied":false
 }

*/


public class JRProductSeller: NSObject {

    @objc var sellerId: String?
    public var sellerName: String?
    public var price: String? {
        return offerPrice
    }//offer price
    var actualPrice: String?
    var offerPrice: String?
    var discount: String?
    @objc var productUrl: String?
    var offerText: String?
    
    var isApplied = false
    var isExist = false
    var isAuthorised = false
    public var authorisedImageUrl: String?
    
    @objc var totalScore: Double = 0.0
    @objc public var sellerRating: JRSellerRating? //old
    
    //new response 
    var productId: String?
    //used in more seller screen
    
    convenience public init(dictionary: [String:Any]) {
        self.init()
        sellerId = dictionary.getOptionalStringForKey("id")
        productId = dictionary.getOptionalStringForKey("product_id")
        sellerName = dictionary.getOptionalStringForKey("name")
        actualPrice = dictionary.getOptionalStringForKey("actual_price")
        offerPrice = dictionary.getOptionalStringForKey("offer_price")
        productUrl = dictionary.getOptionalStringForKey("url")
        totalScore = dictionary.getOptionalDoubleKey("totalScore") ?? 0.0
        isExist = dictionary.getBoolForKey("exist")
        discount = dictionary.getOptionalStringForKey("discount")
        isApplied = dictionary.getBoolForKey("applied")
    }
    
    public func shouldShowAuthorizedTag() -> Bool {
        return isAuthorised && authorisedImageUrl?.isEmpty == false
    }
}
