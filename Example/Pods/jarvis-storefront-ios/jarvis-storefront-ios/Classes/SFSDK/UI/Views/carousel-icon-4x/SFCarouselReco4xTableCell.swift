//
//  SFRecoTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 28/01/20.
//

import UIKit

class SFCarouselReco4xTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var carouselRecoView: SFCarouselReco4xView!
    
    var screenWidth = UIScreen.main.bounds.width
    private var recoInfo: (SFLayoutViewInfo?, IndexPath)?
    
    override public class func register(table: UITableView) {
        if let mNib = SFCarouselReco4xTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselReco4xTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarouselReco4xTableCell" }
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFCarouselReco4xTableCell") }
    private var tableIndex = IndexPath()
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        recoInfo = (info, indexPath)
        if let cancelledRecoItems = SFUtilsManager.getCancelledRecoItems(), cancelledRecoItems.count > 0 {
            let cancelledRecos: Set<String> = Set(cancelledRecoItems)
            info.vItems = info.vItems.filter { (item) -> Bool in
                let hashKey: String = SFUtilsManager.cancelledRecoHashKey(itemId: item.itemId, title: item.itemTitle , ctaLabel: item.ctaLabel ?? "")
                return !cancelledRecos.contains(hashKey)
            }
        }
        super.show(info: info, indexPath: indexPath)
        addBorderSupport(info: info)
        if info.vItems.count == 0 {
            recoInfo = (nil, indexPath)
        }
        carouselRecoView.recoRemovedObserver = { [weak self] in
            guard let strongSelf = self, let recoInfo = self?.recoInfo, let info = recoInfo.0 else {
                return
            }
            strongSelf.show(info:  info, indexPath: recoInfo.1)
            if let delegate = self?.layout?.pDelegate,info.vItems.count == 0 {
                  delegate.sfRemoveRecoWidget(indexPath:indexPath)
            }
        }
        if let carouselInfo = recoInfo?.0 {
            
            carouselRecoView.show(info: carouselInfo, indexPath: indexPath)
        } 
    }
    
    private func addBorderSupport(info: SFLayoutViewInfo) {
        if let bgColor = info.metaLayoutInfo?.bgColor, !bgColor.isEmpty {
            contentView.backgroundColor = UIColor.colorWithHexString(bgColor)
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
}

