//
//  SFTabbedView.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

public protocol SFTabbedViewDelegate: class {
    func tabbedView(_ tabbedView: SFTabbedView, didSelectFilter filter: SFFilter, forItem item: SFLayoutItem, selectedIndex:Int)
    func tabbedView(_ tabbedView: SFTabbedView, didSelectSorting sortKey: SFSortingValue, forItem item: SFLayoutItem)
    func tabbedView(_ tabbedView: SFTabbedView, didSelectItem item: SFLayoutItem)
}

public class SFTabbedView: UIView {

    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var filterTabView: SFFilterTabView!
    @IBOutlet private weak var tabbedViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet private weak var filterTabViewHeightConstraint: NSLayoutConstraint!

    //Public Vars
    public weak var delegate: SFTabbedViewDelegate?
    
    // Private vars
    private var layoutItems: [SFLayoutItem] = [SFLayoutItem]()
    private var selectedIndex: Int = -1
    
    var collectCellId: String { return "kSFTabCollectionCell" }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFTabCollectionCell") }
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    public static func loadTabbedView() -> SFTabbedView {
        return Bundle.sfBundle.loadNibNamed("SFTabbedView", owner: self, options: nil)?.last as! SFTabbedView
    }
    
    public func configureView(_ layout: SFLayoutViewInfo?) {
        layoutItems.removeAll()
        if let items = layout?.vItems, !items.isEmpty {
            layoutItems.append(contentsOf: items)
        }
        
        collectionView.reloadData()
        configureTopTabView(layout)
        configureFilterTabView()
    }
    
    public func selectItemAtIndex(_ index: Int) {
        collectionView(collectionView, didSelectItemAt: IndexPath(item: index, section: 0))
    }
    
    // MARK: Private Methods
    private func configureTopTabView(_ layout: SFLayoutViewInfo? ) {
        if let hideTab = layout?.hideTabbedView {
            if hideTab {
                tabbedViewHeightConstraint.constant = 0
            }
            else {
                tabbedViewHeightConstraint.constant = 50
            }
            
            layoutIfNeeded()
        }
    }
    
    private func configureFilterTabView() {
        filterTabView.isHidden = true
        if selectedIndex != -1, !layoutItems.isEmpty {
            let item: SFLayoutItem = layoutItems[selectedIndex]
            if let gridLayout = item.gridLayout, gridLayout.isFiltersPresent() {
                filterTabView.isHidden = false
                filterTabView.delegate = self
                filterTabView.configureView(item)
            }
        }
    }
    
    private func selectTabAtIndex(_ index: Int) {
        for item in layoutItems {
            item.isSelected = false
        }
        
        if index < layoutItems.count {
            layoutItems[index].isSelected = true
            selectedIndex = index
        }
    }
    
    private func getTabItemWidth(_ item: SFLayoutItem) -> CGFloat {
        var width: CGFloat = 0
        if !item.itemName.isEmpty  {
            let attrString: NSMutableAttributedString = NSMutableAttributedString(string: item.itemName)
            var font: UIFont = tabItemFont
            if layoutItems.count == 1 {
              font = UIFont.systemMediumFontOfSize(16.0)
            }
            attrString.addAttributes([NSAttributedString.Key.font: font], range: NSRange(location:0, length:attrString.length))
            width = attrString.textWidth(withConstrainedHeight: self.frame.size.height)
        }
        
        return width
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SFTabbedView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return layoutItems.count
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFTabCollectionCell {
            cell.configureCollectionCell(layoutItems[indexPath.item])
            if layoutItems.count == 1 {
                cell.hideBottomLineForTabbedView(true)
                cell.makeHeaderBold()
            }
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let item: SFLayoutItem = layoutItems[indexPath.item]
        let width: CGFloat = getTabItemWidth(item)
        return CGSize(width: width + 10, height: collectionView.frame.size.height)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if selectedIndex == indexPath.item {
            return
        }
        
        selectTabAtIndex(indexPath.item)
        collectionView.reloadData()
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        
        delegate?.tabbedView(self, didSelectItem: layoutItems[indexPath.item])
    }
}

extension NSAttributedString {
    func textWidth(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}

extension SFTabbedView: SFFilterTabViewDelegate {
    func filterTabViewFilterTabbed(_ tabbedView: SFFilterTabView, selectedFilter: SFFilter, selectedFilterIndex: Int) {
        if selectedIndex != -1, !layoutItems.isEmpty {
            delegate?.tabbedView(self, didSelectFilter: selectedFilter, forItem: layoutItems[selectedIndex],selectedIndex:selectedFilterIndex)
        }
    }
    
    func filterTabViewFilterTabbed(_ tabbedView: SFFilterTabView, selectedSortValue: SFSortingValue) {
        if selectedIndex != -1, !layoutItems.isEmpty {
            delegate?.tabbedView(self, didSelectSorting: selectedSortValue, forItem: layoutItems[selectedIndex])
        }
    }
}
