//
//  SFHVideoContainerCell.swift
//  Bolts
//
//  Created by Chetan Agarwal on 18/12/19.
//

import UIKit

class SFHVideoContainerCell: SFBaseTableCellIncCollection {
    
    override class var cellId: String { return "SFHVideoContainerCell" }
   
    private class var nib: UINib? { return Bundle.nibWith(name: "SFHVideoContainerCell") }
    private var collectNib: UINib? { return Bundle.nibWith(name: "SFHVideoCell") }
    override var collectCellId: String { return "SFHVideoCell" }
    
    private var collectionViewHandler: SFCollectionViewHandler?
    private var visibleVideoSize: CGSize {
        let videoFrameInParentSuperView: CGRect? = self.superview?.superview?.convert(collectV.frame, from: collectV)
        guard let videoFrame = videoFrameInParentSuperView, let superViewFrame = superview?.frame else { return .zero }
        let visibleVideoFrame = videoFrame.intersection(superViewFrame)
        return visibleVideoFrame.size
    }
    
    override class func register(table: UITableView) {
        if let mNib = SFHVideoContainerCell.nib {
            table.register(mNib, forCellReuseIdentifier: SFHVideoContainerCell.cellId)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        collectV.register(collectNib, forCellWithReuseIdentifier: collectCellId)
    }
    
    override func prepareForReuse() {
        collectionViewHandler = nil
    }
    
    override func show(info: SFLayoutViewInfo, indexPath: IndexPath) {
        super.show(info: info, indexPath: indexPath)
    }
    
    //MARK: - CollectionView Delegate
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let endCell = cell as? SFVideoPlayerDelegate else { return }
        SFVideoPlayer.playerAction(videoDetail: endCell, play: false)
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < mList.count else{ return }
        let cellVM = mList[indexPath.row]
        guard let url = cellVM.displayMetadata?["video_url"] as? String else {return}
        SFVideoPlayer.playVideoOnFullScreen(with: url)
    }
}


extension SFHVideoContainerCell: SFVideoDelegate{
    func handleDeeplink(url: URL, awaitProcessing: Bool) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate, let _ = indexPath else { return }
        delegate.sfVideoHandleDeeplink(url: url, awaitProcessing: awaitProcessing)
    }
    
    func pushEvent(_ type: String, toTime time: Int?) {
        guard let mLayout = self.layout, let delegate = mLayout.pDelegate else {return }
        delegate.spVideoPushEvent(type, toTime: time)
    }
}
