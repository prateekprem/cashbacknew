//
//  FSStoresAroundTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSStoresAroundTableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak var titleLabel: UILabel!
    override class func register(table: UITableView) {
        if let mNib = FSStoresAroundTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSStoresAroundTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSStoresAroundTableCell" }
    override var collectCellId: String { return "FSStoresAroundCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "FSStoresAroundTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "FSStoresAroundCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.reloadData()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 68, height: 94)
    }
    
}
