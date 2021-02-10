//
//  SFCarouselBs1TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 12/10/19.
//

import UIKit

class SFCarouselBs1TableCell: SFBaseTableCellIncCollection {
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionHeightConstraint: NSLayoutConstraint!
    
    private var collectionCellHeight: CGFloat = 210
    private var collectionCellWidth: CGFloat = 130
    private var collectionCellspacing: CGFloat = 10
    private var isConfigurationNeeded = false
    
    override class func register(table: UITableView) {
        if let mNib = SFCarouselBs1TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFCarouselBs1TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFCarouselBs1TableCell" }
    override var collectCellId: String { return "kSFCarouselBs1CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFCarouselBs1TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFCarouselBs1CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        viewAllButton.isHidden = !info.vSeeAllSeoUrl.isValidString()
        isConfigurationNeeded = false
        if let dimension = info.classType, dimension.isEqualToString(find: "low-dimension-image") {
            isConfigurationNeeded = true
            configurationForConsumerApp()
        }
    }
    
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let mLayout = self.layout, collectCellId.count > 0, let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFCarouselBs1CollCell {
            cell.show(item: mList[indexPath.row], cellConfig: mLayout.cellPresentInfo)
            if isConfigurationNeeded {
                cell.ttlLbl.textColor = #colorLiteral(red: 0.1137254902, green: 0.1450980392, blue: 0.1764705882, alpha: 1)
                cell.ttlLbl.font = UIFont.fontSemiBoldOf(size: 11.0)
                cell.labelTopConstraint.constant = 10
                cell.ttlLbl.numberOfLines = 1
            }
            return cell
        }
        return SFBaseCollCell()
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionCellWidth, height: collectionCellHeight)
    }
    
    override func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionCellspacing
    }
    
    @IBAction func viewAllClicked(_ sender: UIButton) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }        
        delegate.sfDidClickViewAll(mLayout)
    }
    
    private func configurationForConsumerApp() {
        collectionCellHeight = 160
        let collectCellImageHeight:CGFloat = 170.0/210.0 * collectionCellHeight//as per storyboard
        collectionHeightConstraint.constant = collectionCellHeight
        collectionCellWidth = 3 / 4 * collectCellImageHeight
        collectionCellspacing = 16
        collectV.reloadData()
        
    }
}

