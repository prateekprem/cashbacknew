//
//  JRPPTransactionHeader.swift
//  Jarvis
//
//  Created by Pankaj Singh on 27/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class JRPCTransactionHeader: UIView {

    
    @IBOutlet weak var coinBalance: UILabel!
    @IBOutlet weak var loaderBtn: UIButton!
    var redeemCoinsClicked: (() -> Void)?

    @IBAction func redeeemCoinsClicked(_ sender: UIButton) {
        redeemCoinsClicked?()
    }
    
}
