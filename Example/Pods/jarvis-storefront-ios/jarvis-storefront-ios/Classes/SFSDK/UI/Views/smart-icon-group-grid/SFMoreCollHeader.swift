//
//  SFMoreCollHeader.swift
//  jarvis-storefront-ios_Example
//
//  Created by Prakash Jha on 24/10/19.
//  Copyright © 2019 CocoaPods. All rights reserved.
//

import UIKit

public class SFMoreCollHeader: UICollectionReusableView {

    @IBOutlet weak private var ttlLbl: UILabel!

    private static let hNib: UINib? = Bundle.nibWith(name: "SFMoreCollHeader")
    public static let cellId = "kSFMoreCollHeader"
    
    override public func awakeFromNib() {
        super.awakeFromNib()
    }
    
    public class func register(collectV: UICollectionView) {
        collectV.register(SFMoreCollHeader.hNib, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader,
                          withReuseIdentifier: SFMoreCollHeader.cellId)
    }
    
    public func show(ttl: String) {
        self.ttlLbl.text = ttl
    }
}
