//
//  SFFilterTabCollectionCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

class SFFilterTabCollectionCell: SFBaseCollCell {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var containerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        doInitialConfiguration()
    }
    
    func configureCell(_ sortingValue: SFSortingValue?) {
        titleLabel.text = nil
        if let value = sortingValue?.name {
            let attributedText = SFFilterTabView.getAttributedTextToDisplay("Sort: ", value: value)
            titleLabel.attributedText = attributedText
        }
    }
    
    func configureCell(_ filter: SFFilter?) {
        titleLabel.text = nil
        let filterValue = filter?.displayNameOfFilterOnCLP() ?? "All"
        if let title = filter?.title {
            let attributedText = SFFilterTabView.getAttributedTextToDisplay("\(title): ", value:filterValue)
            titleLabel.attributedText = attributedText
        }
    }
    
    // MARK: Private Methods
    
    private func doInitialConfiguration() {
        makeRounded(view: containerView, roundV: .custom(5.0), clr: UIColor(hexString: "DDE5ED"), border: 1.0)
    }
}
