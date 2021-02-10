//
//  SFCarouselRecoV2TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 26/11/20.
//

import UIKit

public class SFCarouselRecoV2TableCell: SFBaseTableCell {
    @IBOutlet weak private var carouselRecoView: SFCarouselReco4xView!
    @IBOutlet weak var showMoreView: UIView!
    @IBOutlet weak var showMoreButtonView: UIView!
    @IBOutlet weak var carouselRecoViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var showMoreLabel: UILabel!
    @IBOutlet weak var arrowIcon: UIImageView!
    
    let recoCellHeight:CGFloat = 90
    let collapsedRecoItemLimit:Int = 2
    let showMoreViewHeight:CGFloat = 54
    public var headerRecoRemovedObserver: (() -> Void)?
    
    override public class func register(table: UITableView) {
        if let mNib = SFCarouselRecoV2TableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselRecoV2TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarouselRecoV2TableCell" }
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFCarouselRecoV2TableCell") }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        showMoreButtonView.layer.borderWidth = 1
        showMoreButtonView.layer.borderColor = UIColor(hex: "E8EDF3").cgColor
        showMoreButtonView.layer.cornerRadius = 15
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        showRecoView(info: info, indexPath: indexPath)
    }
    
    func showRecoView(info: SFLayoutViewInfo?, indexPath: IndexPath) {
        carouselRecoView.isExpanded = true
        if let cancelledRecoItems = SFUtilsManager.getCancelledRecoItems(), let items = info?.vItems, cancelledRecoItems.count > 0 {
            let cancelledRecos: Set<String> = Set(cancelledRecoItems)
            info?.vItems = items.filter { (item) -> Bool in
                let hashKey: String = SFUtilsManager.cancelledRecoHashKey(itemId: item.itemId, title: item.itemTitle , ctaLabel: item.ctaLabel ?? "")
                return !cancelledRecos.contains(hashKey)
            }
        }
        carouselRecoView.recoRemovedObserver = { [weak self] in
            guard let strongSelf = self,let mLayout = strongSelf.layout, let delegate = mLayout.pDelegate, let indexPath = strongSelf.indexPath else {
                return
            }
            delegate.sfDidClickExpand(layout: mLayout, indexPath: indexPath)
            if info?.vItems.count == 0 {
                delegate.sfRemoveRecoWidget(indexPath:indexPath)
            }
            if let smarHeaderV2RemoveObserver = self?.headerRecoRemovedObserver {
                smarHeaderV2RemoveObserver()
            }
        }
        if let info = info,let mLayout = self.layout  {
            if info.vItems.count <= collapsedRecoItemLimit {
                showMoreHeightConstraint.constant = 0
                showMoreView.alpha = 0
            } else {
                showMoreHeightConstraint.constant = showMoreViewHeight
                showMoreView.alpha = 1
            }
            if mLayout.isExpanded {
                  carouselRecoViewHeightConstraint.constant = (recoCellHeight + 10) * CGFloat(info.vItems.count)
                showMoreLabel.text =  "jr_reco_show_less".localized
                } else {
                carouselRecoViewHeightConstraint.constant = (recoCellHeight + 10) * CGFloat(min(2,info.vItems.count))
                   showMoreLabel.text =  "jr_reco_show_more".localized
                }
             carouselRecoView.show(info: info, indexPath: indexPath)
        }
    }
    
    @IBAction func showMoreButtonTap(_ sender: Any) {
        if let mLayout = self.layout, let delegate = mLayout.pDelegate, let index = indexPath {
            mLayout.isExpanded = !mLayout.isExpanded
            arrowIcon.transform = arrowIcon.transform.rotated(by: CGFloat(Double.pi));
            if mLayout.isExpanded {
                carouselRecoView.isExpanded = false
                carouselRecoView.expandRecoCells() //Fix for CAI-34131
            }
            delegate.sfDidClickExpand(layout: mLayout, indexPath: index)
        }
    }
}
