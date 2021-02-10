//
//  JRCBSingleLabelFooter.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/01/20.
//

import UIKit

class JRCBSingleLabelFooter: UIView {
    
    @IBOutlet weak var footerLabel: UILabel!
    
    class func instanceFromNib() -> UIView {
        return UINib(nibName: "JRCBSingleLabelFooter", bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    func setText(text: String) {
        self.footerLabel.text = text
    }
}
