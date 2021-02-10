//
//  JRCBScratchCardContainerFullScreen.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 26/05/20.
//

import UIKit

class JRCBScratchCardContainerFullScreen: JRCBPopOver {
    private var contentModels : JRCBScratchContentVM?
    private let margin = CGFloat(40)
    private var cardView: JRCBScratchCardView?
    
    func setUpWith(contentVM: JRCBScratchContentVM) {
        self.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.4)
        self.contentModels = contentVM
        let ww = min(self.bounds.width - 2 * margin, 280)
        let ratio : CGFloat = 1.25
        let hh = (ww * ratio) + 25 //ww * ratio + margin
        let fr = CGRect(x: (self.bounds.width - ww)/2.0, y: (self.bounds.height - hh)/2.0, width: ww, height: hh)
        
        let card = JRCBScratchCardView.cardWith(fr: fr)
        self.cardView = card
        card.delegate = self
        self.addSubview(card)
        card.addCard(contentVM: contentVM)
    }
    
    class func display(gratification: JRCBGratification, fromController: UIViewController) {
        let containerV = JRCBScratchCardContainerFullScreen.init(frame: fromController.view.bounds)
        let viewModel = JRCBScratchContentVM(modelData: gratification, assuredOfferName: "")
        containerV.setUpWith(contentVM: viewModel)
        containerV.addMe(fromController.view)
        containerV.delegate = fromController as? JRCBPopOverDelegate
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first, let cardV = cardView {
            guard let vv = touch.view else {
                return
            }
            if vv != cardV && !vv.isDescendant(of: cardV) {
                self.removeMe()
            }
        }
    }
}

extension JRCBScratchCardContainerFullScreen: JRCBScratchCardViewDelegate {
    func closeView() {
        self.removeMe()
    }
}
