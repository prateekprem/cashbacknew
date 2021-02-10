//
//  SFTree1HeaderTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 18/11/19.
//

import UIKit

class SFTree1HeaderTableCell: SFBaseTableCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var arrowImage: UIImageView!
    
    override class func register(table: UITableView) {
        if let mNib = SFTree1HeaderTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTree1HeaderTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTree1HeaderTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTree1HeaderTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        self.backgroundColor = UIColor(hex: "F5F8FA")
        titleLabel.text = info.vName
        if info.isExpanded {
            arrowImage.image = UIImage.imageNamed(name: "up_arrow")
        }
        else {
            arrowImage.image = UIImage.imageNamed(name: "down_arrow")
        }
        let item = info.vItems[rowIndex]
        logImpressionForItem(item: item)
        
    }
}
