//
//  JRCB_Ext.swift
//  jarvis-cashback-ios
//
//  Created by Prakash Jha on 24/12/19.
//

import UIKit
import Lottie

extension UIView {
    func roundedCorners(radius: CGFloat, borderColor: UIColor? = nil) {
        self.layer.cornerRadius = radius
        self.layer.masksToBounds = true
        if let bColor = borderColor {
            self.layer.borderWidth = 1
            self.layer.borderColor = bColor.cgColor
        }
    }
    
    func roundBy(border: CGFloat, color: UIColor?, radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
        self.clipsToBounds = true
        self.layer.borderWidth = border
        if color != nil {
            self.layer.borderColor = color!.cgColor
        }
    }
    
    func image() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
    
    func cbAddLoadingView() {
        let animationView = JRCBLOTAnimation.animationPaymentsLoader.lotView
        animationView.frame = self.bounds
        animationView.backgroundColor = self.backgroundColor
        animationView.contentMode = .scaleAspectFit
        animationView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        animationView.autoresizesSubviews = true
        self.addSubview(animationView)
        JRCBLoaderAnimationView().infinitePlay(viewAnimate: animationView)
    }
    
    func cbRemoveLoadingView() {
        let subViews = self.subviews
        for vw in subViews {
            if vw .isKind(of: LOTAnimationView.self) {
                vw.removeFromSuperview()
            }
        }
    }
}



extension UIView {
    func addDashedBorder(width: CGFloat? = nil, height: CGFloat? = nil, lineWidth: CGFloat = 2, lineDashPattern:[NSNumber]? = [4,3], strokeColor: UIColor = UIColor.red, fillColor: UIColor = UIColor.clear) {
        
        
        var fWidth: CGFloat? = width
        var fHeight: CGFloat? = height
        
        if fWidth == nil { fWidth = self.frame.width }
        if fHeight == nil { fHeight = self.frame.height }
        
        let shapeName = "cbBorderLayer"
        //Remove existing Layer with same name if present to avoid multiple layers getting added during layout cycle.
        for dashLayer in self.layer.sublayers ?? [] where dashLayer.name == shapeName {
            dashLayer.removeFromSuperlayer()
        }
        
        let shapeLayer:CAShapeLayer = CAShapeLayer()
        let shapeRect = CGRect(x: 0, y: 0, width: fWidth!, height: fHeight!)
        shapeLayer.bounds = shapeRect
        shapeLayer.position = CGPoint(x: fWidth!/2, y: fHeight!/2)
        shapeLayer.fillColor = fillColor.cgColor
        shapeLayer.strokeColor = strokeColor.cgColor
        shapeLayer.lineWidth = lineWidth
        shapeLayer.lineJoin = CAShapeLayerLineJoin.round
        shapeLayer.lineDashPattern = lineDashPattern
        shapeLayer.name = shapeName
        shapeLayer.path = UIBezierPath(roundedRect: shapeRect, cornerRadius: 10).cgPath
        self.layer.addSublayer(shapeLayer)
    }

    //Function: addBorder
    func addBorder(borderColor: UIColor = UIColor.black, borderWidth: CGFloat = 1.0) {
        self.layer.borderColor = borderColor.cgColor
        self.layer.borderWidth = borderWidth
        self.layer.masksToBounds = true
    }
    
    public func addRoundAndShadowViewWith(cornerRadius: CGFloat) {
        self.layer.cornerRadius = cornerRadius
        let shadowPath = UIBezierPath.init(roundedRect: self.bounds, cornerRadius: cornerRadius)
        self.layer.masksToBounds = false
        self.layer.shadowColor = UIColor.init(white: 0, alpha: 0.14).cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 4)
        self.layer.shadowOpacity = 1.0
        self.layer.shadowPath = shadowPath.cgPath
    }
}


extension Dictionary where Key == String {
    var stringForm: String? {
        let options: JSONSerialization.WritingOptions = []
        do {
            let data = try JSONSerialization.data(withJSONObject: self, options: options)
            if let string = String(data: data, encoding: String.Encoding.utf8) {
                return string
            }
        } catch {
            print(error)
        }
        
        return nil
    }
    
    func merge(dict: JRCBJSONDictionary) -> JRCBJSONDictionary {
        var mDict = self as JRCBJSONDictionary
        for (key, value) in dict {
            mDict[key] = value
        }
        return mDict
    }
}

extension Dictionary {
    func toJSONData() -> Data {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: self, options: .prettyPrinted)
            return jsonData
            
        } catch {
            print(error.localizedDescription)
            return Data()
        }
    }
}

extension Formatter {
    static let withSeparator: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.groupingSeparator = ","
        formatter.numberStyle = .decimal
        return formatter
    }()
}

extension BinaryInteger {
    var formattedWithSeparator: String {
        return Formatter.withSeparator.string(for: self) ?? ""
    }
}

extension UILabel {
    func applyLetterSpacing(latterSpacing: CGFloat = 0) {
        let characterSpacing: CGFloat = latterSpacing
        let string = NSMutableAttributedString(string: self.text!)
        if string.length > 0 {
            string.addAttribute(.kern, value: characterSpacing, range: NSRange(location: 0, length: string.length - 1))
            self.attributedText = string
        }
    }
    
    func set(text: String, lineSpace: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text)
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpace // Whatever line spacing you want in points
        attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attributedString.length))
        self.attributedText = attributedString
    }
    
    func setHTML(text: String) {
        self.attributedText = text.htmlAttributedString()
    }
}

extension UIColor {
    class func colorWith(r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat = 1.0) -> UIColor {
        return UIColor(red: r/255, green: g/255, blue: b/255, alpha: a)
    }
}


extension UIImage {
    convenience init(color: UIColor, size: CGSize) {
        UIGraphicsBeginImageContextWithOptions(size, false, 1)
        color.set()
        let ctx = UIGraphicsGetCurrentContext()!
        ctx.fill(CGRect(origin: .zero, size: size))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        self.init(data: image.pngData()!)!
    }
}


extension UISegmentedControl {
    func fallBackToPreIOS13Layout(tintColor: UIColor = UIColor.ScratchCard.Blue.commonBtnBlueColor) {
        self.tintColor = tintColor
        if #available(iOS 13, *) {
            let bg = UIImage(color: .clear, size: CGSize(width: 1, height: 32))
            let devider = UIImage(color: tintColor, size: CGSize(width: 1, height: 32))
            self.setBackgroundImage(bg, for: .normal, barMetrics: .default)
            self.setBackgroundImage(devider, for: .selected, barMetrics: .default)
            self.setDividerImage(devider, forLeftSegmentState: .normal, rightSegmentState: .normal, barMetrics: .default)
            self.layer.borderWidth = 1
            self.layer.borderColor = tintColor.cgColor
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: tintColor], for: .normal)
            self.setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
            
        } else {
            self.tintColor = tintColor
        }
    }
}

extension String {
    func separate(every stride: Int = 4, with separator: Character = " ") -> String {
        if self.isEmpty { return self }
        return String(enumerated().map { $0 > 0 && $0 % stride == 0 ? [separator, $1] : [$1]}.joined())
    }

    func htmlAttributedString() -> NSAttributedString? {
        guard let data = self.data(using: String.Encoding.utf16, allowLossyConversion: false) else { return nil }
        guard let html = try? NSMutableAttributedString(
            data: data,
            options: [.documentType: NSAttributedString.DocumentType.html],
            documentAttributes: nil) else { return nil }
        
        html.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0, weight: .regular) , range: NSRange(location: 0, length: html.length))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        html.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, html.length))
        
        return html
    }
    
    func getUnderlineAttrText(font: UIFont = UIFont.fontMediumOf(size: 14),
                              clr: UIColor = UIColor(hex: "1D2F54")) -> NSAttributedString {
        let attrs = [
            NSAttributedString.Key.font : UIFont.fontMediumOf(size: 14),
            NSAttributedString.Key.foregroundColor : UIColor(hex: "1D2F54"),
            NSAttributedString.Key.underlineStyle : 1] as [NSAttributedString.Key : Any]
        
         let attributedString = NSMutableAttributedString(string:"")
        let ttlStr = NSMutableAttributedString(string:self, attributes:attrs)
        attributedString.append(ttlStr)
        return attributedString
    }
}


extension Date {
    func displayStrIn(format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format //"dd, MMM yyyy"
        return formatter.string(from: self)
    }
}

extension UIImage {
    class func imageWith(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.cbBundle, compatibleWith: nil)
    }
}
