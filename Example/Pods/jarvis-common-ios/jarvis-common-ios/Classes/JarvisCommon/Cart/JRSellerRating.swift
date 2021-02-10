//
//  JRSellerRating.swift
//  Jarvis
//
//  Created by Prakash Jha on 13/08/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public typealias JRJSONDictionary = [String:Any]

@objc public class JRSellerRating: NSObject {
    @objc private(set) var sample_count: Int = 0
    @objc private(set) var display_rating: Double = 0
    @objc private(set) var merchant_id: Int = 0
    @objc private(set) var rating: Double = 0.0
    @objc public private(set) var data: [JRSellerRatingItem]?
    
    @objc var merchantId: String {
        get {
            if merchant_id != 0 {
                return "\(merchant_id)"
            }
            return ""
        }
    }
    
    @objc public func getDisplayRating() -> Double {
        return display_rating
    }
    
    @objc public func getData() -> [JRSellerRatingItem]? {
        return data
    }
    
    @objc public init(dict: JRJSONDictionary) {
        super.init()
        self.fillUp(dict: dict)
    }
    
    @objc init(sellerRatingDict: JRJSONDictionary) {
        super.init()
        self.fillUpsellerRating(dict: sellerRatingDict)
    }
    
    private func fillUp(dict: JRJSONDictionary) {
        self.sample_count   = dict.intFor(key: "sample_count")
        self.display_rating = dict.doubleFor(key: "display_rating")
        self.merchant_id    = dict.intFor(key: "merchant_id")
        self.rating         = dict.doubleFor(key: "rating")
        
        var ratingItems = [JRSellerRatingItem]()
        if let list = dict["data"] as? [JRJSONDictionary] {
            for mDict in list {
                ratingItems.append(JRSellerRatingItem(dictionary: mDict))
            }
        }
        
        if ratingItems.count > 0 {
            self.data = ratingItems
        }
    }
    
    private func fillUpsellerRating(dict: JRJSONDictionary) {
        self.sample_count   = dict.intFor(key: "sample_count")
        self.display_rating = dict.doubleFor(key: "display_rating")
        self.merchant_id    = dict.intFor(key: "merchant_id")
        self.rating         = dict.doubleFor(key: "rating")
        
        let rating1 = JRSellerRatingItem(dictionary: ["text": "Product Description",
                                                      "rating": dict.doubleFor(key: "s1")])
        let rating2 = JRSellerRatingItem(dictionary: ["text": "Product Packaging",
                                                      "rating": dict.doubleFor(key: "s2")])
        let rating3 = JRSellerRatingItem(dictionary: ["text": "Product Delivery",
                                                      "rating": dict.doubleFor(key: "s3")])
        
        self.data = [rating1, rating2, rating3]
        
        var rate: Float = 0
        for ratingItem in self.data! {
            rate = rate + Float(ratingItem.rating)
        }
        
        self.display_rating = Double(rate/Float(self.data!.count))
    }
}
