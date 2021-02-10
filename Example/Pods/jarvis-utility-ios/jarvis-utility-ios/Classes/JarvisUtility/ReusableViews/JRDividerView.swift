//
//  JRDividerView.swift
//  Jarvis
//
//  Created by Chaithanya Kumar on 04/01/16.
//  Copyright © 2016 One97. All rights reserved.
//

import UIKit

public class JRDividerView: UIView {

    @objc public var color: UIColor?
    
    override public func awakeFromNib() {
        
        
    }
    
    @objc public func redrawWithColor(_ color: UIColor) {
        self.setValue(color, forKey: "color")
        self.setNeedsDisplay()
    }
    
    override public func draw(_ rect: CGRect) {
        
        super.draw(rect)
        
        let bottomInset: CGFloat = 0.0
        
        if let context = UIGraphicsGetCurrentContext() {
            
            context.saveGState()
            //draw
            context.setLineWidth(1.0)
            
            var lineColor = self.value(forKey: "color") as? UIColor
            if (lineColor == nil) {
                
                lineColor = UIColor.dividerColor()
            }

            context.setStrokeColor(lineColor!.cgColor)
            context.move(to: CGPoint(x: 0, y: rect.height - bottomInset))
            context.addLine(to: CGPoint(x: rect.width, y: rect.height - bottomInset))
            context.strokePath()
            context.restoreGState()
        }
    }
}
