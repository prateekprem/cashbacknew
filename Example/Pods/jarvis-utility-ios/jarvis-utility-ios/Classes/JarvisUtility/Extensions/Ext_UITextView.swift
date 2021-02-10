//
//  Ext_UITextView.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UITextView {

    public func setHTML(html: String?) {
        if let htmlText = html {
            do {
                if let fontPointSize = font?.pointSize,
                    let textHexFormat = textColor?.hexFormat(),
                    let modifiedFont = NSString(format:"<span style=\"font-family: -apple-system; white-space: pre-line; font-size: \(fontPointSize); color: \(textHexFormat)\">%@</span>" as NSString, htmlText) as String?,
                    let modifiedData = modifiedFont.data(using: .unicode, allowLossyConversion: true) {
                    
                    let attrStr = try NSAttributedString(
                        data: modifiedData,
                        options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html, NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8.rawValue],
                        documentAttributes: nil)
                    let mutableAttributedString = NSMutableAttributedString(attributedString: attrStr)
                    mutableAttributedString.trimCharacters(in: CharacterSet.newlines)
                    self.attributedText = mutableAttributedString
                } else {
                    self.attributedText = nil
                }
            } catch {
                self.attributedText = nil
            }
        } else {
            self.attributedText = nil
        }
    }
    
}
