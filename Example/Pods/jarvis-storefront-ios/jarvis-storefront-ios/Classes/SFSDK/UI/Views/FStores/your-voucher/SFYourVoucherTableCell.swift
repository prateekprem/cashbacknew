//
//  SFYourVoucherTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class SFYourVoucherTableCell: SFBaseTableCellIncCollection {
   
    @IBOutlet weak var descpLable: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var backGroundView: UIView!
    private var firstItem: SFLayoutItem?
    override class func register(table: UITableView) {
        if let mNib = SFYourVoucherTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFYourVoucherTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "SFYourVoucherTableCell" }
    override var collectCellId: String { return "SFYourVoucherCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFYourVoucherTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFYourVoucherCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        // backGroundView.drawGradient(colors: [UIColor(red: 0, green: 0, blue: 0, alpha: 1.0).cgColor, UIColor(red: 0, green: 0.094, blue: 0.37, alpha: 1.0).cgColor], direction: .topToBottom)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 344, height: 204)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets (top: 0, left: 20, bottom: 0, right: 20)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let visibleRect = CGRect(origin: collectV.contentOffset, size: collectV.bounds.size)
        let visiblePoint = CGPoint(x: visibleRect.midX, y: visibleRect.midY)
        if let visibleIndexPath = collectV.indexPathForItem(at: visiblePoint) {
            self.pageControl.currentPage = visibleIndexPath.row
        }
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
       
        firstItem = layout?.vItems.first
         title.text = layout?.vTitle
        pageControl.numberOfPages = info.vItems.count
    }
    
}

