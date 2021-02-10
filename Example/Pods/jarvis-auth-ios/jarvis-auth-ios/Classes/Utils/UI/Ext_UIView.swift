//
//  Ext_UIView.swift
//  jarvis-auth-ios
//
//  Created by Parmod on 22/11/18.
//

import Foundation
extension UIView {
    func showToast(toastMessage:String,duration:CGFloat, yPosition: CGFloat = 0.0) {
        //View to blur bg and stopping user interaction
        //Label For showing toast text
        DispatchQueue.main.async {
            let lblMessage = UILabel()
            lblMessage.numberOfLines = 0
            lblMessage.lineBreakMode = .byWordWrapping
            lblMessage.textColor = .white
            lblMessage.backgroundColor = .black
            lblMessage.textAlignment = .center
            lblMessage.font = UIFont.init(name: "Helvetica Neue", size: 17)
            lblMessage.text = toastMessage
            
            //calculating toast label frame as per message content
            let maxSizeTitle : CGSize = CGSize(width: self.bounds.size.width-16, height: self.bounds.size.height)
            var expectedSizeTitle : CGSize = lblMessage.sizeThatFits(maxSizeTitle)
            // UILabel can return a size larger than the max size when the number of lines is 1
            expectedSizeTitle = CGSize(width:maxSizeTitle.width.getminimum(value2:expectedSizeTitle.width), height: maxSizeTitle.height.getminimum(value2:expectedSizeTitle.height))
            var yPos = yPosition
            if yPos == 0.0 {
                yPos = (self.bounds.size.height / 2) - ((expectedSizeTitle.height+16)/2)
            }
            
            lblMessage.frame = CGRect(x:((self.bounds.size.width)/2) - ((expectedSizeTitle.width+16)/2) , y: yPos, width: expectedSizeTitle.width+16, height: expectedSizeTitle.height+16)
            lblMessage.layer.cornerRadius = 8
            lblMessage.layer.masksToBounds = true
            //lblMessage.padding = UIEdgeInsets(top: 4, left: 4, bottom: 4, right: 4)
            self.addSubview(lblMessage)
            lblMessage.alpha = 0
            
            UIView.animateKeyframes(withDuration:TimeInterval(duration) , delay: 0, options: [] , animations: {
                lblMessage.alpha = 1
            }, completion: {
                sucess in
                UIView.animate(withDuration:TimeInterval(duration), delay: 8, options: [] , animations: {
                    lblMessage.alpha = 0
                })
                lblMessage.removeFromSuperview()
            })
        }
    }
    
    func dismissKeyboardOnTap(){
        let tap = UITapGestureRecognizer(target: self, action: #selector(UIView.endEditing(_:)))
        self.addGestureRecognizer(tap)
    }
    
    func anchor(top: NSLayoutYAxisAnchor? = nil,
                left: NSLayoutXAxisAnchor? = nil,
                bottom: NSLayoutYAxisAnchor? = nil,
                right: NSLayoutXAxisAnchor? = nil,
                paddingTop: CGFloat = 0,
                paddingLeft: CGFloat = 0,
                paddingBottom: CGFloat = 0,
                paddingRight: CGFloat = 0,
                width: CGFloat? = nil,
                height: CGFloat? = nil) {
        translatesAutoresizingMaskIntoConstraints = false
        if let top = top { topAnchor.constraint(equalTo: top, constant: paddingTop).isActive = true }
        if let left = left { leftAnchor.constraint(equalTo: left, constant: paddingLeft).isActive = true }
        if let bottom = bottom { bottomAnchor.constraint(equalTo: bottom, constant: -paddingBottom).isActive = true }
        if let right = right { rightAnchor.constraint(equalTo: right, constant: -paddingRight).isActive = true }
        if let width = width { widthAnchor.constraint(equalToConstant: width).isActive = true }
        if let height = height { heightAnchor.constraint(equalToConstant: height).isActive = true }
    }
    
    func centerX(inView view: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
    }
    
    func centerY(inView view: UIView, leftAnchor: NSLayoutXAxisAnchor? = nil,
                 paddingLeft: CGFloat = 0, constant: CGFloat = 0) {
        translatesAutoresizingMaskIntoConstraints = false
        centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: constant).isActive = true
        if let left = leftAnchor { anchor(left: left, paddingLeft: paddingLeft) }
    }
    
    func setDimensions(height: CGFloat, width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func setHeight(height: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        heightAnchor.constraint(equalToConstant: height).isActive = true
    }
    
    func setWidth(width: CGFloat) {
        translatesAutoresizingMaskIntoConstraints = false
        widthAnchor.constraint(equalToConstant: width).isActive = true
    }
    
    func addBlurBackground(withStyle style: UIBlurEffect.Style) {
        guard !UIAccessibility.isReduceTransparencyEnabled else { return }
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(blurEffectView, at: 0)
    }
}

extension CGFloat {
    func getminimum(value2:CGFloat) -> CGFloat {
        if self < value2 {
            return self
        }
        return value2
    }
}

extension String {
    func isValidMobileNumber() -> Bool {
        //"^[7-9][0-9]{9}$"
        //MOB_NO_REG_EX = "^([6,7,8,9]{1}+[0-9]{9})$";
        //Please enter valid Mobile Number
        let mobileNumberRegx = "[56789][0-9]{9}"
        let mobileNumberPredicate = NSPredicate(format:"SELF MATCHES %@", mobileNumberRegx)
        let isValid =  mobileNumberPredicate.evaluate(with: self)
        return isValid
    }
    
    func convertMobForTxtFld() -> String{
        if self.count > 5{
            return self.insert(seperator: " ", interval: 5)
        }
        return self
    }
}

extension UIStackView {
    func customize(backgroundColor: UIColor = .clear, radiusSize: CGFloat = 0) {
        let subView = UIView(frame: bounds)
        subView.backgroundColor = backgroundColor
        subView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        insertSubview(subView, at: 0)
        
        subView.layer.cornerRadius = radiusSize
        subView.layer.masksToBounds = true
        subView.clipsToBounds = true
    }
}

extension UIImage {
    func imageWithInsets(insets: UIEdgeInsets) -> UIImage? {
        UIGraphicsBeginImageContextWithOptions(
            CGSize(width: self.size.width + insets.left + insets.right,
                   height: self.size.height + insets.top + insets.bottom), false, self.scale)
        let _ = UIGraphicsGetCurrentContext()
        let origin = CGPoint(x: insets.left, y: insets.top)
        self.draw(at: origin)
        let imageWithInsets = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return imageWithInsets
    }
}

extension UILabel {
    private struct AssociatedKeys {
        static var popupPadding = UIEdgeInsets()
    }
    
    public var popupPadding: UIEdgeInsets? {
        get {
            return objc_getAssociatedObject(self, &AssociatedKeys.popupPadding) as? UIEdgeInsets
        }
        set {
            if let newValue = newValue {
                objc_setAssociatedObject(self, &AssociatedKeys.popupPadding, newValue as UIEdgeInsets?, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
            }
        }
    }
    
    override open func draw(_ rect: CGRect) {
        if let insets = popupPadding {
            self.drawText(in: rect.insetBy(dx: insets.left, dy: insets.top))
        } else {
            self.drawText(in: rect)
        }
    }
    
    public func setMargins(margin: CGFloat = 0.0) {
        if let textString = self.text {
            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.firstLineHeadIndent = margin
            paragraphStyle.headIndent = margin
            paragraphStyle.tailIndent = -margin
            paragraphStyle.alignment = .center
            let attributedString = NSMutableAttributedString(string: textString)
            attributedString.addAttribute(.paragraphStyle, value: paragraphStyle, range: NSRange(location: 0, length: attributedString.length))
            attributedText = attributedString
        }
    }
    
    public func setBottomBorder() {
        self.layer.backgroundColor = UIColor.white.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.gray.cgColor
        self.layer.shadowOffset = CGSize(width: 0.0, height: 1.0)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowRadius = 0.0
    }
}

extension UITextField{
    func isEmpty() -> Bool{
        if let text = self.text, !text.isEmpty{ return true }
        else {return false}
    }
}

public extension NSAttributedString {
    convenience init(format: NSAttributedString, args: [NSAttributedString]) {
        let mutableNSAttributedString = NSMutableAttributedString(attributedString: format)

        for arg in args{
            let range = NSString(string: mutableNSAttributedString.string).range(of: "%@")
            if range.length != 0{
                mutableNSAttributedString.replaceCharacters(in: range, with: arg)
            }
        }
        self.init(attributedString: mutableNSAttributedString)
    }
}
