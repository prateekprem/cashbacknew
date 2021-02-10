//
//  SFSmartIconCarouselTableCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 21/08/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

class SFSmartIconCarouselTableCell: SFBaseTableCellIncCollection {
   
    @IBOutlet weak private var tagV       : UIView!
    @IBOutlet weak private var tagLbl     : UILabel!
    @IBOutlet weak private var riseImgV   : UIImageView!

    override public class func register(table: UITableView) {
        if let mNib = SFSmartIconCarouselTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconCarouselTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconCarouselTableCell" }
    override var collectCellId: String { return "kSFSmartIconCarouselCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIconCarouselTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconCarouselCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        tagV.sfRoundCorner(0, nil, tagV.frame.size.height / 2.0, true)
    }
    
    override public func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        if let mLayout = self.layout {
            tagLbl.text = mLayout.vSubTitle
            var shHideTag = true
            if mLayout.vSubTitle.count > 0  {
                shHideTag = false
            }
            tagV.isHidden = shHideTag
            riseImgV.isHidden = shHideTag
        }
    }
}


