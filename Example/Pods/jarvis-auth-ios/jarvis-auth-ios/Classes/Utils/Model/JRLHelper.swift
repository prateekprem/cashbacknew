//
//  JRLHelper.swift
//  Login
//
//  Created by Parmod on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

internal class JRLHelper: NSObject {
    
    static func getAttributedString(_ messageStr: String, _ links: [String]) -> NSAttributedString {
        let content = NSMutableAttributedString(string: messageStr, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)])
        var attributedLinks: [NSAttributedString] = []
        for link in links{
            let l1 = NSAttributedString(string: link, attributes: [NSAttributedString.Key.foregroundColor: UIColor.paytmBlueColor(), NSAttributedString.Key.font : UIFont.systemFont(ofSize: 11)])
            attributedLinks.append(l1)
        }
        
        let result  = NSAttributedString(format: content, args: attributedLinks)
        return result
    }
    
    static func getUnderlineAttributedString(_ messageStr: String, _ links: [String]) -> NSAttributedString {
        let attributedString = NSMutableAttributedString(string: messageStr, attributes: [NSAttributedString.Key.font : UIFont.systemFont(ofSize: 14)])
        
        for linkStr in links {
            if let textRange = messageStr.range(of: linkStr) {
                let range = NSMakeRange(textRange.lowerBound.utf16Offset(in: messageStr), textRange.upperBound.utf16Offset(in: messageStr)-textRange.lowerBound.utf16Offset(in: messageStr))
                if range.location + range.length < attributedString.length{
                    attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.paytmBlueColor(), range: range)
                    attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.patternDot.rawValue | NSUnderlineStyle.single.rawValue, range: range)
                }
            }
        }
        return attributedString
    }
    
    static func getFullLoginId(dataModel:JRLOtpPsdVerifyModel?) -> String?{
        guard let dataModel = dataModel, let loginId = dataModel.loginId else {
            return nil
        }
        var fullLoginId = loginId
        if dataModel.loginType == .mobile {
            fullLoginId = "+91" + loginId
            return fullLoginId
        }
        return loginId
    }
}

class JRAuthUtility {
    static func addSeparator(_ inputString: String, _ separator: String, _ frequency: Int) -> String {
        let outputString = NSMutableString(string: inputString)
        let maxLength: Int = outputString.length
        let separationCount: Int = maxLength/frequency - 1
        for index in 1...separationCount {
            outputString.insert(separator, at: index * frequency)
        }
        return String(outputString)
    }
    
    static func serializedString(from object: Any) -> String {
        do {
            let options: JSONSerialization.WritingOptions
            if #available(iOS 11.0, *) {
                options = .sortedKeys
            } else {
                options = .prettyPrinted
            }
            let jsonData = try JSONSerialization.data(withJSONObject: object, options: options)
            return (String(data: jsonData, encoding: .ascii) ?? "")
        } catch {
            return ""
        }
    }
}

extension Error{
    func getMsgWithCode() -> (String, String){
        let lmsg = self.localizedDescription
        let msg = lmsg.isEmpty ? JRLoginConstants.generic_error_message : lmsg
        let eCode = (self as NSError).code
        return (msg,String(eCode))
    }
}
