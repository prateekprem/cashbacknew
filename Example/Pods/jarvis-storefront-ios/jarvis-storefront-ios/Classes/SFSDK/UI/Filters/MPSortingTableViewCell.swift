//
//  MPSortingTableViewCell.swift
//  marketplace-ios
//
//  Created by Avinash Kumar on 07/08/19.
//

import UIKit

class MPSortingTableViewCell: UITableViewCell {
    @IBOutlet weak private var label: UILabel!
   
    func configureCell(value: SFSortingValue){
        if let name = value.name {
            label.text = name
        }
        if value.isSelected {
            label.font = UIFont.systemSemiBoldFontOfSize(15.0)
            label.textColor = UIColor.paytmBlueColor()
        }else {
            label.font = UIFont.systemFont(ofSize: 15.0)
            label.textColor = UIColor(hex: "1D252D")
        }
    }
}
