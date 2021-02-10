//
//  SFHVideoCell.swift
//  Bolts
//
//  Created by Chetan Agarwal on 18/12/19.
//

import UIKit
import AVFoundation

protocol SFVideoDelegate: NSObjectProtocol{
    func handleDeeplink(url: URL, awaitProcessing: Bool)
    func pushEvent(_ type: String, toTime time: Int?)
}

extension SFVideoDelegate{
    func handleDeeplink(url: URL, awaitProcessing: Bool) { }
    func pushEvent(_ type: String, toTime time: Int?) { }
}

class SFHVideoCell: SFBaseCollCell {
    
    weak var delegate: SFVideoDelegate?
    
    @IBOutlet weak var imgVw: SFPlayerImageView!
    @IBOutlet weak var thinStripImgView: UIImageView!
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var muteButton: UIButton!
    

    override func show(item: SFLayoutItem, cellConfig: SFTableCellPresentInfo) {
        super.show(item: item, cellConfig: cellConfig)
        if let mediaData = item.displayMetadata {
            imgVw.setupVideoPlayer(with: self)
            if let urlString = mediaData["image2_url"] as? String,  let url = URL(string: urlString) {
                imgVw.jr_setImage(with: url)
            }
            
            if let urlString = mediaData["image_url"] as? String, let url = URL(string: urlString) {
                thinStripImgView.jr_setImage(with: url)
            }
        }
        
        muteButton.isSelected = SFVideoPlayer.mute
        thinStripImgView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openLink)))
    }
    
    override func prepareForReuse() {
        imgVw.image = nil
        super.prepareForReuse()
    }
    
    @IBAction func playClicked(_ sender: UIButton) {
        
        sender.isSelected = !sender.isSelected
        if sender.isSelected {
            logVideoEvent(.played)
            SFVideoPlayer.playerAction(videoDetail: self, play: true)
        }else{
            SFVideoPlayer.isAutoPlay = false
            logVideoEvent(SFVideoPlayer.videoPauseQuartile)
            SFVideoPlayer.playerAction(videoDetail: self, play: false)
        }
    }
    
    @IBAction func muteClicked(_ sender: UIButton) {
        sender.isSelected = !sender.isSelected
        SFVideoPlayer.mute = sender.isSelected
    }
    
    @objc func openLink(_ sender: UIGestureRecognizer) {
        
        pushEvent("thinbar_clicked")
        guard  let mediaDeta = self.lItem?.displayMetadata,
            let urlString = mediaDeta["url"] as? String,
            let url = URL(string: urlString),
            let ldelegate = self.delegate else {return}
        
        ldelegate.handleDeeplink(url: url, awaitProcessing: false)
    }
}

//Extension for used to log all event on Google Analytics
extension SFHVideoCell {
    
    func logVideoEvent(_ type: SFHVideoPlayerStatus) {
        
        guard let player = videoLayer?.player else { return }
        let currentSecTime = Int(CMTimeGetSeconds(player.currentTime()))
        
        switch type {
        case .played:
            pushEvent("video_impression")
        case .paused(.first):
            pushEvent("video_first_quartile", toTime: currentSecTime)
        case .paused(.second):
            pushEvent("video_second_quartile", toTime: currentSecTime)
        case .paused(.third):
            pushEvent("video_third_quartile", toTime: currentSecTime)
        case .completed:
            pushEvent("video_completed")
        case .paused(_): break
        }
    }
    
    func pushEvent(_ type: String, toTime time: Int? = nil) {
        
        delegate?.pushEvent(type, toTime: time)
    }
}


extension SFHVideoCell: SFVideoPlayerDelegate {
    
    var videoLayer: AVPlayerLayer? {
        return imgVw.playerLayer
    }
    
    var videoURL: String? {
        guard let metaData = self.lItem?.displayMetadata else { return nil }
        return metaData["video_url"] as? String
    }
    
    func videoStatus(_ status: SFHVideoPlayerStatus) {
        
        if status == .completed {
            logVideoEvent(status)
        }
        playPauseButton.isSelected = status == .played
    }
    
    func videoAudioStatus(_ isMute: Bool) {
        muteButton.isSelected = isMute
    }
}
