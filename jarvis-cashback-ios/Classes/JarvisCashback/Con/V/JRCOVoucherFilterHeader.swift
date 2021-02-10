//
//  JRCOVoucherFilterHeader.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 05/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRCOVoucherFilterHeader: UITableViewHeaderFooterView {
    @IBOutlet weak private var sectionTitle: UILabel!
    
    func set(title: String) {
        sectionTitle.text = title
    }
}

