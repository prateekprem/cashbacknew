//
//  JRAttriTextView.swift
//  JRAttriTextView
//
//  Created by Sandesh Kumar on 05/01/17.
//  Copyright © 2017 Robosoft Technologies. All rights reserved.
//

import UIKit
public typealias TextViewHandler = () -> Void
public typealias TextViewHandler1 = (_ isHighlightedTextTapped: Bool)-> Void

public class JRAttriTextView: UITextView {
    public var handler: TextViewHandler?
    public var handler1: TextViewHandler1?
    public var isBlankSpaceTouch : Bool = false
    
    public func setTitle(_ text: String, subStr: String, hightlightColor: UIColor, needUnderline: Bool = false, handler: TextViewHandler?) {
        if let handler = handler {
            self.handler = handler
        }
        attributedText = highlightedSubstring(text + " ", substring: subStr, color: hightlightColor, needUnderLine: needUnderline)
    }
    
    public func setTitleByAppendingHightlighter(_ titleText: String, highlighterText: String, hightlightColor: UIColor, needUnderline: Bool = false, handler: TextViewHandler?) {
        if let handler = handler {
            self.handler = handler
        }
            
        attributedText = appendingHighlightedString(titleText + " ", highlighterText: highlighterText, color: hightlightColor, needUnderLine: needUnderline)
    }
    
    //to set attributed text
    public func setAttributedTitle( attriText: NSMutableAttributedString, subStr: String, hightlightColor: UIColor, needUnderline: Bool = false, handler: (( _ isHighlightedTextTapped: Bool)-> Void)?) {
        if let handler = handler {
            self.handler1 = handler
        }
        let range = (attriText.string as NSString).range(of: subStr, options: NSString.CompareOptions.caseInsensitive)
        if range.location != NSNotFound && range.length > 0 {
            attriText.addAttribute(NSAttributedString.Key.foregroundColor, value:hightlightColor, range: range)
            let style = needUnderline ? NSUnderlineStyle.single.rawValue : NSUnderlineStyle.none.rawValue
            attriText.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: style), range: range)
        }
        attributedText = attriText
    }
    
    public func setTitle( text: String, subStr: String, hightlightColor: UIColor, needUnderline: Bool = false, handler: (( _ isHighlightedTextTapped: Bool)-> Void)?) {
        if let handler = handler {
            self.handler1 = handler
        }
        attributedText = highlightedSubstring(text + " ", substring: subStr, color: hightlightColor, needUnderLine: needUnderline)
    }
    
    override public func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if let touch = touches.first {
            
            var location = touch.location(in: self)
            if (self.bounds.contains(location))
            {
                location.x -= textContainerInset.left
                location.y -= textContainerInset.top
                // Find the character that's been tapped on
                let index = layoutManager.characterIndex(for: location, in: textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
                if index < textStorage.length - 1 {
                    var range = NSRange()
                    let dict =  textStorage.attributes(at: index, effectiveRange: &range)
                    if let value = dict[NSAttributedString.Key.underlineStyle] as? Int, value == NSUnderlineStyle.single.rawValue || value == NSUnderlineStyle.none.rawValue {
                        handler?()
                        handler1?(true)
                    } else {
                        handler1?(false)
                    }
                } else if isBlankSpaceTouch == true {
                    handler1?(false)
                }
            }
        }
    }
    
    
    
    private func highlightedSubstring(_ text: String, substring: String, color: UIColor, needUnderLine: Bool) -> NSMutableAttributedString {
        let string = text as NSString
        let range = string.range(of: substring, options: NSString.CompareOptions.caseInsensitive)
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        let str = NSMutableAttributedString(string: text)
        
        if let textColor = textColor {
            str.addAttribute(NSAttributedString.Key.foregroundColor, value: textColor, range: NSRange(location: 0, length: text.length))
        }
 
        if range.location != NSNotFound && range.length > 0 {
            str.addAttribute(NSAttributedString.Key.foregroundColor, value:color, range: range)
            let style = needUnderLine ? NSUnderlineStyle.single.rawValue : NSUnderlineStyle.none.rawValue
            str.addAttribute(NSAttributedString.Key.underlineStyle, value: NSNumber(value: style), range: range)
            str.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 12) , range: NSRange.init(location: 0, length: string.length))
            str.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, str.length))
            return str
        }
        return str
    }
    
    
    
    private func appendingHighlightedString(_ titleText: String, highlighterText: String, color: UIColor, needUnderLine: Bool) -> NSMutableAttributedString {
        
        let title = NSMutableAttributedString(string: titleText)
        
        var attrib: [NSAttributedString.Key : Any] = [NSAttributedString.Key.foregroundColor: color]
        attrib[NSAttributedString.Key.underlineStyle] = needUnderLine ? NSNumber(value:NSUnderlineStyle.single.rawValue) : NSNumber(value:NSUnderlineStyle.none.rawValue)
        title.append(NSMutableAttributedString(string: highlighterText, attributes:attrib))
        
        let totalLength = title.length
        title.addAttribute(NSAttributedString.Key.font, value: self.font ?? UIFont.systemFont(ofSize: 12) , range: NSRange.init(location: 0, length: totalLength))
        
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 4
        title.addAttribute(NSAttributedString.Key.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, totalLength))
        
        return title
    }
}
