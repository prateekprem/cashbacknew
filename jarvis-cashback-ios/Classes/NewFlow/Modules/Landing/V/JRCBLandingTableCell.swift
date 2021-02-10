//
//  JRCBLandingTableCell.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 22/01/20.
//

import UIKit


protocol JRCBLandingTableCellDelegate {
    func cbLandingTableCellDidClick(row: Int, inCell: JRCBLandingTableCell)
}

class JRCBLandingTableCell: UITableViewCell {    
    @IBOutlet weak var collectV : UICollectionView!
    @IBOutlet weak var ttlLbl : UILabel!
        
    var layoutInfo = JRCBSFLayout()
    var delegate: JRCBLandingTableCellDelegate?
    class var cellId: String { return "kJRCBLandingTableCell" }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.collectV.isScrollEnabled = true
        self.registerNib()
    }
    
    func registerNib() {
        self.collectV.register(Bundle.nibWith(name: JRCBScratchWonCVC.identifier), forCellWithReuseIdentifier: JRCBScratchWonCVC.identifier)
        self.collectV.register(Bundle.nibWith(name: JRCBLandingViewAllCollCell.identifier), forCellWithReuseIdentifier: JRCBLandingViewAllCollCell.identifier)
    }
    
    func show(info: JRCBSFLayout) {
        self.layoutInfo = info
        self.ttlLbl.text = info.lTitle
        self.collectV.reloadData()
    }
}


// MARK :- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension JRCBLandingTableCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.layoutInfo.lItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cellId = JRCBScratchWonCVC.identifier
        guard self.layoutInfo.lItems.count > indexPath.row else {
              let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! JRCBScratchWonCVC
            cell.showShimmerLoading(isShow: true)
            return cell
        }
        
        let lItem = self.layoutInfo.lItems[indexPath.row]
        if lItem.rIsViewAll {
            if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: JRCBLandingViewAllCollCell.identifier, for: indexPath) as? JRCBLandingViewAllCollCell {
                cell.loadData(item: lItem)
                return cell
            }
            return JRCBLandingViewAllCollCell()
        }
        
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: self.layoutInfo.cellConfig.identifier, for: indexPath) as? JRCBLandingBaseCollCell {
            cell.loadData(item: lItem)
            return cell
        }
        
        return JRCBLandingBaseCollCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView,
                               layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.layoutInfo.cellConfig.contentSZ
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout,
                               insetForSectionAt section: Int) -> UIEdgeInsets {
        let margin = self.layoutInfo.cellConfig.collCellMargine
        return UIEdgeInsets (top: 0, left: margin, bottom: 0, right: margin)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return self.layoutInfo.cellConfig.collCellMargine
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.delegate?.cbLandingTableCellDidClick(row: indexPath.row, inCell: self)
    }
}


