//
//  SFTabbed1xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 08/11/19.
//

import UIKit

class SFTabbed1xnTableCell: SFBaseTableCell {
    @IBOutlet private weak var itemImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mrpLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var offerLabel: UILabel!
    @IBOutlet private weak var cashbackDescLabel: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    @IBOutlet private weak var badgeIcon: UIImageView!
    @IBOutlet private weak var badgeLabel: UILabel!
    @IBOutlet private weak var varientTitle: UILabel!
    @IBOutlet private weak var variantExpandArrow: UIImageView!
    @IBOutlet private weak var increaseButton: UIButton!
    @IBOutlet private weak var decreaseButton: UIButton!
    @IBOutlet private weak var soldOutButton: UILabel!
    @IBOutlet private weak var brandLabel: UILabel!
    @IBOutlet private weak var timerView: UIView!
    @IBOutlet private weak var timerLabel: UILabel!
    @IBOutlet private weak var timerImgView: UIImageView!
    @IBOutlet private weak var sponsoredLabel: UILabel!{
        didSet{
            sponsoredLabel.layer.cornerRadius = 2
            sponsoredLabel.layer.masksToBounds = true
        }
    }
    
    
    @IBOutlet weak private var variantsView: UIView!{
        didSet{
            variantsView.layer.borderWidth = 1.0
            variantsView.layer.borderColor = UIColor(hex: "DDE5ED").cgColor
            variantsView.layer.cornerRadius = 5.0
            variantsView.layer.masksToBounds = true
       }
    }
    
    @IBOutlet weak private var quantityView: UIView!{
        didSet{
            quantityView.layer.borderWidth = 1
            quantityView.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1).cgColor
            quantityView.layer.cornerRadius = 5
            quantityView.clipsToBounds = true
        }
    }
    @IBOutlet weak var quantityLabel: UILabel!
    @IBOutlet private var ratingLabel: UILabel!
    @IBOutlet private var reviewsCountLabel: UILabel!
    @IBOutlet private var favButton: UIButton!
    @IBOutlet weak var imageWidth: NSLayoutConstraint!
    private var variantTap:UITapGestureRecognizer = UITapGestureRecognizer()
    private var timer: Timer?
    private var counter = 0

    private var quantityCount:Int = 0 {
        didSet{
            addToCartButton.isHidden = (quantityCount > 0)
            quantityView.isHidden = !addToCartButton.isHidden
            quantityLabel.text = String(describing: quantityCount)
            if let item = selectedItem?.gridItems[rowIndex].first {
                item.quantity = quantityCount
            }
            if quantityCount >= maxQuantityCountForItem  {
                increaseButton.isEnabled = false
                increaseButton.setTitleColor(UIColor(hex:"B3E6F9"), for: .normal)
            }else {
                increaseButton.isEnabled = true
                increaseButton.setTitleColor(UIColor(hex:"00ACED"), for: .normal)
            }
        }
    }
    
    private var maxQuantityCountForItem:Int = 10000 {
        didSet{
            if let item = selectedItem?.gridItems[rowIndex].first {
                item.maxQuantity = maxQuantityCountForItem
            }
        }
    }
    
    @IBOutlet weak private var brandStoreSeparator: UIView!
    @IBOutlet weak private var ratingStackView: UIStackView!
    @IBOutlet weak private var brandStoreView: UIStackView!
    
    private var selectedItem: SFLayoutItem?
    
    override class func register(table: UITableView) {
        if let mNib = SFTabbed1xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTabbed1xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTabbed1xnTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTabbed1xnTableCell") }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doInitialConfiguration()
    }
    
    @objc func variantTapped(_ sender: UITapGestureRecognizer? = nil) {
        print("Present variant view")
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate , let selectedItem = selectedItem else { return }
        if let item = selectedItem.gridItems[rowIndex].first {
            delegate.sfVariantTapped(item: item,parent: selectedItem)
        }
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        
        if let items = layout?.vItems {
            for item in items {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
        }
        
        if let item = selectedItem?.gridItems[rowIndex].first {
            configureCell(item)
        }
    }
    private func showFirstFrame( endTime: Date) {
        if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
            if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                counter = difference.second!
                timerLabel.text = "\(SFUtilsManager.getHours(counter: self.counter)) : \(SFUtilsManager.getMinutes(counter: self.counter)) : \(SFUtilsManager.getSeconds(counter: self.counter))"
            }
        }
    }
            
    private func startTimer( endTime: Date, result: ((String) -> ())?) {
        invalidateTimerForTabbed2Cell()
        if timer == nil {
            if let diff = UserDefaults.standard.value(forKey: "kDiffrenceTime") as? Int {
                if let date  = Calendar.current.date(byAdding: Calendar.Component.second, value: diff, to: Date()) {
                    let difference = Calendar.current.dateComponents([.second], from: date, to: endTime)
                    counter = difference.second!
                    timer =  Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true, block: { (timer) in
                        self.counter-=1
                        if self.counter <= 0 {
                            self.timer?.invalidate()
                            self.timer = nil
                        }else{
                            result?("\(SFUtilsManager.getHours(counter: self.counter)) : \(SFUtilsManager.getMinutes(counter: self.counter)) : \(SFUtilsManager.getSeconds(counter: self.counter))")
                        }
                        
                    })
                }else {
                    invalidateTimerForTabbed2Cell()
                }
            }
        }
    }
    
    override func invalidateTimerForTabbed2Cell() {
        if timer != nil {
            timer?.invalidate()
            timer = nil
        }
    }
    
    
    // MARK: Private Methods
    
    private func configureCell(_ item: SFLayoutItem?) {
        clearAllValues()
        
        if let bool = item?.isFlashSaleTimerShow, bool {
            timerView.isHidden = false
            timerLabel.isHidden = false
            timerImgView.isHidden = false
            if let endDate = item?.isFlashSaleValidUpto {
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSz"
                if let date = dateFormatter.date(from: endDate) {
                    showFirstFrame(endTime: date)
                    startTimer(endTime: date) { (lblValue) in
                        self.timerLabel.text = lblValue
                    }
                }
            }
        }
        else {
            timerView.isHidden = true
            timerLabel.isHidden = true
            timerImgView.isHidden = true
            
        }
        
        if let isSponsored = item?.sponsored, isSponsored {
            sponsoredLabel.isHidden = false
        }else {
            sponsoredLabel.isHidden = true
        }
        
        if let showBrand = item?.showBrand, showBrand {
            brandLabel.isHidden = false
            brandLabel.text = item?.brand
        }
        else {
            brandLabel.isHidden = true
        }
        soldOutButton.isHidden = true
        if let item = item {
            if let inStock = item.inStock , inStock == false {
                soldOutButton.isHidden = false
                addToCartButton.isHidden = true
                quantityView.isHidden = true
                item.v1OfferText = "SOLD OUT"
                item.v1OfferSubText = nil
                
            }else if let showAddToCart = item.isAddToCartEnabled, showAddToCart{
                addToCartButton.isHidden = true
                quantityView.isHidden = true
                if let mLayout = self.layout, let delegate = mLayout.pDelegate{
                    let (quantity, maxQuantity) = delegate.getItemQuantityCountFromCart(item)
                    self.maxQuantityCountForItem = maxQuantity
                    self.quantityCount = quantity
                }
            }else {
                addToCartButton.isHidden = true
                quantityView.isHidden = true
                soldOutButton.isHidden = true
            }
        }
        
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            itemImageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        if let viewType =  item?.gridLayout?.viewType , viewType == .largeList {
            imageWidth.constant = 95
        }else {
            imageWidth.constant = 80
        }
        
        if let itm = item, isItemPresentInWishlist(itm) {
            showWishlistIcon(selected: true)
        }
        else {
            showWishlistIcon(selected: false)
        }
        
        nameLabel.text = item?.itemName
        if let price = item?.offerPrice?.getFormattedAmount() {
            priceLabel.text = "\(rupeeSymbol)\(price)"
        }
        
        if let actualPrice = item?.actualPrice?.getFormattedAmount() {
            mrpLabel.setStrikeOutText("\(rupeeSymbol)\(actualPrice)")
        }
        
        if let discount = item?.discount, discount != "0" {
            discountLabel.text = "\(discount)% Off"
        }else {
            mrpLabel.isHidden = true
            discountLabel.isHidden = true
        }
        
        if let offerText = item?.v1OfferText {
            offerLabel.text = offerText
            if let offerText = item?.v1OfferSubText {
                cashbackDescLabel.text = offerText
            }
            if let redemptionType = item?.v1RedemptionType, redemptionType == "SINGLE_REDEMPTION" {
                offerLabel.textColor = UIColor(hex: "FF585D")
            }else {
                offerLabel.textColor =  UIColor(hex: "11BF80")
            }
        }else {
            offerLabel.isHidden = true
            cashbackDescLabel.isHidden = true
        }
        
        
        if let avgRating = item?.avgRating , avgRating > 0.0  {
            ratingStackView.isHidden = false
            ratingLabel.text = String(describing: avgRating)
            if let totalRatings = item?.totalRatings , totalRatings > 0 {
                reviewsCountLabel.text = "(" + String(describing: totalRatings) + ")"
            }
        }else {
            ratingStackView.isHidden = true
        }
        
        if let item = item , let (text,url) = item.getGridBadgeToShow(),let imageUrl = URL(string: url){
            brandStoreSeparator.isHidden = ratingStackView.isHidden
            brandStoreView.isHidden = false
            badgeLabel.text = text
            badgeIcon.setImageFrom(url: imageUrl, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }else {
            brandStoreSeparator.isHidden = true
            brandStoreView.isHidden = true
        }
        if let item = item {
            if item.shouldShowVariantView() {
                variantsView.isHidden = false
                if item.shouldAllowTapOnVariants() {
                    variantTap = UITapGestureRecognizer(target: self, action: #selector(self.variantTapped(_:)))
                    variantsView.addGestureRecognizer(variantTap)
                    variantExpandArrow.isHidden = false
                }else {
                    variantExpandArrow.isHidden = true
                }
                
                if let title = item.variantTitleName() {
                    varientTitle.text = title
                }
            }else {
                variantsView.isHidden = true
            }
        }
    }
    
    override func hideInfoForFlashSale(_ hide: Bool) {
        priceLabel.isHidden = hide
        mrpLabel.isHidden = hide
        discountLabel.isHidden = hide
        offerLabel.isHidden = hide
        cashbackDescLabel.isHidden = hide
    }
    
    private func showWishlistIcon(selected isSelected: Bool) {
        if isSelected {
            favButton.setImage(UIImage.imageNamed(name: "wishlist_selected"), for: .normal)
        }
        else {
            favButton.setImage(UIImage.imageNamed(name: "whishlist"), for: .normal)
        }
    }
    
    private func clearAllValues(){
        ratingLabel.text = nil
        reviewsCountLabel.text = nil
        offerLabel.text = nil
        cashbackDescLabel.text = nil
        reviewsCountLabel.text = nil
        nameLabel.text = nil
        priceLabel.text = nil
        mrpLabel.text = nil
        discountLabel.text = nil
        ratingLabel.text = nil
        reviewsCountLabel.text = nil
        varientTitle.text = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        offerLabel.isHidden = false
        cashbackDescLabel.isHidden = false
        ratingLabel.isHidden = false
        reviewsCountLabel.isHidden = false
        mrpLabel.isHidden = false
        discountLabel.isHidden = false
        addToCartButton.isHidden = true
        variantsView.removeGestureRecognizer(variantTap)
    }
    
    private func doInitialConfiguration() {
        addToCartButton.layer.borderWidth = 1.0
        addToCartButton.layer.borderColor = UIColor.paytmBlueColor().cgColor
        addToCartButton.layer.cornerRadius = 5.0
        addToCartButton.isHidden = false
        quantityView.isHidden = true

    }
    
    private func isItemPresentInWishlist(_ item: SFLayoutItem) -> Bool {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return false }
        return delegate.sfIsItemPresentInWishlist(item)
    }
    
    @IBAction func addToCartButtonClicked(_ sender: UIButton?) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        if let item = selectedItem?.gridItems[rowIndex].first {
            delegate.sfAddToCart(item) { [weak self] (error) in
                if error == nil {
                    let (quantity, maxQuantity) = delegate.getItemQuantityCountFromCart(item)
                    self?.maxQuantityCountForItem = maxQuantity
                    self?.quantityCount = quantity
                }
            }
        }
    }
    
    @IBAction func favButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        
        if let item = selectedItem?.gridItems[rowIndex].first {
            delegate.sfDidClickOnWishlist(item) { [weak self] (error, isAdded) in
                if error == nil {
                    self?.showWishlistIcon(selected: isAdded)
                }
            }
        }
    }
    
    @IBAction func reduceItemQtytTapped(_ sender: Any) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        if let item = selectedItem?.gridItems[rowIndex].first {
            delegate.sfDeleteFromCart(item,count: self.quantityCount) { [weak self] (error) in
                if error == nil {
                    let (quantity, maxQuantity) = delegate.getItemQuantityCountFromCart(item)
                    self?.maxQuantityCountForItem = maxQuantity
                    self?.quantityCount = quantity
                }
            }
        }
    }
    
    @IBAction func increaseItemQuantity(_ sender: Any) {
        addToCartButtonClicked(nil)
    }
}
