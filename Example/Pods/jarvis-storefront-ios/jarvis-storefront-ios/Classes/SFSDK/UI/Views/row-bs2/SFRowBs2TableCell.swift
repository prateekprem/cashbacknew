//
//  SFRowBs2TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 14/10/19.
//

import UIKit

class SFRowBs2TableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak var viewAllButton: UIButton!
    
    override class func register(table: UITableView) {
        if let mNib = SFRowBs2TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFRowBs2TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFRowBs2TableCell" }
    override var collectCellId: String { return "kSFRowBs2CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFRowBs2TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFRowBs2CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        viewAllButton.isHidden = !info.vSeeAllSeoUrl.isValidString()
    }
    
    @IBAction private func viewAllClicked(_ sender: UIButton) {
        guard let mLayout = self.layout else { return }
        
        guard let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
}
