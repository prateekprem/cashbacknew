//
//  SFSmartIconHeaderTableCell.swift
//  StoreFront
//
//  Created by Prakash Jha on 25/09/19.
//  Copyright © 2019 Prakash Jha. All rights reserved.
//

import UIKit

public class SFSmartIconHeaderTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet weak var serverImgV: UIImageView?

    override public class func register(table: UITableView) {
        if let mNib = SFSmartIconHeaderTableCell.Nib {
            table.register(mNib, forCellReuseIdentifier: SFSmartIconHeaderTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFSmartIconHeaderTableCell" }
    override var collectCellId: String { return "kSFSmartIconHeaderCollCell" }
    
    private class var Nib: UINib? { return Bundle.nibWith(name: "SFSmartIconHeaderTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFSmartIconHeaderCollCell") }
    
    override open func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    public override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        serverImgV?.setImageFromUrlPath(info.vImageUrl)
        setLayoutColor()
    }
    
    private func setLayoutColor() {
        let selectPageColor = UIColor.colorRGB(255, g:255, b:255, a:1.0)
        let pageColor = UIColor.colorRGB(255, g:255, b:255, a:0.2)
        setSelectedLayoutColor(selectPageColor: selectPageColor, pageColor: pageColor, scale: 0.65)
    }
}
