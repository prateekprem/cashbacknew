//
//  SFCategoryPopupItemCell.swift
//  Jarvis
//
//  Created by Abhishek Tripathi on 04/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

public class SFCategoryPopupItemCell: UICollectionViewCell {
    
    @IBOutlet weak private var titleLabel: UILabel!
    @IBOutlet weak private var cellImage: UIImageView!
    @IBOutlet weak var iconContainerView: UIView!
    @IBOutlet weak private var offerLabel: UILabel!
    @IBOutlet weak private var offerContainer: UIView!
    
    public var itemImageDictionary: [String : UIImage]?
    
    public var shouldShowGrid: Bool = false
    public var item :SFLayoutItem? {
        didSet {
            configureView()
        }
    }
    
    func configureView() {
        if let item: SFLayoutItem = item {
            titleLabel.accessibilityLabel = item.categoryName
            titleLabel.isAccessibilityElement = true
            titleLabel.text = item.categoryName
            self.cellImage.contentMode = UIView.ContentMode.scaleAspectFit
            cellImage.image = nil
            self.makeRound()
            self.cellImage.backgroundColor = UIColor.colorRGB(0, g: 0, b: 0, a: 0.05)
            if !item.itemImageUrl.isEmpty {
                if let itemImageDict: [String : UIImage] = itemImageDictionary, let itemImage = itemImageDict[item.itemImageUrl] {
                    cellImage.image = itemImage
                    self.cellImage.backgroundColor = UIColor.clear
                } else {
                    self.cellImage.jr_setImage(with: URL(string: item.itemImageUrl), completed: { (image, error , cache, imageURL) in
                        if  let img: UIImage = image  {
                            if var itemImageDict: [String : UIImage] = self.itemImageDictionary {
                                
                                let urlString: String = imageURL?.absoluteString ?? ""
                                itemImageDict[urlString] = img
                            }
                            self.cellImage.image = img
                            self.cellImage.backgroundColor = UIColor.clear
                            
                        }
                    })
                }
            }
            if self.offerContainer != nil {
                if let tagLabel: String = item.layoutLabel, tagLabel.count > 0 {
                    self.offerContainer.superview?.isHidden = false
                    self.offerLabel.text = tagLabel
                    self.offerContainer.roundCorner(0.5, borderColor: UIColor(red: 240/255.0, green: 191/255.0, blue: 68/255.0, alpha: 1), rad: 4)
                }
                else {
                 self.offerContainer.superview?.isHidden = true
                 }
            }
        }
        self.configureHomeUserInterface()
    }
    
    func makeRound() {
        if shouldShowGrid {
            if iconContainerView != nil {
                let borderColor = UIColor(red:221.0/255.0, green: 229.0/255.0, blue: 237.0/255.0, alpha: 1.0)
                iconContainerView.roundCorner(0.5, borderColor: borderColor, rad: 10)
            }
        }
    }
    
    func configureHomeUserInterface() {
        self.offerContainer.backgroundColor = UIColor(red: 240/255.0, green: 191/255.0, blue: 68/255.0, alpha: 1)
        self.offerLabel.textColor = UIColor.white
        self.titleLabel.font = UIFont.systemFont(ofSize: 12)
        self.titleLabel.textColor = UIColor(red: 80/255.0, green: 109/255.0, blue: 133/255.0, alpha: 1)
    }
}
