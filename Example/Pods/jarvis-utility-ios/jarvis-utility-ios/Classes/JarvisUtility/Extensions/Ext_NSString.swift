//
//  Ext_NSString.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import CommonCrypto

extension NSString {
    
    //    call this method to remove spaces in a string ex : "     Stev   Job   " output will be "Stev Job"
    public func getStringWithRomovingWhiteSpaces() -> String {
        var formatedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let stringComponent = formatedString.components(separatedBy: " ")
        formatedString = stringComponent.filter { !$0.isEmpty }.joined(separator: " ")
        return formatedString
    }
    
    @objc public func getQueryStringParameter(param: String) -> String {
        if let urlComponents = URLComponents(string: self  as String), let queryItems = (urlComponents.queryItems) {
            let value =  queryItems.first(where: { $0.name == param })?.value
            if let value = value {
                return value
            }
        }
        return ""
    }
    
    @objc public func updateFormatsForLocalization() -> NSString {
        
        var localisedString = self
        var updatedString = self.replacingOccurrences(of: ",", with: " ")
        updatedString = updatedString.replacingOccurrences(of: "-", with: " ")
        let updatedStringsArray = updatedString.components(separatedBy: " ")
        for subString in updatedStringsArray {
            
            localisedString = localisedString.replacingOccurrences(of: subString, with: NSLocalizedString(subString, comment: subString)) as NSString
        }
        return localisedString
    }
    
    @objc public static func ordinalNumberSuffix(_ number: Int) -> String {
        
        if number > 3 && number < 21 {
            return "th"
        }
        
        switch number % 10 {
            
        case 1: return "st"
        case 2: return "nd"
        case 3: return "rd"
        default : return "th"
        }
    }
    
    public func encodeURLString() -> NSString {
        
        let newCharacterSet = CharacterSet.init(charactersIn: "!*'() ;:@&+$,/?%#[]").inverted
        if let encodedString = self.addingPercentEncoding(withAllowedCharacters: newCharacterSet) {
            return encodedString as NSString
        } else {
            return self
        }
    }
    
    
    @objc public func doesTheStringMatchesWithRegularExpression(_ regexString : NSString?) -> Bool {
        guard regexString != nil else {
            print("No Regex provided")
            return true
        }
        
        do {
            let regex = try NSRegularExpression(pattern: regexString! as String, options: [.caseInsensitive])
            let numberOfMatches = regex.numberOfMatches(in: self as String, options:[], range: NSMakeRange(0, self.length))
            return numberOfMatches != 0
        }
        catch {
            return true
        }
    }
    
    public func doesTheWholeStringMatchesWithRegularExpression(regexString : NSString?) -> Bool {
        guard regexString != nil else {
            print("No Regex provided")
            return true
        }
        
        do {
            _ = try NSRegularExpression(pattern: regexString! as String, options: [.caseInsensitive])
            let predicate:NSPredicate = NSPredicate(format: "SELF MATCHES %@", regexString!)
            var matches:Bool = false
            
            if predicate.evaluate(with: self) {
                matches = true
            }
            return matches
        }
        catch {
            return true
        }
    }

    
    // MARK: - URL encode-decode for model cache
    @objc public class func stringArchiveEncode(_ string: String) -> Data? {
        var stringData: Data? = nil
        if let data = string.data(using: String.Encoding.utf8) {
            stringData = data.base64EncodedData(options: Data.Base64EncodingOptions.lineLength76Characters)
        }
        return stringData
    }
    
    @objc public class func stringArchiveDecode(_ data: Data) -> String? {
        var decodedString: String? = nil
        if let decodedData = Data(base64Encoded: data, options: .ignoreUnknownCharacters) {
            decodedString = String(data: decodedData, encoding: String.Encoding.utf8)
        }
        return decodedString
    }
    
    @objc
    public func isBlank() -> Bool {
        guard !isNull(), !trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return true }
        return false
    }
    
    @objc
    public func widthForfont(_ inFont: UIFont, height inHeight: CGFloat) -> CGFloat {
        let stringAttributes = [NSAttributedString.Key.font: inFont]
        let stringSize = boundingRect(with: CGSize(width: 10000, height: inHeight),
                                      options: [.truncatesLastVisibleLine, .usesLineFragmentOrigin],
                                      attributes: stringAttributes, context: nil).size
        return ceil(stringSize.width)
    }
    
    @objc
    public func trimWhitespace() -> String {
        return trimmingCharacters(in: .whitespacesAndNewlines)
    }
    
    @objc(priceString)
    public func price() -> String? {
        let numberFormatter = NumberFormatter()
        let locale = Locale(identifier: "en_IN")
        numberFormatter.locale = locale
        numberFormatter.numberStyle = .decimal
        
        guard let number = numberFormatter.number(from: self as String), let string = numberFormatter.string(from: number) else { return nil }
        return string
    }
    
    @objc
    public func dateString(withFormate outFormate: String, formInputFromate inFormate: String) -> String {
        let date = NSDate.dateForDateformat(inFormate, date: self as String)
        return NSDate.date(date, inFormat: outFormate) ?? ""
    }
    
    @objc
    public class func fetchDeliveryInfoString(fromArray range: [String]?) -> String? {
        guard let range = range, range.count == 2, let first = range.first, let last = range.last else { return "" }
        
        
        var deliveryInfoString = ""

        let estimationStartDate = NSDate.dateFromServerString(first)
        let estimationEndDate = NSDate.dateFromServerString(last)

        var dateFormat = NSDate.isDateFromSameMonth(estimationStartDate, secondDate: estimationEndDate) ? "dd" : "dd MMM";
        var infoFormat = NSDate.date(estimationStartDate, inFormat: dateFormat) ?? ""
        deliveryInfoString = deliveryInfoString + infoFormat
        deliveryInfoString = deliveryInfoString + "-"

        dateFormat = "dd MMM"
        infoFormat = NSDate.date(estimationEndDate, inFormat: dateFormat) ?? ""
        deliveryInfoString = deliveryInfoString + infoFormat

        return deliveryInfoString
    }
    
    @objc
    public class func getSizeFor(_ string: String, with font: UIFont) -> CGSize {
        return string.getSizeWith(font)
    }
    
    func boundingRect(for size: CGSize, font: UIFont) -> CGRect {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    }

    
    @objc //Url must not be Url encoded format.
    public class func url(withHMACEmbededForurl url: String, httpMethod method: String) -> String? {
        let timeStamp = Date().timeIntervalSince1970
        let string = String(format: "%@\n%.0f\n%@", method, timeStamp, url)

        var HMACKey: String {
            switch JRUtilityManager.shared.moduleConfig.varient {
            case .mall:
                return "vfeuratrhaznjc6gbbaash8teegujiwyx"
            case .paytm:
                return "690mw4l105f61a99844c20ui56ni3s78d"
            }
        }
        
        guard let signature = string.hmacsha12(withSecret:HMACKey)?.urlEncode() else { return nil }
        return String(format: "%@&timestamp=%.0f&signature=%@", url, timeStamp, signature)
    }
    
    @objc
    public func removeHTMLTag() -> String? {
        guard let data = data(using: String.Encoding.utf8.rawValue) else { return self as String }
        let attributedString = try? NSAttributedString(data: data,
                                                       options: [.documentType: NSAttributedString.DocumentType.html,.characterEncoding: String.Encoding.utf8.rawValue],
                                                       documentAttributes: nil)
        return attributedString?.string
    }
    
    @objc
    public func isValidEmail() -> Bool {
        return range(of: "^[A-Z0-9a-z\\._%+-]+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2,4}$", options: .regularExpression).location != NSNotFound
    }
    
    @objc
    public func isValidMobileNumber() -> Bool {
        return range(of: "^([6,7,8,9]{1}+[0-9]{9})$", options: .regularExpression).location != NSNotFound
    }
    
    @objc
    public func baseUrlString() -> String {
        let queryRange = range(of: "?")
        if queryRange.length > 0 {
            return substring(to: queryRange.location)
        } else {
           return self as String
        }
    }
    
    @objc public func unformattedPhoneNumberString() -> String {
        let charactersToExclude = CharacterSet.decimalDigits.inverted
        return components(separatedBy: charactersToExclude).joined()
    }
    
    @objc public func substring(matchingRegularExpression regularExpression: String?) -> String? {
        guard let regularExpression = regularExpression, !regularExpression.isEmpty,
            let regulaEx = try? NSRegularExpression(pattern: regularExpression, options: .caseInsensitive)
            else { return nil }
        
        let range = regulaEx.rangeOfFirstMatch(in: self as String, options: [], range: NSRange(location: 0, length: length))
        
        guard range.location != NSNotFound else { return nil }
        return self.substring(with: range)
    }
    
    @objc public func base64String() -> String? {
        let plainData = self.data(using: String.Encoding.utf8.rawValue)
        let stringinBase64String = plainData?.base64EncodedString(options: [])
        return stringinBase64String
    }
    
    @objc public class func getCRMID(_ sourceString: String) -> String {
        return (sourceString as NSString).getCRMID()
    }

    func getCRMID() -> String {
        guard let keyWithHeader = (self as String).data(using: .utf8) else { return "" }
        var hash = [UInt8](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        
        keyWithHeader.withUnsafeBytes {
            _ = CC_SHA256($0.baseAddress, CC_LONG(keyWithHeader.count), &hash)
        }
        return Data(hash).base64EncodedString()
    }
}
