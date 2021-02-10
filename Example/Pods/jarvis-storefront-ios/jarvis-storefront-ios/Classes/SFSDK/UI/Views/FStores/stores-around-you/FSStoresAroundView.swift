//
//  FSStoresAroundView.swift
//  jarvis-storefront-ios
//
//  Created by Sumit Jain on 02/12/19.
//

import UIKit

public protocol FStoresAroundViewDelegate: class {
    
    func tabbedStoreView(_ tabbedView: FSStoresAroundView, didSelectItem item: SFLayoutItem, index: IndexPath)
}

public class FSStoresAroundView: UIView {
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var collection: UICollectionView!
    @IBOutlet weak var viewAllBtn: UIButton!
    @IBOutlet weak var viewAllIcon: UIButton!
    @IBOutlet weak var collectionTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleHeightConstraint: NSLayoutConstraint!
    
    //Public Vars
    public weak var delegate: FStoresAroundViewDelegate?
    
    // Private vars
    private var layoutItems: [SFLayoutItem] = [SFLayoutItem]()
    public lazy var selectedIndex = 0
    private var layoutInfo: SFLayoutViewInfo?
    
    var collectCellId: String { return "FSStoresAroundCollCell" }
    private var collectNib: UINib? { return Bundle.nibWith(name: "FSStoresAroundCollCell") }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        collection.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    public static func loadView() -> FSStoresAroundView {
        return Bundle.sfBundle.loadNibNamed("FSStoresAroundView", owner: self, options: nil)?.last as! FSStoresAroundView
    }
    
    public func configureView(_ layout: SFLayoutViewInfo?, isTitleHide: Bool = false) {
        layoutItems.removeAll()
        layoutInfo = layout
        if let selIndex = layout?.storeSelectedIndex{
            selectedIndex = selIndex
        }
        if let items = layout?.vItems, !items.isEmpty {
            layoutItems.append(contentsOf: items)
        }
        titleLabel.text = layout?.vTitle
        collection.reloadData()
        if isTitleHide {
            viewAllBtn.isHidden = true
            viewAllIcon.isHidden = true
            titleLabel.isHidden = true
            collectionTopConstraint.constant = 0
            titleHeightConstraint.constant = 0
        }else{
            viewAllBtn.isHidden = false
            viewAllIcon.isHidden = false
            titleLabel.isHidden = false
            collectionTopConstraint.constant = 15
            titleHeightConstraint.constant = 21
        }
    }
    
    override public func layoutSubviews() {
        super.layoutSubviews()
        if selectedIndex != 0 {
            collection.scrollToItem(at: IndexPath(item: self.selectedIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
    }
    
    private func viewAllClicked() {
        guard let mLayout = self.layoutInfo, let delegate = mLayout.pDelegate else { return }
        delegate.sfDidClickViewAll(mLayout)
    }
    
    @IBAction func viewAllButtonClicked(_ sender: Any) {
        viewAllClicked()
    }
    @IBAction func viewAllIconClicked(_ sender: Any) {
        viewAllClicked()
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension FSStoresAroundView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? FSStoresAroundCollCell {
            var isSelected = false
            if selectedIndex == indexPath.item {
                isSelected = true
            }
            cell.configureCollectionCell(layoutItems[indexPath.item], isSelected: isSelected)
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 80, height: 120)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedIndex = indexPath.item
        delegate?.tabbedStoreView(self, didSelectItem: layoutItems[indexPath.item] , index: indexPath)
    }
}
