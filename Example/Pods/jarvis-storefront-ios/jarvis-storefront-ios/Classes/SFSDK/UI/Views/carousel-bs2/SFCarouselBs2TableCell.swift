//
//  SFCarouselBs2TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 15/10/19.
//

import UIKit

class SFCarouselBs2TableCell: SFBaseTableCellIncCollection {
    override class func register(table: UITableView) {
        if let mNib = SFCarouselBs2TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselBs2TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarouselBs2TableCell" }
    override var collectCellId: String { return "kSFCarouselBs2CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCarouselBs2TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFCarouselBs2CollCell") }
    
    private var emptyNib: UINib? { return Bundle.nibWith(name: "SFEmptyCollCell") }
    private var emptyCollCellId: String { return "kSFEmptyCollCell" }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.register(emptyNib, forCellWithReuseIdentifier: emptyCollCellId)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 { // Empty cell and view all cell
            return 1
        }
        
        return super.collectionView(collectionView, numberOfItemsInSection: section)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.section == 0 {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: emptyCollCellId, for: indexPath) as? SFEmptyCollCell {
                cell.backgroundColor = UIColor.clear
                return cell
            }
        }
        
        return super.collectionView(collectionView, cellForItemAt: indexPath)
    }
    
    override func collectionView(_ collectionView : UICollectionView,layout collectionViewLayout:UICollectionViewLayout,sizeForItemAt indexPath:IndexPath) -> CGSize
    {
        if indexPath.section == 0 {
            return CGSize(width: SFConstants.windowWidth/3 , height: collectionView.frame.size.height)
        }
        
        return CGSize(width: 120 , height: collectionView.frame.size.height)
    }
}
