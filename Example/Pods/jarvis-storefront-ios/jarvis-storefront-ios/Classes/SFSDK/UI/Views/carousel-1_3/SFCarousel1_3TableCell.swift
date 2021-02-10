//
//  SFCarousel1_3TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Pankaj Singh on 31/08/20.
//

import UIKit

class SFCarousel1_3TableCell: SFBaseInfiniteCollCell {
    
    @IBOutlet weak private var collectionViewHeight: NSLayoutConstraint!
    
    private var screenWidth = UIScreen.main.bounds.width
    var pageNumber:Int = 0
    
    override class func register(table: UITableView) {
        if let mNib = SFCarousel1_3TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCarousel1_3TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarousel1_3TableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCarousel1_3TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.decelerationRate = UIScrollView.DecelerationRate.fast
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        shouldAutoScroll = info.autoScroll
        super.show(info: info, indexPath: indexPath)
        addBorderSupport(info: info)
        modifyDatasourceForCircularScroll()
        configureCollectionView()
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth: CGFloat = UIScreen.main.bounds.size.width - 30.0
        return CGSize(width: itemWidth, height: itemWidth/3)
    }
    
     override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let mLayout = self.layout {
            return mLayout.cellPresentInfo.collectLineSpace
        }
        return 0
    }
    
    private func configureCollectionView() {
        collectionViewHeight.constant = (UIScreen.main.bounds.size.width - 30.0)/3
        collectV.contentInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15);
        self.layoutIfNeeded()
        collectV.reloadData()
        setupForInfiniteScrolling()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let pageWidth:CGFloat = UIScreen.main.bounds.size.width - 30.0
        let kCellSpacing : CGFloat = 5.0
        let currentOffset:CGFloat = collectV.contentOffset.x
        let cellFrontSpace:CGFloat = (screenWidth - pageWidth)/2
        var newTargetOffset: CGFloat = 0.0
        pageNumber = Int(ceil(currentOffset/pageWidth))
        if velocity.x > 0 {
            let pageNumber = ceil(currentOffset/pageWidth)
            newTargetOffset = ((pageWidth + kCellSpacing) * pageNumber) - cellFrontSpace
        } else if velocity.x < 0 {
            let pageNumber = floor(currentOffset/pageWidth)
            newTargetOffset = ((pageWidth + kCellSpacing) * pageNumber) - cellFrontSpace
        } else if (velocity.x == 0) {
            let pageNumber = round(currentOffset/pageWidth)
            newTargetOffset = ((pageWidth + kCellSpacing) * pageNumber) - cellFrontSpace
        }
        targetContentOffset.pointee.x = newTargetOffset
    }
    
    override func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let pageWidth = UIScreen.main.bounds.width - 30
        let kCellSpacing : CGFloat = 5.0
        let cellFrontSpace:CGFloat = (screenWidth - pageWidth)/2
        let page = pageNumber
        let numberOfCells = mList.count
        if mList.count > 1 { //case for circular infinte scroll
            _ = (pageWidth) * CGFloat(mList.count - 2)
            if page >=  mList.count - 1 {
                scrollView.contentOffset.x =  (pageWidth + kCellSpacing) * 1.0 - cellFrontSpace
            } else if page <=  1 {
                scrollView.contentOffset.x =  (pageWidth + kCellSpacing) * CGFloat(mList.count - 2) - cellFrontSpace
            }
        }
        
        if page == 0 { // we are within the fake last, so delegate real last
            self.currentPage = numberOfCells - 1
        } else if page == numberOfCells - 1 { // we are within the fake first, so delegate the real first
            self.currentPage = 0
        } else { // real page is always fake minus one
            self.currentPage = page - 1
        }
    }
    
    override func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
    }
}
