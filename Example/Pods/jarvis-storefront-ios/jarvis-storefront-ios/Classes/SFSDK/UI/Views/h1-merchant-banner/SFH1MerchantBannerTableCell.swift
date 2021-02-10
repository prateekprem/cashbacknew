//
//  SFH1MerchantBannerTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 18/10/19.
//

import UIKit

class SFH1MerchantBannerTableCell: SFBaseTableCell {
    @IBOutlet private weak var storeImageView: UIImageView!
    @IBOutlet private weak var nameLabel: UILabel!
    @IBOutlet private weak var locationLabel: UILabel!
    @IBOutlet weak var searchView: UIView!{
        didSet{
            let tapGesture = UITapGestureRecognizer(target: self, action: #selector(searchTapped))
            searchView.addGestureRecognizer(tapGesture)
            searchView.layer.cornerRadius = 20
            searchView.layer.masksToBounds = true
        }
    }
    
    @objc func searchTapped() {
        guard let mLayout = self.layout else { return }
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfSearchTapped(mLayout)
    }
    
    override class func register(table: UITableView) {
        if let mNib = SFH1MerchantBannerTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFH1MerchantBannerTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFH1MerchantBannerTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFH1MerchantBannerTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        nameLabel.text = ""
        if let imageUrlString = layout?.storeInfo?.logo, let imageUrl = URL(string: imageUrlString) {
            storeImageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        else {
            storeImageView.image = UIImage.imageNamed(name: "store")
        }
        
        if let name = layout?.storeInfo?.name {
            nameLabel.text = name
        }
        
        var locationString: String = ""
//        if let locality = layout?.storeInfo?.locality {
//            locationString += locality
//        }
        if let city = layout?.storeInfo?.city {
            locationString += "\(city)"
        }
        
        locationLabel.text = locationString
    }
    
    @IBAction func backButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout else { return }
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfbackButtonTapped(mLayout)
    }
}
