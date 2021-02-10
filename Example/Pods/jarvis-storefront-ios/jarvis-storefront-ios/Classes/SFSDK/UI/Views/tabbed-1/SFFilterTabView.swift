//
//  SFFilterTabView.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 22/10/19.
//

import UIKit

protocol SFFilterTabViewDelegate: class {
    func filterTabViewFilterTabbed(_ tabbedView: SFFilterTabView, selectedSortValue: SFSortingValue)
    func filterTabViewFilterTabbed(_ tabbedView: SFFilterTabView, selectedFilter: SFFilter, selectedFilterIndex:Int)
}

class SFFilterTabView: UIView {
    enum SFFilterSection {
        case sort
        case frontend
        case filter
    }

    weak var delegate: SFFilterTabViewDelegate?
    @IBOutlet private weak var collectionView: UICollectionView!
    
    private var sectionsArray: [SFFilterSection] = [SFFilterSection]()
    private var gridLayout: SFGridLayoutParser?
    
    var collectCellId: String { return "kSFFilterTabCollectionCell" }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFFilterTabCollectionCell") }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectionView.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    static func loadFilterTabView() -> SFFilterTabView {
        return Bundle.sfBundle.loadNibNamed("MPFilterTabView", owner: self, options: nil)?.last as! SFFilterTabView
    }
    
    static func getAttributedTextToDisplay(_ label: String, value: String) -> NSAttributedString {
        let labelAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: label)
        labelAttrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor(hex: "506D85")], range: NSRange(location:0, length:labelAttrStr.length))
        
        let valueAttrStr: NSMutableAttributedString = NSMutableAttributedString(string: "\(value)")
        valueAttrStr.addAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 12.0), NSAttributedString.Key.foregroundColor: UIColor(hexString: "8BA6C1")], range: NSRange(location:0, length:valueAttrStr.length))
        labelAttrStr.append(valueAttrStr)
        
        return labelAttrStr
    }
    
    public func configureView(_ item: SFLayoutItem?) {
        gridLayout = item?.gridLayout
        sectionsArray.removeAll()
        if let gridLayout = item?.gridLayout {
            if !gridLayout.sortingKeys.isEmpty {
                sectionsArray.append(.sort)
            }
            
            if !gridLayout.frontendFilters.isEmpty {
                sectionsArray.append(.frontend)
            }
            
            if !gridLayout.filters.isEmpty {
                sectionsArray.append(.filter)
            }
        }
        collectionView.reloadData()
    }

    // MARK: Private Methods
    
    private func getSelectedSortingValue() -> SFSortingValue? {
        if let sortingValues = gridLayout?.sortingKeys, !sortingValues.isEmpty {
            for sortingValue in sortingValues {
                if sortingValue.isSelected {
                    return sortingValue
                }
            }
            
            return sortingValues.first
        }
        
        return nil
    }
}

// MARK: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout

extension SFFilterTabView: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return sectionsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let sectionType: SFFilterSection = sectionsArray[section]
        switch sectionType {
        case .sort:
            return 1
        case .frontend:
            return gridLayout?.frontendFilters.count ?? 0
        case .filter:
            return gridLayout?.filters.count ?? 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectCellId, for: indexPath) as? SFFilterTabCollectionCell {
            let sectionType: SFFilterSection = sectionsArray[indexPath.section]
            switch sectionType {
            case .sort:
                let selectedFilter: SFSortingValue? = getSelectedSortingValue()
                cell.configureCell(selectedFilter)
            case .frontend:
                cell.configureCell(gridLayout?.frontendFilters[indexPath.item])
            case .filter:
                cell.configureCell(gridLayout?.filters[indexPath.item])
            }
            
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        var width: CGFloat = 0
        let sectionType: SFFilterSection = sectionsArray[indexPath.section]
        switch sectionType {
        case .sort:
            if let selectedFilter = getSelectedSortingValue(), let value = selectedFilter.name {
                let attributedText = SFFilterTabView.getAttributedTextToDisplay("Sort: ", value: value)
                width = attributedText.width(withConstrainedHeight: collectionView.frame.size.height)
            }
            
        case .frontend:
            if let filter = gridLayout?.frontendFilters[indexPath.item], let title = filter.title {
                let attributedText = SFFilterTabView.getAttributedTextToDisplay("\(title): ", value: filter.displayNameOfFilterOnCLP())
                width = attributedText.width(withConstrainedHeight: collectionView.frame.size.height)
            }
            
        case .filter:
            if let filter = gridLayout?.filters[indexPath.item], let title = filter.title {
                let attributedText = SFFilterTabView.getAttributedTextToDisplay("\(title): ", value: filter.displayNameOfFilterOnCLP())
                width = attributedText.width(withConstrainedHeight: collectionView.frame.size.height)
            }
        }
        return CGSize(width: width + 30, height: collectionView.frame.size.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch sectionsArray[indexPath.section] {
        case .sort:
            if let selectedSortValue = gridLayout?.sortingKeys[indexPath.item] {
                delegate?.filterTabViewFilterTabbed(self, selectedSortValue: selectedSortValue)
            }
            
        case .frontend:
            if let selectedFilter = gridLayout?.frontendFilters[indexPath.item] {
                delegate?.filterTabViewFilterTabbed(self, selectedFilter: selectedFilter,selectedFilterIndex:indexPath.item)
            }
        case .filter:
            if let selectedFilter = gridLayout?.filters[indexPath.item] {
                delegate?.filterTabViewFilterTabbed(self, selectedFilter: selectedFilter, selectedFilterIndex:(gridLayout?.frontendFilters.count ?? 0) + indexPath.item)
            }
        }
    }
}

extension NSAttributedString {
    func height(withConstrainedWidth width: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    func width(withConstrainedHeight height: CGFloat) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, context: nil)
        
        return ceil(boundingBox.width)
    }
}
