//
//  VideoPlayerView.swift
//  YouTubePlayer
//
//  Created by Giles Van Gruisen on 12/21/14.
//  Copyright (c) 2014 Giles Van Gruisen. All rights reserved.
//
import UIKit
import WebKit
import Foundation

let kYTPlayerStateUnstartedCode:String = "-1"
let kYTPlayerStateEndedCode:String = "0"
let kYTPlayerStatePlayingCode:String = "1"
let kYTPlayerStatePausedCode:String = "2"
let kYTPlayerStateBufferingCode:String = "3"
let kYTPlayerStateCuedCode:String = "5"
let kYTPlayerStateUnknownCode:String = "unknown"

// Constants representing playback quality.
let kYTPlaybackQualitySmallQuality: String = "small"
let kYTPlaybackQualityMediumQuality: String = "medium"
let kYTPlaybackQualityLargeQuality: String = "large"
let kYTPlaybackQualityHD720Quality: String = "hd720"
let kYTPlaybackQualityHD1080Quality: String = "hd1080"
let kYTPlaybackQualityHighResQuality: String = "highres"
let kYTPlaybackQualityAutoQuality: String = "auto"
let kYTPlaybackQualityDefaultQuality: String = "default"
let kYTPlaybackQualityUnknownQuality: String = "unknown"

// Constants representing YouTube player errors.
let kYTPlayerErrorInvalidParamErrorCode: String = "2"
let kYTPlayerErrorHTML5ErrorCode: String = "5"
let kYTPlayerErrorVideoNotFoundErrorCode: String = "100"
let kYTPlayerErrorNotEmbeddableErrorCode: String = "101"
let kYTPlayerErrorCannotFindVideoErrorCode: String = "105"
let kYTPlayerErrorSameAsNotEmbeddableErrorCode: String = "150"

// Constants representing player callbacks.
let kYTPlayerCallbackOnReady: String = "onReady"
let kYTPlayerCallbackOnStateChange: String = "onStateChange"
let kYTPlayerCallbackOnPlaybackQualityChange: String = "onPlaybackQualityChange"
let kYTPlayerCallbackOnError: String = "onError"
let kYTPlayerCallbackOnPlayTime: String = "onPlayTime"

let kYTPlayerCallbackOnYouTubeIframeAPIReady: String = "onYouTubeIframeAPIReady"
let kYTPlayerCallbackOnYouTubeIframeAPIFailedToLoad: String = "onYouTubeIframeAPIFailedToLoad"

let kYTPlayerEmbedUrlRegexPattern: String = "^http(s)://(www.)youtube.com/embed/(.*)$"
let kYTPlayerAdUrlRegexPattern: String = "^http(s)://pubads.g.doubleclick.net/pagead/conversion/"
let kYTPlayerOAuthRegexPattern: String = "^http(s)://accounts.google.com/o/oauth2/(.*)$"
let kYTPlayerStaticProxyRegexPattern: String = "^https://content.googleapis.com/static/proxy.html(.*)$"
let kYTPlayerSyndicationRegexPattern: String = "^https://tpc.googlesyndication.com/sodar/(.*).html$"

/** These enums represent the state of the current video in the player. */
public enum YTPlayerState:Int {
    case unstarted
    case ended
    case playing
    case paused
    case buffering
    case cued
    case unknown
}

/** These enums represent the resolution of the currently loaded video. */
public enum YTPlaybackQuality:Int {
    case kYTPlaybackQualitySmall
    case kYTPlaybackQualityMedium
    case kYTPlaybackQualityLarge
    case kYTPlaybackQualityHD720
    case kYTPlaybackQualityHD1080
    case kYTPlaybackQualityHighRes
    case kYTPlaybackQualityAuto /** Addition for YouTube Live Events. */
    case kYTPlaybackQualityDefault
    case kYTPlaybackQualityUnknown /** This should never be returned. It is here for future proofing. */
}

/** These enums represent error codes thrown by the player. */
public enum YTPlayerError:Int {
    case kYTPlayerErrorInvalidParam
    case kYTPlayerErrorHTML5Error
    case kYTPlayerErrorVideoNotFound // Functionally equivalent error codes 100 and
    // 105 have been collapsed into |kYTPlayerErrorVideoNotFound|.
    case kYTPlayerErrorNotEmbeddable // Functionally equivalent error codes 101 and
    // 150 have been collapsed into |kYTPlayerErrorNotEmbeddable|.
    case kYTPlayerErrorUnknown
}

/** Completion handlers for player API calls. */
public typealias YTIntCompletionHandler = (Int,Error?)->Void
public typealias YTFloatCompletionHandler = (Float,Error?)->Void
public typealias YTDoubleCompletionHandler = (Double,Error?)->Void
public typealias YTStringCompletionHandler = (String?,Error?)->Void
public typealias YTArrayCompletionHandler = ([AnyObject]?,Error?)->Void
public typealias YTURLCompletionHandler = (URL?,Error?)->Void
public typealias YTPlayerStateCompletionHandler = (YTPlayerState, Error?)->Void
public typealias YTPlaybackQualityCompletionHandler = (YTPlaybackQuality, Error?)->Void


open class YTPlayerView: UIView, WKNavigationDelegate {
    
    private var initialLoadingView: UIView!
    private var webView : WKWebView?
    
    
    private var _originURL:NSURL!
    private var originURL:NSURL! {
        get {
            if (_originURL == nil) {
                let bundleId:String! = Bundle.main.bundleIdentifier
                _originURL = NSURL(string: String(format:"http://%@", bundleId))
            }
            return _originURL
        }
        set { _originURL = newValue }
    }
        
    public weak var delegate: YTPlayerViewDelegate?
    
    @discardableResult public func load(withVideoId videoId: String) -> Bool {
        return self.load(withVideoId: videoId, playerVars:nil)
    }
    
    @discardableResult public func loadWithPlaylistId(_ playlistId: String) -> Bool {
        return self.loadWithPlaylistId(playlistId, playerVars: nil)
    }
    
    @discardableResult public func load(withVideoId videoId: String, playerVars: [AnyHashable: Any]?) -> Bool {
        
        var playerVariables = playerVars
        if (playerVariables == nil) {
            playerVariables = [:]
        }
        let playerParams = ["videoId" : videoId, "playerVars" : playerVariables!] as [AnyHashable : Any]
        return self.loadWithPlayerParams(additionalPlayerParams: playerParams)
    }
    
    public func loadWithPlaylistId(_ playlistId: String?, playerVars: [AnyHashable : Any]?) -> Bool {
        
        // Mutable copy because we may have been passed an immutable config dictionary.
        var tempPlayerVars: [AnyHashable : Any] = [:]
        tempPlayerVars["listType"] = "playlist"
        tempPlayerVars["list"] = playlistId
        if let playerVars = playerVars {
            for (k, v) in playerVars { tempPlayerVars[k] = v }
        }
        
        let playerParams = [
            "playerVars": tempPlayerVars
        ]
        
        return loadWithPlayerParams(additionalPlayerParams: playerParams)
    }
    
    public func playVideo() {
        evaluateJavaScript("player.playVideo();")
    }
    
    public func pauseVideo() {
        notifyDelegateOfYouTubeCallbackUrl(URL(string: "ytplayer://onStateChange?data=\(kYTPlayerStatePausedCode)"))
        evaluateJavaScript("player.pauseVideo();")
    }
    
    public func stopVideo() {
        evaluateJavaScript("player.stopVideo();")
    }
    
    public func seek(toSeconds seekToSeconds: Float, allowSeekAhead: Bool) {
        let secondsValue = NSNumber(value: seekToSeconds)
        let allowSeekAheadValue = stringForJSBoolean(allowSeekAhead)
        let command = "player.seekTo(\(secondsValue), \(allowSeekAheadValue));"
        evaluateJavaScript(command)
    }
    
    public func cueVideo(
        byId videoId: String?,
        startSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let command = "player.cueVideoById('\(videoId ?? "")', \(startSecondsValue));"
        evaluateJavaScript(command)
    }
    
    public func cueVideo(
        byId videoId: String?,
        startSeconds: Float,
        endSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let endSecondsValue = NSNumber(value: endSeconds)
        let command = String(
            format: """
                player.cueVideoById({'videoId': '%@',\
                'startSeconds': %@, 'endSeconds': %@});
                """, videoId ?? "", startSecondsValue, endSecondsValue)
        evaluateJavaScript(command)
    }
    
    public func loadVideo(
        byId videoId: String?,
        startSeconds: Float,
        endSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let endSecondsValue = NSNumber(value: endSeconds)
        let command = String(
            format: """
                player.loadVideoById({'videoId': '%@',\
                'startSeconds': %@, 'endSeconds': %@});
                """, videoId ?? "", startSecondsValue, endSecondsValue)
        evaluateJavaScript(command)
    }
    
    public func cueVideo(
        byURL videoURL: String?,
        startSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let command = "player.cueVideoByUrl('\(videoURL ?? "")', \(startSecondsValue));"
        evaluateJavaScript(command)
    }
    
    public func cueVideo(
        byURL videoURL: String?,
        startSeconds: Float,
        endSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let endSecondsValue = NSNumber(value: endSeconds)
        let command = "player.cueVideoByUrl('\(videoURL ?? "")', \(startSecondsValue), \(endSecondsValue));"
        evaluateJavaScript(command)
    }
    
    public func loadVideo(
        byURL videoURL: String?,
        startSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let command = "player.loadVideoByUrl('\(videoURL ?? "")', \(startSecondsValue));"
        evaluateJavaScript(command)
    }
    
    public func loadVideo(
        byURL videoURL: String?,
        startSeconds: Float,
        endSeconds: Float
    ) {
        let startSecondsValue = NSNumber(value: startSeconds)
        let endSecondsValue = NSNumber(value: endSeconds)
        let command = "player.loadVideoByUrl('\(videoURL ?? "")', \(startSecondsValue), \(endSecondsValue));"
        evaluateJavaScript(command)
    }
    
    // MARK: - Cueing methods for lists
    public func cuePlaylist(
        byPlaylistId playlistId: String?,
        index: Int,
        startSeconds: Float) {
        
        let playlistIdString = "'\(playlistId ?? "")'"
        cuePlaylist(
            cueingString: playlistIdString,
            index: index,
            startSeconds: startSeconds)
    }
    
    public func cuePlaylist(
        byVideos videoIds: [AnyHashable]?,
        index: Int,
        startSeconds: Float) {
        cuePlaylist(
            cueingString: string(fromVideoIdArray: videoIds),
            index: index,
            startSeconds: startSeconds)
    }
    
    public func loadPlaylist(
        byPlaylistId playlistId: String?,
        index: Int,
        startSeconds: Float
    ) {
        let playlistIdString = "'\(playlistId ?? "")'"
        loadPlaylist(
            playlistIdString,
            index: index,
            startSeconds: startSeconds)
    }
    
    public func loadPlaylist(
        byVideos videoIds: [AnyHashable]?,
        index: Int,
        startSeconds: Float
    ) {
        loadPlaylist(
            string(fromVideoIdArray: videoIds),
            index: index,
            startSeconds: startSeconds)
    }
    
//    public func playbackRate(_ completionHandler: YTFloatCompletionHandler?) {
//        evaluateJavaScript(
//            "player.getPlaybackRate();",
//            completionHandler: { result, error in
//                if completionHandler == nil {
//                    return
//                }
//                if let error = error {
//                    completionHandler?(-1, error as NSError)
//                    return
//                }
//                if result == nil || !(result is NSNumber) {
//                    completionHandler?(0, nil)
//                    return
//                }
//                completionHandler?((result as? NSNumber)?.floatValue ?? 0.0, nil)
//        })
//    }
    
    //    func availablePlaybackRates(_ completionHandler: YTArrayCompletionHandler?) {
    //        evaluateJavaScript(
    //            "player.getAvailablePlaybackRates();",
    //            completionHandler: { result, error in
    //                if completionHandler == nil {
    //                    return
    //                }
    //                if let error = error {
    //                    completionHandler?(nil, error)
    //                    return
    //                }
    //                if result == nil || !(result is [AnyHashable]) {
    //                    completionHandler?(nil, nil)
    //                    return
    //                }
    //                completionHandler?(result, nil)
    //        })
    //    }
    
    // MARK: - Setting playback behavior for playlists
    public func setLoop(_ loop: Bool) {
        let loopPlayListValue = stringForJSBoolean(loop)
        let command = "player.setLoop(\(loopPlayListValue));"
        evaluateJavaScript(command)
    }
    
    public func setShuffle(_ shuffle: Bool) {
        let shufflePlayListValue = stringForJSBoolean(shuffle)
        let command = "player.setShuffle(\(shufflePlayListValue));"
        evaluateJavaScript(command)
    }
    
    // MARK: - Playback status
    public func videoLoadedFraction(_ completionHandler: YTFloatCompletionHandler?) {
        evaluateJavaScript(
            "player.getVideoLoadedFraction();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(-1, error)
                    return
                }
                if result == nil || !(result is NSNumber) {
                    completionHandler?(0, nil)
                    return
                }
                completionHandler?((result as? NSNumber)?.floatValue ?? 0.0, nil)
        })
    }
    
    public func playerState(_ completionHandler: YTPlayerStateCompletionHandler?) {
        evaluateJavaScript(
            "player.getPlayerState();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(.unknown, error)
                    return
                }
                if result == nil || !(result is NSNumber) {
                    completionHandler?(.unknown, error)
                    return
                }
                let state = (result as? NSNumber)?.intValue ?? 0
                completionHandler?(YTPlayerState(rawValue: state) ?? .unstarted, nil)
        })
    }
    
    public func currentTime(_ completionHandler: YTFloatCompletionHandler?) {
        evaluateJavaScript(
            "player.getCurrentTime();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(-1, error)
                    return
                }
                if result == nil || !(result is NSNumber) {
                    completionHandler?(0, nil)
                    return
                }
                completionHandler?((result as? NSNumber)?.floatValue ?? 0.0, nil)
        })
    }
    
    public func duration(_ completionHandler: YTDoubleCompletionHandler?) {
        evaluateJavaScript(
            "player.getDuration();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(-1, error)
                    return
                }
                if result == nil || !(result is NSNumber) {
                    completionHandler?(0, nil)
                    return
                }
                completionHandler?((result as? NSNumber)?.doubleValue ?? 0.0, nil)
        })
    }
    
    public func videoUrl(_ completionHandler: YTURLCompletionHandler?) {
        evaluateJavaScript(
            "player.getVideoUrl();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(nil, error)
                    return
                }
                if result == nil || !(result is NSString) {
                    completionHandler?(nil, nil)
                    return
                }
                completionHandler?(URL(string: result as? String ?? ""), nil)
        })
    }
    
    public func videoEmbedCode(_ completionHandler: YTStringCompletionHandler?) {
        evaluateJavaScript(
            "player.getVideoEmbedCode();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(nil, error)
                    return
                }
                if result == nil || !(result is NSString) {
                    completionHandler?(nil, nil)
                    return
                }
                completionHandler?(result as? String, nil)
        })
    }
    
    // MARK: - Playlist methods
    public func playlist(_ completionHandler: YTArrayCompletionHandler?) {
        evaluateJavaScript(
            "player.getPlaylist();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(nil, error)
                }
                if result == nil || !(result is [AnyHashable]) {
                    completionHandler?(nil, nil)
                    return
                }
                completionHandler?(result as? [AnyObject], nil)
        })
    }
    
    public func playlistIndex(_ completionHandler: YTIntCompletionHandler?) {
        evaluateJavaScript(
            "player.getPlaylistIndex();",
            completionHandler: { result, error in
                if completionHandler == nil {
                    return
                }
                if let error = error {
                    completionHandler?(-1, error)
                    return
                }
                if result == nil || !(result is NSNumber) {
                    completionHandler?(0, nil)
                    return
                }
                completionHandler?((result as? NSNumber)?.intValue ?? 0, nil)
        })
    }
    
    // MARK: - Playing a video in a playlist
    public func nextVideo() {
        evaluateJavaScript("player.nextVideo();")
    }
    
    public func previousVideo() {
        evaluateJavaScript("player.previousVideo();")
    }
    
    public func playVideo(at index: Int) {
        let command = "player.playVideoAt(\(NSNumber(value: Int32(index))));"
        evaluateJavaScript(command)
    }
    
    /**
     * Convert a quality value from NSString to the typed enum value.
     *
     * @param qualityString A string representing playback quality. Ex: "small", "medium", "hd1080".
     * @return An enum value representing the playback quality.
     */
    public class func playbackQuality(for qualityString: String?) -> YTPlaybackQuality {
        var quality: YTPlaybackQuality = .kYTPlaybackQualityUnknown
        
        if qualityString == kYTPlaybackQualitySmallQuality {
            quality = .kYTPlaybackQualitySmall
        } else if qualityString == kYTPlaybackQualityMediumQuality {
            quality = .kYTPlaybackQualityMedium
        } else if qualityString == kYTPlaybackQualityLargeQuality {
            quality = .kYTPlaybackQualityLarge
        } else if qualityString == kYTPlaybackQualityHD720Quality {
            quality = .kYTPlaybackQualityHD720
        } else if qualityString == kYTPlaybackQualityHD1080Quality {
            quality = .kYTPlaybackQualityHD1080
        } else if qualityString == kYTPlaybackQualityHighResQuality {
            quality = .kYTPlaybackQualityHighRes
        } else if qualityString == kYTPlaybackQualityAutoQuality {
            quality = .kYTPlaybackQualityAuto
        }
        return quality
    }
    
    public class func playerState(for stateString: String?) -> YTPlayerState {
        var state = YTPlayerState.unknown
        if stateString == kYTPlayerStateUnstartedCode {
            state = .unstarted
        } else if stateString == kYTPlayerStateEndedCode {
            state = .ended
        } else if stateString == kYTPlayerStatePlayingCode {
            state = .playing
        } else if stateString == kYTPlayerStatePausedCode {
            state = .paused
        } else if stateString == kYTPlayerStateBufferingCode {
            state = .buffering
        } else if stateString == kYTPlayerStateCuedCode {
            state = .cued
        }
        return state
    }
    
    //MARK:- WKNavigationDelegate
    public func webView(_ webView: WKWebView, decidePolicyFor navigationAction: WKNavigationAction, decisionHandler: @escaping (WKNavigationActionPolicy) -> Void) {
        let request = navigationAction.request
        if request.url?.host == originURL.host {
            decisionHandler(WKNavigationActionPolicy.allow)
            return
        } else if request.url?.scheme == "ytplayer" {
            notifyDelegateOfYouTubeCallbackUrl(request.url)
            decisionHandler(WKNavigationActionPolicy.cancel)
            return
        } else if (request.url?.scheme == "http") || (request.url?.scheme == "https") {
            if request.url != nil && handleHttpNavigation(to: request.url!) {
                decisionHandler(WKNavigationActionPolicy.allow)
            } else {
                decisionHandler(WKNavigationActionPolicy.cancel)
            }
            return
        }
        decisionHandler(WKNavigationActionPolicy.allow)
    }
    
    public func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
        if initialLoadingView != nil {
            initialLoadingView.removeFromSuperview()
        }
    }
    
    //MARK: Private Metthod(s)
    private func notifyDelegateOfYouTubeCallbackUrl(_ url: URL?) {
        
        let action = url?.host
        
        // We know the query can only be of the format ytplayer://action?data=SOMEVALUE,
        // so we parse out the value.
        let query = url?.query
        var data: String?
        if  query != nil && query != "" {
            data = query!.components(separatedBy: "=")[1]
        }
        
        if action == kYTPlayerCallbackOnReady {
            if (initialLoadingView != nil) {
                initialLoadingView.removeFromSuperview()
            }
            delegate?.playerViewDidBecomeReady(self)
        } else if action == kYTPlayerCallbackOnStateChange {
            let state = YTPlayerView.playerState(for: data)
            delegate?.playerView(self, didChangeTo: state)
        }
        else if action == kYTPlayerCallbackOnPlaybackQualityChange {
            let quality = YTPlayerView.playbackQuality(for: data)
            delegate?.playerView(self, didChangeToQuality: quality)
        } else if action == kYTPlayerCallbackOnError {
            var error: YTPlayerError = .kYTPlayerErrorUnknown
            
            if data == kYTPlayerErrorInvalidParamErrorCode {
                error = .kYTPlayerErrorInvalidParam
            } else if data == kYTPlayerErrorHTML5ErrorCode {
                error = .kYTPlayerErrorHTML5Error
            } else if (data == kYTPlayerErrorNotEmbeddableErrorCode) || (data == kYTPlayerErrorSameAsNotEmbeddableErrorCode) {
                error = .kYTPlayerErrorNotEmbeddable
            } else if (data == kYTPlayerErrorVideoNotFoundErrorCode) || (data == kYTPlayerErrorCannotFindVideoErrorCode) {
                error = .kYTPlayerErrorVideoNotFound
            }
            
            delegate?.playerView(self, receivedError: error)
        } else if action == kYTPlayerCallbackOnPlayTime {
            let time = Float(data?.doubleValue() ?? 0)
            delegate?.playerView(self, didPlayTime: time)
        } else if action == kYTPlayerCallbackOnYouTubeIframeAPIFailedToLoad {
            if initialLoadingView != nil {
                initialLoadingView.removeFromSuperview()
            }
        }
    }
    
    private func handleHttpNavigation(to url: URL) -> Bool {
        // Usually this means the user has clicked on the YouTube logo or an error message in the
        // player. Most URLs should open in the browser. The only http(s) URL that should open in this
        // webview is the URL for the embed, which is of the format:
        //     http(s)://www.youtube.com/embed/[VIDEO ID]?[PARAMETERS]
        var ytRegex: NSRegularExpression? = nil
        do {
            ytRegex = try NSRegularExpression(
                pattern: kYTPlayerEmbedUrlRegexPattern,
                options: .caseInsensitive)
        } catch {
        }
        let ytMatch = ytRegex?.firstMatch(
            in: url.absoluteString,
            options: [],
            range: NSRange(location: 0, length: url.absoluteString.count))
        
        
        let adRegex = try? NSRegularExpression(
            pattern: kYTPlayerAdUrlRegexPattern,
            options: .caseInsensitive)
        
        let adMatch = adRegex?.firstMatch(
            in: url.absoluteString,
            options: [],
            range: NSRange(location: 0, length: url.absoluteString.count))
        
        var syndicationRegex: NSRegularExpression? = nil
        do {
            syndicationRegex = try NSRegularExpression(
                pattern: kYTPlayerSyndicationRegexPattern,
                options: .caseInsensitive)
        } catch {
        }
        
        let syndicationMatch = syndicationRegex?.firstMatch(
            in: url.absoluteString,
            options: [],
            range: NSRange(location: 0, length: url.absoluteString.count))
        
        var oauthRegex: NSRegularExpression? = nil
        do {
            oauthRegex = try NSRegularExpression(
                pattern: kYTPlayerOAuthRegexPattern,
                options: .caseInsensitive)
        } catch {
        }
        
        let oauthMatch = oauthRegex?.firstMatch(
            in: url.absoluteString,
            options: [],
            range: NSRange(location: 0, length: url.absoluteString.count))
        
        var staticProxyRegex: NSRegularExpression? = nil
        do {
            staticProxyRegex = try NSRegularExpression(
                pattern: kYTPlayerStaticProxyRegexPattern,
                options: .caseInsensitive)
        } catch {
        }
        let staticProxyMatch = staticProxyRegex?.firstMatch(
            in: url.absoluteString,
            options: [],
            range: NSRange(location: 0, length: url.absoluteString.count))
        
        if (ytMatch != nil) || adMatch != nil || oauthMatch != nil || staticProxyMatch != nil || syndicationMatch != nil {
            return true
        } else {
            UIApplication.shared.open(url)
            return false
        }
    }
    
    /**
     * Private helper method to load an iframe player with the given player parameters.
     *
     * @param additionalPlayerParams An NSDictionary of parameters in addition to required parameters
     *                               to instantiate the HTML5 player with. This differs depending on
     *                               whether a single video or playlist is being loaded.
     * @return YES if successful, NO if not.
     */
    private func loadWithPlayerParams(additionalPlayerParams: [AnyHashable : Any]?) -> Bool {
        let playerCallbacks:NSDictionary = [
            "onReady" : "onReady",
            "onStateChange" : "onStateChange",
            "onPlaybackQualityChange" : "onPlaybackQualityChange",
            "onError" : "onPlayerError"
        ]
        let playerParams: NSMutableDictionary = NSMutableDictionary()
        if additionalPlayerParams != nil {
            playerParams.addEntries(from: additionalPlayerParams!)
        }
        if playerParams.object(forKey: "height") == nil {
            playerParams.setValue("100%", forKey:"height")
        }
        if playerParams.object(forKey: "width") == nil {
            playerParams.setValue("100%", forKey:"width")
        }
        
        playerParams.setValue(playerCallbacks, forKey:"events")
        
        var playerVars = playerParams.object(forKey: "playerVars") as? [AnyHashable: Any]
        if (playerVars == nil) {
            // playerVars must not be empty so we can render a '{}' in the output JSON
            playerVars = [AnyHashable: Any]()
        }
        // We always want to ovewrite the origin to self.originURL, not just for
        // the webView.baseURL
        playerVars?["origin"] = self.originURL.absoluteString
        playerParams.setValue(playerVars, forKey:"playerVars")
        
        // Remove the existing webview to reset any state
        self.webView?.removeFromSuperview()
        self.webView = self.createNewWebView()
        self.addSubview(self.webView!)
        
        var path = Bundle(for: YTPlayerView.self).path(forResource: "YTPlayerView-iframe-player",
                                                            ofType:"html",
                                                            inDirectory:"Assets")
        
        // in case of using Swift and embedded frameworks, resources included not in main bundle,
        // but in framework bundle
        if (path == nil) {
            if let bPath = YTPlayerView.frameworkBundle() {
                path = bPath.path(
                    forResource: "YTPlayerView-iframe-player",
                    ofType:"html",
                    inDirectory:"Assets")
                
            }
        }
        
        if path == nil {
            debugPrint("YTPlayerView : Bundle path not found")
            return false
        }
        
        var embedHTMLTemplate: String!
        do {
            embedHTMLTemplate = try String(contentsOfFile: path!, encoding: .utf8)
        } catch let err {
            debugPrint("Received error rendering template: \(err.localizedDescription)")
            return false
        }
            
        // Render the playerVars as a JSON dictionary.
        let jsonData = try? JSONSerialization.data(withJSONObject: playerParams as Any, options: .prettyPrinted)
        if (jsonData == nil) {
            debugPrint("Attempted configuration of player with invalid playerVars: \(String(describing: playerParams))")
            return false
        }
        
        let playerVarsJsonString:String! = String(data: jsonData!, encoding:String.Encoding.utf8)
        
        let embedHTML:String! = String(format:embedHTMLTemplate, playerVarsJsonString)
        
        self.webView?.loadHTMLString(embedHTML, baseURL: self.originURL as URL)
        self.webView?.navigationDelegate = self
        
        if delegate != nil {
            let initialLoadingView:UIView! = self.delegate?.playerViewPreferredInitialLoadingView(self)
            if (initialLoadingView != nil) {
                initialLoadingView.frame = self.bounds
                initialLoadingView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
                self.addSubview(initialLoadingView)
                self.initialLoadingView = initialLoadingView
            }
        }
        
        return true
    }
    
    /**
     * Private method for cueing both cases of playlist ID and array of video IDs. Cueing
     * a playlist does not start playback.
     *
     * @param cueingString A JavaScript string representing an array, playlist ID or list of
     *                     video IDs to play with the playlist player.
     * @param index 0-index position of video to start playback on.
     * @param startSeconds Seconds after start of video to begin playback.
     * @return The result of cueing the playlist.
     */
    private func cuePlaylist(cueingString:String!, index:Int, startSeconds:Float) {
        let indexValue = NSNumber(value: Int32(index))
        let startSecondsValue = NSNumber(value: startSeconds)
        let command:String! = String(format:"player.cuePlaylist(%@, %@, %@);",
                                     cueingString, indexValue, startSecondsValue)
        self.evaluateJavaScript(command)
    }
    
    /**
     * Private method for loading both cases of playlist ID and array of video IDs. Loading
     * a playlist automatically starts playback.
     *
     * @param cueingString A JavaScript string representing an array, playlist ID or list of
     *                     video IDs to play with the playlist player.
     * @param index 0-index position of video to start playback on.
     * @param startSeconds Seconds after start of video to begin playback.
     * @return The result of cueing the playlist.
     */
    private func loadPlaylist(_ cueingString: String?, index: Int, startSeconds: Float) {
        let indexValue = NSNumber(value: Int32(index))
        let startSecondsValue = NSNumber(value: startSeconds)
        let command = "player.loadPlaylist(\(cueingString ?? ""), \(indexValue), \(startSecondsValue));"
        evaluateJavaScript(command)
    }
    
    /**
     * Private helper method for converting an NSArray of video IDs into its JavaScript equivalent.
     *
     * @param videoIds An array of video ID strings to convert into JavaScript format.
     * @return A JavaScript array in String format containing video IDs.
     */
    private func string(fromVideoIdArray videoIds: [AnyHashable]?) -> String? {
        var formattedVideoIds: [String] = []
        
        for unformattedId in videoIds ?? [] {
            formattedVideoIds.append("'\(unformattedId)'")
        }
        
        return "[\(formattedVideoIds.joined(separator: ", "))]"
    }
    
    /**
     * Private method for evaluating JavaScript in the webview.
     *
     * @param jsToExecute The JavaScript code in string format that we want to execute.
     */
    private func evaluateJavaScript(_ jsToExecute:String!) {
        self.evaluateJavaScript(jsToExecute, completionHandler: nil)
    }
    
    /**
     * Private method for evaluating JavaScript in the webview.
     *
     * @param jsToExecute The JavaScript code in string format that we want to execute.
     * @param completionHandler A block to invoke when script evaluation completes or fails.
     */
    private func evaluateJavaScript(_ jsToExecute:String!, completionHandler:((Any?, Error?)->Void)? = nil) {
        webView?.evaluateJavaScript(
            jsToExecute,
            completionHandler: { (result, error) in
                if error != nil {
                    completionHandler?(nil, error)
                    return
                }
                if result == nil || (result is NSNull) {
                    // we can consider this an empty result
                    completionHandler?(nil, nil)
                    return
                }
                
                completionHandler?(result, nil)
        })
    }
    
    /**
     * Private method to convert a Objective-C BOOL value to JS boolean value.
     *
     * @param boolValue Objective-C BOOL value.
     * @return JavaScript Boolean value, i.e. "true" or "false".
     */
    private func stringForJSBoolean(_ boolValue: Bool) -> String {
        return boolValue ? "true" : "false"
    }
    
    // MARK: - Exposed for Testing
    private func setWebView(webView: WKWebView) {
        self.webView = webView
    }
    
    private func createNewWebView() -> WKWebView {
        let webViewConfiguration = WKWebViewConfiguration()
        webViewConfiguration.allowsInlineMediaPlayback = true
        
        if #available(iOS 10.0, *) {
            webViewConfiguration.mediaTypesRequiringUserActionForPlayback = []
        } else {
            webViewConfiguration.mediaPlaybackRequiresUserAction = false
        }
        
        let webView:WKWebView = WKWebView(frame: self.bounds,
                                          configuration:webViewConfiguration)
        webView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        webView.scrollView.isScrollEnabled = false
        webView.scrollView.bounces = false
        
        if delegate != nil {
            webView.backgroundColor = self.delegate?.playerViewPreferredWebViewBackgroundColor(self)
            if webView.backgroundColor == .clear {
                webView.isOpaque = false
            }
        }
        return webView
    }
    
    private func removeWebView() {
        self.webView?.removeFromSuperview()
        self.webView = nil
    }
    
    private class func frameworkBundle() -> Bundle? {
        let mainBundlePath: String? = Bundle(for: YTPlayerView.self).resourcePath
        if let bundlePath = mainBundlePath   {
            let frameworkBundlePath = bundlePath.nsString.appendingPathComponent("Assets.bundle")
            return Bundle(path: frameworkBundlePath)
        }
        return nil
    }

}
