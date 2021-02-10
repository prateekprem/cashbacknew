//
//  YTPlayerViewDelegate.swift
//  jarvis-locale-ios
//
//  Created by Gulshan Kumar on 18/11/20.
//

import UIKit

/**
 * A delegate for ViewControllers to respond to YouTube player events outside
 * of the view, such as changes to video playback state or playback errors.
 * The callback functions correlate to the events fired by the IFrame API.
 * For the full documentation, see the IFrame documentation here:
 *     https://developers.google.com/youtube/iframe_api_reference#Events
 */
public protocol YTPlayerViewDelegate: class {


    /**
     * Invoked when the player view is ready to receive API calls.
     *
     * @param playerView The YTPlayerView instance that has become ready.
     */
    func playerViewDidBecomeReady(_ playerView: YTPlayerView)

    /**
     * Callback invoked when player state has changed, e.g. stopped or started playback.
     *
     * @param playerView The YTPlayerView instance where playback state has changed.
     * @param state YTPlayerState designating the new playback state.
     */
    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState)

    /**
     * Callback invoked when playback quality has changed.
     *
     * @param playerView The YTPlayerView instance where playback quality has changed.
     * @param quality YTPlaybackQuality designating the new playback quality.
     */
    func playerView(_ playerView: YTPlayerView, didChangeToQuality quality: YTPlaybackQuality)

    /**
     * Callback invoked when an error has occured.
     *
     * @param playerView The YTPlayerView instance where the error has occurred.
     * @param error YTPlayerError containing the error state.
     */
    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError)

    /**
     * Callback invoked frequently when playBack is plaing.
     *
     * @param playerView The YTPlayerView instance where the error has occurred.
     * @param playTime float containing curretn playback time.
     */
    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float)

    /**
     * Callback invoked when setting up the webview to allow custom colours so it fits in
     * with app color schemes. If a transparent view is required specify clearColor and
     * the code will handle the opacity etc.
     *
     * @param playerView The YTPlayerView instance where the error has occurred.
     * @return A color object that represents the background color of the webview.
     */
    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor

    /**
     * Callback invoked when initially loading the YouTube iframe to the webview to display a custom
     * loading view while the player view is not ready. This loading view will be dismissed just before
     * -playerViewDidBecomeReady: callback is invoked. The loading view will be automatically resized
     * to cover the entire player view.
     *
     * The default implementation does not display any custom loading views so the player will display
     * a blank view with a background color of (-playerViewPreferredWebViewBackgroundColor:).
     *
     * Note that the custom loading view WILL NOT be displayed after iframe is loaded. It will be
     * handled by YouTube iframe API. This callback is just intended to tell users the view is actually
     * doing something while iframe is being loaded, which will take some time if users are in poor networks.
     *
     * @param playerView The YTPlayerView instance where the error has occurred.
     * @return A view object that will be displayed while YouTube iframe API is being loaded.
     *         Pass nil to display no custom loading view. Default implementation returns nil.
     */
    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView?

}


public extension YTPlayerViewDelegate {

    func playerViewDidBecomeReady(_ playerView: YTPlayerView) {

    }

    func playerView(_ playerView: YTPlayerView, didChangeTo state: YTPlayerState) {

    }

    func playerView(_ playerView: YTPlayerView, didChangeToQuality quality: YTPlaybackQuality) {

    }

    func playerView(_ playerView: YTPlayerView, receivedError error: YTPlayerError) {

    }

    func playerView(_ playerView: YTPlayerView, didPlayTime playTime: Float) {

    }

    func playerViewPreferredWebViewBackgroundColor(_ playerView: YTPlayerView) -> UIColor {
        return .clear
    }

    func playerViewPreferredInitialLoadingView(_ playerView: YTPlayerView) -> UIView? {
        return nil
    }
}

