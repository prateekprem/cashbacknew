//
//  FSBrandTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSBrandTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var titleLabel: UILabel!
    private var firstItem: SFLayoutItem?
    override class func register(table: UITableView) {
        if let mNib = FSBrandTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSBrandTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSBrandTableCell" }
    override var collectCellId: String { return "FSBrandCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "FSBrandTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "FSBrandCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 100, height: 145)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        titleLabel.text = layout?.vTitle
        firstItem = layout?.vItems.first
    }
    
    private func viewAllClicked() {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
    
    @IBAction func viewAllButtonClicked(_ sender: Any) {
        viewAllClicked()
    }
    @IBAction func viewAllIconClicked(_ sender: Any) {
        viewAllClicked()
    }
}
