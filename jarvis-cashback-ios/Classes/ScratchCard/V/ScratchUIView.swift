//
//  ScratchUIView.swift
//  ScratchCard
//
//  Created by Prateek Prem on 2019/12/23.
//

import Foundation
import UIKit


var uiScratchWidth: CGFloat!

 protocol ScratchUIViewDelegate: class {
    func scratchBegan(_ view: ScratchUIView)
    func scratchMoved(_ view: ScratchUIView)
    func scratchEnded(_ view: ScratchUIView)
}

class ScratchUIView: UIView, ScratchViewDelegate {
    
    weak var delegate: ScratchUIViewDelegate!
    var scratchView: ScratchView!
    var maskImage: UIImageView!
    var maskPath: UIImage!
    var coupponPath: UIImage!
    var maskColor: UIColor!
    var scratchPosition: CGPoint!
    
    func getScratchPercent() -> Double {
        return scratchView.getAlphaPixelPercent()
    }
    
    init(frame: CGRect, Coupon: UIImage, MaskImage: UIImage, MaskColor: UIColor, ScratchWidth: CGFloat) {
        super.init(frame: frame)
        coupponPath = Coupon
        maskPath = MaskImage
        maskColor = MaskColor
        uiScratchWidth = ScratchWidth
        self.initMe()
    }
    
    required public init?(coder aDecoder: NSCoder) {
      super.init(coder: aDecoder)
    }
    
    fileprivate func initMe() {
        maskImage = UIImageView(image: maskPath)
        maskImage.backgroundColor = maskColor

        maskImage.layer.masksToBounds = true
        maskImage.layer.cornerRadius = self.layer.cornerRadius
        
        scratchView = ScratchView(frame: self.frame, CouponImage: coupponPath, ScratchWidth: uiScratchWidth)
        scratchView.layer.masksToBounds = true
        scratchView.layer.cornerRadius = self.layer.cornerRadius
        
        maskImage.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scratchView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
        scratchView.delegate = self
        scratchView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        maskImage.autoresizingMask = [.flexibleWidth, .flexibleHeight]

        
        self.backgroundColor = UIColor.clear
        self.addSubview(maskImage)
        self.addSubview(scratchView)
        self.bringSubviewToFront(scratchView)
        
    }
    
    internal func began(_ view: ScratchView) {
        if self.delegate != nil {
            
            if view.position.x >= 0 && view.position.x <= view.frame.width && view.position.y >= 0 && view.position.y <= view.frame.height  {
                scratchPosition = view.position
            }
            self.delegate.scratchBegan(self)
        }
    }
    
    internal func moved(_ view: ScratchView) {
        if self.delegate != nil {
            if view.position.x >= 0 && view.position.x <= view.frame.width && view.position.y >= 0 && view.position.y <= view.frame.height  {
                scratchPosition = view.position
            }
            self.delegate.scratchMoved(self)
        }
    }
    
    internal func ended(_ view: ScratchView) {
        if self.delegate != nil {
            if view.position.x >= 0 && view.position.x <= view.frame.width && view.position.y >= 0 && view.position.y <= view.frame.height  {
                scratchPosition = view.position
            }
            self.delegate.scratchEnded(self)
        }
    }
}
