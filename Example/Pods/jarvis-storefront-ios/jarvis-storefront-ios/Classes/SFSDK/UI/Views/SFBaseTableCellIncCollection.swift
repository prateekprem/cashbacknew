//
//  SFBaseTableCellIncCollection.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 11/10/19.
//

import UIKit

public class SFBaseTableCellIncCollection: SFBaseTableCell {
    
    @IBOutlet weak var collectV             : UICollectionView!
    @IBOutlet weak private var layoutTtlLbl : UILabel!
    @IBOutlet weak private var layoutImgV   : UIImageView!
    @IBOutlet weak private var layoutPageC  : UIPageControl!
    
    @IBOutlet weak var layoutPageCHeeight: NSLayoutConstraint!
    public var shouldAutoScroll: Bool   = false
    private var isAutoScrollStart: Bool = false
    private var isSmartIconHeaderScrolled: Bool = true
    var isInfiniteScrollType: Bool = false
    
    private var cron: SFCron?
    private var isAutoScrolling: Bool = true
    private var tableIndexPath = IndexPath()
    var currentPage = 0 {
        didSet {
            if layoutPageC != nil {
                layoutPageC.currentPage = currentPage
                layout?.bannerIndex = currentPage
            }
        }
    }
    
    private var totalPage = 1 {
        didSet {
            if layoutPageC != nil {
                layoutPageC.numberOfPages = totalPage
            }
        }
    }
    
    internal var mList = [SFLayoutItem]()
    internal var collectCellId: String { return "" }
    
    func configureList() {
        guard let mLayout = self.layout else { return }
        
        switch mLayout.cellPresentInfo.itemLimit {
        case .custom(let count):
            var limit = count
            if mLayout.layoutVType == .smartIconGroupGrid || mLayout.layoutVType == .smartIconGrid4xn {
                let itemCountInARow: Int = Int(mLayout.cellPresentInfo.collectColomnCount)
                let isExpanded = mLayout.isExpanded
                if !mLayout.vSeoUrl.isValidString() && !isExpanded {
                    limit = (mLayout.numRowsShown != 0 && mLayout.numRowsShown * itemCountInARow < mLayout.vItems.count) ? ((mLayout.numRowsShown * itemCountInARow) - 1) : mLayout.vItems.count
                }else {
                    limit = mLayout.vItems.count
                }
            } else if mLayout.layoutVType == .smartIconButton2xn {
                if mLayout.vItems.count > 1 && mLayout.vItems.count % 2 != 0 {
                    limit = mLayout.vItems.count - 1
                } else {
                    limit = mLayout.vItems.count
                }
            }
            mList = mLayout.itemsWith(limit: limit, index: 0, addEmpty: false)
        default:
            mList = mLayout.vItems
        }
        
        guard let delegate = mLayout.pDelegate else { return }
        switch mLayout.layoutVType {
        case .itemInCart:
            mList = delegate.sfGetCartItems()
        case .itemInWishlist:
            mList = delegate.sfGetWishlistItems()
        case .recentlyViewed:
            mList = delegate.sfGetRecentlyViewedItems()
        case .activeOrder:
            mList = delegate.sfGetActiveOrderItems()
        default:
            break
        }
        
        let touple = delegate.sfPresenterAppendItemForLayout(type: mLayout.layoutVType)
        if let mItem = touple.item {
            switch mItem.itemType {
            case .header:
                mList.insert(mItem, at: 0)
            case .more:
                mList.append(mItem)
            case .showMore:
                let itemCount: Int = Int(mLayout.cellPresentInfo.collectColomnCount)
                var showMoreText = "Show More"
                if let btnText = mLayout.viewAllLabel, btnText.isValidString() {
                    showMoreText = btnText
                }
                var title = showMoreText
                var imageUrl = mLayout.viewAllImage
                let seoUrl = mLayout.vSeoUrl.isValidString() ? mLayout.vSeoUrl : ""
                let subTitle = mLayout.vSubTitle.isValidString() ? mLayout.vSubTitle : ""
                if  (mLayout.vSeoUrl.isValidString()) { //Deeplink present case
                    if (mLayout.vItems.count % itemCount != 0) {//dont show item level show more if items is in multiple of 3
                        let showMoreItem = SFLayoutItem.customItemWith(type: .showMore, title: title, localImg: "", imageUrl: imageUrl, seoUrl: seoUrl, subTitle: subTitle, itemIndex: mList.count + 1)
                        mList.append(showMoreItem)
                    }
                } else if mLayout.layoutVType == .smartIconGroupGrid || mLayout.layoutVType == .smartIconGrid4xn { //No deeplink present case
                    let itemCountInARow: Int = Int(mLayout.cellPresentInfo.collectColomnCount)
                    if mLayout.numRowsShown != 0 && mLayout.numRowsShown * itemCountInARow < mLayout.vItems.count {
                        if mLayout.isExpanded {
                            title = mLayout.viewLessLabel ?? "Show Less"
                            imageUrl = mLayout.viewLessImage
                        }
                        let showMoreItem = SFLayoutItem.customItemWith(type: .showMore, title: title, localImg: "", imageUrl: imageUrl, seoUrl: seoUrl, subTitle: subTitle, itemIndex: mList.count + 1)
                        mList.append(showMoreItem)
                    }
                }
            default: return
            }
        }
        if let mLayout = self.layout, mLayout.vItems.count <= 1 {
            shouldAutoScroll = false
        }
        if shouldAutoScroll && isAutoScrollStart == false{
            isAutoScrollStart = true
            setTimer()
        }
    }
    
    func setSelectedLayoutColor(selectPageColor: UIColor?, pageColor: UIColor?, scale:CGFloat = 1.0) {
        layoutPageC.currentPageIndicatorTintColor = selectPageColor ?? #colorLiteral(red: 0, green: 0.6745098039, blue: 0.9294117647, alpha: 1)
        layoutPageC.pageIndicatorTintColor = pageColor ?? #colorLiteral(red: 0.501960814, green: 0.501960814, blue: 0.501960814, alpha: 1)
        layoutPageC.transform = CGAffineTransform(scaleX: scale, y: scale)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        self.tableIndexPath = indexPath
        if layoutTtlLbl != nil {
            layoutTtlLbl.text = info.vTitle
        }
        
        self.configureList()
        let pInfo = info.cellPresentInfo
        let pageCapicity = Int(pInfo.collectColomnCount) * pInfo.collectionRowCount
        if pageCapicity > 0 {
            self.totalPage = Int((CGFloat(mList.count) / CGFloat(pageCapicity)).rounded(.up))
        }
        if(self.totalPage == 1 && layoutPageCHeeight != nil && self.layout?.layoutVType == .thinSmall) {
            layoutPageCHeeight.constant = 0
        }
        if let mURL = URL(string: info.vImageUrl), layoutImgV != nil {
            makeRounded(view: layoutImgV, roundV: pInfo.tableCellBgImageRoundBy)
            self.layoutImgV.setImageFrom(url: mURL, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        self.collectV.reloadData()
        if shouldAutoScroll {
            if isInfiniteScrollType {
                cron?.resumeWithTimeReset()
            }
            else {
                cron?.resume()
            }
        }
    }
    
    //    override public func suspendTimer() {
    //        //cron?.suspend()
    //    }
    
    override public func pauseResumeAutoScroll(isResume: Bool) {
        if !shouldAutoScroll {
            return
        }
        if isResume {
            cron?.resume()
        } else {
            cron?.suspend()
        }
    }
}


// MARK :- UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout
extension SFBaseTableCellIncCollection: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return mList.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as! SFBaseCollCell
        if let mLayout = self.layout, collectCellId.count > 0 {
            cell.show(item: mList[indexPath.row], cellConfig: mLayout.cellPresentInfo)
        }
        return cell
    }
    
    public func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let _ = self.layout, collectCellId.count > 0 {
            logImpressionForItem(item: mList[indexPath.row])
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectCellId.count > 0, let mLayout = self.layout {
            var margin = CGFloat(10)
            if mLayout.cellPresentInfo.collectColomnCount == 1 { margin = 0 }
            if mLayout.layoutVType == .smartIconCarousel { margin = 8 }
            
            var clmCnt = mLayout.cellPresentInfo.collectColomnCount
            
            if mLayout.layoutVType == .smartIconButton {
                clmCnt = min(clmCnt, CGFloat(mLayout.vItems.count))
            }
            if mLayout.layoutVType == .smartIconHeaderV2 {
                clmCnt = min(CGFloat(mList.count),clmCnt)
            }
            let hh = collectionView.frame.height/CGFloat(mLayout.cellPresentInfo.collectionRowCount)
            let ww = (collectionView.frame.width)/clmCnt
            
            return CGSize(width: ww-margin, height: hh-5)
        }
        return CGSize(width: 0, height: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if let mLayout = self.layout {
            switch mLayout.layoutVType {
            case .c4Large, .carouselBs1, .carousel1, .carousel4:
                return UIEdgeInsets (top: 0, left: 15, bottom: 0, right: 15)
            case .rowBs1, .recentlyViewed, .itemInCart, .itemInWishlist, .carouselBs2:
                return UIEdgeInsets (top: 0, left: 12, bottom: 0, right: 12)
            case .lCBOffers:
                let margin = mLayout.cellPresentInfo.collectLineSpace
                return UIEdgeInsets (top: 0, left: margin, bottom: 0, right: margin)
            default: break
            }
        }
        
        return UIEdgeInsets (top: 0, left: 0, bottom: 0, right: 0)
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if let mLayout = self.layout {
            return mLayout.cellPresentInfo.collectLineSpace
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if let mLayout = self.layout {
            return mLayout.cellPresentInfo.collectInterimSpace
        }
        return 0
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        let item: SFLayoutItem = mList[indexPath.row]
        if item.itemType == .showMore {
            if !mLayout.vSeoUrl.isValidString() {
                mLayout.isExpanded = !mLayout.isExpanded
                delegate.sfDidClickExpand(layout: mLayout, indexPath: tableIndexPath) //pass table indexpath to expand collapse cell
                return
            }
        }
        delegate.sfSDKDidClick(item: item, viewInfo: mLayout, tableIndex: self.index, collectIndex: indexPath.row)
        if !item.iconIds.isEmpty {
            handleSmartIconGroupGridClick(item: mList[indexPath.row])
        }
    }
    
    public func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if  self.layoutPageC != nil {
            let pageWidth = scrollView.frame.width
            let page = Int(floor((scrollView.contentOffset.x + 75 - pageWidth / 2) / pageWidth) + 1)
            if page <= totalPage, page >= 0 {
                self.currentPage = isInfiniteScrollType ? (page - 1) : page
            } else if (page > totalPage) {
                 self.currentPage = 0
            }
        }
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        isSmartIconHeaderScrolled = true
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
         isSmartIconHeaderScrolled = false
        if shouldAutoScroll && !self.isAutoScrolling {
            self.isAutoScrolling = true
            let offset = scrollView.contentOffset.x
            let width = scrollView.frame.size.width
            let page = Int(offset/width)
            if page >= 0 && page < totalPage{
                self.currentPage = isInfiniteScrollType ? (page - 1) : page
            }
        }
    }
    
    private func setTimer() {
        var timeInterval = 6.0
        if let tInterval = self.layout?.dwellTime {
            timeInterval = tInterval
        }
        cron?.suspend()
        if cron == nil {
            cron = SFCron(timeInterval: timeInterval, handler: { [weak self] in
                self?.autoScroll()
            })
        }
        cron?.resume()
    }
    
    private func autoScroll() {
        if (shouldAutoScroll && self.layout?.vItems.count ?? 0 > 1) {
            self.currentPage = self.currentPage + 1
            let fakeCount = isInfiniteScrollType ? 1 : 0
            self.didScrollTo(self.currentPage + fakeCount)
        }
    }
    
    func didScrollTo(_ page: Int, animated: Bool = true) {
        if mList.count <= 1 {
            return
        }
        let fakeCount = isInfiniteScrollType ? 1 : 0
        if page <= totalPage + fakeCount {
            let indexPath = IndexPath(item: page, section: 0)
            self.collectV.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: animated)
            if(page == totalPage + fakeCount) {
                self.currentPage = 0
                if let dwelllTime = self.layout?.dwellTime {
                    DispatchQueue.main.asyncAfter(deadline: .now() + (dwelllTime / 2) ) {
                        self.collectV.scrollToItem(at: IndexPath(item: fakeCount, section: 0), at: .centeredHorizontally, animated: false)
                    }
                }
            }
        }
    }
}


extension SFBaseTableCellIncCollection {
    private func handleSmartIconGroupGridClick(item: SFLayoutItem) {
        if let _ = self.layout {
            if item.itemUrlType == "paytmmore" || item.itemUrl == "paytmmp://paytmmore" || item.itemsubName == "paytmmp://paytmmore" {
                return
            }
            if item.iconIds.count == 0 {
                self.layout?.pDelegate?.sfHandleClickForItem(item)
                return
            }
            let parsedInfo: [SFLayoutViewInfo] = parsedInformation(item)
            if parsedInfo.count == 0 {
                self.layout?.pDelegate?.sfHandleClickForItem(item)
            } else {
                self.layout?.pDelegate?.sfShowCategoryPopup(parsedInfo,item,self.layout)
            }
        }
    }
    
    func parsedInformation(_ items: SFLayoutItem) -> ([SFLayoutViewInfo]) {
        let layouts: [SFLayoutViewInfo] = self.categoryDatasource?.sfSDKGetLayoutData() ?? []
        var viewItems: [SFLayoutViewInfo] = []
        for id in items.iconIds {
            let output = layouts.filter { (layout) -> Bool in
                return layout.vId == id
            }
            viewItems.append(contentsOf: output)
        }
        if let layoutType = self.layout?.layoutVType {
            for item in viewItems {
                item.updateLayoutViewType(layout: layoutType)
            }
        }
        return viewItems
    }
    
}
