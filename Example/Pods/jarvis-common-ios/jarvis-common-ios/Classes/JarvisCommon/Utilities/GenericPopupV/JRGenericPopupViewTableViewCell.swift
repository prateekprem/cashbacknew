//
//  JRGenericPopupViewTableViewCell.swift
//  jarvis-common-ios
//
//  Created by Shivam Jaiswal on 18/12/20.
//

import UIKit

class JRGenericPopupViewTableViewCell: UITableViewCell {
    var isCellSelected: Bool = false {
        didSet {
            tickImageView.image = self.isCellSelected ? UIImage(named: "gender_radio_button_selected") : UIImage(named: "gender_radio_button")
        }
    }
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var tickImageView: UIImageView!
}
