//
//  JRCBScratchCardView.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 20/05/20.
//

import UIKit

protocol JRCBScratchCardViewDelegate: class {
    func closeView()
}

class JRCBScratchCardView: UIView {
    private var contentCard: JRCBScratchContentV!
    @IBOutlet weak var btnClose: UIButton!
    weak var delegate: JRCBScratchCardViewDelegate?
    
    class func cardWith(fr: CGRect) -> JRCBScratchCardView {
        let vv =  UINib(nibName: "JRCBScratchCardContainerView", bundle: Bundle.cbBundle).instantiate(withOwner: nil, options: nil)[1] as! JRCBScratchCardView
        vv.frame = fr
        return vv
    }
    
    func addCard(contentVM: JRCBScratchContentVM) {
        if contentCard == nil {
            let bnd = self.bounds
            if let contCard = JRCBScratchContentV.cardWith(fr: CGRect(x: 0, y: 25, width: bnd.width, height: bnd.height-25), viewM: contentVM) {
                self.contentCard = contCard
                self.btnClose.isHidden = !contentVM.isFromScrstchCardSection
                self.insertSubview(contentCard, at: 0)
                self.addConstraint(contentV: contCard)
                self.layoutIfNeeded()
                contentCard.delegate = self
                contentCard.addRoundAndShadowViewWith(cornerRadius: 20)
                contentCard.superContainerV.roundedCorners(radius: 20)

                contentCard.refreshCardUI()
            }
        }
    }
    
    private func replaceCard(contentVM: JRCBScratchContentVM) {
        contentCard.removeFromSuperview()
        contentCard = nil
        self.addCard(contentVM: contentVM)
    }

    func addConstraint(contentV: UIView) {
        contentV.translatesAutoresizingMaskIntoConstraints = false
        let attributes: [(NSLayoutConstraint.Attribute, CGFloat)] = [(.top, 25.0), (.bottom, 0.0), (.right, 0.0), (.left, 0.0)]
        NSLayoutConstraint.activate(attributes.map {
            NSLayoutConstraint(item: contentV, attribute: $0.0, relatedBy: .equal, toItem: self, attribute: $0.0, multiplier: 1, constant: $0.1)
        })
    }
    
    @IBAction func btnCloseClicked(_ sender: Any) {
        self.delegate?.closeView()
    }
}


extension JRCBScratchCardView: JRCBScratchContentVProtocol {
    func flipAnimationHandle(contentGratif: JRCBGratification) {
        let transitionOptions = UIView.AnimationOptions.transitionFlipFromRight
        UIView.transition(with: self, duration: 1.0, options: transitionOptions, animations: {
            let contentVM = JRCBScratchContentVM(modelData: contentGratif)
            DispatchQueue.main.async {
                self.replaceCard(contentVM: contentVM)
            }
            JRCBNotificationName.notifRemoveScreatchCard.fireMeWith(userInfo: ["refresh": "true"])
            
        }) { (_) in
            
        }
    }
}
