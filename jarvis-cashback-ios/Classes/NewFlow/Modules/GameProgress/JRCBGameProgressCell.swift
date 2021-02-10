//
//  JRCBGameProgressCell.swift
//  GameProgress
//
//  Created by Prateek Prem on 13/02/20.
//  Copyright © 2020 paytm. All rights reserved.
//

import UIKit

class JRCBGameProgressCell: UICollectionViewCell {
    
    @IBOutlet weak var lineView: UIView!
    @IBOutlet weak var imageView: UIImageView! {
        didSet {
            imageView.roundedCorners(radius: imageView.frame.size.width/2 - 2 )
        }
    }
    @IBOutlet weak var iconImage: UIImageView!
  
    var viewModel: JRCBGameProgressCellVM = JRCBGameProgressCellVM()
    
    static var nib:UINib {
        return UINib(nibName: identifier, bundle: Bundle.cbBundle)
    }
    
    static var identifier: String {
        return String(describing: self)
    }
    
    func show(viewModel: JRCBGameProgressCellVM) {
        imageView.roundedCorners(radius: imageView.frame.size.width/2)

        if viewModel.isFirst {
            lineView.isHidden = true
        } else {
            lineView.isHidden = false
        }
        lineView.backgroundColor = viewModel.color

        self.iconImage.isHidden = viewModel.isIconHidden
        if viewModel.isIconHidden {
            imageView.image = viewModel.image

        } else {
            iconImage.image = viewModel.image
        }
        
        if viewModel.isborder {
            if viewModel.gamestatus != .completedWithOutIcon {
                //imageView.addBorder(borderColor: viewModel.color, borderWidth: 1)
            }
            
        } else {
            if viewModel.gamestatus == .pendingWithOutIcon {
                imageView.backgroundColor = viewModel.color
            }
        }
    }

}

class JRCBGameProgressCellVM {
    var gamestatus: TransactionStatus = .pendingWithOutIcon
    var position: CellPosition = .middle

    var image: UIImage {
        get {
            if let myImage = UIImage.imageWith(name: self.gameStageConfig().image) {
                return myImage
            }
            return UIImage()
        }
    }
    
    var color: UIColor {
        get {
            return self.gameStageConfig().color
        }
    }
    
    var isFirst: Bool {
        get {
            return position == .first
        }
    }
    
    var isLast: Bool {
        get {
            return position == .last
        }
    }
    
    var isIconHidden: Bool {
        get {
            return gameStageConfig().isIconHidden
        }
    }
    
    var isborder: Bool {
        get {
            return gameStageConfig().isborderEnabled
        }
    }
    
    init(gamestatus: TransactionStatus = .pendingWithOutIcon, position: CellPosition = .middle) {
        self.gamestatus = gamestatus
        self.position = position
    }
    
    private func gameStageConfig() ->  (image: String, color: UIColor, isIconHidden: Bool, isborderEnabled: Bool) {
        switch gamestatus {
        case .pendingWithOutIcon:
            return (image: "", color: CashbackColors.cashbackGrey243.color, false, false)
        case .completedWithOutIcon:
            return (image: "icTick4", color: CashbackColors.cashbackGreen33.color, false, false)
        case .pendingWithIcon:
            return (image: "ic_giftFade", color: CashbackColors.cashbackGrey243.color, false, false)
        case .completedWithIcon:
            return (image: "ic_gift", color: CashbackColors.cashbackGreen33.color, false, false)
        }
    }
}
