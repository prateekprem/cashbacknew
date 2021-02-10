//
//  JRUtility.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 17/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit
import SystemConfiguration.CaptiveNetwork

@objc open class JRUtility: NSObject {
    
    @objc public class var appStoreID: UInt {
        if JRUtilityManager.shared.moduleConfig.varient == .mall{
            return 1157845438
        }
        return 473941634
    }
    
    fileprivate static let numberFormatter: NumberFormatter = {
        let formatter: NumberFormatter  = NumberFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.numberStyle = .decimal
        return formatter
    }()
    
   @objc public static func validString(input:String?) -> String {
        if input?.isEmpty == false {
            return input!
        }
        return ""
    }
    
    @objc public static func validInt(input:String?) -> Int {
        if let input = input, !input.isEmpty, let intValue = Int(input){
            return intValue
        }
        return 0
    }
    
    @objc public static func validBool(input:String?) -> Bool {
        return input?.lowercased() == "true"
    }
    
    @objc public static func jsonStringToDictionary(jsonString: String) -> [String: Any]? {
        if let data = jsonString.data(using: String.Encoding.utf8) {
            do {
                if let dictonary = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] {
                    return dictonary
                }
            } catch {
            }
        }
        return nil
    }
    
    @objc public static func dictionaryToJsonString(dictionary: [String: Any]) -> String? {
        do {
            let jsonData = try JSONSerialization.data(withJSONObject: dictionary, options: [])
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
        }
        return nil
    }
    
    @objc public static func converStringToIndianCurrency(forString string: String) -> String? {
        let initalValue = string
        let currencyFormatter = NumberFormatter()
        currencyFormatter.numberStyle = .decimal
        currencyFormatter.locale = Locale(identifier: "en_IN")
        currencyFormatter.maximumFractionDigits = 0
        if let integerValue = Int(initalValue) {
            return currencyFormatter.string(from: NSNumber(value: integerValue))
        }
        return nil
    }
    
    @objc public static func isRooted() -> Bool {
        #if targetEnvironment(simulator)
            return false
        #else
        // Check 1 : existence of files that are common for jailbroken devices
        if FileManager.default.fileExists(atPath: "/Applications/Cydia.app")
            || FileManager.default.fileExists(atPath: "/Library/MobileSubstrate/MobileSubstrate.dylib")
            || FileManager.default.fileExists(atPath: "/bin/bash")
            || FileManager.default.fileExists(atPath: "/usr/sbin/sshd")
            || FileManager.default.fileExists(atPath: "/etc/apt")
            || FileManager.default.fileExists(atPath: "/private/var/lib/apt/")
            || UIApplication.shared.canOpenURL(URL(string:"cydia://package/com.example.package")!)
        {
            return true
        }
        // Check 2 : Reading and writing in system directories (sandbox violation)
        let stringToWrite = "Jailbreak Test"
        do
        {
            try stringToWrite.write(toFile:"/private/JailbreakTest.txt", atomically:true, encoding:String.Encoding.utf8)
            //Device is jailbroken
            return true
        }catch
        {
            return false
        }
        #endif
    }
    
    @objc public static func fetchSSIDInfo() -> String {
        var currentSSID = ""
        if let interfaces = CNCopySupportedInterfaces() {
            for i in 0..<CFArrayGetCount(interfaces) {
                let interfaceName: UnsafeRawPointer = CFArrayGetValueAtIndex(interfaces, i)
                let rec = unsafeBitCast(interfaceName, to: AnyObject.self)
                let unsafeInterfaceData = CNCopyCurrentNetworkInfo("\(rec)" as CFString)
                if unsafeInterfaceData != nil {
                    if let interfaceData = unsafeInterfaceData! as? [String: Any], let ssid = interfaceData["SSID"] as? String {
                        currentSSID = ssid
                    }
                }
            }
        }
        return currentSSID
    }

    @objc public static func getAttributedStringFromHTMLString(_ htmlString: String?) -> NSAttributedString? {
        return getAttributedStringFromHTMLString(htmlString, size: 14.0)
    }
    
    @objc public static func getAttributedStringFromHTMLString(_ htmlString: String?, size: CGFloat,alignment: String = "center") -> NSAttributedString? {
        guard let _ = htmlString else {
            return nil
        }
        var completeHTMLString  = getHTMLTextFromString(htmlString)
        let htmlFont = UIFont.systemFont(ofSize: size)
        completeHTMLString.append("<style>body{font-family: '\(htmlFont.fontName)'; font-size:\(htmlFont.pointSize)px; text-align: \(alignment);}</style>")
        
        do {
            if let data = completeHTMLString.data(using: .utf8) {
                let attributedString = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return attributedString
            }
        }
        catch {
            
        }
        
        return nil
    }
    
    @objc public static func getLeftAlignAttributedStringFromHTMLString(_ htmlString: String?, size: CGFloat) -> NSAttributedString? {
        guard let string = htmlString else {
            return nil
        }
        
        var completeHTMLString  = getHTMLTextFromString(string)
        let htmlFont = UIFont.systemFont(ofSize: size)
        completeHTMLString.append("<style>body{font-family: '\(htmlFont.fontName)'; font-size:\(htmlFont.pointSize)px;}</style>")
        
        do {
            if let data = completeHTMLString.data(using: .utf8) {
                let attributedString = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return attributedString
            }
        }
        catch {
            
        }
        
        return nil
    }
    
    @objc public static func getHTMLTextFromString(_ string: String?) -> String {
        return "<html><body>\(string ?? "")</body></html>"
    }
    
    @objc public static func getLeftAlignAttributedStringOrderListFromHTMLString(_ htmlString: String?, size: CGFloat) -> NSAttributedString? {
        guard let string = htmlString else {
            return nil
        }
        
        var completeHTMLString  = getHTMLTextFromString(string)
        let htmlFont = UIFont.boldSystemFont(ofSize: size)
        completeHTMLString.append("<style>body{font-family: 'Helvetica-Bold'; font-size:\(htmlFont.pointSize)px;}</style>")
        do {
            if let data = completeHTMLString.data(using: .utf8) {
                let attributedString = try NSAttributedString(data: data, options: [NSAttributedString.DocumentReadingOptionKey.documentType: NSAttributedString.DocumentType.html], documentAttributes: nil)
                return attributedString
            }
        }
        catch {
            
        }
        
        return nil
    }
    
    @objc public static func deleteCookies(){
        let storage : HTTPCookieStorage = HTTPCookieStorage.shared
        if let cookies : [HTTPCookie] = storage.cookies{
            for cookie in cookies{
                storage.deleteCookie(cookie)
            }
        }
    }
    
    @objc public static func disableUserInteractionWithUIControl(){
        if !UIApplication.shared.isIgnoringInteractionEvents{
            UIApplication.shared.beginIgnoringInteractionEvents()
        }
    }
    
    @objc public static func enableUserInteractionWithUIControl(){
        if UIApplication.shared.isIgnoringInteractionEvents{
            UIApplication.shared.endIgnoringInteractionEvents()
        }
    }
    
    
    @objc public static func smoothlySlide(view : UIView, upOrDownBy yPoints: CGFloat, withDelay delay : TimeInterval){
        UIView.animate(withDuration: 0.2, delay: delay, options: .curveEaseOut, animations: {
            view.frame = CGRect.init(x: view.frame.origin.x, y: (view.frame.origin.y + yPoints), width: view.frame.size.width, height: view.frame.size.height)
        }, completion: nil)
    }
    
    @objc public static func purgeCookiesAndCache(){
        URLCache.shared.removeAllCachedResponses()
        let cs : HTTPCookieStorage = HTTPCookieStorage.shared
        let cookies : [HTTPCookie] = [HTTPCookie]()
        for cookie in cookies{
            cs.deleteCookie(cookie)
        }
    }
    
    @objc public static func strippedString(ofString str : String) -> String?{
        var finalStr : String? = nil
        if str.count > 0{
            let strippedString : NSMutableString = NSMutableString.init(capacity: str.count)
            let scanner : Scanner = Scanner.init(string: str)
            let numbers : CharacterSet = CharacterSet.init(charactersIn: "0123456789")
            while scanner.isAtEnd == false{
                var buffer : NSString?
                if scanner.scanCharacters(from: numbers, into: &buffer), let string = buffer as String?{
                    strippedString.append(string)
                }else{
                    scanner.scanLocation = scanner.scanLocation + 1
                }
            }
            if strippedString.length > 10 {
                finalStr = strippedString.substring(from: strippedString.length-10)
            }else{
                finalStr = strippedString as String
            }
        }
        return finalStr
    }
    
    @objc public static func strippedStringForUtility(string str : String) -> String?{
        var finalStr : String? = nil
        if str.count > 0{
            let strippedString : NSMutableString = NSMutableString.init(capacity: str.count)
            let scanner : Scanner = Scanner.init(string: str)
            let numbers : CharacterSet = CharacterSet.init(charactersIn: "0123456789")
            while scanner.isAtEnd == false{
                var buffer : NSString?
                if scanner.scanCharacters(from: numbers, into: &buffer), let string = buffer as String?{
                    strippedString.append(string)
                }else{
                    scanner.scanLocation = scanner.scanLocation + 1
                }
            }
            finalStr = strippedString as String
        }
        return finalStr
    }
    
    public static func updatedString(ofText text : String, afterChangingCharactersInRange range : Range<String.Index>, replacementString string: String, prefixNeeded : Bool) -> String?{
        let finalString = JRUtility.strippedString(ofString: string)
        
        //The case of copy-pasting a number from the phonebook
        var updatedText : String?
        if let finalStr = finalString{
            updatedText = text.replacingCharacters(in: range, with: finalStr)
        }else{
            updatedText = text.replacingCharacters(in: range, with: string)
        }
        if let updatedTxt = updatedText, prefixNeeded, !updatedTxt.contain(subStr: JRPrefixCountryCode){
            updatedText = String.init(format: "%@%@", JRPrefixCountryCode, updatedTxt)
        }
        return updatedText
    }
    
    @objc public static var appVersion : String? {
        get{
           return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
        }
    }
    
    @objc public static var systemName : String{
        get{
            return UIDevice.current.systemName
        }
    }
    
    @objc public static var systemVersion : String{
        get{
            return UIDevice.current.systemVersion
        }
    }
    
    @objc public static var batteryPercentage : Float {
        get{
            UIDevice.current.isBatteryMonitoringEnabled = true
            if UIDevice.current.batteryLevel != -1.0{
                return UIDevice.current.batteryLevel  * 100
            }
            return 0.0
        }
    }
    
    @objc public static var platformString : String {
        return "\(UIDevice.current.modelName) (iOS \(JRUtility.systemVersion))"
    }
    
    @objc public static func getHeight(forLabel label : UILabel, withString string : String?, andFont font : UIFont?) -> CGFloat{
        let maxLabelSize = CGSize.init(width: label.frame.size.width, height: CGFloat.greatestFiniteMagnitude)
        var theFont : UIFont = label.font
        if let userFont = font{
            theFont = userFont
        }
        var text = label.text
        if let string = string{
            text = string
        }
        if let text = text{
            return NSString(string: text).boundingRect(with: maxLabelSize, options: .usesLineFragmentOrigin, attributes: [.font : theFont], context: nil).size.height
        }
        return CGFloat.leastNormalMagnitude
    }
    
    @objc public static func isValidOrderId(_ orderId : String) -> Bool{
        let inStringSet : CharacterSet = CharacterSet.init(charactersIn: orderId)
        return CharacterSet.decimalDigits.isSuperset(of: inStringSet)
    }

    @objc public static func does(theString string : String, matchesRegularExpression regexString : String) -> Bool{
        do{
            var numberOfMatches : Int = 0
            let regex : NSRegularExpression = try NSRegularExpression.init(pattern: regexString, options: .caseInsensitive)
            numberOfMatches = regex.numberOfMatches(in: string, options: .reportProgress, range: NSRange.init(location: 0, length: string.length))
            if numberOfMatches == 0{
                return false
            }
            return true
        }catch{
            return false
        }
    }
    
    @objc public static func does(theString string : String, exactlyMatchesRegularExpression regexString : String) -> Bool{
        do{
            var numberOfMatches = 0
            let regex : NSRegularExpression = try NSRegularExpression.init(pattern: regexString, options: .caseInsensitive)
            numberOfMatches = regex.numberOfMatches(in: string, options: .reportProgress, range: NSRange.init(location: 0, length: string.length))
            if numberOfMatches == string.length{
                return true
            }
            return false
        }catch{
            return false
        }
    }
    
   @objc public static func getIPAddressForCellOrWireless()-> String? {
        
        let WIFI_IF : [String] = ["en0"]
        let KNOWN_WIRED_IFS : [String] = ["en2", "en3", "en4"]
        let KNOWN_CELL_IFS : [String] = ["pdp_ip0","pdp_ip1","pdp_ip2","pdp_ip3"]
        
        var addresses : [String : String] = ["wireless":"",
                                             "wired":"",
                                             "cell":""]
        
        var address: String?
        var ifaddr: UnsafeMutablePointer<ifaddrs>? = nil
        if getifaddrs(&ifaddr) == 0 {
            
            var ptr = ifaddr
            while ptr != nil {
                defer { ptr = ptr?.pointee.ifa_next } // memory has been renamed to pointee in swift 3 so changed memory to pointee
                
                let interface = ptr?.pointee
                let addrFamily = interface?.ifa_addr.pointee.sa_family
                if addrFamily == UInt8(AF_INET) || addrFamily == UInt8(AF_INET6) {
                    
                    let name: String = String(cString: (interface?.ifa_name)!)
                    if (WIFI_IF.contains(name) || KNOWN_WIRED_IFS.contains(name) || KNOWN_CELL_IFS.contains(name)) {
                        
                        // String.fromCString() is deprecated in Swift 3. So use the following code inorder to get the exact IP Address.
                        var hostname = [CChar](repeating: 0, count: Int(NI_MAXHOST))
                        getnameinfo(interface?.ifa_addr, socklen_t((interface?.ifa_addr.pointee.sa_len)!), &hostname, socklen_t(hostname.count), nil, socklen_t(0), NI_NUMERICHOST)
                        address = String(cString: hostname)
                        if WIFI_IF.contains(name){
                            addresses["wireless"] =  address
                        }else if KNOWN_WIRED_IFS.contains(name){
                            addresses["wired"] =  address
                        }else if KNOWN_CELL_IFS.contains(name){
                            addresses["cell"] =  address
                        }
                    }
                    
                }
            }
        }
        freeifaddrs(ifaddr)
        
        var ipAddressString : String?
        let wirelessString = addresses["wireless"]
        let wiredString = addresses["wired"]
        let cellString = addresses["cell"]
        if let wirelessString = wirelessString, wirelessString.count > 0{
            ipAddressString = wirelessString
        }else if let wiredString = wiredString, wiredString.count > 0{
            ipAddressString = wiredString
        }else if let cellString = cellString, cellString.count > 0{
            ipAddressString = cellString
        }
        return ipAddressString
    }
    
    @objc public static func generateQRCode(forString qrString: String, withColor outputColor: CIColor,andScale scale : CGFloat = 5.0) -> UIImage?{
        if let qrCode = JRUtility.createQR(forString: qrString, withColor: outputColor) {
            let scale = UIScreen.main.scale * scale
            return JRUtility.createNonInterpolatedUIImage(fromCIImage: qrCode, withScale: scale)
        }
        return nil
    }
    
    @objc private static func createNonInterpolatedUIImage(fromCIImage image : CIImage, withScale scale : CGFloat) -> UIImage?{
        // Render the CIImage into a CGImage
        if let cgImage : CGImage = CIContext.init(options: nil).createCGImage(image, from: image.extent){
            // Now we'll rescale using CoreGraphics
            UIGraphicsBeginImageContext(CGSize.init(width: image.extent.size.width * scale, height: image.extent.size.width * scale))
            if let context : CGContext = UIGraphicsGetCurrentContext(){
                // We don't want to interpolate (since we've got a pixel-correct image)
                context.interpolationQuality = CGInterpolationQuality.none
                context.draw(cgImage, in: context.boundingBoxOfClipPath)
                //Get the Image out
                if let scaledImage : UIImage = UIGraphicsGetImageFromCurrentImageContext(){
                    // Tidy up
                    UIGraphicsEndImageContext()
                    return scaledImage
                }
            }
        }
        return nil
    }
    
    @objc private static func createQR(forString qrString : String, withColor outputColor : CIColor) -> CIImage?{
        var filterColor : CIFilter?
        guard qrString.count > 0 else { return nil }
        
        // Need to convert the string to a UTF-8 encoded NSData object
        guard let stringData : Data = qrString.data(using: .utf8) else { return nil }
        //Create the filter
        guard let qrFilter : CIFilter = CIFilter.init(name: "CIQRCodeGenerator") else { return nil }
        // Set the message content and error-correction level
        qrFilter.setValue(stringData, forKey: "inputMessage")
        qrFilter.setValue("M", forKey: "inputCorrectionLevel")
        if let image = qrFilter.value(forKey: "outputImage") as? CIImage{
            filterColor = CIFilter.init(name: "CIFalseColor", parameters: ["inputImage":image,
                                                                           "inputColor0":outputColor,
                                                                            "inputColor1":CIColor.init(red: 1.0, green: 1.0, blue: 1.0)])
            if let outputImage = filterColor?.value(forKey: "outputImage") as? CIImage{
                return outputImage
            }
        }
        return nil
    }
    
    public static func startShimmeringAnimation(onSkeletonView skeletonView: UIView?) {
        
        if let animateView = skeletonView {
            animateView.clipsToBounds = true
            let gradientLayer = CAGradientLayer()
            gradientLayer.backgroundColor = UIColor.clear.cgColor
            let light = UIColor.white.withAlphaComponent(0.1).cgColor
            let alpha = UIColor.white.withAlphaComponent(0.6).cgColor
            gradientLayer.name = "ShimmerLayer"
            gradientLayer.colors = [light,light,light,light,light,light,alpha,alpha,alpha,light,light,light,light,light,light]
            gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.0)
            gradientLayer.endPoint = CGPoint(x: 1.2, y: 0.6)
            gradientLayer.frame = CGRect(x: 0, y: 0, width:animateView.frame.size.width , height: animateView.bounds.size.height)
            animateView.layer.mask = nil
            animateView.layer.addSublayer(gradientLayer)
            let animation = CABasicAnimation(keyPath: "transform.translation.x")
            animation.duration = 1.25
            animation.fromValue = -animateView.frame.size.width
            animation.toValue = animateView.frame.size.width
            animation.repeatCount = .infinity
            animation.isRemovedOnCompletion = false
            gradientLayer.add(animation, forKey: "")
            
        }
    }
    
    public static func stopShimmeringAnimation(onSkeletonView skeletonView : UIView?) {
        
        if let animateView = skeletonView {
            if let layer = animateView.layer.sublayers {
                for layerObj in layer {
                    if layerObj.name == "ShimmerLayer" {
                        layerObj.removeFromSuperlayer()
                        animateView.layer.mask = nil
                        break
                    }
                }
            }
        }
    }
    
    
    public class func getLangId(forLangCode code: String) -> Int{
        let langDic : [String : Int] = [
            "en-IN" : 1,
            "hi-IN" : 2,
            "bn-IN" : 3,
            "or-IN" : 4,
            "mr-IN" : 5,
            "ml-IN" : 6,
            "kn-IN" : 7,
            "ta-IN" : 8,
            "te-IN" : 9,
            "gu-IN" : 10,
            "pa-IN" : 11
        ]
        return langDic[code] ?? 1
    }
    
    @objc public class func getCommaFormattedPricingForPrice(_ price: Double) -> String {
        return JRUtility.getCommaFormattedPricingForPrice(price, fractionDigit: 2)
    }
    
    @objc public class func getCommaFormattedPricingForPrice(_ price: Double, fractionDigit: Int) -> String {
        JRUtility.numberFormatter.maximumFractionDigits = fractionDigit
        if let numberString = JRUtility.numberFormatter.string(from: NSNumber(value: price)) {
            return numberString
        }
        
        return ""
    }
    
    @objc public class func getFormattedNumberString(_ priceString: String) -> String? {
        let num: NSNumber? = JRUtility.numberFormatter.number(from: priceString)
        if let num = num {
            return JRUtility.numberFormatter.string(from: num)
        }
        return nil
    }
    
    public class func setProfileType(profileType: ProfileType) {
        UserDefaults.standard.set(profileType.rawValue, forKey: kProfileType)
        UserDefaults.standard.synchronize()
    }
    
    public class func getProfileType() -> ProfileType {
        let rawValue = UserDefaults.standard.integer(forKey: kProfileType)
        if let type = ProfileType(rawValue: rawValue) {
            return type
        }
        
        return .consumer
    }
    
    public class func resetProfileType() {
        UserDefaults.standard.removeObject(forKey: kProfileType)
        UserDefaults.standard.synchronize()
    }    
    
    /**
    * Method to get Free Ram, Used Ram and Total Ram
    **/
    public class func getMemory() -> (usedRam : Int64, freeRam : Int64, totalRam : Int64){
        var pagesize: vm_size_t = 0
        
        let host_port: mach_port_t = mach_host_self()
        var host_size: mach_msg_type_number_t = mach_msg_type_number_t(MemoryLayout<vm_statistics_data_t>.stride / MemoryLayout<integer_t>.stride)
        host_page_size(host_port, &pagesize)
        
        var vm_stat: vm_statistics = vm_statistics_data_t()
        withUnsafeMutablePointer(to: &vm_stat) { (vmStatPointer) -> Void in
            vmStatPointer.withMemoryRebound(to: integer_t.self, capacity: Int(host_size)) {
                if (host_statistics(host_port, HOST_VM_INFO, $0, &host_size) != KERN_SUCCESS) {
                    NSLog("Error: Failed to fetch vm statistics")
                }
            }
        }
        
        /* Stats in bytes */
        let mem_used: Int64 = Int64(vm_stat.active_count +
            vm_stat.inactive_count +
            vm_stat.wire_count) * Int64(pagesize)
        let mem_free: Int64 = Int64(vm_stat.free_count) * Int64(pagesize)
        let mem_total = mem_used + mem_free
        
        return (mem_used, mem_free, mem_total)
    }

    @objc public class func getFormattedAmount(numberStr: String) -> String {
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
