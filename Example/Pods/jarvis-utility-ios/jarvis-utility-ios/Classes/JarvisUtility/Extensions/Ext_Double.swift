//
//  Ext_Double.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Double {
    
    /**
     Returns digit count ignoring the decimal section.
     */
    public func digitCount() -> Int {
        let string = String(format: "%.0f", arguments: [self])
        return string.count
    }
    
    mutating public func roundToPlaces(_ places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
    
    public func getFormattedStringValue() -> String {
        let formatSpecifier = (self - floor(self) > 0.0) ? "%.2f" : "%.0f"
        return String(format: formatSpecifier, self)
    }
    
    public var cleanValue: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
    
    public var cleanValueUpto2Digits: String {
        return self.truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(format: "%.2f", self)
    }
    
    public func roundToInt() -> Int{
        let value = Int(self)
        let f = self - Double(value)
        if f == 0 {
            return value
        } else {
            return value + 1
        }
    }
    
    public func displStringWith(char: String, fontSz: CGFloat, currSymbol: String, isRmvZeroPaise: Bool = false) -> NSAttributedString {
        return displStringWith(unitPrefix: char, fontSz: fontSz, unit: currSymbol, isRmvZeroPaise: isRmvZeroPaise)
    }
    
    public func displStringWith(unitPrefix: String, fontSz: CGFloat, unit: String, isRmvZeroPaise: Bool = false, postfixUnit: Bool = false, truncate: Bool = true, highlightFraction: Bool = false) -> NSAttributedString {
        let amntStr = truncate ? String(format:"%.02f", self) : String(self)
        let stringSep = amntStr.components(separatedBy: ".")
        
        var fPart = stringSep[0]
        if let mInt = Int(fPart) {
            fPart = mInt.commaString()
        }
        
        let txt0 = "\(unitPrefix)\(unit) "
        
        var txt2 = stringSep[1]
        var txt1 = "\(fPart)."
        
        if isRmvZeroPaise && txt2 == "00" {
            txt2 = ""
            txt1 = "\(fPart)"
        }
        
        let fnt1 = UIFont.systemFont(ofSize: fontSz, weight: UIFont.Weight.semibold)
        let fnt2 = UIFont.systemFont(ofSize: fontSz, weight: UIFont.Weight.light)
        
        let amountStr = NSMutableAttributedString(string: txt1, attributes: [NSAttributedString.Key.font: fnt1])
        let decStr = NSMutableAttributedString(string: txt2, attributes: [NSAttributedString.Key.font: highlightFraction ? fnt1 : fnt2])
        amountStr.append(decStr)
        
        let symStr = NSMutableAttributedString(string: txt0, attributes: [NSAttributedString.Key.font: fnt2])
        
        var result: NSMutableAttributedString!
        if postfixUnit {
            amountStr.append(symStr)
            result = amountStr
        } else {
            symStr.append(amountStr)
            result = symStr
        }
        
        return result
    }
    
    public func dateFromTimestamp(format: DateFormat = .standard) -> Date {
        return Date(timeIntervalSince1970: (self/1000))
    }

}
