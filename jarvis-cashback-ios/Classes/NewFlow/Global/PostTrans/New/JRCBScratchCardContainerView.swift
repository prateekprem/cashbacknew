//
//  JRCBScratchCardContainerView.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 20/05/20.
//

import UIKit

class JRCBScratchCardContainerView: UIView {
    private let margin = CGFloat(40)
    private var sCards = [JRCBScratchCardView]()
    private let kMAXCardLimit = 2
    private(set) var cbBannerDelegate: JRCBPostTxnBannerDelegate?
    private var hRatio: CGFloat = 1.0 // this is helping while closing
    let animationView = JRCBLOTAnimation.animationLoadScratch.lotView
    
    private func getHeightWith(width: CGFloat) -> CGFloat {
        let ww = width - 2 * margin
        let ratio : CGFloat = 1.45
        return ww * ratio + margin
    }
    
    class func containerWith(superBound: CGRect) -> JRCBScratchCardContainerView {
        let vv =  UINib(nibName: "JRCBScratchCardContainerView", bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[0] as! JRCBScratchCardContainerView
        
        let mHeight = vv.getHeightWith(width: superBound.width)
        vv.hRatio = mHeight/superBound.height
        let fr = CGRect(x: 0, y: superBound.height - mHeight, width: superBound.width, height: mHeight)
        vv.frame = fr
        vv.backgroundColor = .clear
        return vv
    }
    
    func setUpWith(delegate: JRCBPostTxnBannerDelegate?, contentVMs: [JRCBScratchContentVM]) {
        guard contentVMs.count > 0 else { return }
        self.cbBannerDelegate = delegate
        
        self.performGAEventForScratchCardLoad(for: contentVMs[0])
        
        let total = min(self.kMAXCardLimit, contentVMs.count)
        
        let mH = self.bounds.height - 150
        let mY = self.bounds.height
        let kWidth = mH * 0.75
        var totalCardWidth = kWidth
        if total > 1 {
            totalCardWidth += 20
        }
        var mX = (self.frame.width - totalCardWidth)/2
        let fr1 = CGRect(x: mX, y: mY, width: kWidth, height: mH)
        
        let card = JRCBScratchCardView.cardWith(fr: fr1)
        self.addSubview(card)
        card.addCard(contentVM: contentVMs[0])
        self.sCards.append(card)
        
        if total > 1 {
            for i in 1..<total {
                mX += 20
                let fr = CGRect(x: mX, y: mY, width: kWidth, height: mH - 50)
                let card1 = JRCBScratchCardView.cardWith(fr: fr)
                self.insertSubview(card1, at: 0)
                card1.addCard(contentVM: contentVMs[i])
                self.sCards.append(card1)
            }
        }
        
        animationView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        animationView.contentMode = .scaleAspectFill
        self.addSubview(animationView)
        self.performInitialCardLoadAnimation()
        
    }
    
    
    private func performGAEventForScratchCardLoad(for viewModel: JRCBScratchContentVM) {
        var screen: JRCBAnalyticsScreen = viewModel.getAnalyticsScreen()
        var eventCategory: JRCBAnalyticsCategory = .cat_PostTransaction
        if viewModel.cardTriggerType == .appOpen {
            screen = .screen_PaytmHomepage
            eventCategory = .cat_AppOpen
        }
        JRCBAnalytics(screen: screen, vertical: .vertical_Cashback,
                      eventType: .eventCustom, category: eventCategory,
                      action: .act_ScratchCardLoaded, labels: [:]).track()
    }
    
    private func addLottieAnimtionView() {
        self.animationView.play()
    }
}



// MARK: - all animation...
private extension JRCBScratchCardContainerView {
    private func performInitialCardLoadAnimation() {
        var yMargin: CGFloat = 0.0
        var delayMargin: Double = 0.0
        if self.sCards.count > 0 {
            self.addLottieAnimtionView()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {

            for card in self.sCards {
                UIView.animate(withDuration: 0.7, delay: delayMargin, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: [], animations: {
                    card.frame.origin.y = self.margin + yMargin
                    if yMargin == 0 {
                        
                    }
                    yMargin += 25.0
                    delayMargin += 0.2
                    
                }) { (_) in
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        self.close(card: card)
                    }
                    
                }
            }
            
        }
        }
    }
    
    
    func close(card: UIView) {
        JRCBManager.shareInstance.clearPostTxnObject()
        
        var toPoint = CGPoint(x: self.frame.width/2.0, y: self.frame.height - self.margin)
        if let delegate = self.cbBannerDelegate {
            let pt = delegate.cbPostTrClosingPoint(uniqueId: JRCBManager.kCBSFTabUniqueID)
            if pt.x >= 0, pt.y >= 0 {
                toPoint = CGPoint(x: pt.x, y: pt.y * hRatio)
            }
        }
                
        UIView.animate(withDuration: 0.5, animations: {
            card.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
            card.center = toPoint
            //frame = CGRect(x: toPoint.x, y: toPoint.y, width: card.frame.width, height: card.frame.height)
            
        }, completion: { (success) in
            self.cbBannerDelegate?.cbDidFinishPresentAnimation(uniqueId: JRCBManager.kCBSFTabUniqueID, animated: true)
            self.removeMe()
        })
    }
    
    func removeMe() {
        UIView.animate(withDuration: 0.3, animations: {
            self.alpha = 0.0
        }, completion: { (success) in
            self.removeFromSuperview()
        })
    }
}
