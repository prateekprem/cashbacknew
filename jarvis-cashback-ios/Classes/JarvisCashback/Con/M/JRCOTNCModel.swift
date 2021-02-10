//
//  JRCOTNCModel.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 06/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

class JRCOTNCModel {
   private(set) var terms = ""
   private(set) var terms_title = ""
    
    init(dict: JRCBJSONDictionary) {
        var mDict = dict
        if let data = dict["data"] as? JRCBJSONDictionary {
            mDict = data
        }
        self.terms = mDict.getStringKey("terms")
        self.terms_title = mDict.getStringKey("terms_title")
    }
    
    init(termsTitle:String, termsDescription:String) {
        self.terms = termsDescription
        self.terms_title = termsTitle
    }
}
