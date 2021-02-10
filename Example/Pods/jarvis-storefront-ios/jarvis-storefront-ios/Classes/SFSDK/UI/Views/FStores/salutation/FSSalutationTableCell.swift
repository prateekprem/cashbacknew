//
//  FSSalutationTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSSalutationTableCell: SFBaseTableCell {
    
    @IBOutlet weak var greetingLabel: UILabel!
    private var firstItem: SFLayoutItem?
    override class func register(table: UITableView) {
        if let mNib = FSSalutationTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSSalutationTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSSalutationTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "FSSalutationTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        firstItem = layout?.vItems.first
        if let firstItem = firstItem, let greetingMsg = firstItem.greetingMsg{
            greetingLabel.text = greetingMsg
        }
    }
}
