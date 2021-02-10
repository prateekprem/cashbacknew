//
//  SFVideoPlayerHelper.swift
//  Bolts
//
//  Created by Chetan Agarwal on 18/12/19.
//

import UIKit
import AVFoundation
import AVKit

protocol SFVideoPlayerDelegate {
    
    var videoURL: String? { get }
    var videoLayer: AVPlayerLayer? { get }
    
    func videoPlayed(to currentTime: Int, of totalTime: Int)
    func videoStatus(_ status: SFHVideoPlayerStatus)
    func videoAudioStatus(_ isMute: Bool)
}

extension SFVideoPlayerDelegate {
    
    func videoStatus(_ playing: Bool) {}
    func videoAudioStatus(_ isMute: Bool) {}
    func videoPlayed(to duration: Int, of totalDuration: Int) {}
}

class SFPlayerImageView: UIImageView {
    
    override class var layerClass: AnyClass {
        return AVPlayerLayer.self
    }
    
    var playerLayer: AVPlayerLayer {
        return layer as! AVPlayerLayer
    }
    
    func setupVideoPlayer(with playerDetail: SFVideoPlayerDelegate) {
        SFVideoPlayer.setupVideoPlayer(with: playerDetail)
    }
}

extension SFVideoPlayer {
    
    class func playVideoOnFullScreen(with url: String? = nil) {
        
        guard let container = SFVideoPlayer.currentVideoContainer(url), var url = URL(string: container.videoURL) else { return }
        
        if let savedFilePath = filePath(of: container.videoURL), FileManager.default.fileExists(atPath: savedFilePath.path) {
            url = savedFilePath
        }
        
        container.player.pause()
        
        let controllerPlayer = AVPlayer(url: url)
        let time = container.player.currentTime()
        controllerPlayer.currentItem?.seek(to: time, completionHandler: nil)
        
        let controller = AVPlayerViewController()
        controller.player = controllerPlayer
        SFVideoPlayer.isPlayingOnFullScreen = true
        
        if let parentController = UIApplication.topViewController() {
            parentController.present(controller, animated: true) {
                DispatchQueue.main.async {
                    controllerPlayer.play()
                }
            }
        }
    }
    
    static var videoFullScreenClose: (_ closeTime: CMTime) -> Void = { (closeTime) in
        
        SFVideoPlayer.isPlayingOnFullScreen = false
        guard let videoContainer = SFVideoPlayer.currentVideoContainer() else { return }
        videoContainer.player.currentItem?.seek(to: closeTime, completionHandler: nil)
        videoContainer.player.play()
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnterForeground),
                                               name: UIApplication.willEnterForegroundNotification,
                                               object: nil)
        
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.appEnteredBackground),
                                               name: UIApplication.didEnterBackgroundNotification,
                                               object: nil)
    }
    
    @objc private func appEnterForeground() {
        guard let videoDetail = delegate, let videoContainer = SFVideoPlayer.currentVideoContainer(), videoContainer.playOn == true else { return }
        SFVideoPlayer.playerAction(videoDetail: videoDetail, play: true)
    }
    
    @objc private func appEnteredBackground() {
        guard let videoDetail = delegate else { return }
        SFVideoPlayer.playerAction(videoDetail: videoDetail, play: false)
    }
}

extension AVPlayerViewController {
    open override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.player?.pause()
        if let time = self.player?.currentTime() {
            SFVideoPlayer.videoFullScreenClose(time)
        }
    }
}

enum SFHVideoPlayerStatus: Equatable {
    case played
    case paused(VideoQuartile)
    case completed
    
    enum VideoQuartile {
        case first
        case second
        case third
        case unknown
    }
}

