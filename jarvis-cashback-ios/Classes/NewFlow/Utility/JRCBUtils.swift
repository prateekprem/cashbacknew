//
//  JRCBUtils.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 27/12/19.
//

import UIKit
import Lottie


class JRCBUtils {
    class func differanceFromNowSince(timestamp: TimeInterval) -> (tSec: Int64, tHour: Int32) {
        let expiryInSec = timestamp/1000 // since was in mili sec
        let mNow = Date().timeIntervalSince1970
        let sDiff = expiryInSec - mNow
        let hh = sDiff/(60*60)
        return (Int64(sDiff), Int32(hh))
    }
    
    class func isExpiryWith(expireAt: String?) -> Bool {
        if let expiryStr = expireAt, let expireTimestamp = TimeInterval(expiryStr) {
            let hour = JRCBUtils.differanceFromNowSince(timestamp: expireTimestamp).tHour
            return hour <= JRCBRemoteConfig.kCBScratchCardExpiryLimitHour.intValue
        }
        return false
    }
    
    //Used to set lucky draw amount text with rupees
    class func getLuckyDrawAmount(amount: Int, amountFontSize: CGFloat = 26.0, rupeeFontSize: CGFloat = 11.0) -> NSAttributedString {
        if amount > 0 {
            let mainFont = UIFont.systemFont(ofSize: amountFontSize)
            let changeFont = UIFont(name: mainFont.fontName, size: (mainFont.pointSize / 2))!
            let offset = (mainFont.capHeight - changeFont.capHeight) + 2
            let rupeeAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: rupeeFontSize), NSAttributedString.Key.baselineOffset: offset] as [NSAttributedString.Key : Any]
            
            let rupeeString = NSMutableAttributedString(string: JRCBConstants.Symbol.kRupee, attributes: rupeeAttributes)
            
            let amtAttributes = [NSAttributedString.Key.font: mainFont]
            let amtString = NSMutableAttributedString(string: String(amount), attributes: amtAttributes)
            
            rupeeString.append(amtString)
            return rupeeString
        }
        
        return NSAttributedString()
    }
}

extension Bundle {
    static var cbBundle: Bundle {
        return Bundle.init(for: JRCBServiceManager.self)
    }
    
    static func nibWith(name: String) -> UINib? {
        return UINib(nibName : name, bundle : Bundle.cbBundle)
    }
    
    func image(named: String?) -> UIImage? {
        guard let imgNm = named else { return nil }
        return UIImage(named: imgNm, in: Bundle.cbBundle, compatibleWith: nil)
    }
}

struct JRCBStoryboard {
    static let stbLanding     = UIStoryboard(name: "JRCBLanding", bundle: Bundle.cbBundle)
    static let stbConsumer    = UIStoryboard(name: "JRCashbackConsumer", bundle: Bundle.cbBundle)
    static let stbLandingDetails  = UIStoryboard(name: "JRCBLandingDetails", bundle: Bundle.cbBundle)
    static let stbMerchant    = UIStoryboard(name: "JRCBMerchant", bundle: Bundle.cbBundle)
    static let stbReferral    = UIStoryboard(name: "JRCBReferral", bundle: Bundle.cbBundle)

    
}

enum JRCBNotificationName: String {
    case notifRemoveScreatchCard = "kNotifRemoveScreatchCard"
    case notifCampainActivated = "kNotifCampainActivated"
     case notifMerchantOfferActivated = "kNotifMerchantOfferActivated"
    
    func fireMeWith(userInfo: [AnyHashable : Any]?) {
        let nc = NotificationCenter.default
        nc.post(name: Notification.Name(self.rawValue), object: nil, userInfo: userInfo)
    }
    
    func addObserverTo(object: Any, selector: Selector, obj: Any?) {
        let nc = NotificationCenter.default
        nc.addObserver(object, selector: selector,
                       name: Notification.Name(self.rawValue),
                       object: obj)
    }
}

enum JRCBLOTAnimation: String {
    case animationPaymentsLoader  = "Payments-Loader"
    case animationActOfferSparcleBigButton  = "Activate-Offer-Sparcle-BigButton"
    case animationActButtonOnDealsCard      =  "Activate-Button-On-DealsCard"
    case animationAfterScratch = "CB-AfterScratch" //New animation after scratch on landing
    case animationLoadScratch = "CB-LoadScratch" //New animation on scratch load on post txn
    
    var lotView: LOTAnimationView {
        return LOTAnimationView(name: self.rawValue, bundle: Bundle.cbBundle)
    }
    
    static func startPlaying(viewAnimate : LOTAnimationView) {
        viewAnimate.play{ (finished) in
            JRCBLOTAnimation.startPlaying(viewAnimate: viewAnimate)
        }
    }
}


class JRCBLoaderAnimationView {
    
    func infinitePlay(viewAnimate : LOTAnimationView) {
        viewAnimate.play{ (finished) in
            self.infinitePlay(viewAnimate: viewAnimate)
        }
    }
    
}
public class JRPointsLoaderView: UIView {

    private let loaderAnimationView =  LOTAnimationView(name: "Payments-Loader", bundle: Bundle.cbBundle)
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        addLoaderView()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        addLoaderView()
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
        updateFrame()
    }
    
    private func addLoaderView() {
        updateFrame()
        self.autoresizingMask = [UIView.AutoresizingMask.flexibleWidth, UIView.AutoresizingMask.flexibleHeight]
        self.alpha = 0
        self.addSubview(loaderAnimationView)
    }
    
    private func updateFrame() {
        loaderAnimationView.frame = CGRect(origin: CGPoint.zero, size: self.frame.size)
    }
    
    /*
     * Plays the animation, unhides self
     * Parameter: isInfinite = true/false to play it infinitely or for default time interval
     */
    public func show(_ isInfinite: Bool = true) {
        loaderAnimationView.loopAnimation = isInfinite
        loaderAnimationView.play()
        self.isHidden = false
        self.alpha = 0
        UIView.animate(withDuration: 0.23) {
            self.alpha = 1
        }
    }
    
    /*
     * Stops the animation, hides self
     */
    public func hide() {
        loaderAnimationView.stop()
        UIView.animate(withDuration: 0.23, animations: {
            self.alpha = 0
        }) { (finished) in
            self.isHidden = true
        }
    }
}


extension UIButton {
    func showPointsLoader(shouldRemoveTitle: Bool = true, defaultBGColor: UIColor = UIColor(red: 234.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1.0)) {
        let viewLoading = UIView(frame: self.bounds)
        viewLoading.tag = 999
        viewLoading.backgroundColor = defaultBGColor
        let animationView: LOTAnimationView =  LOTAnimationView(name: "Payments-Loader", bundle: Bundle.cbBundle)
        animationView.accessibilityIdentifier = "ctaInlineLoader"
        animationView.frame = CGRect(x: 0, y: 0, width: 100, height: 30)
        animationView.center = viewLoading.center
        viewLoading.addSubview(animationView)
        if shouldRemoveTitle {
            self.setTitle("", for: .normal)
        }
        self.addSubview(viewLoading)
        JRCBLoaderAnimationView().infinitePlay(viewAnimate: animationView)
    }
    
    func showPoinstCheckBalance(shouldRemoveTitle: Bool = true, defaultBGColor: UIColor = UIColor(red: 234.0/255.0, green: 250.0/255.0, blue: 255.0/255.0, alpha: 1.0)) {
        let viewLoading = UIView(frame: self.bounds)
        let spacing = self.bounds.size.height > 15.0 ? (self.bounds.size.height - 15.0)/2 : 0.0
        viewLoading.tag = 999
        viewLoading.backgroundColor = defaultBGColor
        let animationView =  LOTAnimationView(name: "Payments-Loader", bundle: Bundle.cbBundle)
        animationView.frame = CGRect(x: 0, y: spacing, width:  self.bounds.size.width, height: 15.0)
        animationView.center = viewLoading.center
        viewLoading.addSubview(animationView)
        if shouldRemoveTitle {
            self.setTitle("", for: .normal)
        }
        self.addSubview(viewLoading)
        JRCBLoaderAnimationView().infinitePlay(viewAnimate: animationView)
    }
}
