//
//  SFTabbed1ErrorTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 08/11/19.
//

import UIKit

class SFTabbed1ErrorTableCell: SFBaseTableCell {
    
    @IBOutlet private weak var errorLabel: UILabel!
    @IBOutlet private weak var loaderView: UIView!
    @IBOutlet private weak var activityIndicatorView: UIActivityIndicatorView!
    
    private var selectedItem: SFLayoutItem?

    override class func register(table: UITableView) {
        if let mNib = SFTabbed1ErrorTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTabbed1ErrorTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTabbed1ErrorTableCell" }
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTabbed1ErrorTableCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        
        if let items = layout?.vItems {
            for item in items {
                if item.isSelected {
                    selectedItem = item
                    break
                }
            }
        }
        
        if let selectedItem = selectedItem {
            configureCell(selectedItem)
        }
    }
    
    // MARK: Private Methods
    
    private func configureCell(_ item: SFLayoutItem) {
        var errorText = "Something went wrong! Try again later."
        if let isNetReachable = SFManager.shared.interactor?.isNetworkReachable(), !isNetReachable {
            errorText = "No Internet Connection!"
        }
        errorLabel.text = errorText
        if item.isGridItemLoading {
            loaderView.isHidden = false
            activityIndicatorView.startAnimating()
        }
        else {
            loaderView.isHidden = true
            activityIndicatorView.stopAnimating()
        }
    }
    
    @IBAction private func retryButtonClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
            
        if let selectedItem = selectedItem {
            delegate.sfDidClickOnRetry(selectedItem)
        }
    }
}
