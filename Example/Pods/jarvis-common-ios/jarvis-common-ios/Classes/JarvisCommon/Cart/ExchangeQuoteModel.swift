//
//  ExchangeQuoteModel.swift
//  Jarvis
//
//  Created by Brammanand Soni on 02/01/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class ExchangeQuoteModel: NSObject {

    @objc public var quoteId: String?
    @objc var title: String?
    @objc var subTitle: String?
    @objc var instructionText: String?
    @objc var brand: String?
    @objc var model: String?
    var expiryDate: String?
    
    @objc public var exchangePID: String?
    
    var exchangeAmount: Double = 0.0
    var markupAmount: Double = 0.0
    @objc public var totalAmount: Double = 0.0
    
    @objc public convenience init(_ dictionary: [String: Any]) {
        self.init()
        quoteId = dictionary.getOptionalStringForKey("quote_id")
        title = dictionary.getOptionalStringForKey("title")
        subTitle = dictionary.getOptionalStringForKey("sub_title")
        instructionText = dictionary.getOptionalStringForKey("instruction_text")
        brand = dictionary.getOptionalStringForKey("brand")
        model = dictionary.getOptionalStringForKey("model")
        expiryDate = dictionary.getOptionalStringForKey("expiry_date")
        
        exchangeAmount = dictionary.getDoubleKey("exchange_amount")
        markupAmount = dictionary.getDoubleKey("markup_amount")
        totalAmount = dictionary.getDoubleKey("total_amount")
    }
    
    @objc convenience init(withWeex dictionary: [String: Any]) {
        self.init()
        model = dictionary.getOptionalStringForKey("exchangedProductName")
        totalAmount = dictionary.getDoubleKey("quoteAmount")
        instructionText = dictionary.getOptionalStringForKey("cashbackText")
        quoteId = dictionary.getOptionalStringForKey("quoteId")
        exchangeAmount = dictionary.getDoubleKey("cashbackValue")
        exchangePID = dictionary.getOptionalStringForKey("productId")
    }
}
