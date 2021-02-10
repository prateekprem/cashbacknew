//
//  CustomVoucherDetailView.swift
//  Jarvis
//
//  Created by Nikita Maheshwari on 16/04/19.
//  Copyright © 2019 One97. All rights reserved.
//

import UIKit

class CustomVoucherDetailView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        self.drawCustomBorder(cutEdge: 5.0)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func drawCustomBorder(cutEdge: CGFloat) {
        if self.tag == 0 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: 0.0, y: cutEdge))
            path.addLine(to: CGPoint(x: 0, y: self.bounds.height - cutEdge))
            path.addLine(to: CGPoint(x: cutEdge, y: self.bounds.height))
            path.addLine(to: CGPoint(x: self.bounds.width - cutEdge, y: self.bounds.height))
            path.addLine(to: CGPoint(x: self.bounds.width, y: self.bounds.height - cutEdge))
            path.addLine(to: CGPoint(x: self.bounds.width, y: cutEdge))
            path.addCurve(to: CGPoint(x: self.bounds.width - cutEdge, y: 0), controlPoint1: CGPoint(x: self.bounds.width, y: cutEdge/2), controlPoint2: CGPoint(x: self.bounds.width - (cutEdge/2), y: 0))
            path.addLine(to: CGPoint(x: self.bounds.width - cutEdge, y: 0))
            path.addLine(to: CGPoint(x: cutEdge, y: 0))
            path.addCurve(to: CGPoint(x: 0, y: cutEdge), controlPoint1: CGPoint(x: cutEdge/2, y: 0), controlPoint2: CGPoint(x:0, y: cutEdge/2))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            self.layer.mask = shapeLayer
            
        } else if self.tag == 1 {
            let path = UIBezierPath()
            path.move(to: CGPoint(x: cutEdge, y: 0))
            path.addLine(to: CGPoint(x: 0, y: cutEdge))
            path.addLine(to: CGPoint(x: 0, y: self.bounds.height - cutEdge))
            path.addCurve(to: CGPoint(x: cutEdge, y: self.bounds.height), controlPoint1: CGPoint(x: 0, y: self.bounds.height - (cutEdge/2)), controlPoint2: CGPoint(x: cutEdge/2, y: self.bounds.height))
            path.addLine(to: CGPoint(x: self.bounds.width - cutEdge, y: self.bounds.height))
            path.addCurve(to: CGPoint(x: self.bounds.width, y: self.bounds.height - cutEdge), controlPoint1: CGPoint(x: self.bounds.width - (cutEdge/2), y: self.bounds.height), controlPoint2: CGPoint(x: self.bounds.width, y: self.bounds.height - (cutEdge/2)))
            path.addLine(to: CGPoint(x: self.bounds.width, y: cutEdge))
            path.addLine(to: CGPoint(x: self.bounds.width - cutEdge, y: 0))
            path.addLine(to: CGPoint(x: cutEdge, y: 0))
            
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = path.cgPath
            self.layer.mask = shapeLayer
        }
    }
}
