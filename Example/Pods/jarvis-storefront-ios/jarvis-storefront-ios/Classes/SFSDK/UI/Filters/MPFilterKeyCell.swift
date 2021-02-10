//
//  MPFilterKeyCell.swift
//  marketplace-ios
//
//  Created by Shikha Sharma on 23/07/19.
//

import UIKit

class MPFilterKeyCell: UITableViewCell {
    
    @IBOutlet weak private var blueSelectionView: UILabel!
    @IBOutlet weak private var filterSelectedView: UIImageView!
    @IBOutlet weak private var filterKey: UILabel!
    
    func setCellSelectionState(selected:Bool){
        if selected {
            contentView.backgroundColor = UIColor.white
            filterKey.textColor = UIColor.getColorFromHexValue(0x1d252d, Alpha: 1.0)
            filterKey.font = UIFont.boldSystemFont(ofSize: 12.0)
            blueSelectionView.isHidden = false
            
        }else {
            contentView.backgroundColor = UIColor.clear
            filterKey.textColor = UIColor.getColorFromHexValue(0x506d85, Alpha: 1.0)
            filterKey.font = UIFont.systemMediumFontOfSize(12.0)
            blueSelectionView.isHidden = true
        }
    }
    
    func configureKey(filter: SFFilter){
        filterKey.text = filter.title
        if (filter.filterType == .linearRectangular) || (filter.filterType == .rangeSlider) {
            filterSelectedView.isHidden = (filter.selectedFilteredValues.count == 0)
        }else {
            if let appliedNode = filter.appliedCategoryTreeNode, appliedNode.count > 0 {
                 filterSelectedView.isHidden = false
            }else {
                 filterSelectedView.isHidden = true
            }
        }
    }
    
    override func prepareForReuse(){
        super.prepareForReuse()
        filterSelectedView.isHidden = true
        filterKey.text = ""
        filterKey.textColor = UIColor.darkGray
        filterKey.font = UIFont.systemFont(ofSize: 14)
    }
}
