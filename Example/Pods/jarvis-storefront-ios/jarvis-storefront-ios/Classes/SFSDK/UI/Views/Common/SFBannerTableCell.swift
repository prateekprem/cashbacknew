//
//  SFBannerTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Pankaj Singh on 09/11/20.
//

import UIKit

enum H1Bannerclass: String {
    case home = "home"
    case fullwidthimage = "full-width-image"
    case none
}

class SFBannerTableCell: SFBaseInfiniteCollCell {
    
    private var needToHidePadding: Bool = false
    private var classType: String = ""
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewTopConstraint: NSLayoutConstraint!
    @IBOutlet private weak var collectionViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var pageViewBottom: NSLayoutConstraint!
    
    override class func register(table: UITableView) {
        if let mNib = SFBannerTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFBannerTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFBannerTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFBannerTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.isAccessibilityElement = false
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "kSFImageCollCell", for: indexPath) as! SFImageCollCell
        if let mLayout = self.layout {
            cell.needToHidePadding = needToHidePadding
            cell.classType = self.classType
            cell.show(item: mList[indexPath.row], cellConfig: mLayout.cellPresentInfo)
        }
        return cell
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        shouldAutoScroll = info.autoScroll
        super.show(info: info, indexPath: indexPath)
        self.currentPage = info.bannerIndex
        if let classType = info.classType, classType.lowercased() == H1Bannerclass.fullwidthimage.rawValue {
            needToHidePadding = true
        } else {
            needToHidePadding = false
        }
        if let classType = info.classType?.lowercased() {
            self.classType = classType
        } else {
            self.classType = ""
        }
        addBorderSupport(info: info)
        setLayoutColor(info: info)
        setupLayout(info: info)
        modifyDatasourceForCircularScroll()
        configureCollectionView(info: info)
    }
    
    private func setupLayout(info: SFLayoutViewInfo) {
        collectionViewTopConstraint.constant = info.cellPresentInfo.margin.top
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = info.cellPresentInfo.backColor
        }
    }
    
    private func setLayoutColor(info: SFLayoutViewInfo) {
        if (info.layoutVType == .thinSmall || info.layoutVType == .thinBanner) && classType != H1Bannerclass.home.rawValue {
            let selectPageColor = UIColor.colorRGB(139, g:166, b:193, a:1.0)
            let pageColor = UIColor.colorRGB(222, g:228, b:236, a:1.0)
            setSelectedLayoutColor(selectPageColor: selectPageColor, pageColor: pageColor, scale: 1.0)
            pageViewBottom.constant = 20.0
            if layoutPageCHeeight.constant == 0.0 {
                collectionViewBottomConstraint.constant = info.cellPresentInfo.margin.bottom
            } else {
                collectionViewBottomConstraint.constant = 28.0
            }
        }
        else if (info.layoutVType == .h1Banner || info.layoutVType == .h1FullBanner) && classType != H1Bannerclass.home.rawValue && classType != H1Bannerclass.fullwidthimage.rawValue {
            let selectPageColor = UIColor.colorRGB(139, g:166, b:193, a:1.0)
            let pageColor = UIColor.colorRGB(222, g:228, b:236, a:1.0)
            setSelectedLayoutColor(selectPageColor: selectPageColor, pageColor: pageColor, scale: 1.0)
            pageViewBottom.constant = 0.0
            collectionViewBottomConstraint.constant = info.cellPresentInfo.margin.bottom
        }
        else {
            let selectPageColor = UIColor.colorRGB(0, g:172, b:237, a:1.0)
            let pageColor = UIColor.colorRGB(29, g:37, b:45, a:0.2)
            setSelectedLayoutColor(selectPageColor: selectPageColor, pageColor: pageColor, scale: 0.65)
            pageViewBottom.constant = 0.0
            collectionViewBottomConstraint.constant = info.cellPresentInfo.margin.bottom
        }
    }
    
    private func configureCollectionView(info: SFLayoutViewInfo) {
        var defaultWidth: CGFloat = UIScreen.main.bounds.size.width
        if let width = self.layout?.pDelegate?.sfGetTableViewWidth() {
            defaultWidth = width
        }
        if needToHidePadding {
            collectionViewHeightConstraint.constant = defaultWidth * info.cellPresentInfo.bannerScaleFactor
            if self.containerType() == .consumerApp && info.cellPresentInfo.hideBottomMarginInCaseOfConsumerApp {
                collectionViewBottomConstraint.constant = 0.0
            }
        }
        else {
            collectionViewHeightConstraint.constant = (defaultWidth - info.cellPresentInfo.collectCellMargin.left - info.cellPresentInfo.collectCellMargin.right) * info.cellPresentInfo.bannerScaleFactor
        }
        self.layoutIfNeeded()
        collectV.reloadData()
        setupForInfiniteScrolling()
    }
}
