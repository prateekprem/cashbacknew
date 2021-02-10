//
//  SFSmartIconGroupGridTableCell.swift
//  Jarvis
//
//  Created by Prakash Jha on 20/10/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class SFSmartIconGroupGridTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var headerViewHeight: NSLayoutConstraint!
    @IBOutlet weak var collectionViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showMoreViewHeight: NSLayoutConstraint!
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var showMoreButtonView: UIView!
    @IBOutlet weak var showMoreLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    var defaultCollectionCellHeight:Double = 120.0
    
    override public class func register(table: UITableView) {
        if let mNib = SFSmartIconGroupGridTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconGroupGridTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconGroupGridTableCell" }
    override var collectCellId: String { return "kSFSmartIconGroupGridCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIconGroupGridTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconGroupGridCollCell") }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        showMoreButtonView.layer.borderWidth = 1
        showMoreButtonView.layer.borderColor = UIColor(hex: "E8EDF3").cgColor
        showMoreButtonView.layer.cornerRadius = 15
    }
    
    public override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
         shouldShowShowMore()
        if layout?.vTitle != "" {
            headerViewHeight.constant = 40
        } else {
            headerViewHeight.constant = 8
        }
        collectionViewHeight.constant = CGFloat(defaultCollectionCellHeight * ceil((Double(mList.count) / 3.0)))
        contentView.layoutIfNeeded()
        collectV.reloadData()
    }
    
    private func shouldShowShowMore() {
         if let layout = layout, (layout.vItems.count % 3) == 0,  (layout.vSeoUrl.isValidString() || layout.vSubTitle.isValidString())  { 
             showMoreButtonView.isHidden = false
             showMoreViewHeight.constant = 54
             var showMoreText = "jr_home_show_More".localized
            if let btnText = layout.viewAllLabel, btnText.isValidString() {
                showMoreText = btnText
            }
            showMoreLabel.text = showMoreText
         } else {
             //hide show more(center) button
             showMoreButtonView.isHidden = true
             showMoreViewHeight.constant = 0
         }
     }
    
    @IBAction func showMoreButtonTap(_ sender: Any) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        let url = mLayout.vSeoUrl.isValidString() ? mLayout.vSeoUrl : mLayout.vSubTitle
         delegate.sfHandleFooterShowMoreClick(url, type: mLayout.layoutVType, showMoreText: showMoreLabel.text ?? "jr_home_show_More".localized)
    }
    
    override public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectCellId.count > 0, let mLayout = self.layout {
            var margin = CGFloat(10)
            if mLayout.cellPresentInfo.collectColomnCount == 1 { margin = 0 }
            if mLayout.layoutVType == .smartIconCarousel { margin = 8 }
            
            var clmCnt = mLayout.cellPresentInfo.collectColomnCount
            
            if mLayout.layoutVType == .smartIconButton {
                clmCnt = min(clmCnt, CGFloat(mLayout.vItems.count))
            }
            let ww = (collectionView.frame.width)/clmCnt
            return CGSize(width: ww-margin, height: CGFloat(defaultCollectionCellHeight))
        }
        return CGSize(width: 0, height: 0)
    }
}
