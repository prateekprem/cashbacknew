//
//  Ext_UILabel.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UILabel {
    
    public func setTextSpacing(spacing: CGFloat) {
        let attributedString = NSMutableAttributedString(string: text!)
        if textAlignment == .center || textAlignment == .right {
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length-1))
        } else {
            attributedString.addAttribute(NSAttributedString.Key.kern, value: spacing, range: NSRange(location: 0, length: attributedString.length))
        }
        attributedText = attributedString
    }
    
    public func getLabelHeight() -> CGFloat {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight = lroundf(Float(self.sizeThatFits(textSize).height))
        return CGFloat(rHeight)
    }
    
    public var numberOfVisibleLines: Int {
        let textSize = CGSize(width: CGFloat(self.frame.size.width), height: CGFloat(MAXFLOAT))
        let rHeight: Int = lroundf(Float(self.sizeThatFits(textSize).height))
        let charSize: Int = lroundf(Float(self.font.pointSize))
        return rHeight / charSize
    }
    
    public func showAttributedTxt(boldString:String, with textColor: UIColor) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize)!,
            .foregroundColor: textColor
            ])
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize)!, range: rangeStr!)
        self.attributedText = attributedString
    }
    
    public func showAttributedTxt(boldString:String) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor as Any
            ])
        
        let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
        attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
        self.attributedText = attributedString
    }
    
    public func showAttributedMultiTxt(boldStringArr:[String]) {
        
        let fontName = self.getBoldFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor as Any
            ])
        
        for boldString in boldStringArr {
            let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: boldString)
            attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
            self.attributedText = attributedString
        }
    }
    
    public func getBoldFontName() ->  String{
        var fontName = self.font.fontName
        if let range = fontName.range(of: "-") {
            fontName = String(fontName[(fontName.startIndex)..<range.lowerBound])
            fontName.append("-Bold")
        }
        return fontName
    }
    
    public func show(price: Double, inCurrency: Currency, isRmvZeroPaise: Bool = false) {
        if isRmvZeroPaise {
            let str = price.displStringWith(char: "", fontSz: self.font.pointSize, currSymbol: inCurrency.symbol, isRmvZeroPaise: isRmvZeroPaise)
            self.attributedText = str
        }
        else {
            let str = price.displStringWith(char: "", fontSz: self.font.pointSize, currSymbol: inCurrency.symbol)
            self.attributedText = str
        }
    }
    
    public func show(price: Double, inCurrency: Currency, startsWithStr:String) {
        let str = price.displStringWith(char: startsWithStr, fontSz: self.font.pointSize, currSymbol: inCurrency.symbol)
        self.attributedText = str
    }
    
    public func show(amount: Double, unit: String, unitPrefix: String, isRmvZeroPaise: Bool = false, postfixUnit: Bool = false, truncate: Bool = true, highlightFraction: Bool = false) {
        let str = amount.displStringWith(unitPrefix: unitPrefix, fontSz: self.font.pointSize, unit: unit, isRmvZeroPaise: isRmvZeroPaise, postfixUnit: postfixUnit, truncate: truncate, highlightFraction: highlightFraction)
        self.attributedText = str
    }
    
    public func showAttributedMultiTxt(mediumStringArr:[String]) {
        let fontName = self.getMediumFontName()
        let attributedString = NSMutableAttributedString(string: self.text!, attributes: [
            .font: UIFont(name: self.font.fontName, size: self.font.pointSize) as UIFont? as Any,
            .foregroundColor: self.textColor as Any
            ])
        for mediumString in mediumStringArr {
            let rangeStr: NSRange? = (attributedString.string as NSString?)?.range(of: mediumString)
            attributedString.addAttribute(.font, value: UIFont(name: fontName, size: self.font.pointSize) as UIFont? as Any, range: rangeStr!)
            self.attributedText = attributedString
        }
    }
    
    public func getMediumFontName() ->  String{
        var fontName = self.font.fontName
        if let range = fontName.range(of: "-") {
            fontName = String(fontName[(fontName.startIndex)..<range.lowerBound])
            fontName.append("-Medium")
        }
        return fontName
    }
    
    public func show(text: NSAttributedString) {
        if text.length == 0 {
            self.attributedText = text
        }
    }
    
    public func setHTMLText(html: String) {
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedString  = try NSMutableAttributedString(data: htmlData,
                                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                                      documentAttributes: nil)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0, weight: .regular) , range: NSRange(location: 0, length: attributedString.length))
                
                self.attributedText = attributedString
                
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    public func setHTMLTextOnInProgress(html: String) {
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedString  = try NSMutableAttributedString(data: htmlData,
                                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                                      documentAttributes: nil)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 13.0, weight: .regular) , range: NSRange(location: 0, length: attributedString.length))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingTail
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                self.attributedText = attributedString
                
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }

    public func setHTMLTextOnActivate(html: String) {
        if let htmlData = html.data(using: String.Encoding.unicode) {
            do {
                let attributedString  = try NSMutableAttributedString(data: htmlData,
                                                                      options: [.documentType: NSAttributedString.DocumentType.html],
                                                                      documentAttributes: nil)
                attributedString.addAttribute(.font, value: UIFont.systemFont(ofSize: 15.0, weight: .regular) , range: NSRange(location: 0, length: attributedString.length))
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineBreakMode = .byTruncatingTail
                attributedString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraphStyle, range: NSMakeRange(0, attributedString.length))
                self.attributedText = attributedString
                
            } catch let e as NSError {
                print("Couldn't parse \(html): \(e.localizedDescription)")
            }
        }
    }
    
    public func preferedLineHeight(forWidth width: CGFloat) -> CGFloat {
        guard let text = self.text as NSString?, let font = self.font else { return 0 }
        return text.boundingRect(for: CGSize(width: width, height: .greatestFiniteMagnitude), font: font).size.height
    }
    
    @objc
    public func preferedLineHeight() -> CGFloat {
        return self.preferedLineHeight(forWidth: bounds.width)
    }
    
    @objc
    public func preferedLineWidth() -> CGFloat {
        guard let text = self.text as NSString?, let font = self.font else { return 0 }
        return text.boundingRect(for: CGSize(width: .greatestFiniteMagnitude, height: bounds.height), font: font).size.width
    }
    
    @objc
    public func setStrikeOutText(_ text: String) {
        guard let text = self.text, let font = self.font else { return }
        attributedText = text.strikeOutTextWithfont(font, color: textColor, range: NSRange(location: 0, length: text.length))
    }
    
    @objc
    public func updateTextColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            textColor = UIColor.paytmRedColor()
        case .paytm:
            textColor = UIColor.paytmBlueColor()
        }
    }
    
    @objc
    public func updateDiscountColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            textColor = UIColor.paytmGreenColor()
        case .paytm:
            textColor = UIColor.paytmRedColor()
        }
    }
    
    @objc
    public func updateBackgroundColor() {
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            backgroundColor = UIColor.paytmRedColor()
        case .paytm:
            backgroundColor = UIColor.paytmBlueColor()
        }
    }
}
