//
//  SFVariantCell.swift
//  jarvis-storefront-ios
//
//  Created by Shikha Sharma on 09/12/19.
//

import UIKit

public protocol SFVariantCellDelegate: class {
   func variantAddToCart(_ item: SFLayoutItem, completionHandler: ((_ error: Error?) -> Void)?)
   func variantDeleteFromCart(_ item: SFLayoutItem,count: Int, completionHandler: ((_ error: Error?) -> Void)?)
   func variantItemQuantityCountFromCart(_ item: SFLayoutItem) -> (Int,Int)
   func refreshView()
   func stopLoader()
}

enum SFVariantOperation {
    case add
    case delete
}
class SFVariantCell: UITableViewCell {
    @IBOutlet private weak var title: UILabel!
    @IBOutlet private weak var priceLabel: UILabel!
    @IBOutlet private weak var mrpLabel: UILabel!
    @IBOutlet private weak var discountLabel: UILabel!
    @IBOutlet private weak var icon: UIImageView!
    @IBOutlet private weak var iconTitle: UILabel!
    @IBOutlet weak var offerStackView: UIStackView!
    private var selectedItem:SFLayoutItem?
    weak var delegate:SFVariantCellDelegate?
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    var updateOperationStack:((SFVariantOperation, SFLayoutItem?, Int, Bool)-> Void)?
    
    @IBOutlet weak private var quantityView: UIView!{
        didSet{
            quantityView.layer.borderWidth = 1
            quantityView.layer.borderColor = UIColor(red: 0.0/255.0, green: 172.0/255.0, blue: 237.0/255.0, alpha: 1).cgColor
            quantityView.layer.cornerRadius = 5
            quantityView.clipsToBounds = true
        }
    }
    @IBOutlet private weak var quantityLabel: UILabel!
    @IBOutlet private weak var addToCartButton: UIButton!
    @IBOutlet private weak var increaseButton: UIButton!
    @IBOutlet private weak var decreaseButton: UIButton!
    
    private var quantityCount:Int = 0 {
        didSet{
            addToCartButton.isHidden = (quantityCount > 0)
            quantityView.isHidden = !addToCartButton.isHidden
            quantityLabel.text = String(describing: quantityCount)
            if let item = selectedItem {
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
            if let item = selectedItem {
                item.maxQuantity = maxQuantityCountForItem
            }
        }
    }
    
    func configureVarientCell(item: SFLayoutItem?) {
        title.text = nil
        priceLabel.text = nil
        discountLabel.text = nil
        mrpLabel.text = nil
        iconTitle.text = nil
        quantityLabel.text = ""
        selectedItem = item
        if let item = item , let showAddToCart = item.isAddToCartEnabled, showAddToCart{
            if let delegate = delegate {
                let (quantity, maxQuantity) = delegate.variantItemQuantityCountFromCart(item)
                self.maxQuantityCountForItem = maxQuantity
                self.quantityCount = quantity
                if self.quantityCount > 0 {
                    updateOperationStack?(SFVariantOperation.add, item, quantity, false)
                }
            }
        }else {
            addToCartButton.isHidden = true
            quantityView.isHidden = true
        }
        title.text = item?.getItemVariantDescriptionTitle() ?? ""
            
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
        if let offer = item?.offerText {
            iconTitle.text = offer
        }else {
            offerStackView.isHidden = true
        }
     }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        doInitialConfiguration()
    }
    
    private func doInitialConfiguration() {
        addToCartButton.layer.borderWidth = 1.0
        addToCartButton.layer.borderColor = UIColor.paytmBlueColor().cgColor
        addToCartButton.layer.cornerRadius = 5.0
        addToCartButton.isHidden = true
        quantityView.isHidden = true
        
    }
   
    override func prepareForReuse() {
        super.prepareForReuse()
        mrpLabel.isHidden = false
        discountLabel.isHidden = false
    }
}

extension SFVariantCell {
    @IBAction func increaseItemQuantity(_ sender: Any) {
        addToCartButtonClicked(nil)
    }
    
    @IBAction func reduceItemQtytTapped(_ sender: Any) {
        if let item = selectedItem, let delegate = delegate {
            activityIndicator.startAnimating()
            delegate.variantDeleteFromCart(item,count: self.quantityCount) { [weak self] (error) in
                if error == nil {
                    self?.activityIndicator.stopAnimating()
                    let (quantity, maxQuantity) = delegate.variantItemQuantityCountFromCart(item)
                    self?.maxQuantityCountForItem = maxQuantity
                    self?.quantityCount = quantity
                    self?.updateOperationStack?(SFVariantOperation.delete, self?.selectedItem, quantity, true)
                }
            }
        }
    }
    
    @IBAction func addToCartButtonClicked(_ sender: UIButton?) {
        if let item = selectedItem, let delegate = delegate {
            activityIndicator.startAnimating()
            delegate.variantAddToCart(item) { [weak self] (error) in
                if error == nil {
                    self?.activityIndicator.stopAnimating()
                    let (quantity, maxQuantity) = delegate.variantItemQuantityCountFromCart(item)
                    self?.maxQuantityCountForItem = maxQuantity
                    self?.quantityCount = quantity
                    self?.updateOperationStack?(SFVariantOperation.add, self?.selectedItem, quantity, true)
                }
            }
        }
    }
}
