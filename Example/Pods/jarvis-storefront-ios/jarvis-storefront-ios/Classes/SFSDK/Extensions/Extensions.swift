//
//  Ext_UIView.swift
//  jarvis-storefront-ios
//
//  Created by Prakash Jha on 03/10/19.
//

import UIKit
//import SDWebImage
import jarvis_utility_ios

enum GradientDirection {
    case leftToRight
    case rightToLeft
    case topToBottom
    case bottomToTop
}

extension UIView {
    public func sfRoundCorner(_ aBorder: CGFloat, _ borderColor: UIColor?, _ rad: CGFloat, _ shouldClip: Bool) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = rad
        self.clipsToBounds = shouldClip
        
        self.layer.borderWidth = aBorder
        if borderColor != nil {
            self.layer.borderColor = borderColor!.cgColor
        }
    }
    
    public func sfRoundCorner(_ radius: CGFloat) {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = radius
    }
    
    public func sfMakeShadow(shadowRadius: CGFloat, shadowOpacity: Float, shadowColor:CGColor, shadowOffset: CGSize) {
        self.layer.masksToBounds = false
        self.layer.shadowRadius = shadowRadius
        self.layer.shadowOpacity = shadowOpacity
        self.layer.shadowColor = shadowColor
        self.layer.shadowOffset = shadowOffset
    }
    
    
    func drawGradient(colors: [CGColor], direction: GradientDirection) {
        if let subLayers = self.layer.sublayers {
            for layer in subLayers {
                if layer is CAGradientLayer {
                    return
                }
            }
        }
        
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = colors
        
        switch direction {
        case .leftToRight:
            gradient.startPoint = CGPoint(x: 0.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 1.0, y: 0.5)
        case .rightToLeft:
            gradient.startPoint = CGPoint(x: 1.0, y: 0.5)
            gradient.endPoint = CGPoint(x: 0.0, y: 0.5)
        case .bottomToTop:
            gradient.startPoint = CGPoint(x: 0.5, y: 1.0)
            gradient.endPoint = CGPoint(x: 0.5, y: 0.0)
        default:
            break
        }
        
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func drawGradientByRemovingOld(colors: [CGColor], direction: GradientDirection) {
        removeGradientIfAny()
        drawGradient(colors: colors, direction: direction)
    }
    
    func removeGradientIfAny() {
        if let subLayers = self.layer.sublayers {
            for layer in subLayers {
                if layer is CAGradientLayer {
                    layer.removeFromSuperlayer()
                }
            }
        }
    }
}


extension Bundle {
    class var sfBundle : Bundle{
        return Bundle.init(for: SFConfig.self)
    }
    
    class func nibWith(name: String) -> UINib? {
        return UINib(nibName : name, bundle : Bundle.sfBundle)
    }
}

extension UIImage {
    class func imageNamed(name: String) -> UIImage? {
        return UIImage(named: name, in: Bundle.sfBundle, compatibleWith: nil)
    }
}

extension UIImageView {
    func setImageFrom(url: URL?, placeHolderImg: UIImage?, completion: JRImageCacheCompletionBlock?) {
        self.jr_setImage(with: url, placeholderImage: placeHolderImg, options: .retryFailed,
                         completed: completion)
    }
}

extension UIColor {
    public class func themeBlueColor() -> UIColor {
        return UIColor(red: 0/255.0, green: 186.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
}

extension String {
    public func replaceFirst(of pattern:String,
                             with replacement:String) -> String {
        if let range = self.range(of: pattern) {
            return self.replacingCharacters(in: range, with: replacement)
        }else{
            return self
        }
    }
}

extension Double {
    public func getFormattedAmount() -> String {
        let numberStr = String(format: "%.2f", CGFloat(self))
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 0
        formatter.maximumFractionDigits = 2
        let number: NSNumber? = formatter.number(from: numberStr)
        
        if let number = number {
            if Double(truncating: number)/Double(Int(truncating: number)) > 1.0 {
                formatter.minimumFractionDigits = 2
            }
            if let formattedStr = formatter.string(from: number) {
                return formattedStr
            }
            return String(describing: number)
        }
        
        return numberStr
    }
}

extension Array {
    func chunked(into size: Int) -> [[Element]] {
        return stride(from: 0, to: count, by: size).map {
            Array(self[$0 ..< Swift.min($0 + size, count)])
        }
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
}

extension UICollectionView {
    func moveCellToCenter() {
        let visibleCenterPositionOfScrollView = Float(self.contentOffset.x + (self.bounds.size.width / 2))
        var closestCellIndex = -1
        var closestDistance: Float = .greatestFiniteMagnitude
        for i in 0..<self.visibleCells.count {
            let cell = self.visibleCells[i]
            let cellWidth = cell.bounds.size.width
            let cellCenter = Float(cell.frame.origin.x + cellWidth / 2)
            
            // Now calculate closest cell
            let distance: Float = fabsf(visibleCenterPositionOfScrollView - cellCenter)
            if distance < closestDistance {
                closestDistance = distance
                closestCellIndex = self.indexPath(for: cell)!.row
            }
        }
        if closestCellIndex != -1 {
            self.scrollToItem(at: IndexPath(row: closestCellIndex, section: 0), at: .centeredHorizontally, animated: true)
        }
        
    }
}

extension Dictionary where Key == String  { // where Key: String, Value: Any
    
    public func sfStringFor(key: String) -> String {
        return self.sfActualValueFor(key: key, inInt: true)
    }
    
    public func sfIntFor(key: String) -> Int {
        if let mInt = self[key] as? Int { return mInt }
        let value = Int(self.sfActualValueFor(key: key, inInt: true))
        return value != nil ? value! : 0
    }
    
    public func sfDoubleFor(key: String) -> Double {
        let value = Double(self.sfActualValueFor(key: key, inInt: false))
        return value != nil ? value! : 0.0
    }
    
    public func sfBooleanFor(key: String) -> Bool {
        return self.sfStringFor(key: key).lowercased() == "true" || self.sfIntFor(key: key) >= 1
    }
    
    private func sfActualValueFor(key: String, inInt: Bool) -> String {
        let str1 = self[key]
        if str1 == nil { return "" }
        
        if let str = str1 as? String {
            return (str.lowercased() == "nil" || str.lowercased() == "null") ? "" : str
        }
        
        if let num = str1 as? NSNumber {
            return inInt ? String(format:"%i", num.int32Value) : String(format:"%f", num.doubleValue)
        }
        return ""
    }
}
