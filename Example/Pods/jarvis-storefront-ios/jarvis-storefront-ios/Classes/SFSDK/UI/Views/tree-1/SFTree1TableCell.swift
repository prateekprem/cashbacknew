//
//  SFTree1TableCell.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 21/10/19.
//

import UIKit

class SFTree1TableCell: SFBaseTableCell {
    @IBOutlet private weak var containerView: UIView!
    @IBOutlet private weak var bannerImageView: UIImageView!
    @IBOutlet private weak var arrowImage: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var subTitleLabel: UILabel!
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var collectionViewHeightConstraint: NSLayoutConstraint!
    
    private var l1Items: [SFLayoutItem] = [SFLayoutItem]()
    private let noOfItemsInARow: Int = 3
    private let collectionCellHeight: CGFloat = 160

    override class func register(table: UITableView) {
        if let mNib = SFTree1TableCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFTree1TableCell.cellId)
        }
    }
    
    override class var cellId: String { return "kSFTree1TableCell" }
    var collectCellId: String { return "kSFTree1L1CollCell" }
    
    private class var nib: UINib? { return Bundle.nibWith(name: "SFTree1TableCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFTree1L1CollCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(collectNib, forCellWithReuseIdentifier: collectCellId)
        addTapGestureToContainerView()
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
        let item: SFLayoutItem? = layout?.vItems[rowIndex]
        configureCell(item)
    }
    
    // MARK: Private Methods
    
    private func addTapGestureToContainerView() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(didTapOnContainerView))
        containerView.addGestureRecognizer(tap)
    }
    
    @objc private func didTapOnContainerView() {
        let item = layout?.vItems[rowIndex]
        if let isExpanded = item?.isExpanded {
            item?.isExpanded = !isExpanded
        }
       
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate, let layoutIndexPath = indexPath else { return }
        delegate.reloadSection(layoutIndexPath)
    }
    
    private func configureCell(_ item: SFLayoutItem?) {
        if let imageUrlString = item?.itemImageUrl, let imageUrl = URL(string: imageUrlString) {
            bannerImageView.setImageFrom(url: imageUrl, placeHolderImg: placeholderImage) { (img, err, cacheType, url) in
            }
        }
        
        titleLabel.text = item?.itemTitle
        subTitleLabel.text = item?.itemSubTitle
        
        l1Items.removeAll()
        if let items = item?.items {
            l1Items.append(contentsOf: items)
        }
        
        if let isExpanded = item?.isExpanded {
            if isExpanded {
                arrowImage.image = UIImage.imageNamed(name: "up_arrow")
            }
            else {
                arrowImage.image = UIImage.imageNamed(name: "down_arrow")
            }
        }
        
        arrowImage.isHidden = l1Items.isEmpty
        calculateCellHeight(item)
        logImpressionForItem(item: item)
        collectionView.reloadData()
    }
    
    private func calculateCellHeight(_ item: SFLayoutItem?) {
        if let isExpanded = item?.isExpanded {
            if isExpanded {
                let noOfRows: CGFloat = CGFloat(l1Items.count) / CGFloat(noOfItemsInARow)
                let totalHeight: CGFloat = CGFloat(ceil(noOfRows)) * collectionCellHeight
                collectionViewHeightConstraint.constant = totalHeight
            }
            else {
                collectionViewHeightConstraint.constant = 0
            }
        }
        
        contentView.layoutIfNeeded()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout
extension SFTree1TableCell: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return l1Items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFTree1L1CollCell {
            let item = l1Items[indexPath.item]
            cell.configureCell(item)
            logImpressionForItem(item: item)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: (collectionView.frame.size.width) / CGFloat(noOfItemsInARow), height: collectionCellHeight)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else { return }
        delegate.sfSDKDidClick(item: l1Items[indexPath.item],viewInfo:mLayout, tableIndex: self.index, collectIndex: indexPath.row)
    }
}
