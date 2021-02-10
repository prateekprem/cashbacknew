//
//  SFRecoCollectionCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 28/01/20.
//

import UIKit

protocol RecoCellActionDelegate:class {
    func preventInteractions(_ shouldPrevent:Bool)
}
class SFCarouselReco4xCollCell: SFBaseCollCell {
    
    @IBOutlet weak var crossBtn: UIButton!
    @IBOutlet weak var titleInitial: UILabel!
    @IBOutlet weak var mContentView: UIView!
    @IBOutlet weak private var title: UILabel!
    @IBOutlet weak private var subTitle: UILabel!
    @IBOutlet weak private var imageView: UIImageView!
    @IBOutlet weak private var imgWidth: NSLayoutConstraint!
    @IBOutlet weak private var imgHeight: NSLayoutConstraint!
    @IBOutlet weak var initialsContainerView: UIView!
    @IBOutlet weak var ctaLabel: UILabel!
    @IBOutlet weak var ctaButtonContainer: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var buttonCenterConstaint: NSLayoutConstraint!
    
    var layout: SFLayoutViewInfo?
    private var item: SFLayoutItem?
    var isExpanded:Bool = false
    var recoRemovedObserver: ((Int, String, String?) -> Void)?
    var isAnimating:Bool = false
    weak var interactionDelegate:RecoCellActionDelegate?
    private let mobilePrepaidString = "mobile-prepaid"
    private let mobilePostpaidString = "mobile-postpaid"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
        crossBtn.isHidden = !(SFUtilsManager.value(forKey: "isRecoCrossEnabled") ?? false)
    }
    
    func initialSetup() {
        self.layer.cornerRadius = 8
        mContentView.layer.cornerRadius = 8
        mContentView.layer.borderWidth = 1
        mContentView.layer.borderColor =  UIColor(red: 0.867, green: 0.898, blue: 0.929, alpha: 0.6).cgColor
        self.contentView.layer.shadowColor =  UIColor(red: 0.867, green: 0.898, blue: 0.929, alpha: 1).cgColor
         self.contentView.dropShadowDownside(CGSize(width: 5, height: 5), radius: 5, opacity: 1)
        ctaButtonContainer.layer.cornerRadius = 4
    }
    
    func setContentViewOpacity(isExpanded:Bool,index:Int) {
        if !isExpanded {
            if index > 2 {
                self.mContentView.alpha = 0
            } else {
                let alpha:CGFloat = CGFloat(CGFloat(3 - index)/3)
                self.mContentView.alpha = alpha
            }
        } else {
            self.mContentView.alpha = 1
        }
    }
    
    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        self.item = item
        super.show(item: item, cellConfig: cellConfig)
        backgroundColor = cellConfig.collectCellBackColor
        title.text = item.itemTitle
        if item.itemSubTitle.isEmpty {
            subTitle.isHidden = true
        } else {
            subTitle.isHidden = false
            subTitle.text = item.itemSubTitle
        }
        let ctaText = item.ctaLabel ?? ""
        ctaLabel.text = ctaText
        if (item.itemUrlType == mobilePrepaidString || item.itemUrlType == mobilePostpaidString) {
            checkNameInPhoneContact(item)
        } else {
            nameLabel.text = item.itemName
        }
        if ctaText.isValidString() {
            ctaButtonContainer.isHidden = false
        } else {
            ctaButtonContainer.isHidden = true
        }
        if let imgUrl = URL(string: item.itemImageUrl) {
            self.imageView.setImageFrom(url: imgUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        } else
        {
            imageView.image = placeholderImage
        }
        if item.itemImageUrl == "" {
            titleInitial.isHidden = false
            let itemInitial = item.itemInitial
            titleInitial.text = itemInitial
            let hexColor =  item.itemColor.replaceFirst(of: "#", with: "")
            initialsContainerView.isHidden = false
            initialsContainerView.backgroundColor = UIColor.colorWith(hex:hexColor)
        } else {
            titleInitial.isHidden = true
            initialsContainerView.isHidden = true
            imageView.backgroundColor = UIColor.clear
            initialsContainerView.backgroundColor = UIColor.clear
        }
        makeImageCircular()
    }
    
    private func checkNameInPhoneContact(_ item:SFLayoutItem) {
        if let mLayout = self.layout, let delegate = mLayout.pDelegate, let name = delegate.getPhoneContact(phoneNumber: item.itemTitle) {
            nameLabel.text = name
        } else {
            nameLabel.text = item.itemName
        }
    }
    
    @IBAction func ctaTapAction(_ sender: UIButton) {
        guard let mLayout = self.layout,let mItem = self.item, let delegate = mLayout.pDelegate else {
            return
        }
        delegate.sfDidClickCTA(item: mItem)
        var trackingDict: [String:Any] = [String:Any]()
        trackingDict = mLayout.gaPromotionImpressionParamFor(item: mItem)
        if mLayout.verticalName.isValidString() {
            SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: mLayout.verticalName, pageName: mLayout.gaKey)
        }
    }
    
    func makeImageCircular() {
        makeRounded(view: imageView, roundV: .custom(imgWidth.constant / 2), clr: UIColor(hex: "DDE5ED"), border: 0.0)
    }
    
    
    @IBAction func crossBtnClicked(_ sender: UIButton) {
        if SFUtilsManager.isUserLoggedIn(), let userId = SFUtilsManager.getUserId(), userId.isValidString(), let itemId = item?.itemId, itemId != 0 {
            var cancelledRecoItems: Set<String> = []
            if let cancelledRecos = SFUtilsManager.getCancelledRecoItems() {
                cancelledRecoItems = Set(cancelledRecos)
            }
            let hashKey: String = SFUtilsManager.cancelledRecoHashKey(itemId: itemId, title: item?.itemTitle ?? "", ctaLabel: item?.ctaLabel ?? "")
            cancelledRecoItems.insert(hashKey)
            SFUtilsManager.setCancelledRecoItems(array: Array(cancelledRecoItems))
            removePulseEvent()
            if let intDelegate = interactionDelegate {
                intDelegate.preventInteractions(true)
            }
            UIView.animate(withDuration: 0.3, animations: { [unowned self] in
                self.transform = CGAffineTransform(scaleX: 0.2, y: 0.2)
                self.alpha = 0.0
            }) { (completed) in
                if let intDelegate = self.interactionDelegate {
                    intDelegate.preventInteractions(false)
                }
                self.recoRemovedObserver?(itemId, self.item?.itemTitle ?? "", self.item?.ctaLabel)
            }
        }
    }
    
    private func removePulseEvent() {
        guard let viewInfo = layout, let mItem = item else {
            return
        }
        var trackingDict: [String:Any] = [String:Any]()
        trackingDict = viewInfo.gaPromotionImpressionParamFor(item: mItem)
        if viewInfo.verticalName.isValidString() {
            trackingDict["name"] = "carousel-icon-4x"
            trackingDict["creative"] = mItem.itemName + "_cross_clicked"
            SFItemTracker.shared.logPromotionClickForItem(dict: trackingDict, verticalName: viewInfo.verticalName, pageName: viewInfo.gaKey)
        }
    }
    
}
