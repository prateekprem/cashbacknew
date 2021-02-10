//
//  SFBanner3xnTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 11/10/19.
//

import UIKit

class SFBanner3xnTableCell: SFBaseTableCellIncCollection {
    
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private let numberOfItemsInEachRow = 3
    private var collectionCellHeight:Int = 114
    private var collectionCellWidth:Int = Int(UIScreen.main.bounds.width) / 3
        
    override class func register(table: UITableView) {
        if let mNib = SFBanner3xnTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFBanner3xnTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFBanner3xnTableCell" }
    override var collectCellId: String { return "kSFImageCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFBanner3xnTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFImageCollCell") }
    
    var windowWidth: CGFloat {
        if let rootwindow = UIApplication.shared.delegate?.window, let view = rootwindow!.rootViewController?.view{
            return view.bounds.size.width
        }
        return 0
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        collectV.isScrollEnabled = false
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        configureCollectionView()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if self.containerType() == .consumerApp {
            return CGSize(width: collectionCellWidth , height: collectionCellHeight)
        }else{
            let itemWidth:Int = Int(collectionView.frame.size.width) / numberOfItemsInEachRow
            return CGSize(width: itemWidth, height: collectionCellHeight)
        }
    }
    
    private func configureCollectionView() {
        if self.containerType() == .consumerApp {
            let width = UIScreen.main.bounds.width / 3.6
            let height = width / 1.32
            collectionCellWidth = Int(width)
            collectionCellHeight = Int(height)
            collectionViewHeightConstraint.constant = CGFloat(collectionCellHeight * (mList.count/numberOfItemsInEachRow)) + CGFloat(10 * (mList.count/numberOfItemsInEachRow))
        } else {
            collectionViewHeightConstraint.constant = CGFloat(collectionCellHeight * (mList.count/numberOfItemsInEachRow))
        }
        self.layoutIfNeeded()
        collectV.reloadData()
    }
}
