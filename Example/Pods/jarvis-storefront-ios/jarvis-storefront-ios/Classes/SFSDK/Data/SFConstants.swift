//
//  SFConstants.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 14/10/19.
//

import Foundation

public let rupeeSymbol: String = "₹"

enum MPBrandFilterSection: Int{
    case popularBrand = 1
    case otherBrand = 2
}

class SFConstants {
    @objc public class var windowWidth: CGFloat {
        if let rootwindow = UIApplication.shared.delegate?.window, let view = rootwindow!.rootViewController?.view{
            return view.bounds.size.width
        }
        return 0
    }
    
    //Filter Specific
    static let brandFilterPopular = "Popular Brands"
    static let brandFilterOther = "Other Brands"
}
