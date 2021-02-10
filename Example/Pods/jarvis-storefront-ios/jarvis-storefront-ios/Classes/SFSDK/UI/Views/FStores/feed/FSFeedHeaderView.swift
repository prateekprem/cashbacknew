//
//  FSFeedHeaderView.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

public protocol FSFeedViewDelegate: class {
    func feedFollwed(_ isOn: Bool, layout: SFLayoutViewInfo?)
}


public class FSFeedHeaderView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var switchBtn: UISwitch!
    
    //Public Vars
    public weak var delegate: FSFeedViewDelegate?
    
     private var layoutInfo: SFLayoutViewInfo?
    
    public static func loadView() -> FSFeedHeaderView {
        return Bundle.sfBundle.loadNibNamed("FSFeedHeaderView", owner: self, options: nil)?.last as! FSFeedHeaderView
    }
    
    public func configureView(_ layout: SFLayoutViewInfo?) {
        layoutInfo = layout
        titleLabel.text = layout?.vTitle
        if let isFollowed = layout?.isfeedFollowed, isFollowed {
            switchBtn.isOn = true
        }else{
            switchBtn.isOn = false
        }
    }

    @IBAction func switchAction(_ sender: Any) {
        if switchBtn.isOn {
            delegate?.feedFollwed(false, layout: layoutInfo)
        }else{
            delegate?.feedFollwed(true, layout: layoutInfo)
        }
    }
}
