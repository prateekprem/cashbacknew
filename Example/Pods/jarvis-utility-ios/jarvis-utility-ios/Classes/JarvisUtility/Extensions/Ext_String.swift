//
//  Ext_String.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 13/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import CommonCrypto

extension String {
    
    public func separate(every: Int, with separator: String) -> String {
        return String(stride(from: 0, to: Array(self).count, by: every).map {
            Array(Array(self)[$0..<min($0 + every, Array(self).count)])
            }.joined(separator: separator))
    }
    
    public func isValidString() -> Bool {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).count > 0
    }
    
    public func lastPathComponent(withExtension: Bool = true) -> String {
        let lpc = self.nsString.lastPathComponent
        return withExtension ? lpc : lpc.nsString.deletingPathExtension
    }
    
    public var nsString: NSString {
        return NSString(string: self)
    }
    
    public func getHighlightedSubString(_ subString: String?, withFont font: UIFont? = UIFont.fontSemiBoldOf(size: 16.0), andColor color: UIColor? = UIColor.colorWithHexString("#222222")) -> NSAttributedString {
        let attr = NSMutableAttributedString(string: self)
        if let subString = subString, let range = self.lowercased().range(of: subString.lowercased()) {
            let subStringRange = NSRange(location: range.lowerBound.utf16Offset(in: self), length: range.upperBound.utf16Offset(in: self)-range.lowerBound.utf16Offset(in: self))
            if let font = font {
                attr.addAttribute(NSAttributedString.Key.font, value: font, range: subStringRange)
            }
            
            if let color = color {
                attr.addAttribute(NSAttributedString.Key.foregroundColor, value: color, range: subStringRange)
            }
        }
        
        return attr
    }
    
    public func insert(seperator: String, interval: Int) -> String {
        var output = ""
        let characters = Array(self)
        characters.enumerated().forEach { (index,c) in
            if index % interval == 0 && index > 0 {
                output += seperator
            }
            output.append(c)
        }
        return output
    }
    
    public func hmacSHA256(key: String) -> String? {
        guard let cKey = key.cString(using: String.Encoding.utf8), let cData = self.cString(using: String.Encoding.utf8) else {
            return nil
        }
        var result = [CUnsignedChar](repeating: 0, count: Int(CC_SHA256_DIGEST_LENGTH))
        CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA256), cKey, strlen(cKey), cData, strlen(cData), &result)
        let hmacData = Data(bytes: result, count: result.count)
        let hexString = hmacData.hexEncodedString()
        return hexString
    }
    
    public var asciiArray: [UInt32] {
        return unicodeScalars.filter{$0.isASCII}.map{$0.value}
    }
    
    public func width(withConstrainedHeight height: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    public static func validateInput(withValue text:String?,andRegularExpression regex:String?) -> Bool {
        var validated = false
        if let textToValidate = text, let regex = regex {
            let documentComponentPredicate = NSPredicate(format:"SELF MATCHES %@", regex);
            validated = documentComponentPredicate.evaluate(with: textToValidate)
        }
        
        return validated
    }
    
    public func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        return String(data: data, encoding: .utf8)
    }
    
    public func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
    }
    
    public func isNumeric() -> Bool {
        guard self.count > 0 else { return false }
        let nums: Set<Character> = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
        return Set(self).isSubset(of: nums)
    }
    
    public func isEqualToString(find: String) -> Bool {
        return String(format: self) == find
    }
    
    public func contains(find: String) -> Bool{
        return self.range(of: find) != nil
    }
    
    public func capitalizingFirstLetter() -> String {
        let first = String(prefix(1)).capitalized
        let other = String(dropFirst())
        return first + other
    }
    
    public mutating func capitalizeFirstLetter() {
        self = self.capitalizingFirstLetter()
    }
    
    public func capitalizeEachWordInSpaceSeparatedSentance() ->  String{
        return self.components(separatedBy: " ").map { (str) -> String in
            str.lowercased().capitalizingFirstLetter()
            }.joined(separator: " ")
    }
    
    public func convertToDictionary() -> [String: Any]? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    public static func formatedDateString(_ timeStamp: String?) -> String? {
        if let timeStamp = timeStamp {
            if let reviewDate = Date.dateFromServerString(timeStamp) {
                if let dateInString = Date.date(reviewDate, inFormat: "dd MMM yyyy hh:mm a") {
                    return dateInString
                }
            }
        }
        return nil
    }
    
    /**
     Returns count of characters in String.
     */
    public var length: Int {
        return count
    }
    
    public func getINRAmount()-> String? {
        
        var currencyInString = self
        currencyInString = currencyInString.replacingOccurrences(of: "₹", with: "")
        currencyInString = currencyInString.replacingOccurrences(of: " ", with: "")
        currencyInString = currencyInString.replacingOccurrences(of: ",", with: "")
        
        return currencyInString
    }
    
    public func getDecimalValue()-> String? {
        var currencyInString = self
        currencyInString = currencyInString.replacingOccurrences(of: "₹", with: "")
        currencyInString = currencyInString.replacingOccurrences(of: " ", with: "")
        currencyInString = currencyInString.replacingOccurrences(of: ",", with: "")
        
        return currencyInString
    }
    
    public func beginsWith(_ str: String) -> Bool {
        if let range = self.range(of: str) {
            return range.lowerBound == self.startIndex
        }
        return false
    }
    
    //    call this method to remove spaces in a string ex : "     Stev   Job   " output will be "Stev Job"
    public func getStringWithRomovingWhiteSpaces() -> String {
        var formatedString = self.trimmingCharacters(in: .whitespacesAndNewlines)
        let stringComponent = formatedString.components(separatedBy: " ")
        formatedString = stringComponent.filter { !$0.isEmpty }.joined(separator: " ")
        return formatedString
    }
    
    public func endsWith (str: String) -> Bool {
        
        if let range = self.range(of: str, options: String.CompareOptions.backwards, range: nil, locale: nil) {
            return range.upperBound == self.endIndex
        }
        return false
    }
    
    public func toBool() -> Bool? {
        
        switch self {
        case "true", "True", "TRUE", "yes", "1", "Y", "y" :
            return true
        case "false", "False", "FALSE", "no", "0", "N", "n" :
            return false
        default:
            return nil
        }
    }
    
    public func indexOf(string: String) -> String.Index? {
        
        return range(of: string, options: String.CompareOptions.literal, range: nil, locale: nil)?.lowerBound
    }
    
    public func isValidEmail() -> Bool {
        
        let laxString = "^.+@([A-Za-z0-9-]+\\.)+[A-Za-z]{2}[A-Za-z]*$"
        let emailTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        return emailTest.evaluate(with: self)
    }
    
    public func isvalidFullName() -> Bool {
        let laxString = "^[a-zA-Z][a-zA-Z ]*$"//"[A-Za-z]+(\\s[A-Za-z]+)?\\s{0,1}"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        return  nameTest.evaluate(with: self)
    }
    
    public func isvalidPassportNumber() -> Bool {
        let laxString = "^(?=.*\\d)(?=.*[a-zA-Z]*).{6,10}$"
        let nameTest = NSPredicate(format: "SELF MATCHES %@", laxString)
        let passOne =  nameTest.evaluate(with: self)
        if passOne {
            let laxStringTwo = "[a-zA-Z0-9]*"
            let nameTestTwo =  NSPredicate(format: "SELF MATCHES %@", laxStringTwo)
            return nameTestTwo.evaluate(with: self)
        }
        return false
    }
    
    public func extractYoutubeIdFromLink() -> String? {
        let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
        guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return nil
        }
        let nsLink = self as NSString
        let options = NSRegularExpression.MatchingOptions(rawValue: 0)
        let range = NSRange(location: 0, length: nsLink.length)
        let matches = regExp.matches(in: self as String, options:options, range:range)
        if let firstMatch = matches.first {
            return nsLink.substring(with: firstMatch.range)
        }
        return nil
    }
    
    #if true // APPSTORE_BUILD //Make it False to Make Catalog Preprod Build
    public static func validString(val: Any?) -> String? {
        if let val = val as? String, val.length > 0 {
            return val
        }
        return nil
    }
    #else  // For Catalog pre pod pointed build
    public static func validString(val: Any?) -> String? {
        if let val = val as? String, val.length > 0 {
            if val.contains("kyc-staging.paytm.in") == true {
                let modified = val.replacingOccurrences(of: "kyc-staging.paytm.in", with: "kyc-ite.paytm.in")
                return modified
            }
            return val
        }
        return nil
    }
    #endif
    
    /**
     Returns encoded String.
     decodes the string before encode in order to prevent double encoding
     */
    public func stringByEncoding() -> String {
        guard let encodedString = self.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) else {
            return self
        }
        return encodedString
    }
    
    public static func ordinalNumberSuffix(number: Int) -> String {
        
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
    
    
    public func encodeURLString() -> String {
        let newCharacterSet = CharacterSet.init(charactersIn: "!*'() ;:@&+$,/?%#[]|").inverted
        if let encodedString = self.addingPercentEncoding(withAllowedCharacters: newCharacterSet) {
            return encodedString
        } else {
            return self
        }
    }
    
    
    public func updateFormatsForLocalization() -> String {
        
        var localisedString = self
        var updatedString = self.replacingOccurrences(of: ",", with: " ")
        updatedString = updatedString.replacingOccurrences(of: "-", with: " ")
        let updatedStringsArray = updatedString.components(separatedBy: " ")
        for subString in updatedStringsArray {
            localisedString = localisedString.replacingOccurrences(of: subString, with: NSLocalizedString(subString, comment: subString))
        }
        return localisedString
    }
    
    public func secondNameFromFullName() -> String? {
        
        let str = trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
        if str.length > 0 {
            let nameSplit = str.components(separatedBy: " ")
            if nameSplit.count > 1 {
                return nameSplit.last
            }
        }
        return nil
    }
    
    public func isBlank() -> Bool {
        
        if self.length == 0 {
            return true
        } else if self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines).length == 0 {
            return true
        }
        return false
    }
    
    public func removeHTMLTagsFromServerString() -> String {
        let str = replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
        return str
    }
    
    public func removeHTMLTag() -> String? {
        let attributedString = try? NSAttributedString.init(data: self.data(using: .utf8)!, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html,
                                                                                                      NSAttributedString.DocumentReadingOptionKey.characterEncoding: String.Encoding.utf8], documentAttributes: nil)
        return attributedString?.string
    }
    
    // MARK: - URL encode-decode for model cache
    public static func stringArchiveEncode(string:String) -> Data? {
        var stringData: Data? = nil
        if let data = string.data(using: String.Encoding.utf8) {
            stringData = data.base64EncodedData(options: Data.Base64EncodingOptions.lineLength76Characters)
        }
        return stringData
    }
    
    public static func stringArchiveDecode(data: Data) -> String? {
        var decodedString: String? = nil
        if let decodedData = Data(base64Encoded: data, options: .ignoreUnknownCharacters) {
            decodedString = String(data: decodedData, encoding: String.Encoding.utf8)
        }
        
        return decodedString
    }
    
    public func initialString() -> String? {
        
        if self.count > 0 {
            return String(self.prefix(1))
        }
        return nil
    }
    
    public func containsIgnoringCase(find: String) -> Bool{
        
        return  (self.range(of: find, options:  NSString.CompareOptions.caseInsensitive, range: nil, locale: nil) != nil)
        
    }
    
    public func getWidth(withConstraintedHeight height: CGFloat, font: UIFont) -> CGFloat
    {
        let constraintRect = CGSize(width: .greatestFiniteMagnitude, height: height)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.width)
    }
    
    public func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public func insert(_ string:String,ind:Int) -> String {
        return  String(self.prefix(ind)) + string + String(self.suffix(self.count-ind))
    }
    
    public func getTrailerVideoIndetifier()-> String? {
        if(self != "") {
            let pattern = "((?<=(v|V)/)|(?<=be/)|(?<=(\\?|\\&)v=)|(?<=embed/))([\\w-]++)"
            guard let regExp = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
                return nil
            }
            
            let nsLink = self as NSString
            let options = NSRegularExpression.MatchingOptions(rawValue: 0)
            let range = NSRange(location: 0,length: nsLink.length)
            let matches = regExp.matches(in:self, options:options, range:range)
            if let firstMatch = matches.first {
                return nsLink.substring(with:firstMatch.range)
            }else {
                return nil
            }
        }
        return nil
    }
    
    public func getYoutubeID() -> String? {
        return URLComponents(string: self)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    public func widthOfString(usingFont font: UIFont) -> CGFloat {
        let fontAttributes = [NSAttributedString.Key.font: font]
        let size = self.size(withAttributes: fontAttributes)
        return size.width
    }
    
    public func getDateFor(_ dateFormat: String) -> String {
        let inputFormatter = DateFormatter()
        inputFormatter.dateFormat = "yyyy-MM-dd"
        let date = inputFormatter.date(from: self)
        inputFormatter.dateFormat = dateFormat
        let dateString = inputFormatter.string(from: date!)
        return dateString
    }
    
    public func height(withConstrainedWidth width: CGFloat, _ font: UIFont = UIFont.systemFont(ofSize: 12.0)) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
    
    public var htmlToAttributedString: NSAttributedString? {
        
        guard let data = data(using: .utf8) else { return NSAttributedString() }
        do {
            return try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType:  NSAttributedString.DocumentType.html], documentAttributes: nil)
        } catch {
            return NSAttributedString()
        }
    }
    public var htmlToString: String {
        return htmlToAttributedString?.string ?? ""
    }
    
    public var intValue: Int {
        get {
            if let val = Int(self) { return val }
            return 0
        }
    }
    
    public var isValidMobileNo: Bool {
        get {
            let PHONE_REGEX = "^\\d{10}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result = phoneTest.evaluate(with: self)
            return result
        }
    }
    
    public var isValidIndianPhoneNumber: Bool {
        get {
            let PHONE_REGEX = "^[6-9]\\d{9}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: self)
            return result
        }
    }
    
    public func containSubStr(_ str: String) -> Bool {
        return self.lowercased().range(of: str.lowercased()) != nil
    }
    
    public func dictFormat() -> NSDictionary? {
        if let data = self.data(using: .utf8) {
            do {
                return try JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary
            } catch {
                print(error.localizedDescription)
            }
        }
        return nil
    }
    
    // Version checker
    public func isLowerVersion(then: String) -> Bool {
        return self.compare(nextVer: then) == -1
    }
    
    public func isUpperVersion(then: String) -> Bool {
        return self.compare(nextVer: then) == 1
    }
    
    public func compare(nextVer: String) -> Int {  // -1/0/1 : (left is balancer)
        let curV1  = self.components(separatedBy: ".").map  { Int($0) == nil ? 0 : Int($0) }
        let nextV1 = nextVer.components(separatedBy: ".").map { Int($0) == nil ? 0 : Int($0) }
        
        let mx = max(curV1.count, nextV1.count)
        var result = -1
        for i in 0..<mx {
            let left  = i >= curV1.count  ? 0 : curV1[i]!
            let right = i >= nextV1.count ? 0 : nextV1[i]!
            result = left == right ? 0 : (left > right ? 1 : -1)
            if result != 0 { break }
        }
        
        return result
    }
    
    public var isAlphanumeric: Bool {
        return !isEmpty && range(of: "[^a-zA-Z0-9]", options: .regularExpression) == nil
    }
    
    public func getMaskString(small: Bool) -> String {
        if self.isEmpty {return ""}
        if self.count <= 6 {
            return self
        }
        var midTxt = "XXXX"
        if small { midTxt = midTxt.lowercased() }
        return "\(self.prefix(2))\(midTxt)\(self.suffix(4))"
    }
    
    public func validateText(regex:String?) -> Bool {
        let validation = NSPredicate(format : "SELF MATCHES %@", regex!)
        return validation.evaluate(with: self)
    }
    
    public var withoutWhiteSpace: String {
        get {
            let sText = self.trimmingCharacters(in: .whitespacesAndNewlines)
            return sText
        }
    }
    
    public func widthWidth(font: UIFont, height: CGFloat) -> CGFloat {
        let size = (self as NSString).size(withAttributes: [NSAttributedString.Key.font: font])
        return size.width
    }
    
    public func dtStringWithFormate(_ oldFormate: DateFormat, _ newFormat: DateFormat) -> String {
        if self.isEmpty {return "" }
        
        let formatter = DateFormatter()
        formatter.dateFormat = oldFormate.rawValue
        if let dt = formatter.date(from: self) {
            formatter.dateFormat = newFormat.rawValue
            return formatter.string(from: dt)
        }
        
        return ""
    }
    
    public func dateIn(formate: DateFormat) -> Date { // gives in same formate
        if self.isEmpty { return Date() }
        
        let formatter = DateFormatter()
        formatter.dateFormat = formate.rawValue
        if let dt = formatter.date(from: self) { return dt }
        
        return Date()
    }
    
    public func dateIn(formate: DateFormat, inGTM: Bool) -> Date { // gives in same formate
        if self.isEmpty { return Date() }
        
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: inGTM ? "GTM" : "UTC")
        formatter.dateFormat = formate.rawValue
        if let dt = formatter.date(from: self) {
            return dt
        }
        
        return Date()
    }
    
    public func contain(subStr: String) -> Bool {
        return self.lowercased().range(of: subStr.lowercased()) != nil
    }
    
    public func substring(start: Int, end: Int) -> String {
        if self.count <= 0 {return ""}
        return "".padding(toLength:end-start, withPad:self, startingAt:start)
    }
    
    public func displaySortText() -> String {
        let acronyms = self.components(separatedBy:" ").map({ $0.first != nil ?  String($0.first!) : "" }).joined(separator: "")
        if acronyms.count > 2 {
            return acronyms.substring(start: 0, end: 2)
        }
        return acronyms
    }
    
    // This variable is used to get only digits and decimals from the string
    public var digitsAndDecimal: String {
        return components(separatedBy: CharacterSet(charactersIn: "01234567890.").inverted)
            .joined()
    }
    
    // This variable is used to get only digits from the string
    public var digits: String {
        return components(separatedBy: CharacterSet.decimalDigits.inverted)
            .joined()
    }
    
    // This function check if string contains anything else then Number and Decimal and return boolean
    public func containsCharatersExceptNumbersAndDecimal() -> Bool {
        let alphaCharacters = CharacterSet(charactersIn: "01234567890.").inverted
        let decimalRange = self.rangeOfCharacter(from: alphaCharacters)
        if decimalRange != nil {
            return true
        }
        return false
    }
    
    // This function check if string contains anything else then provided set and return boolean
    public func containsExceptProvidedSet(charaterSet:CharacterSet) -> Bool {
        let decimalRange = self.rangeOfCharacter(from: charaterSet)
        if decimalRange != nil {
            return true
        }
        return false
    }
    
    public func location(of character: Character) -> Int? {
        guard let index = firstIndex(of: character) else { return nil }
        return distance(from: startIndex, to: index)
    }
    
    public func convertHtml(htmlString : String) -> String{
        let documentKey = NSAttributedString.Key("NSDocumentTypeDocumentAttribute")
        let charsetKey = NSAttributedString.Key("NSCharacterEncodingDocumentAttribute")
        let responseString = NSAttributedString(string: htmlString,
                                                attributes: [documentKey: NSAttributedString.DocumentType.html,
                                                             charsetKey: String.Encoding.utf8.rawValue])
        return responseString.string
    }
    
    public func getFormattedDateString(_ format: String) -> String {
        
        let serverDate =  NSDate.dateFromServerString(self)
        guard let _serverDate = serverDate else {
            return ""
        }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: _serverDate)
    }
    
    public func doubleValue() -> Double {
        var value = NSDecimalNumber(string: self).doubleValue
        if !value.isNaN {
            let roundedValue = value.roundToPlaces(2)
            return roundedValue
        }
        return 0
    }
    
    public func getYoutubeIDForBank() -> String? {
        return URLComponents(string: self)?.queryItems?.first(where: { $0.name == "v" })?.value
    }
    
    public func currencyFormatting(addSymbol: Bool = true, isInput: Bool = false ) -> (formattedString: String, amount: Double) {
        
        let dot = "."
        let currency = addSymbol ? "₹" : ""
        let emptyText = ""
        let comma = ","
        
        let formatter = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .currency
        formatter.currencySymbol = emptyText
        formatter.maximumFractionDigits = 2
        formatter.minimumFractionDigits = 0
        
        let actualText = self
        var text = self
        text = text.replacingOccurrences(of: comma, with: emptyText)
        text = text.replacingOccurrences(of: currency, with: emptyText)
        
        if text.contains(dot){
            var array = text.components(separatedBy: dot)
            if array[1].count == 0 {
                text = array[0]
            } else if array[1].count > 2 {
                array[1].removeLast()
                text = array.joined(separator: dot)
            }
        }
        
        var formattedString = emptyText
        var amount = 0.0
        if let number = formatter.number(from: text), number != (0 as NSNumber){
            amount = number.doubleValue
            formattedString = formatter.string(from: number)!.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
            if isInput && !formattedString.contains(dot){
                if actualText.hasSuffix(dot) {
                    formattedString += dot
                } else if actualText.hasSuffix("\(dot)0") {
                    formattedString += "\(dot)0"
                } else if actualText.hasSuffix("\(dot)00") {
                    formattedString += "\(dot)0"
                }
            }
            formattedString = "\(currency)\(formattedString)"
        }
        return (formattedString, amount)
    }
    
    public var masked: String{
        if count < 4{
            return self
        }
        let arr = Array<String>(repeating: "XXXX ", count: 2)
        let lastChars = self[index(endIndex, offsetBy: -4)...]
        return " "+arr.joined()+String(lastChars)
    }
    
    public func mask(inGroupsOf length:Int) -> String{
        var maskedString = ""
        for (n, c) in self.enumerated() {
            maskedString = n%length == 0 ? maskedString + " " : maskedString
            maskedString = maskedString + "\(c)"
        }
        return maskedString
    }

    public var phoneNumberFromatter: String {
        let char = Array(self)
        if (char.count < 10) {return self}
        let newString = char.suffix(10).pairs.joined(separator: " ")
        return String(newString)
    }
    
    public var isValidIndianPhoneNumberWithCountryCode: Bool {
        get {
            let PHONE_REGEX = "^91[6-9]\\d{9}$"
            let phoneTest = NSPredicate(format: "SELF MATCHES %@", PHONE_REGEX)
            let result =  phoneTest.evaluate(with: self)
            return result
        }
    }
    
    public func handleNull() -> String {
        if NSString(string: self).isNull() {
            return ""
        }
        return self
    }
    
    public func stringToJson() -> [AnyHashable: Any] {
        guard let data = data(using: .utf8) else { return [:] }
        let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [AnyHashable: Any]
        return json ?? [:]
    }
    
    public static func check(forSpecialCharacters string: NSString?) -> Bool {
        let myRegex = "[A-Z0-9a-z_ .]*"
        let myTest = NSPredicate(format: "SELF MATCHES %@", myRegex)
        let valid = myTest.evaluate(with: string)
        return !valid
    }
    
    func urlEncode() -> String {
        let escapeSet = NSCharacterSet(charactersIn: "!*'\"();:@&=+$,/?%#[]% ")
        let escapedString = addingPercentEncoding(withAllowedCharacters: escapeSet.inverted) ?? ""
        return escapedString
    }
    
    func getSizeWith(_ font: UIFont) -> CGSize {
        return self.size(withAttributes: [.font: font])
    }
    
    public func getFirstLetterStringForEachWord() -> String {
        return components(separatedBy: .whitespacesAndNewlines).map { $0.prefix(1) }.joined()
    }
    
    func hmacsha12(withSecret key: String) -> String? {
        guard let cKey = key.cString(using: .utf8), let cSelf = (self as String).cString(using: .utf8) else { return nil }
        var resultData = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        resultData.withUnsafeMutableBytes { CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), cKey, strlen(cKey), cSelf, strlen(cSelf), $0.baseAddress) }
        return resultData.base64EncodedString()
    }
    
    func strikeOutTextWithfont(_ font: UIFont, color: UIColor, range: NSRange) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self)
        attributedString.setAttributes([.font: font, .foregroundColor: color, .strikethroughStyle: 2], range: range)
        return attributedString
    }
    
    public func superscriptedSubstring(_ substring: String, with font: UIFont, withOffset offset: Int) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: self as String)
        let range = (self as NSString).range(of: substring, options: .caseInsensitive)
        
        if range.location != NSNotFound {
            attributedString.setAttributes([.font: font, .baselineOffset: offset], range: range)
        }
        
        return attributedString
    }
    
    public func superscriptedTermAndConditionString() -> NSMutableAttributedString {
        let astricString = "*"
        let tAndCString = "\(astricString)\("T&C".localized)"

        let attributedString = NSMutableAttributedString(string: tAndCString)
        attributedString.addAttribute(.font, value: UIFont.helveticaNeueFontOfSize(13.0), range: NSRange(location: 0, length: tAndCString.count))
        switch JRUtilityManager.shared.moduleConfig.varient {
        case .mall:
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor.appColor(),
                                          range: NSRange(location: 0, length: tAndCString.count))
        case .paytm:
            attributedString.addAttribute(.foregroundColor,
                                          value: UIColor(red: 65.0 / 255.0, green: 213.0 / 255.0, blue: 255.0 / 255.0, alpha: 1.0),
                                          range: NSRange(location: 0, length: tAndCString.count))
        }
        
        attributedString.addAttribute(.baselineOffset, value: NSNumber(value: 1), range: (tAndCString as NSString).range(of: astricString))
        attributedString.addAttribute(.underlineStyle, value: NSNumber(value: 0), range: NSRange(location: 0, length: tAndCString.count))

        return attributedString
    }
    
    public static func checkForSpecialCharacters(withAlphabetsAndNumbers string: String) -> Bool {
        return string.range(of: "^[A-Z0-9a-z_ .]*$", options: .regularExpression) == nil
    }
    
    func boundingRect(for size: CGSize, font: UIFont) -> CGRect {
        return self.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: [.font: font], context: nil)
    }
    
    public func width(for width: CGSize, font: UIFont) -> CGFloat {
        self.boundingRect(for: width, font: font).width
    }
}
