//
//  SFVideoPlayer.swift
//  Bolts
//
//  Created by Chetan Agarwal on 18/12/19.
//

import Foundation
import AVFoundation

class SFVideoContainer {
    var videoURL: String
    var playOn: Bool = false {
        didSet {
            player.isMuted = SFVideoPlayer.mute
            playerItem.preferredPeakBitRate = SFVideoPlayer.preferredPeakBitRate
            if playOn && playerItem.status == .readyToPlay {
                player.play()
            }
            else{
                player.pause()
            }
        }
    }
    let player: AVPlayer
    let playerItem: AVPlayerItem
    
    init(player: AVPlayer, item: AVPlayerItem, url: String) {
        self.player = player
        self.playerItem = item
        self.videoURL = url
    }
}

class SFVideoPlayer: NSObject {
    
    static public var mute = true {
        didSet {
            shared.delegate?.videoAudioStatus(mute)
            shared.currentLayer?.player?.isMuted = mute
        }
    }
    
    class private var directoryPath: URL? {
        guard let dirPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).last else { return nil }
        
        let path = dirPath.appendingPathComponent("home_ad_widget_video")
        if !FileManager.default.fileExists(atPath: path.absoluteString) {
            try? FileManager.default.createDirectory(at: path, withIntermediateDirectories: false, attributes: nil)
        }
        return path
    }
    
    static public var isRepeat = false
    static public var isAutoPlay: Bool = true
    static public var isPlayingOnFullScreen: Bool = false
    static public var preferredPeakBitRate: Double = 1000000
    static public var minimumLayerHeightToPlay: CGFloat = 100
    static public var minimumLayerWidthToPlay: CGFloat = 100
    static public var videoPauseQuartile: SFHVideoPlayerStatus = .paused(.unknown)
    
    var delegate: SFVideoPlayerDelegate?
    static var shared: SFVideoPlayer = SFVideoPlayer()
    
    private var currentLayer: AVPlayerLayer? {
        didSet {
            if let layer = currentLayer {
                SFVideoPlayer.minimumLayerHeightToPlay = layer.videoRect.midY
                SFVideoPlayer.minimumLayerWidthToPlay = layer.videoRect.midX
            }
        }
    }
    
    private var videoURL: String?
    private var videoCache: NSCache = NSCache<NSString, SFVideoContainer>()
    private var observingURLs = Dictionary<String, Bool>()
    private var timeObserver: Any?
    private var asset: AVURLAsset?
    
    
    private override init() {
        super.init()
        videoCache.delegate = self
        videoCache.countLimit = 1
        setupNotification()
        setupAudio()
    }
    
    private func setupAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSession.Category.playback, mode: AVAudioSession.Mode.default, options: .mixWithOthers) //For playing volume when phone is on silent
        } catch {
            print(error.localizedDescription)
        }
    }
    
    class func currentVideoContainer(_ url: String? = nil) -> SFVideoContainer? {
        guard let url = url ?? shared.videoURL, let videoContainer = shared.videoCache.object(forKey: url as NSString) else { return nil }
        return videoContainer
    }
    
    public class func setupVideoPlayer(with videoDetail: SFVideoPlayerDelegate)  {
        
        videoDetail.videoAudioStatus(mute)
        
        if let url = videoDetail.videoURL, let _ = shared.videoCache.object(forKey: url as NSString) {
            playVideo(with: videoDetail)
        }else{
            setupAssets(for: videoDetail)
        }
    }
    
    fileprivate class func setupAssets(for videoDetail: SFVideoPlayerDelegate) {
        
        guard let urlStr = videoDetail.videoURL, var url = URL(string: urlStr) else { return }
        
        if let savedFilePath = filePath(of: urlStr), FileManager.default.fileExists(atPath: savedFilePath.path) {
            url = savedFilePath
        }
        
        shared.asset = AVURLAsset(url: url)
        
        let requestedKeys = ["playable"]
        
        guard let asset = shared.asset else { return }
        
        asset.loadValuesAsynchronously(forKeys: requestedKeys) {
            
            var error: NSError? = nil
            let status = asset.statusOfValue(forKey: "playable", error: &error)
            
            switch status {
            case .loaded:
                break
            case .failed, .cancelled:
                return
            default:
                print("Unkown state of asset")
                return
            }
            setupPlayer(for: asset, with: videoDetail)
        }
    }
    
    private class func setupPlayer(for asset: AVURLAsset, with videoDetail: SFVideoPlayerDelegate) {
        
        let player = AVPlayer()
        let item = AVPlayerItem(asset: asset)
        
        DispatchQueue.main.async {
            
            guard let url = videoDetail.videoURL, let layer = videoDetail.videoLayer else { return }
            
            let videoContainer = SFVideoContainer(player: player, item: item, url: url)
            videoContainer.player.replaceCurrentItem(with: videoContainer.playerItem)
            shared.videoCache.setObject(videoContainer, forKey: url as NSString)
            
            if shared.videoURL == nil && shared.currentLayer == nil {
                shared.videoURL = url
                shared.currentLayer = layer
            }
            
            if shared.videoURL == url, isAutoPlay {
                playVideo(with: videoDetail)
            }
        }
    }
    
    private class func playVideo(with videoDetail: SFVideoPlayerDelegate) {
        
        guard let url = videoDetail.videoURL, let layer = videoDetail.videoLayer, SFVideoPlayer.isAutoPlay else { return }
        
        shared.delegate = videoDetail
        shared.currentLayer = layer
        shared.videoURL = url
        
        if let videoContainer = shared.videoCache.object(forKey: url as NSString) {
            layer.player = videoContainer.player
            videoContainer.playOn = true
            shared.addObservers(url: url, container: videoContainer)
        }
        
        // Give chance for current video player to be ready to play
        DispatchQueue.main.async {
            if let videoContainer = shared.videoCache.object(forKey: url as NSString),
                videoContainer.player.currentItem?.status == .readyToPlay  {
                videoContainer.playOn = true
            }
        }
    }
    
    private class func pauseVideo(forLayer layer: AVPlayerLayer, url: String) {
        
        shared.currentLayer = nil
        shared.videoURL = nil
        
        guard let videoContainer = currentVideoContainer(url) else { return }
        videoContainer.playOn = false
        shared.removeObserverFor(url: url)
    }
    
    class func removeFromSuperLayer(layer: AVPlayerLayer, url: String) {
        pauseVideo(forLayer: layer, url: url)
        layer.player = nil
    }
    
    private func removeObserverFor(url: String) {
        
        if let videoContainer = videoCache.object(forKey: url as NSString), let currentItem = videoContainer.player.currentItem, observingURLs[url] == true {
            
            videoContainer.playOn = false
            
            currentItem.removeObserver(self,
                                       forKeyPath: "status",
                                       context: nil)
            
            NotificationCenter.default.removeObserver(self,
                                                      name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                      object: currentItem)
            observingURLs[url] = false
        }
    }
    
    // Play video again in case the current player has finished playing
    @objc private func playerDidFinishPlaying(note: NSNotification) {
        
        guard let playerItem = note.object as? AVPlayerItem, let container = SFVideoPlayer.currentVideoContainer() else {
            return
        }
        
        let currentPlayer = container.player
        if let currentItem = currentPlayer.currentItem, currentItem == playerItem, SFVideoPlayer.isRepeat {
            replayVideo(currentPlayer)
        }else{
            delegate?.videoStatus(.completed)
            currentPlayer.seek(to: CMTime.zero)
            
        }
        saveToLocal(asset: asset)
    }
    
    private func replayVideo(_ player: AVPlayer) {
        player.seek(to: CMTime.zero)
        player.play()
    }
    
    private func addObservers(url: String, container: SFVideoContainer) {
        
        if observingURLs[url] == false || observingURLs[url] == nil {
            
            container.player.currentItem?.addObserver(self,
                                                      forKeyPath: "status",
                                                      options: [.new, .initial],
                                                      context:nil)
            
            addPeriodicTimeObserver(url, with: container.player)
            
            container.player.addObserver(self,
                                         forKeyPath: "timeControlStatus",
                                         options: [.old, .new],
                                         context: nil)
            
            NotificationCenter.default.addObserver(self,
                                                   selector: #selector(self.playerDidFinishPlaying(note:)),
                                                   name: NSNotification.Name.AVPlayerItemDidPlayToEndTime,
                                                   object: container.player.currentItem)
            observingURLs[url] = true
        }
    }
    
    // Play video only when current videourl's player is ready to play
    internal override func observeValue(forKeyPath keyPath: String?, of object: Any?,
                                        change: [NSKeyValueChangeKey: Any]?,
                                        context: UnsafeMutableRawPointer?) {
        
        if keyPath == "status" {
            
            if let newStatusInt = change?[NSKeyValueChangeKey.newKey] as? Int, let newStatus = AVPlayerItem.Status(rawValue: newStatusInt) {
                
                guard let item = object as? AVPlayerItem, let videoContainer = SFVideoPlayer.currentVideoContainer(), item == videoContainer.player.currentItem, videoContainer.playOn == true else {
                    return
                }
                switch newStatus {
                case .readyToPlay:
                    videoContainer.playOn = true
                case .failed:
                    print("Url player failed")
                case .unknown:
                    print("error unknown")
                }
            }
            
        }else if keyPath == "timeControlStatus" {
            
            if let newValue = change?[NSKeyValueChangeKey.newKey] as? Int, let oldValue = change?[NSKeyValueChangeKey.oldKey] as? Int {
                
                let oldStatus = AVPlayer.TimeControlStatus(rawValue: oldValue)
                let newStatus = AVPlayer.TimeControlStatus(rawValue: newValue)
                
                if (newStatus == .playing && oldStatus == .waitingToPlayAtSpecifiedRate) || (oldStatus == .playing && newStatus == .paused) {
                    DispatchQueue.main.async {[weak self] in
                        self?.delegate?.videoStatus(newStatus == .playing ? .played : SFVideoPlayer.videoPauseQuartile)
                    }
                }
            }
        }
    }
    
    private func addPeriodicTimeObserver(_ url: String, with player: AVPlayer) {
        
        // Invoke callback every half second
        let interval = CMTime(seconds: 0.1,
                              preferredTimescale: CMTimeScale(NSEC_PER_SEC))
        
        timeObserver = player.addPeriodicTimeObserver(forInterval: interval, queue: DispatchQueue.global()) { [weak self] time in
            
            guard let strongSelf = self, let duration = player.currentItem?.duration, CMTimeGetSeconds(duration) != Double.nan, CMTimeGetSeconds(time) != Double.nan else { return }
            
            let totalDuration = Double(CMTimeGetSeconds(duration))
            let currentTime = Double(CMTimeGetSeconds(time))
            SFVideoPlayer.videoPauseQuartile = strongSelf.videoQuartile(of: currentTime, from: totalDuration)
        }
    }
    
    
    private func videoQuartile(of currentTime: Double, from totalTime: Double) -> SFHVideoPlayerStatus {
        
        print("currentTime \(currentTime) \n totalTime \(totalTime)")
        
        let firstQuartile = totalTime/4.0
        let secondQuartile = totalTime/2.0
        let thirdQuartile = (3.0 * totalTime)/4.0
        
        if currentTime >= firstQuartile && currentTime < secondQuartile {
            return .paused(.first)
        }else if currentTime >= secondQuartile && currentTime < thirdQuartile {
            return .paused(.second)
        }else if currentTime >= thirdQuartile && currentTime < totalTime {
            return .paused(.third)
        }
        return .paused(.unknown)
    }
}

//Save file locally for offline mode
extension SFVideoPlayer {
    
    class func filePath(of urlStr: String) -> URL? {
        
        guard let urlFileName = urlStr.split(separator: "/").last else { return nil }
        let filename = String(urlFileName)
        let outputURL = directoryPath?.appendingPathComponent(filename)
        return outputURL
    }
    
    private func saveToLocal(asset: AVURLAsset?) {
        
        guard let asset = asset, let urlString = videoURL, let outputURL = SFVideoPlayer.filePath(of: urlString) else { return }
        
        asset.resourceLoader.setDelegate(self, queue: DispatchQueue(label: "AssetResourceLoaderQueue"))
        
        if !FileManager.default.fileExists(atPath: outputURL.path) {
            
            removeSavedData()
            let exporter = AVAssetExportSession(asset: asset, presetName: AVAssetExportPresetHighestQuality)
            exporter?.outputURL = outputURL
            exporter?.outputFileType = AVFileType.mp4
            exporter?.exportAsynchronously { }
        }
    }
    
    private func removeSavedData() {
        
        guard let dirPath = SFVideoPlayer.directoryPath else {return}
        let pathContents = try? FileManager.default.contentsOfDirectory(at: dirPath, includingPropertiesForKeys: nil, options: .skipsHiddenFiles)
        guard let urlContents = pathContents else {return}
        
        //I am maintaining pool where i can save 5 video in directory
        //        if urlContents.count > 1 {
        for i in 0..<urlContents.count {
            try? FileManager.default.removeItem(atPath: urlContents[i].absoluteString)
        }
        //        }
    }
}

extension SFVideoPlayer: AVAssetResourceLoaderDelegate {}

extension SFVideoPlayer: NSCacheDelegate {
    
    func cache(_ cache: NSCache<AnyObject, AnyObject>, willEvictObject obj: Any) {
        if let videoObject = obj as? SFVideoContainer {
            observingURLs[videoObject.videoURL] = false
        }
    }
}


//Helpful in auto play video in Tableview and collectionview cell
extension SFVideoPlayer {
    
    private class func getVisibleCellData(visibleCells: [SFVideoPlayerDelegate], isHorizontal: Bool, of visibleSize: CGSize) -> (container: SFVideoPlayerDelegate?, visibleCellSize: CGFloat) {
        
        var videoCellContainer: SFVideoPlayerDelegate?
        var maxLayerLayout: CGFloat = 0.0
        for cellContainer in visibleCells {
            
            guard let videoCellURL = cellContainer.videoURL, let layer = cellContainer.videoLayer else { continue }
            
            let layerLayout = isHorizontal ? visibleSize.width : visibleSize.height
            if maxLayerLayout < layerLayout {
                maxLayerLayout = layerLayout
                videoCellContainer = cellContainer
            }
            pauseVideo(forLayer: layer, url: videoCellURL)
        }
        minimumLayerWidthToPlay = videoCellContainer?.videoLayer?.frame.midX ?? 0
        minimumLayerHeightToPlay = videoCellContainer?.videoLayer?.frame.midY ?? 0
        return (videoCellContainer, maxLayerLayout)
    }
    
    
    public class func playVideos(_ visibleCells: [SFVideoPlayerDelegate], isHorizontal: Bool, of visibleSize: CGSize) {
        
        let videoCellData = getVisibleCellData(visibleCells: visibleCells, isHorizontal: isHorizontal, of: visibleSize)
        let videoCellContainer = videoCellData.container
        let visibleCellSize: CGFloat = videoCellData.visibleCellSize
        
        guard let cellContainer = videoCellContainer else { return }
        
        let minLayoutToPlay = isHorizontal ? minimumLayerWidthToPlay : minimumLayerHeightToPlay
        
        if visibleCellSize > minLayoutToPlay{
            playVideo(with: cellContainer)
        }
    }
}


extension SFVideoPlayer {
    
    public class func playerAction(videoDetail: SFVideoPlayerDelegate, play: Bool) {
        
        guard let container = currentVideoContainer(videoDetail.videoURL) else {
            setupAssets(for: videoDetail)
            return
        }
        shared.delegate = videoDetail
        shared.videoURL = videoDetail.videoURL
        shared.currentLayer = videoDetail.videoLayer
        if let player = videoDetail.videoLayer?.player, player.currentTime() == player.currentItem?.duration, play {
            shared.replayVideo(player)
        }else{
            container.playOn = play
        }
    }
    
    public class func stop(videoDetail: SFVideoPlayerDelegate? = nil) {
        
        let detail: SFVideoPlayerDelegate? = videoDetail ?? shared.delegate
        guard let url = detail?.videoURL ?? shared.videoURL, let layer = detail?.videoLayer ?? shared.currentLayer else { return }
        detail?.videoStatus(videoPauseQuartile)
        pauseVideo(forLayer: layer, url: url)
        shared.delegate = videoDetail
    }
}



