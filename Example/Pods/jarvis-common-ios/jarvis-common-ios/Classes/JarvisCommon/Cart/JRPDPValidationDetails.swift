//
//  JRPDPValidationDetails.swift
//  Jarvis
//
//  Created by Brammanand Soni on 29/01/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@objc public class JRPDPValidationDetails: NSObject {

    @objc var headerText: String?
    @objc var placeHolder: String?
    @objc var inputMaxLength = 50
    @objc var helpText: String?
    
    var regex: String?
    var url: String?
    var keyboardType: UIKeyboardType = .`default`
    var validationName: String?

    @objc public var inputText: String?
    @objc public var isInputVerified = false
    
    
    @objc public convenience init(dictionary: [String:Any]) {
        self.init()
        validationName = dictionary.getOptionalStringForKey("validation_name")
        headerText = dictionary.getOptionalStringForKey("header_text")
        placeHolder = dictionary.getOptionalStringForKey("input_label")
        if let kbType = dictionary.getOptionalStringForKey("input_type"), kbType == "numeric" {
            keyboardType = .numberPad
        }
        
        if let inputLength = dictionary.getOptionalIntForKey("input_length") {
            inputMaxLength = inputLength
        }
        
        helpText = dictionary.getOptionalStringForKey("help_text")
        regex = dictionary.getOptionalStringForKey("regex")
        url = dictionary.getOptionalStringForKey("endpoint_url")
    }
    
    public override init(){
        super.init()
    }
    
    @objc func isValidInput() -> Bool {
        guard let regexString = regex else {
            return true
        }
        
        let predicate = NSPredicate(format: "SELF MATCHES %@", regexString)
        return predicate.evaluate(with: inputText)
    }
}
