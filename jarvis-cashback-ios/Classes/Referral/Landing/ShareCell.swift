//
//  ShareCell.swift
//  jarvis-chat-ios
//
//  Created by Abhishek Tripathi on 28/07/20.
//

import UIKit

class ShareCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    var viewModel: ShareViewModel!
    
    override class func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupData(data: ShareViewModel) {
        self.viewModel = data
        self.imageView.image = UIImage(named: self.viewModel.image, in: Bundle.cbBundle, compatibleWith: nil)
    }
}
