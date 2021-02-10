//
//  JRMCOLandingSectionHeader.swift
//  Jarvis
//
//  Created by Siddharth Suneel on 20/02/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRMCOLandingSectionHeader: UITableViewHeaderFooterView {    
    @IBOutlet weak var parentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    
    func updateTextAlignment(align: NSTextAlignment) {
        titleLabel.textAlignment = align
        setNeedsLayout()
    }
    
    func setHeaderTitle(titleText: String) {
        titleLabel.text = titleText.capitalized
        setNeedsLayout()
    }
}
