//
//  JRHScrolTabCollectCell.swift
//  BusinessApp
//
//  Created by Prakash Jha on 18/01/19.
//  Copyright © 2019 PayTm. All rights reserved.
//

import UIKit

public class SFScrollTabsCollectCell: UICollectionViewCell {

    @IBOutlet weak private var ttLbl: UILabel!
    @IBOutlet weak private var lineV: UIView!
    
    class var mNib : UINib? {
        get {
            return Bundle.nibWith(name: "SFScrollTabsCollectCell")
        }
    }
    
    func show(title: String, selected: Bool) {
        self.ttLbl.text = title
        
        let ttlClrHex = selected ? "00ACED" : "222222"
        ttLbl.font = UIFont.systemFont(ofSize: 12.0, weight: selected ? .semibold : .regular)
        ttLbl.textColor = UIColor(hex: ttlClrHex)
        self.lineV.alpha = 0.0
        
        if selected {
            UIView.animate(withDuration: 0.2) {
                self.lineV.alpha = 1.0
            }
        }
       
    }
}

// MARK: - SFScrolTabDataModel
public class SFScrolTabDataModel {
    private(set) var title = ""
    private(set) var width = CGFloat(0)
    
    func increaseWidth(by: CGFloat) {
        self.width = width + by
    }
    
    init(ttl: String) {
        self.title = ttl
        self.width = ttl.width(withConstrainedHeight: CGFloat(0.0), font: UIFont.systemFont(ofSize: 14.0, weight: .bold))
    }
    
    
}

extension String {
    func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
}
