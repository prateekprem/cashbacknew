//
//  JRPPBaseViewController.swift
//  Jarvis
//
//  Created by Pankaj Singh on 27/12/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit
import Lottie

 class JRPCBaseViewController: JRCBBaseVC {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.isNavBarHidden = false // since variable is move to maain base and here default was false
    }
    
    deinit {
        debugPrint("\(String(describing: self)) dealloacated")
    }
        
    func updateLoader(show: Bool) {
        DispatchQueue.main.async {
            if show {
                JRPPLoadingIndicator.show(self.view, loadingText: nil, bgColor: UIColor.clear, style: .gray, type: .opaqueBgActivityIndicator)
            } else {
                JRPPLoadingIndicator.hide()
            }
        }
    }
}


//MARK: ============================ Loading Indicator ===========================================
enum JRPPLoadingIndicatorType {
    case opaqueBgBubble
    case transparentBgBubble
    case opaqueBgActivityIndicator
}

class JRPPLoadingIndicator {
    
    static var currentOverlay : UIView?
    static var currentOverlayTarget : UIView?
    static var currentLoadingText: String?
    static var indicatorView: UIView?
    
    static func show() {
        guard let currentMainWindow: UIWindow = UIApplication.shared.keyWindow else {
            return
        }
        show(currentMainWindow)
    }
    
    static func show(_ loadingText: String) {
        guard let currentMainWindow: UIWindow = UIApplication.shared.keyWindow else {
            return
        }
        show(currentMainWindow, loadingText: loadingText)
    }
    
    static func show(_ overlayTarget : UIView) {
        show(overlayTarget, loadingText: nil)
    }
    
    static func show(_ overlayTarget : UIView, loadingText: String?, bgColor: UIColor = UIColor.lightGray, style: UIActivityIndicatorView.Style = .white, type: JRPPLoadingIndicatorType = .opaqueBgActivityIndicator, topPaddingg: CGFloat? = nil) {
        // Clear it first in case it was already shown
        hide()
        
        // Create the overlay
        let overlay = UIView()
        overlay.alpha = 1.0
        if type == .transparentBgBubble {
            overlay.alpha = 0.5
        }
        
        overlay.backgroundColor = bgColor
        overlay.translatesAutoresizingMaskIntoConstraints = false
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        overlay.widthAnchor.constraint(equalTo: overlayTarget.widthAnchor).isActive = true
        overlay.heightAnchor.constraint(equalTo: overlayTarget.heightAnchor).isActive = true
        
        var indicator: UIView!
        if type == .transparentBgBubble || type == .opaqueBgBubble  {
            let indicatorView: JRPointsLoaderView = JRPointsLoaderView(frame: CGRect(x: 0.0, y: 0.0, width: 100, height: 30.0))
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.heightAnchor.constraint(equalToConstant: 30.0).isActive = true
            indicatorView.widthAnchor.constraint(equalToConstant: 100.0).isActive = true
            indicatorView.show(true)
            indicator = indicatorView
        } else {
            // Create and animate the activity indicator
            let indicatorView: UIActivityIndicatorView = UIActivityIndicatorView(style: style)
            indicatorView.translatesAutoresizingMaskIntoConstraints = false
            indicatorView.startAnimating()
            indicator = indicatorView
        }
        overlay.addSubview(indicator)
        var topPadding: CGFloat = 0.0
        if type == .transparentBgBubble || type == .opaqueBgBubble {
            topPadding = -50.0
        }
        if let padd = topPaddingg {
            indicator.topAnchor.constraint(equalTo: overlayTarget.topAnchor, constant: padd).isActive = true
        } else {
            indicator.centerYAnchor.constraint(equalTo: overlay.centerYAnchor, constant: topPadding).isActive =  true
        }
        indicator.centerXAnchor.constraint(equalTo: overlay.centerXAnchor).isActive = true
        // Create label
        if let textString: String = loadingText {
            let label: UILabel = UILabel()
            label.text = textString
            label.textAlignment = .center
            label.textColor = UIColor.black
            label.numberOfLines = 0
            overlay.addSubview(label)
            label.translatesAutoresizingMaskIntoConstraints = false
            
            label.topAnchor.constraint(equalTo: indicator.bottomAnchor, constant: 16).isActive = true
            label.centerXAnchor.constraint(equalTo: indicator.centerXAnchor).isActive = true
            
            overlay.addConstraint(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: overlay, attribute: .trailing, multiplier: 1, constant: -10))
            overlay.addConstraint(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: overlay, attribute: .leading, multiplier: 1, constant: 10))
        }
        
        currentOverlay = overlay
        currentOverlayTarget = overlayTarget
        currentLoadingText = loadingText
        indicatorView = indicator
    }
    
    static func hide() {
        if let bubbleLoader = indicatorView as? JRPointsLoaderView {
            bubbleLoader.hide()
            indicatorView = nil
        }
        if currentOverlay != nil {
            currentOverlay?.removeFromSuperview()
            currentOverlay =  nil
            currentLoadingText = nil
            currentOverlayTarget = nil
        }
    }
}


