//
//  JRSellerRatingItem.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 16/06/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation

public class JRSellerRatingItem: NSObject {

    @objc public var rating: Double
    public let text: String?
    
    @objc public init(dictionary: [String: Any]) {
        
        rating = dictionary.getDoubleKey("rating")
        text = dictionary.getOptionalStringForKey("text")
        super.init()
    }
}


