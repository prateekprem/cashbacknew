//
//  JRProductFavoritesDetail.swift
//  Jarvis
//
//  Created by Prakash Jha on 13/08/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class JRProductFavoritesDetail: NSObject {
    @objc public private(set) var wishlistCount : Int = 0
    @objc public private(set) var orderCount    : Int = 0
    @objc public var isAvailableInUserWishList: Bool = false
    
    @objc public init(dict: [String: Any]) {
        super.init()
        self.fillUp(dict: dict)
    }
    
    private func fillUp(dict: [String: Any]) {
        self.wishlistCount = dict.intFor(key: "wl_count")
        self.orderCount    = dict.intFor(key: "order_count")
    }
}
