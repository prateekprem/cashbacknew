//
//  Ext_UIView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 13/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

fileprivate let kPlaceHolderIconTag = 990088

extension UIView{
    
    public class func fromNib<T : UIView>(inBundle bundle : Bundle? = nil) -> T {
        if let bundle = bundle{
            return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        }
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    //MARK: Instance Methods
    /**
     Method to shake current view for given duration
     */
    public func shakeCurrentViewWithDuration(_ duration: CGFloat) {
        
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = CFTimeInterval(duration)
        animation.values = [-3, 3, -2, 2, -1, 1, 0]
        layer.add(animation, forKey: "shake")
    }
    
    /**
     Method to stop the rotation of given view
     */
    public func stopRotating() {
        
        layer.removeAnimation(forKey: "spin")
    }
    
    /**
     Method to retrieve snapshot of given view
     - returns : This method returns UIImage value.
     */
    @objc public func takeSnapshot() -> UIImage {
        
        UIGraphicsBeginImageContextWithOptions(bounds.size, true, 0)
        drawHierarchy(in: bounds, afterScreenUpdates: true)
        let image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return image!
    }
    
    /**
     Creates a rotation animation with the given duration (time it takes to make a full rotation) and applies it to the view's layer - causing it to start spinning around.
     */
    @objc open func startRotatingWithDuration(_ duration: TimeInterval) {
        // Make sure there's not already a rotation in-flight
        layer.removeAnimation(forKey: "spin")
        let rotate = CABasicAnimation(keyPath: "transform.rotation.z")
        rotate.toValue = NSNumber(value: 2 * Double.pi)
        rotate.duration = duration
        rotate.repeatCount = HUGE
        layer.add(rotate, forKey: "spin")
    }
    
    /// Adds constraints to this `UIView` instances `superview` object to make sure this always has the same size as the superview.
    /// Please note that this has no effect if its `superview` is `nil` – add this `UIView` instance as a subview before calling this.
    public func bindFrameToSuperviewBounds() {
        guard let superview = self.superview else {
            print("Error! `superview` was nil – call `addSubview(view: UIView)` before calling `bindFrameToSuperviewBounds()` to fix this.")
            return
        }
        
        self.translatesAutoresizingMaskIntoConstraints = false
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
        superview.addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-0-[subview]-0-|", options: NSLayoutConstraint.FormatOptions(), metrics: nil, views: ["subview": self]))
    }
    
    /**
     Creates a gradientlayer.
     */
    public class func getGradientViewWithFrame(_ frame: CGRect) -> CAGradientLayer {
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0, green: 0, blue: 0, alpha: 0).cgColor, UIColor(red: 0, green: 0, blue: 0, alpha: 0.7).cgColor]
        gradient.locations = [0.0, 1.0]
        gradient.startPoint = CGPoint(x: 1.0, y: 0.0)
        gradient.endPoint = CGPoint(x: 1.0, y: 1.0)
        gradient.frame = frame
        return gradient
    }
    
    public func toDottedLineView() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.init(red: 218/255, green: 218/255, blue: 218/255, alpha: 1.0).cgColor
        border.fillColor = UIColor.clear.cgColor
        border.lineDashPattern = [4, 4]
        border.path = UIBezierPath(rect: self.bounds).cgPath
        border.frame = self.bounds
        self.layer.addSublayer(border)
    }
    
    public func toDottedLineViewWithRoundedCorner() {
        let border = CAShapeLayer()
        border.strokeColor = UIColor.lightGray.cgColor
        border.fillColor = UIColor.clear.cgColor
        border.lineDashPattern = [4, 4]
        border.path = UIBezierPath(roundedRect: self.bounds, cornerRadius: 8).cgPath
        border.frame = self.bounds
        self.layer.addSublayer(border)
    }
    
     public func makeRoundedBorder(withCornerRadius cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
    }
    
    public func capture() -> UIImage? {
        var image: UIImage?
        
        if #available(iOS 10.0, *) {
            let format = UIGraphicsImageRendererFormat()
            format.opaque = isOpaque
            let renderer = UIGraphicsImageRenderer(size: frame.size, format: format)
            image = renderer.image { context in
                drawHierarchy(in: frame, afterScreenUpdates: true)
            }
        } else {
            UIGraphicsBeginImageContextWithOptions(frame.size, isOpaque, UIScreen.main.scale)
            drawHierarchy(in: frame, afterScreenUpdates: true)
            image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
        }
        
        return image
    }
    
    public func roundCorn(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    // with stick width.
    public func circular(_ aBorder: CGFloat, borderColor: UIColor?) { self.circular(aBorder, borderColor, true) }
    
    public func circular(_ aBorder: CGFloat, _ borderColor: UIColor?, _ clip: Bool) {
        self.roundCorner(aBorder, borderColor, self.bounds.size.height/2.0, clip)
    }
    
    public func roundCorner(_ aBorder: CGFloat, borderColor: UIColor?, rad: CGFloat) {
        self.roundCorner(aBorder, borderColor, rad, true)
    }
    
    public func roundCorner(_ aBorder: CGFloat, _ borderColor: UIColor?, _ rad: CGFloat, _ shouldClip: Bool) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = rad
        self.clipsToBounds = shouldClip
        
        self.layer.borderWidth = aBorder
        if borderColor != nil {
            self.layer.borderColor = borderColor!.cgColor
        }
    }
    
    public func dropShadowDownside(_ offset:CGSize, radius:CGFloat, opacity:Float) {
        self.layer.masksToBounds = false
        self.layer.shadowOffset  = offset
        self.layer.shadowRadius  = radius
        self.layer.shadowOpacity = opacity
    }
    
    // MARK: - Add place holder with a name first char
    public func addPlaceHolderIcon(_ aTxt: String, bgColor: UIColor = UIColor.colorWith(hex: "ACD6F9")) {
        self.removePlaceHolderIcon()
        let placLbl = UILabel(frame: self.bounds)
        placLbl.backgroundColor = bgColor
        self.addSubview(placLbl)
        placLbl.tag = kPlaceHolderIconTag
        placLbl.text = aTxt.displaySortText().uppercased()
        placLbl.textAlignment = .center
        placLbl.textColor = UIColor.white
    }
    
    public func removePlaceHolderIcon() {
        if let vv = self.viewWithTag(kPlaceHolderIconTag) {
            vv.removeFromSuperview()
        }
    }
    
    public func dropShadow(scale: Bool = true) {
        layer.masksToBounds = false
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.5
        layer.shadowOffset = CGSize(width: -1, height: 1)
        layer.shadowRadius = 2
        
        layer.shadowPath = UIBezierPath(rect: bounds).cgPath
        layer.shouldRasterize = true
        layer.rasterizationScale = scale ? UIScreen.main.scale : 1
    }
    
    public func roundAndShadowViewWith(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(white: 0, alpha: 0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = shadowPath.cgPath
    }
    
    public func addDashedLine(strokeColor: UIColor, lineWidth: CGFloat) {
        backgroundColor = .clear
        let shapeLayer = CAShapeLayer()
        shapeLayer.name = "DashedTopLine"
        shapeLayer.bounds = bounds
        shapeLayer.position = CGPoint(x: frame.width / 2, y: frame.height / 2)
        shapeLayer.fillColor = UIColor.clear.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = [4, 4]
        let path = CGMutablePath()
        path.move(to: CGPoint.zero)
        path.addLine(to: CGPoint(x: 0, y: frame.height))
        shapeLayer.path = path
        layer.addSublayer(shapeLayer)
    }
    
    public func dropShadow() {
        //      self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOpacity = 0.5
        self.layer.shadowOffset = CGSize(width: -1, height: 1)
        self.layer.shadowRadius = 1
    }
    
    public func animateViewFromBottom() {
        self.transform = CGAffineTransform(translationX: 0, y: UIScreen.main.bounds.height/2)
        UIView.animate(withDuration: 0.5, delay: 0.1, usingSpringWithDamping: 1.0, initialSpringVelocity: 1.0, options: UIView.AnimationOptions.curveLinear, animations: {
            self.transform = CGAffineTransform.identity
        }) { ( isComplete) -> Void in
            
        }
    }
    
    public class func viewFromNib<T: UIView>(inBundle bundle : Bundle? = nil) -> T {
        if let bundle = bundle{
            return bundle.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
        }
        return Bundle.main.loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as! T
    }
    
    public func shake(count : Float = 2,for duration : TimeInterval = 1.5,withTranslation translation : Float = -5) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.repeatCount = count
        animation.duration = duration/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation
        layer.add(animation, forKey: "shake")
    }
    
    public class func instintiateNib(inBundle bundle : Bundle? = nil) -> UIView {
        return UINib(nibName: String(describing: self), bundle: bundle).instantiate(withOwner: nil, options: nil)[0] as! UIView
    }
    
    public func maskByRoundingCorners(_ masks:UIRectCorner, withRadii radii:CGSize = CGSize(width: 5, height: 5)) {
        let rounded = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: masks, cornerRadii: radii)
        
        let shape = CAShapeLayer()
        shape.path = rounded.cgPath
        
        self.layer.mask = shape
    }
    
    public func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
}
