//
//  JRCBGridCollFlowLayout.swift
//  jarvis-cashback-ios
//
//  Created by Shubham Raj on 30/07/20.
//

import Foundation

//class JRCBGridCollFlowLayout: UICollectionViewFlowLayout {
//    var safeAreaHeight: CGFloat {
//        return UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0.0
//    }
//    var maxHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 50
//    var totalHeight: CGFloat = 180.0
//    private var isNavHeaderVal: Bool = false
//    //
//    //    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//    //        return true
//    //    }
//    //
//    //    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//    //
//    //        let layoutAttributes = super.layoutAttributesForElements(in: rect)
//    //
//    //
//    //        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
//    //            return layoutAttributes
//    //        }
//    //
//    //        let heightDiff = totalHeight - offset.y
//    //        if heightDiff > maxHeight + 50 {
//    //
//    //            for attributes in stLayoutAttributes {
//    //
//    //                if let elmKind = attributes.representedElementKind, elmKind == UICollectionElementKindSectionHeader {
//    //
//    //                    let diffValue = abs(offset.y)
//    //                    var frame = attributes.frame
//    //                    frame.size.height = max(maxHeight, headerReferenceSize.height + diffValue)
//    //                    frame.origin.y = frame.minY - diffValue
//    //                    checkForHeaderView(isNavHeader: false)
//    //                    print(frame)
//    //                    attributes.frame = frame
//    //                }
//    //            }
//    //        }
//    //        else if heightDiff <= maxHeight + 50 {
//    //            for attributes in stLayoutAttributes {
//    //
//    //                if let elmKind = attributes.representedElementKind, elmKind == UICollectionElementKindSectionHeader {
//    //
//    //                    let diffValue = abs(offset.y)
//    //                    var frame = attributes.frame
//    //                    frame.size.height = max(maxHeight, headerReferenceSize.height - diffValue)
//    //                    frame.origin.y = frame.minY + diffValue
//    //
//    //                    checkForHeaderView(isNavHeader: true)
//    //                    print(frame)
//    //                    attributes.frame = frame
//    //                }
//    //            }
//    //        }
//    //        return layoutAttributes
//    //    }
//    //
//    private func checkForHeaderView(isNavHeader: Bool) {
//        if isNavHeaderVal != isNavHeader {
////            print("func call")
//            self.isNavHeaderVal = isNavHeader
//            collectionView?.visibleSupplementaryViews(ofKind: UICollectionElementKindSectionHeader).forEach { view in
//                if let headerView = view as? JRCBGridHeaderV {
//                    headerView.titleLabel.isHidden = isNavHeader
//                    headerView.navView.isHidden = !isNavHeader
//                    headerView.imgV.isHidden = isNavHeader
//                }
//            }
//        }
//    }
//
//
//
//    // MARK: - Collection View Flow Layout Methods
//
//    override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
//        return true
//    }
//
//    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
//        guard let layoutAttributes = super.layoutAttributesForElements(in: rect) else { return nil }
//
//        // Helpers
//        let sectionsToAdd = NSMutableIndexSet()
//        var newLayoutAttributes = [UICollectionViewLayoutAttributes]()
//
//        for layoutAttributesSet in layoutAttributes {
//            if layoutAttributesSet.representedElementCategory == .cell {
//                // Add Layout Attributes
//                newLayoutAttributes.append(layoutAttributesSet)
//
//                // Update Sections to Add
//                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
//
//            } else if layoutAttributesSet.representedElementCategory == .supplementaryView {
//                // Update Sections to Add
//                sectionsToAdd.add(layoutAttributesSet.indexPath.section)
//            }
//        }
//
//        for section in sectionsToAdd {
//            let indexPath = IndexPath(item: 0, section: section)
//
//            if let sectionAttributes = self.layoutAttributesForSupplementaryView(ofKind: UICollectionElementKindSectionHeader, at: indexPath) {
//                newLayoutAttributes.append(sectionAttributes)
//            }
//        }
//
//        return newLayoutAttributes
//    }
//
//    override func layoutAttributesForSupplementaryView(ofKind elementKind: String, at indexPath: IndexPath) -> UICollectionViewLayoutAttributes? {
//        guard let layoutAttributes = super.layoutAttributesForSupplementaryView(ofKind: elementKind, at: indexPath) else { return nil }
//        guard let boundaries = boundaries(forSection: indexPath.section) else { return layoutAttributes }
//        guard let collectionView = collectionView else { return layoutAttributes }
//
//        // Helpers
//        let contentOffsetY = collectionView.contentOffset.y
//        var frameForSupplementaryView = layoutAttributes.frame
//        let minimum = boundaries.minimum - frameForSupplementaryView.height
//        let maximum = boundaries.maximum - frameForSupplementaryView.height
//
//        if boundaries.minimum == 0.0, boundaries.maximum == 0.0 {
//            frameForSupplementaryView.origin.y = contentOffsetY
//        } else if contentOffsetY < minimum {
//            frameForSupplementaryView.origin.y = minimum
//        } else if contentOffsetY > maximum {
//            frameForSupplementaryView.origin.y = maximum
//        } else {
//            frameForSupplementaryView.origin.y = contentOffsetY
//        }
//
////        if frameForSupplementaryView.origin.y < safeAreaHeight {
////            frameForSupplementaryView.origin.y = -safeAreaHeight
////        }
//
//
////        print("frame is before", frameForSupplementaryView)
//
//
//        let heightDiff = totalHeight - contentOffsetY
////        let diffValue = abs(contentOffsetY)
//        if heightDiff < maxHeight + 50 {
//            frameForSupplementaryView.size.height = maxHeight
//            checkForHeaderView(isNavHeader: true)
//        } else if heightDiff > maxHeight + 50 {
//            frameForSupplementaryView.size.height = totalHeight
//            //            frameForSupplementaryView.size.height = min(totalHeight, headerReferenceSize.height + diffValue)
//            //            frameForSupplementaryView.origin.y = layoutAttributes.frame.minY - diffValue
//            checkForHeaderView(isNavHeader: false)
//        }
//
////        print("frame is after", frameForSupplementaryView)
//        layoutAttributes.frame = frameForSupplementaryView
//
//        return layoutAttributes
//    }
//
//    // MARK: - Helper Methods
//
//    func boundaries(forSection section: Int) -> (minimum: CGFloat, maximum: CGFloat)? {
//        // Helpers
//        var result = (minimum: CGFloat(0.0), maximum: CGFloat(0.0))
//
//        // Exit Early
//        guard let collectionView = collectionView else { return result }
//
//        // Fetch Number of Items for Section
//        let numberOfItems = collectionView.numberOfItems(inSection: section)
//
//        // Exit Early
//        guard numberOfItems > 0 else { return result }
//
//        if let firstItem = layoutAttributesForItem(at: IndexPath(item: 0, section: section)),
//            let lastItem = layoutAttributesForItem(at: IndexPath(item: (numberOfItems - 1), section: section)) {
//            result.minimum = firstItem.frame.minY
//            result.maximum = lastItem.frame.maxY
//
//            // Take Header Size Into Account
//            result.minimum -= totalHeight
//            result.maximum -= totalHeight
//
//            // Take Section Inset Into Account
//            result.minimum -= sectionInset.top
//            result.maximum += (sectionInset.top + sectionInset.bottom)
//        }
//
//        return result
//    }
//}


class JRCBGridCollFlowLayout: UICollectionViewFlowLayout {
    var maxHeight = (UIApplication.shared.keyWindow?.safeAreaInsets.top ?? 0) + 50
    var totalHeight: CGFloat = 180.0
    
   override func shouldInvalidateLayout(forBoundsChange newBounds: CGRect) -> Bool {
        return true
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        let layoutAttributes = super.layoutAttributesForElements(in: rect)
        
        
        guard let offset = collectionView?.contentOffset, let stLayoutAttributes = layoutAttributes else {
            return layoutAttributes
        }
//        print(offset.y)
        if offset.y < 0 {
            
            for attributes in stLayoutAttributes {
                
                if let elmKind = attributes.representedElementKind, elmKind == UICollectionView.elementKindSectionHeader {
                    
                    let diffValue = abs(offset.y)
                    var frame = attributes.frame
                    frame.size.height = max(0, totalHeight + diffValue)
                    frame.origin.y = frame.minY - diffValue
                    attributes.frame = frame
                }
            }
        }
        return layoutAttributes
    }
}
