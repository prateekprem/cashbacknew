//
//  Ext_ NSMutableAttributedString.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension NSMutableAttributedString {
    
    public func highlightedSubstring(_ substring: String, withFont font: UIFont, color: UIColor?) -> NSMutableAttributedString {
        let string = self.string as NSString
        let range = string.range(of: substring, options: NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound && range.length > 0 {
            let str = self
            if let color = color {
                str.setAttributes([NSAttributedString.Key.font: font,NSAttributedString.Key.foregroundColor:color], range: range)
            } else {
                str.setAttributes([NSAttributedString.Key.font: font], range: range)
            }
            return str
        }
        return NSMutableAttributedString(string: self.string, attributes: nil)
    }
    
    @objc public func highlightedSubstring(_ substring: String, withFont font: UIFont) -> NSMutableAttributedString {
        return highlightedSubstring(substring, withFont: font, color: nil)
    }
    
    @objc public class func formattedAmountValue(_ font:UIFont, amountValue:Float64) -> NSMutableAttributedString {
        let amountString = (String(format:"%.02f", amountValue))
        let string = amountString as NSString
        let stringSeparator :[String]? = string.components(separatedBy: ".")
        if let stringSeparator = stringSeparator {
            let attributedString = NSMutableAttributedString(string:self.generateFormattedStringWithSeparator(stringSeparator[0]))
            var firstAttributes : NSDictionary
            firstAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font.pointSize, weight: UIFont.Weight.ultraLight)]
            let decimalString = NSMutableAttributedString(string: stringSeparator[1])
            decimalString.addAttributes(firstAttributes as! [NSAttributedString.Key : Any], range: (stringSeparator[1] as NSString).range(of: stringSeparator[1]))
            
            let result = NSMutableAttributedString(string: "₹ ")
            result.append(attributedString)
            result.append(NSMutableAttributedString(string: "."))
            result.append(decimalString)
            return result
            
        } else {
            return NSMutableAttributedString(string: "₹ \(self.generateFormattedStringWithSeparator(amountString))")
        }
    }
    
    public class func generateFormattedStringWithSeparator(_ exValue:String) -> String {
        let fmt = NumberFormatter()
        fmt.numberStyle = .decimal
        fmt.locale = Locale.init(identifier: "en_IN")
        fmt.maximumFractionDigits = 0
        if let intVal = Int(exValue) {
            let result = fmt.string(from: NSNumber(value: intVal))
            return result ?? exValue
        }
        return exValue
    }
    
    /*returns attributed string with:
     1. no space between rupee and value
     2. lightens value after decimal*/
    
    public class func attributedAmountValue(_ font:UIFont, plainString:String) -> NSMutableAttributedString {
        
        let string = plainString as NSString
        let stringSeparator :[String]? = string.components(separatedBy: ".")
        if let stringSeparator = stringSeparator {
            let attributedString = NSMutableAttributedString(string:NSMutableAttributedString.generateFormattedStringWithSeparator(stringSeparator[0]))
            var firstAttributes : NSDictionary
            firstAttributes = [NSAttributedString.Key.font:UIFont.systemFont(ofSize: font.pointSize, weight: UIFont.Weight.ultraLight)]
            
            var result = NSMutableAttributedString(string: "")
            if plainString.contain(subStr: "₹"){
                result.append(attributedString)
            } else {
                result = NSMutableAttributedString(string: "₹")
                result.append(attributedString)
            }
            if stringSeparator.count > 1 {
                let decimalString = NSMutableAttributedString(string: stringSeparator[1])
                decimalString.addAttributes(firstAttributes as! [NSAttributedString.Key : Any], range: (stringSeparator[1] as NSString).range(of: stringSeparator[1]))
                result.append(NSMutableAttributedString(string: "."))
                result.append(decimalString)
                
            }
            return result
            
        } else {
            return NSMutableAttributedString(string: "₹\(NSMutableAttributedString.generateFormattedStringWithSeparator(plainString))")
        }
    }
    
    
    public func trimCharacters(in characterSet: CharacterSet) {
        var range = (string as NSString).rangeOfCharacter(from: characterSet)
        
        // Trim leading characters from character set.
        while range.length != 0 && range.location == 0 {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: characterSet)
        }
        
        // Trim trailing characters from character set.
        range = (string as NSString).rangeOfCharacter(from: characterSet, options: .backwards)
        while range.length != 0 && NSMaxRange(range) == length {
            replaceCharacters(in: range, with: "")
            range = (string as NSString).rangeOfCharacter(from: characterSet, options: .backwards)
        }
    }
    
    public class func stringsArrayWithBulletSymbol(stringList: [String],
                                            font: UIFont,
                                            bullet: String = "\u{2022}",
                                            indentation: CGFloat,
                                            lineSpacing: CGFloat,
                                            paragraphSpacing: CGFloat,
                                            textColor: UIColor,
                                            bulletColor: UIColor) -> NSAttributedString {
        
        let textAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: textColor]
        let bulletAttributes: [NSAttributedString.Key: Any] = [NSAttributedString.Key.font: font, NSAttributedString.Key.foregroundColor: bulletColor]
        
        let paragraphStyle = NSMutableParagraphStyle()
        let nonOptions = [NSTextTab.OptionKey: Any]()
        paragraphStyle.tabStops = [
            NSTextTab(textAlignment: .left, location: indentation, options: nonOptions)]
        paragraphStyle.defaultTabInterval = indentation
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.paragraphSpacing = paragraphSpacing
        paragraphStyle.headIndent = indentation
        
        let bulletList = NSMutableAttributedString()
        for string in stringList {
            let formattedString = "\(bullet) \(string)\n"
            let attributedString = NSMutableAttributedString(string: formattedString)
            
            attributedString.addAttributes(
                [NSAttributedString.Key.paragraphStyle : paragraphStyle],
                range: NSMakeRange(0, attributedString.length))
            
            attributedString.addAttributes(
                textAttributes,
                range: NSMakeRange(0, attributedString.length))
            
            let string:NSString = NSString(string: formattedString)
            let rangeForBullet:NSRange = string.range(of: bullet)
            attributedString.addAttributes(bulletAttributes, range: rangeForBullet)
            bulletList.append(attributedString)
        }
        return bulletList
    }
    
    @discardableResult public func bold(_ text:String,_ size:CGFloat) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size)]
        let boldString = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult public func bold(_ text:String,_ size:CGFloat,color:UIColor) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: size), NSAttributedString.Key.foregroundColor:color]
        let boldString = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult public func bold(_ text:String) -> NSMutableAttributedString {
        let attrs:[NSAttributedString.Key : Any] = [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 15)]
        let boldString = NSMutableAttributedString(string: text, attributes:attrs)
        self.append(boldString)
        return self
    }
    
    @discardableResult public func normal(_ text:String)->NSMutableAttributedString {
        let normal =  NSAttributedString(string: text)
        self.append(normal)
        return self
    }
}


extension NSUnderlineStyle {
    public static var none: NSUnderlineStyle { return NSUnderlineStyle(rawValue: 0) }
}
