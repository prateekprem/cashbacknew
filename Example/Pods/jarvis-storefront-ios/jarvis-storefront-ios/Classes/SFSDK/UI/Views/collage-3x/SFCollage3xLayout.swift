//
//  SFCollage3xLayout.swift
//  jarvis-storefront-ios
//
//  Created by Brammanand Soni on 17/10/19.
//

import UIKit

protocol SFCollage3xLayoutDelegate {
    func colletionView(view: UICollectionView, sizeForItemAt indexPath: IndexPath) -> CGSize
}

class SFCollage3xLayout: UICollectionViewFlowLayout {
    var delegate: SFCollage3xLayoutDelegate!
    
    private var numberOfColumns = 2
    private var cache = [UICollectionViewLayoutAttributes]()
    private var contentHeight: CGFloat  = 0.0
    
    private var contentWidth: CGFloat {
        let insets = collectionView!.contentInset
        return collectionView!.bounds.width - (insets.left + insets.right)
    }
    
    override func prepare() {
        if cache.isEmpty {
            let xOffset = xOffsetsForColumns()
            var column = 0
            var yOffset = [CGFloat](repeating: 0, count: numberOfColumns)
            
            for item in 0 ..< collectionView!.numberOfItems(inSection: 0) {
                let indexPath = IndexPath(item: item, section: 0)
                let cellsize = delegate.colletionView(view: collectionView!, sizeForItemAt: indexPath)
                let frame = CGRect(x: xOffset[column], y: yOffset[column], width: cellsize.width, height: cellsize.height)
                let attributes = UICollectionViewLayoutAttributes(forCellWith: indexPath)
                attributes.frame = frame
                cache.append(attributes)
                contentHeight = max(contentHeight, frame.maxY)
                yOffset[column] = yOffset[column] + cellsize.height
                column += 1
                
                if column >= (numberOfColumns - 1) {
                    column = 1
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
        let contentWidth = SFConstants.windowWidth
        var xOffsets = [CGFloat].init(repeating: 0, count: numberOfColumns)
        xOffsets[0] = 0
        xOffsets[1] = (contentWidth * 0.57)
        return xOffsets
    }
}
