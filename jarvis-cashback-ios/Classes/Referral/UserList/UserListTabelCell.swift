//
//  UserListTabelCell.swift
//  
//
//  Created by Abhishek Tripathi on 25/07/20.
//  Copyright © 2020 Abhishek Tripathi. All rights reserved.
//

import Foundation
import UIKit


class UserListTableCell: UITableViewCell {
   
   @IBOutlet var name: UILabel!
   @IBOutlet var userImage: UIImageView!
   @IBOutlet var amount: UILabel!
   @IBOutlet weak var nameLabel: UILabel!
   @IBOutlet weak var nameView: UIView!
   
   var viewModel: UserListCellViewModel!
   

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImage.layer.cornerRadius = userImage.frame.width/2
        userImage.clipsToBounds = true
        nameView.layer.cornerRadius = nameView.frame.width/2
        nameView.clipsToBounds = true
    }

   override func setSelected(_ selected: Bool, animated: Bool) {
       super.setSelected(selected, animated: animated)

       // Configure the view for the selected state
   }
   
    func configureData(_ model: UserListCellViewModel) {
        self.viewModel = model
        self.name.text = model.name
        self.amount.text = "₹\(Int(model.amount))"
        if  model.image.count > 0 {
            self.userImage.jr_setImage(with: URL(string: model.image)) { (image, error, type, url) in
                if image == nil {
                    self.setImage(model)
                } else {
                    self.userImage.image = image
                    self.nameLabel.isHidden = true
                    self.nameView.isHidden = true
                    self.userImage.isHidden = false
                }
            }
        } else {
            self.setImage(model)
        }
    }
    
    func setImage(_ model: UserListCellViewModel) {
        if model.initialName.count > 0 {
            self.nameLabel.isHidden = false
            self.nameView.isHidden = false
            self.userImage.isHidden = true
            self.nameLabel.text = model.initialName
            let color = model.backGroundColor.replacingOccurrences(of: "#", with: "")
            self.nameView.backgroundColor = UIColor(hex: color)
        } else {
            self.userImage.image = UIImage(named: "emptyUser", in: Bundle.cbBundle, compatibleWith: nil)
            let color = model.backGroundColor.replacingOccurrences(of: "#", with: "")
            self.userImage.backgroundColor = UIColor(hexString: color)
        }
    }
}
