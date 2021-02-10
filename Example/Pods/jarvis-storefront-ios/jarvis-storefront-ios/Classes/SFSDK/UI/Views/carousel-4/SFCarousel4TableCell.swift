//
//  SFCarousel4TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 12/10/19.
//

import UIKit

class SFCarousel4TableCell: SFBaseTableCellIncCollection {
    
    override class func register(table: UITableView) {
        if let mNib = SFCarousel4TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCarousel4TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarousel4TableCell" }
    override var collectCellId: String { return "kSFCarousel4CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCarousel4TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFCarousel4CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 66, height: collectionView.frame.size.height)
    }
}

