//
//  SFSmartIconHeaderV2TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 27/08/20.
//

import UIKit
import jarvis_utility_ios

class SFSmartIconHeaderV2TableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak private var containerView: UIView!
    @IBOutlet weak private var bgImageView: UIImageView!
    @IBOutlet weak private var logoImageView: UIImageView!
    @IBOutlet weak private var bannerImageView: UIImageView!
    @IBOutlet weak private var bottomRoundedView: UIView!
    @IBOutlet weak private var carouselRecoView: SFCarouselReco4xView!
    @IBOutlet weak private var labelContainerView: UIView!
    @IBOutlet weak private var subtitleLabel: UILabel!
    @IBOutlet weak var imageHeightConstrain: NSLayoutConstraint!
    let bannerImageAspectRatio: CGFloat = 1.75
    
    private var firstViewItem: SFLayoutItem?
    private var gradintsArray: [CGColor] = [CGColor]()
    
    private var recoInfo: (SFLayoutViewInfo?, IndexPath)?
    
    override public class func register(table: UITableView) {
        if let mNib = SFSmartIconHeaderV2TableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconHeaderV2TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconHeaderV2TableCell" }
    override var collectCellId: String { return "kSFSmartIconHeaderV2CollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIconHeaderV2TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconHeaderV2CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        configureViews()
        carouselRecoView.isHidden = true
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        if !gradintsArray.isEmpty {
            containerView.drawGradientByRemovingOld(colors: gradintsArray, direction: .topToBottom)
        }
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        subtitleLabel.text = info.vSubTitle
        collectV.reloadData()
        
        gradintsArray.removeAll()
        containerView.removeGradientIfAny()
        
        var bgGradients: [String]?
        if let grads: [String] = info.metaLayoutInfo?.bgGradient, grads.count >= 3 {
            bgGradients = grads
        }
        else {
            bgGradients = ["#FFFFFF", "#EEF8FF", "#80D9FF"]
        }
        if let bgGradient: [String] = bgGradients {
            let gradientArrays = bgGradient.dropFirst()
            for colorCode in gradientArrays {
                gradintsArray.append(UIColor.colorWithHexString(colorCode).cgColor)
            }
            
            containerView.drawGradientByRemovingOld(colors: gradintsArray, direction: .topToBottom)
        }
        
        if let bgImageUrl = info.metaLayoutInfo?.bgImageUrl, let imgUrl = URL(string: bgImageUrl) {
            bgImageView.isHidden = false
            bgImageView.setImageFrom(url: imgUrl, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
        else {
            bgImageView.isHidden = true
        }
        
        if let logoImageUrl = URL(string: info.vImageUrl) {
            let placeholderImage: UIImage? = UIImage(named: "PaytmLogo", in: nil, compatibleWith: nil)
            logoImageView.setImageFrom(url: logoImageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        firstViewItem = info.viewItems.first
        if let firstItem = firstViewItem, let itemImageUrl = URL(string: firstItem.itemImageUrl) {
            bannerImageView.isHidden = false
            imageHeightConstrain.constant = (UIScreen.main.bounds.size.width)/bannerImageAspectRatio
            
            if let cachedImage = JRImageCache.shared.imageFromDiskCache(forKey: firstItem.itemImageUrl) {
                bannerImageView.image = cachedImage
            }
            else {
                var placeHolderImage: UIImage? = UIImage.imageNamed(name: "smart_banner_placeholder")
                if bannerImageView.image != nil {
                    placeHolderImage = bannerImageView.image
                }
                
                bannerImageView.setImageFrom(url: itemImageUrl, placeHolderImg: placeHolderImage) { (img, err, cacheType, url) in
                }
            }
            
            logImpressionForItem(item: firstItem)
        }
        else {
            imageHeightConstrain.constant = 0.0
            bannerImageView.isHidden = true
        }
    }
    
    override func showRecoAsChild(info: SFLayoutViewInfo?, indexPath: IndexPath) {
        recoInfo = (info, indexPath)
        if let cancelledRecoItems = SFUtilsManager.getCancelledRecoItems(), let items = info?.vItems, cancelledRecoItems.count > 0 {
            let cancelledRecos: Set<String> = Set(cancelledRecoItems)
            info?.vItems = items.filter { (item) -> Bool in
                let hashKey: String = SFUtilsManager.cancelledRecoHashKey(itemId: item.itemId, title: item.itemTitle , ctaLabel: item.ctaLabel ?? "")
                return !cancelledRecos.contains(hashKey)
            }
        }
        if info?.vItems.count == 0 {
            recoInfo = (nil, indexPath)
        }
        carouselRecoView.recoRemovedObserver = { [weak self] in
            guard let strongSelf = self, let recoInfo = self?.recoInfo else {
                return
            }
            strongSelf.showRecoAsChild(info: recoInfo.0, indexPath: recoInfo.1)
        }
        if let carouselInfo = recoInfo?.0 {
            carouselRecoView.isHidden = false
            labelContainerView.isHidden = true
            carouselRecoView.show(info: carouselInfo, indexPath: indexPath)
        } else {
            labelContainerView.isHidden = false
            carouselRecoView.isHidden = true
        }
    }
    
    // MARK: Private Methods
    private func configureViews() {
        bottomRoundedView.sfRoundCorner(10)
        addTapGestureOnBannerImageView()
    }
    
    private func addTapGestureOnBannerImageView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnBannerImageView))
        bannerImageView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapOnBannerImageView() {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate, let firstItem = firstViewItem else { return }
        delegate.sfSDKDidClick(item: firstItem,viewInfo:mLayout, tableIndex: self.index, collectIndex: 0)
    }
}
