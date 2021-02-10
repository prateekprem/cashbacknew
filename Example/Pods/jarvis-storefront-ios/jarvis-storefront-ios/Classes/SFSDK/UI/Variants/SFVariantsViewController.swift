//
//  SFVariantsViewController.swift
//  jarvis-storefront-ios
//
//  Created by Shikha Sharma on 09/12/19.
//

import UIKit

public class SFVariantsViewController: UIViewController {
    @IBOutlet weak var topConstraint: NSLayoutConstraint!
    @IBOutlet weak private var itemImageView: UIImageView!
    @IBOutlet weak private var itemTitle: UILabel!
    @IBOutlet weak var variantView: UIView!
    var item:SFLayoutItem?
    public var parentItem:SFLayoutItem?
    private var origin:CGFloat = 0.0
    public weak var delegate:SFVariantCellDelegate?
    @IBOutlet weak private var brandLabel: UILabel!
    private var operationArray:[SFLayoutItem] = [SFLayoutItem]()
    @IBOutlet weak var variantsTableView: UITableView!
    override public func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        view.isOpaque = false
        if let showBrand = item?.showBrand, showBrand {
            brandLabel.isHidden = false
            brandLabel.text = item?.brand
        }
        else {
            brandLabel.isHidden = true
        }
        
        itemTitle.text = item?.itemName ?? ""
        if let imageUrl = item?.itemImageUrl, let mURL = URL(string: imageUrl) {
            itemImageView.setImageFrom(url: mURL, placeHolderImg: nil) { (img, err, cacheType, url) in
            }
        }
        //updateItem()
    }
    
    func roundTopCorners(_ view: UIView, cornerRadius: Double) {
        let path = UIBezierPath(roundedRect: view.bounds, byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: cornerRadius, height: cornerRadius))
        let maskLayer = CAShapeLayer()
        maskLayer.frame = view.bounds
        maskLayer.path = path.cgPath
        view.layer.mask = maskLayer
    }
    
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        origin = variantView.frame.origin.y
        topConstraint.constant = UIScreen.main.bounds.height
        variantView.isHidden = true
        view.layoutIfNeeded()
    }
    
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateVariantsView()
        roundTopCorners(variantView, cornerRadius: 15.0)
        variantView.layoutIfNeeded()
        variantsTableView.reloadData()
    }
    
    public static func getVariantsVC(_ item: SFLayoutItem) -> SFVariantsViewController {
        let storyBoard: UIStoryboard = UIStoryboard(name: "MPFilter", bundle: Bundle.sfBundle)
        let vc = storyBoard.instantiateViewController(withIdentifier: "SFVariantsViewController") as! SFVariantsViewController
        vc.item = item
        return vc
    }
    @IBAction func crossButtonTapped(_ sender: Any) {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.topConstraint.constant = UIScreen.main.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (finished: Bool) -> Void in
            self.delegate?.stopLoader()
            self.dismiss(animated: false, completion: nil)
        })
        
    }
    
    public func animateVariantsView() {
        UIView.animate(withDuration: 0.2, delay: 0, options: .curveEaseInOut, animations: {
            self.variantView.isHidden = false
            self.topConstraint.constant = self.origin
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}

extension SFVariantsViewController: UITableViewDataSource, UITableViewDelegate {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return item?.variants?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let variantCell =  tableView.dequeueReusableCell(withIdentifier: "varientcell") as? SFVariantCell {
            variantCell.delegate = self.delegate
            variantCell.configureVarientCell(item: item?.varientItems[indexPath.row])
            variantCell.updateOperationStack = { (type,item,quantity,refreshView) in
                if let item = item {
                    if type == SFVariantOperation.add {
                        if self.operationArray.contains(item){
                           let index = self.operationArray.index { $0.productId == item.productId }
                            self.operationArray.swapAt(0, index ?? 0)
                        }else {
                            self.operationArray.insert(item, at: 0)
                        }
                    }else {
                        if self.operationArray.contains(item){
                            let index = self.operationArray.index { $0.productId == item.productId }
                            self.operationArray.swapAt(0, index ?? 0)
                        }
                    }
                    
                    var lastItemOperated:SFLayoutItem?
                    if self.operationArray.count > 0 {
                        lastItemOperated  = self.operationArray.first
                    }
                    if quantity == 0 &&  self.operationArray.count > 0 {
                            self.operationArray.remove(at: 0)
                        }
                    if refreshView {
                        if self.operationArray.count > 0 {
                            self.updateItem(newItem: self.operationArray.first!)
                            
                        }else {
                            self.updateItem(newItem: lastItemOperated)
                        }
                    }
                }
            }
            return variantCell
        }
        return UITableViewCell()
    }
}

extension SFVariantsViewController {
    func updateItem(newItem: SFLayoutItem?) {
        if let newItem = newItem {
            parentItem?.updateItem(newItem)
            delegate?.refreshView()
        }
    }
}
