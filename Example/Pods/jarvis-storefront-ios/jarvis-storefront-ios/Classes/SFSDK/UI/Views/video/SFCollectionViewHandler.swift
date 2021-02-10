//
//  SFCollectionViewHandler.swift
//  jarvis-storefront-ios
//
//  Created by Chetan Agarwal on 18/12/19.
//

import UIKit

typealias SFDataSourceActionHandler = ((_ action: DataSourceAction, _ pageIndex: Int) -> Void)

enum DataSourceAction {
    case didSelect
    case willAppear
    case didAppear
    case pageChange
}

class SFCollectionViewHandler: NSObject {
    
    private var items: [SFLayoutItem]?
    private var collectionView: UICollectionView
    private var collectionViewHandler: SFDataSourceActionHandler?
    
    var visibleCollectionViewCell: CGSize = .zero {
        didSet {
            playPauseVideo(isHorizontal: false)
        }
    }
    
    init(_ collectionView: UICollectionView, with viewModel: [SFLayoutItem], completionHandler: SFDataSourceActionHandler?) {
        self.items = viewModel
        self.collectionViewHandler = completionHandler
        self.collectionView = collectionView
        self.collectionView.reloadData()
    }
    
}

extension SFCollectionViewHandler: UIScrollViewDelegate {
    
    func playPauseVideo(isHorizontal: Bool) {
        guard let visibleCells = collectionView.visibleCells as? [SFVideoPlayerDelegate] else { return }
        SFVideoPlayer.playVideos(visibleCells, isHorizontal: isHorizontal, of: visibleCollectionViewCell)
    }
}
