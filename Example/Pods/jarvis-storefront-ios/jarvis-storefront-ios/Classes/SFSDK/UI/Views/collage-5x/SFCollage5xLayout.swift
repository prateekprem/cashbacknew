//
//  SFCollage5xLayout.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 17/10/19.
//

import UIKit

protocol SFCollage5xLayoutDelegate {
    func colletionView(view: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class SFCollage5xLayout: UICollectionViewFlowLayout {
    var delegate: SFCollage5xLayoutDelegate!
    var numberOfColumns = 3
    
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat  = 0.0
    
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        if cache.isEmpty {
            contentHeight = 0
            let xOffset = xOffsetsForColumns()
            var column = 0
            var yOffset = [CGFloat](repeating: 5, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                
                let indexPath = IndexPath(item: item, section: 0)
                let cellsize = delegate.colletionView(view: collectionView!, sizeForItemAt: indexPath)
                let height: CGFloat = cellsize.height + paddingForIndexPath(indexPath)
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellsize.width, height: cellsize.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                contentHeight = max(contentHeight, (frame.maxY + paddingForIndexPath(indexPath)))
                yOffset[column] = yOffset[column] + height
                column += 1
                
                if indexPath.row == 0 {
                    column = 0
                }
                
                if column >= (numberOfColumns - 1) {
                    column = 2
                }
            }
        }
    }
    
    override var collectionViewContentSize: CGSize {
        return CGSize(width: contentWidth, height: contentHeight)
    }
    
    override func layoutAttributesForElements(in rect: CGRect) -> [UICollectionViewLayoutAttributes]? {
        
        var layoutAttributes = [UICollectionViewLayoutAttributes]()
        for attributes in cache {
            if attributes.frame.intersects(rect) {
                layoutAttributes.append(attributes)
            }
        }
        return layoutAttributes
    }
    
    private func xOffsetsForColumns() -> [CGFloat] {
        let contentWidth = SFConstants.windowWidth - 30
        var xOffsets = [CGFloat](repeating: 0, count: numberOfColumns)
        xOffsets[0] = 15
        xOffsets[1] = xOffsets[0] + (contentWidth * 0.29) + 5
        xOffsets[2] = xOffsets[1] + (contentWidth * 0.415)
        return xOffsets
    }
    
    private func paddingForIndexPath(_ indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0, 3 :
            return 5
        default:
            return 0
        }
    }
}
