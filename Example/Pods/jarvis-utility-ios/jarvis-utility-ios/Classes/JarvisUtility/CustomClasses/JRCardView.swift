//
//  JRCardView.swift
//  Jarvis
//
//  Created by Ankit Agarwal on 05/07/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

@IBDesignable open class JRCardView: UIView {
    
    @IBInspectable open var cornerRadius: CGFloat = 10.0
    
    @IBInspectable open var shadowOffsetWidth: Int = 0
    @IBInspectable open var shadowOffsetHeight: Int = 0
    @IBInspectable open var shadowColor: UIColor? = UIColor.gray
    @IBInspectable open var shadowOpacity: Float = 0.5
    
    override open func layoutSubviews() {
        layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        
        layer.masksToBounds = false
        layer.shadowColor = shadowColor?.cgColor
        layer.shadowOffset = CGSize(width: shadowOffsetWidth, height: shadowOffsetHeight);
        layer.shadowOpacity = shadowOpacity
        layer.shadowPath = shadowPath.cgPath
    }
    
}
