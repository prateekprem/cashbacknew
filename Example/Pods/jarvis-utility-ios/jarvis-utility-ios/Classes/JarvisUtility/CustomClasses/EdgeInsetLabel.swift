//
//  EdgeInsetLabel.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 28/06/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@IBDesignable open class EdgeInsetLabel: UILabel {
    @IBInspectable open var topInset: CGFloat = 0.0
    @IBInspectable open var leftInset: CGFloat = 0.0
    @IBInspectable open var bottomInset: CGFloat = 0.0
    @IBInspectable open var rightInset: CGFloat = 0.0
    
    open var insets: UIEdgeInsets {
        get {
            return UIEdgeInsets(top: topInset, left: leftInset, bottom: bottomInset, right: rightInset)
        }
        set {
            topInset = newValue.top
            leftInset = newValue.left
            bottomInset = newValue.bottom
            rightInset = newValue.right
        }
    }
    
    override open func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: insets))
    }
    
    override open func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjSize = super.sizeThatFits(size)
        adjSize.width += leftInset + rightInset
        adjSize.height += topInset + bottomInset
        
        return adjSize
    }
    
    override open var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.width += leftInset + rightInset
        contentSize.height += topInset + bottomInset
        
        return contentSize
    }
}
