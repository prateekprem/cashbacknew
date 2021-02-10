//
//  FSDealsTableCell.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

class FSDealsTableCell: SFBaseTableCellIncCollection {
    
    static var height = 200
    override class func register(table: UITableView) {
        if let mNib = FSDealsTableCell.nib {
            table.register(mNib, forCellReuseIdentifier: FSDealsTableCell.cellId)
        }
    }
    
    override class var cellId: String { return "FSDealsTableCell" }
    override var collectCellId: String { return "FSDealsCollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "FSDealsTableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "FSDealsCollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 145, height: FSDealsTableCell.height)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 20
    }
    
//    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
//        super.show(info: info, indexPath: indexPath)
//        print(info,info)
//        let Offers = info.vItems.filter({$0.offerItems.count > 0})
//        if Offers.count == 0{
//            FSDealsTableCell.height = 220
//        }
//    }
}
