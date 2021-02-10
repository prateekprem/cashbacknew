//
//  ActivityLoader.swift
//
//  Created by Ayush Goel on 04/02/16.
//

import UIKit
import Lottie
import jarvis_utility_ios

public class ActivityLoader: NSObject {
    
    public var indicator:UIActivityIndicatorView!
    public var currentOverlay : UIView?
    public static let sharedInstance = ActivityLoader()
    
    public static var animationLOTView = LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
    
    public class func addActivityLoader(view:UIView)
    {
        ActivityLoader.removeActivityLoader()
        
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        loader.indicator =  UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)
        loader.indicator.center = CGPoint(x: JRSwiftConstants.windowWidth/2, y: JRSwiftConstants.windowHeigth/2)
        loader.indicator.startAnimating()
        loader.indicator.hidesWhenStopped = true
        view.addSubview(loader.indicator)
    }
    public class func addActivityLoaderToWindow()
    {
        //Loader Adjusted to behave same like base loader
        guard let overlayTarget = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        ActivityLoader.removeActivityLoader()
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        loader.indicator =  UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)
        loader.indicator.center = CGPoint(x: JRSwiftConstants.windowWidth/2, y: JRSwiftConstants.windowHeigth/2 - 20)
        loader.indicator.startAnimating()
        loader.indicator.hidesWhenStopped = true
        overlayTarget.addSubview(loader.indicator)
    }
    
    @objc class public func showActivityLoader(withPoint centerPoint: CGPoint = CGPoint.zero) {
        guard let overlayTarget = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        ActivityLoader.removeActivityLoader()
        let animation = ActivityLoader.animationLOTView
        animation.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animation.center = centerPoint == .zero ? CGPoint(x: overlayTarget.bounds.midX, y: overlayTarget.bounds.midY - 20) : centerPoint
        overlayTarget.addSubview(animation)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate:animation)
    }
    
    @objc class public func showActivityLoader(on view: UIView, withPoint centerPoint: CGPoint = CGPoint.zero) {
        
        let animation = ActivityLoader.animationLOTView
        animation.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animation.center = centerPoint == .zero ? CGPoint(x: view.bounds.midX, y: view.bounds.midY - 20) : centerPoint
        view.addSubview(animation)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate:animation)
    }
    
    @objc class public func hideActivityLoader() {
        ActivityLoader.animationLOTView.removeFromSuperview()
    }
    
    @objc public class func addActivityLoader(view:UIView, yOffSet:CGFloat)
    {
        ActivityLoader.removeActivityLoader()
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        loader.indicator =  UIActivityIndicatorView(style:UIActivityIndicatorView.Style.gray)
        loader.indicator.center = CGPoint(x: JRSwiftConstants.windowWidth/2, y: yOffSet)
        loader.indicator.startAnimating()
        loader.indicator.hidesWhenStopped =  true
        view.addSubview(loader.indicator)
    }
    
    @objc public class func removeActivityLoader()
    {
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        if(loader.indicator  != nil)
        {
            loader.indicator.stopAnimating()
            loader.indicator.removeFromSuperview()
            loader.indicator = nil
        }
        
        if let lcurrentOverlay = loader.currentOverlay {
            for view in lcurrentOverlay.subviews {
                view.removeFromSuperview()
            }
            loader.currentOverlay?.removeFromSuperview()
            loader.currentOverlay =  nil
        }
    }
    
    @objc public class func showFullScreenLottieAnimation(loadingText:String? = "jr_rc_activityLoader".localized, yOffSet:CGFloat = 0, view:UIView) {
        removeActivityLoader()
        guard let _ = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: yOffSet, width: view.frame.width, height: view.frame.height - yOffSet))
        overlay.backgroundColor = UIColor.white
        overlay.isUserInteractionEnabled = true
        overlay.alpha = 1.0
        view.addSubview(overlay)
        view.bringSubviewToFront(overlay)
        
        let animationView =  LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = CGPoint(x: view.center.x,y :view.center.y - yOffSet)
        overlay.addSubview(animationView)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate: animationView)
        
        // Create label
        let label = UILabel()
        label.text = loadingText
        label.font =  UIFont.fontLightOf(size: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //for fetching height
        label.frame = CGRect(origin: .zero, size: CGSize(width: overlay.frame.size.width - 20, height:  CGFloat.greatestFiniteMagnitude))
        
        //setting actual frame
        label.frame = CGRect(origin: CGPoint(x: 10, y: animationView.origin.y + animationView.frame.size.height + 50), size: CGSize(width: label.frame.size.width, height: label.getLabelHeight()))
        
        overlay.addSubview(label)
        let strip1: UIView =  UIView(frame: CGRect(x: 0, y: overlay.frame.height - 20, width: overlay.frame.width, height: 10))
        strip1.backgroundColor = UIColor.colorRGB(0, green: 185, blue: 245)
        overlay.addSubview(strip1)
        
        let strip2: UIView =  UIView(frame: CGRect(x: 0, y: overlay.frame.height - 10, width: overlay.frame.width, height: 10))
        strip2.backgroundColor = UIColor.colorRGB(0, green: 46, blue: 110)
        overlay.addSubview(strip2)
        loader.currentOverlay = overlay
    }
    
    @objc public class func showFullScreenLottieAnimation(loadingText:String? = "jr_rc_activityLoader".localized, yOffSet:CGFloat = 0) {
        removeActivityLoader()
        guard let overlayTarget = UIApplication.shared.keyWindow else {
            print("No main window.")
            return
        }
        let loader:ActivityLoader = ActivityLoader.sharedInstance
        let overlay: UIView = UIView(frame: CGRect(x: 0, y: yOffSet, width: overlayTarget.frame.width, height: overlayTarget.frame.height - yOffSet))
        overlay.backgroundColor = UIColor.white
        overlay.isUserInteractionEnabled = true
        overlay.alpha = 1.0
        overlayTarget.addSubview(overlay)
        overlayTarget.bringSubviewToFront(overlay)
        
        let animationView: LOTAnimationView =  LOTAnimationView(name: "Paytm-Loader", bundle: Bundle.framework)
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = CGPoint(x: overlayTarget.center.x,y :overlayTarget.center.y - yOffSet)
        overlay.addSubview(animationView)
        JRPaytmLoaderAnimationView().infinitePlay(viewAnimate: animationView)
        
        // Create label
        let label: UILabel = UILabel()
        label.text = loadingText
        label.font =  UIFont.fontLightOf(size: 17)
        label.textColor = UIColor.black
        label.numberOfLines = 0
        label.sizeToFit()
        label.textAlignment = .center
        label.lineBreakMode = NSLineBreakMode.byWordWrapping
        
        //for fetching height
        label.frame = CGRect(origin: .zero, size: CGSize(width: overlay.frame.size.width - 20, height:  CGFloat.greatestFiniteMagnitude))
        
        //setting actual frame
        label.frame = CGRect(origin: CGPoint(x: 10, y: animationView.origin.y + animationView.frame.size.height + 50), size: CGSize(width: label.frame.size.width, height: label.getLabelHeight()))
        
        overlay.addSubview(label)
        
        let strip1: UIView =  UIView(frame: CGRect(x: 0, y: overlay.frame.height - 20, width: overlay.frame.width, height: 10))
        strip1.backgroundColor = UIColor.colorRGB(0, green: 185, blue: 245)
        overlay.addSubview(strip1)
        
        let strip2: UIView =  UIView(frame: CGRect(x: 0, y: overlay.frame.height - 10, width: overlay.frame.width, height: 10))
        strip2.backgroundColor = UIColor.colorRGB(0, green: 46, blue: 110)
        overlay.addSubview(strip2)
        loader.currentOverlay = overlay
    }
}
