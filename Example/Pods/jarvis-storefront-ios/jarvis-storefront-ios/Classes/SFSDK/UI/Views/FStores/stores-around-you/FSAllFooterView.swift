//
//  FSAllFooterView.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

public protocol FSAllFooterViewDelegate: class {
    
    func viewAllStores(_ info: SFLayoutViewInfo)
}

public class FSAllFooterView: UIView {
    
    @IBOutlet weak var noStoreLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    private var layoutInfo: SFLayoutViewInfo?
    //Public Vars
    public weak var delegate: FSAllFooterViewDelegate?
    
    public static func loadView() -> FSAllFooterView {
        return Bundle.sfBundle.loadNibNamed("FSAllFooterView", owner: self, options: nil)?.last as! FSAllFooterView
    }
    
    public func configureView(_ layout: SFLayoutViewInfo?, isStoresAvailabel: Bool) {
        layoutInfo = layout
        if isStoresAvailabel {
            viewAllButton.isHidden = false
            noStoreLabel.isHidden = true
        }else{
            viewAllButton.isHidden = true
            noStoreLabel.isHidden = false
        }
    }
    
    @IBAction func viewAllAction(_ sender: Any) {
        if let layoutInfo = layoutInfo {
             delegate?.viewAllStores(layoutInfo)
        }
    }
}
