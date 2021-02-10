//
//  Ext_UIColor.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 13/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIColor {
    
    public convenience init(hex: String) {
        
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        
        let r = (rgbValue & 0xff0000) >> 16
        let g = (rgbValue & 0xff00) >> 8
        let b = rgbValue & 0xff
        
        self.init(red: CGFloat(r) / 0xff, green: CGFloat(g) / 0xff, blue: CGFloat(b) / 0xff, alpha: 1)
    }
    
    @objc public class func colorRGB(_ red:CGFloat,  green:CGFloat,  blue:CGFloat) -> UIColor {
        return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: 1.0)
    }
    
    // MARK: - Class Methods
    /**
     Method to retrieve placeholderTextColor
     - returns : This method returns UIColor value.
     */
    public class func placeholderTextColor() -> UIColor {
        
        return UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func rechargeLabelTextColor() -> UIColor {
        
        return UIColor(red: 1.0/255.0, green: 1.0/255.0, blue: 1.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func RGB123Color() -> UIColor {
        
        return UIColor(red: 123.0/255.0, green: 123.0/255.0, blue: 123.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func RGB173Color() -> UIColor {
        
        return UIColor(red: 173.0/255.0, green: 173.0/255.0, blue: 173.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func RGB235Color() -> UIColor {
        
        return UIColor(red: 235.0/255.0, green: 235.0/255.0, blue: 235.0/255.0, alpha: 1.0)
    }
    
    public class func RGB226235238Color() -> UIColor {
        return UIColor(red: 226.0/255.0, green: 235.0/255.0, blue: 238.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve headingLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func RGB153Color() -> UIColor {
        
        return UIColor(red: 153.0/255.0, green: 153.0/255.0, blue: 153.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve shadow color
     - returns : This method returns UIColor value.
     */
    public class func RGB34Color() -> UIColor {
        
        return UIColor(red: 34.0/255.0, green: 34.0/255.0, blue: 34.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve text color
     - returns : This method returns UIColor value.
     */
    public class func RGB68Color() -> UIColor {
        
        return UIColor(red: 68.0/255.0, green: 68.0/255.0, blue: 68.0/255.0, alpha: 1.0)
    }
    
    public static func colorRGB(intValue: UInt8, alpha: CGFloat) -> UIColor {
        return UIColor.init(white: CGFloat(intValue)/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func paytmBlueRGBColor() -> UIColor {
        
        return UIColor(red: 0.0/255.0, green: 185.0/255.0, blue: 245.0/255.0, alpha: 1.0)
    }
    
    
    
    /**
     Method to retrieve rechargeLabelTextColor
     - returns : This method returns UIColor value.
     */
    public class func RGB74Color() -> UIColor {
        
        return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve paytmBlueColor
     - returns : This method returns UIColor value.
     */
    @objc public class func paytmBlueColor() -> UIColor {
        
        return UIColor(red: 0/255.0, green: 186.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve paytmRedColor
     - returns : This method returns UIColor value.
     */
    @objc public class func paytmRedColor() -> UIColor {
        
        return UIColor(red: 0/255.0, green: 186.0/255.0, blue: 242.0/255.0, alpha: 1.0)
    }
    /**
     Method to retrieve paytmDarkBlueColor
     - returns : This method returns UIColor value.
     */
    @objc public class func paytmDarkBlueColor() -> UIColor {
        
        return UIColor(red: 4/255.0, green: 48/255.0, blue: 108/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve paytmDarkerBlueColor
     - returns : This method returns UIColor value.
     */
    @objc public class func paytmDarkerBlueColor() -> UIColor {
        
        return UIColor(red: 0/255.0, green: 46/255.0, blue: 110/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeGrayColor
     - returns : This method returns UIColor value.
     */
    public class func rechargeGrayColor() -> UIColor {
        
        return UIColor(red: 73.0/255.0, green: 73.0/255.0, blue: 73.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeGrayColor
     - returns : This method returns UIColor value.
     */
    public class func darkBlueColor() -> UIColor {
        
        return UIColor(red: 10.0/255.0, green: 40.0/255.0, blue: 109.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeGrayColor
     - returns : This method returns UIColor value.
     */
    public class func lightBlackColor() -> UIColor {
        
        return UIColor(red: 74.0/255.0, green: 74.0/255.0, blue: 74.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve rechargeLightGrayColor
     - returns : This method returns UIColor value.
     */
    public class func rechargeLightGrayColor() -> UIColor {
        
        return UIColor(red: 144.0/255.0, green: 144.0/255.0, blue: 144.0/255.0, alpha: 1.0)
    }
    
    public class func paytmGreyColor() -> UIColor {
        return UIColor(red: 154.0/255.0, green: 154.0/255.0, blue: 154.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve paytmGreenColor
     - returns : This method returns UIColor value.
     */
    @objc public class func paytmGreenColor() -> UIColor {
        
        return UIColor(red: 123.0/255.0, green: 213.0/255.0, blue: 0.0/255.0, alpha: 1.0)
    }
    
    /**
     Method to retrieve dividerColor
     - returns : This method returns UIColor value.
     */
    @objc public class func dividerColor() -> UIColor {
        
        return UIColor(red: 217.0/255, green: 217.0/255, blue: 217.0/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve paytmOrangeColor
     - returns : This method returns UIColor value.
     */
    public class func paytmOrangeColor() -> UIColor {
        
        return UIColor(red: 247.0/255, green: 148.0/255, blue: 30.0/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve grayBackgroundColour
     - returns : This method returns UIColor value.
     */
    public class func grayBackgroundColour() -> UIColor {
        
        return UIColor(red: 229.0/255, green: 229.0/255, blue: 229.0/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve blueBorderColor
     - returns : This method returns UIColor value.
     */
    public class func blueBorderColor() -> UIColor {
        return UIColor(red: 12/255, green: 180/255, blue: 234/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve color info from string containing RGB values
     - returns : This method returns UIColor value.
     */
    public class func colorFromRGBString(rgbString: NSString) -> UIColor {
        
        let array = rgbString.components(separatedBy: ",")
        
        if array.count >= 3 {
            let r = CGFloat(Float(array[0]) ?? 0.0)
            let g = CGFloat(Float(array[1]) ?? 0.0)
            let b = CGFloat(Float(array[2]) ??  0.0)
            return UIColor(red: r, green: g, blue: b, alpha: 1.0)
        }
        return UIColor.paytmBlueColor()
        
    }
    
    /**
     Method to retrieve successColor
     - returns : This method returns UIColor value.
     */
    @objc public class func successColor() -> UIColor {
        
        return UIColor(red: 0, green: 204/255, blue: 153/255, alpha: 1.0)
    }
    /**
     Method to retrieve onHoldColor
     - returns : This method returns UIColor value.
     */
    @objc public class func onHoldColor() -> UIColor {
        
        return UIColor(red: 245/255, green: 100/255, blue: 42/255, alpha: 1.0)
    }
    /**
     Method to retrieve failureColor
     - returns : This method returns UIColor value.
     */
    @objc public class func failureColor() -> UIColor {
        
        return UIColor.red
    }
    
    /**
     Method to retrieve pendingColor
     - returns : This method returns UIColor value.
     */
    @objc public class func pendingColor() -> UIColor {
        
        return UIColor(red: 1, green: 153/255, blue: 51/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve green colour available on web site for available seats.
     - returns : This method returns UIColor value.
     */
    public class func paytmWebGreenColor() -> UIColor {
        
        return UIColor(red: 114/255, green: 229/255, blue: 62/255, alpha: 1.0)
    }
    /**
     Method to retrieve header view/navigation header background colour
     - returns : This method returns UIColor value.
     */
    public class func headerBackgroundColour() -> UIColor {
        
        return UIColor(red: 250/255, green: 250/255, blue: 250/255, alpha: 1.0)
    }
    
    /**
     Method to retrieve pendingColor
     - returns : This method returns UIColor value.
     */
    @objc public class func refundBackColor() -> UIColor {
        
        return UIColor.colorWithHexString("e24913")
    }
    
    /**
     Method to retrieve pendingColor
     - returns : This method returns UIColor value.
     */
    @objc public class func refundSuccessColor() -> UIColor {
        
        return UIColor.colorWithHexString("20BF7A")
    }
    
    /**
     Method to retrieve pendingColor
     - returns : This method returns UIColor value.
     */
    @objc public class func restStatusColor() -> UIColor {
        
        return UIColor.colorWithHexString("F5A623")
    }
    
    /**
     Method to retrieve color info from string containing hex color (eg: #6E1C3B) values
     - returns : This method returns UIColor value.
     */
    @objc public class func colorWithHexString(_ hexString: String) -> UIColor {
        
        let hexString = hexString.replacingOccurrences(of: "#", with: "")
        
        if hexString.count != 6 {
            return paytmBlueColor()
        }
        do {
            // Brutal and not-very elegant test for non hex-numeric characters
            let regex: NSRegularExpression = try NSRegularExpression(pattern: "[^a-fA-F|0-9]", options: [])
            let match = regex.numberOfMatches(in: hexString, options: .reportCompletion, range: NSMakeRange(0, hexString.count))
            
            if match != 0 {
                return paytmBlueColor()
            }
        }
        catch {
            
        }
        
        if let advanceBy2 = hexString.index(hexString.startIndex, offsetBy: 2, limitedBy: hexString.endIndex) {
            let rRange = hexString.startIndex..<advanceBy2
            let rComponent: String = String(hexString[rRange])
            var rVal: UInt32 = 0
            let rScanner: Scanner = Scanner(string: rComponent)
            rScanner.scanHexInt32(&rVal)
            let  rRetVal = Float (rVal) / 254
            
            if let advanceBy4 = hexString.index(hexString.startIndex, offsetBy: 4, limitedBy: hexString.endIndex) {
                let gRange = advanceBy2..<advanceBy4
                let gComponent: String = String(hexString[gRange])
                var gVal: UInt32 = 0
                let gScanner: Scanner = Scanner(string: gComponent)
                gScanner.scanHexInt32(&gVal)
                let  gRetVal = Float (gVal) / 254
                
                if let advanceBy6 = hexString.index(hexString.startIndex, offsetBy: 6, limitedBy: hexString.endIndex) {
                    let bRange = advanceBy4..<advanceBy6
                    let bComponent: String = String(hexString[bRange])
                    var bVal: UInt32 = 0
                    let bScanner: Scanner = Scanner(string: bComponent)
                    bScanner.scanHexInt32(&bVal)
                    let  bRetVal = Float (bVal) / 254
                    
                    return UIColor(red: CGFloat(rRetVal), green: CGFloat(gRetVal), blue: CGFloat(bRetVal), alpha: 1.0)
                }
            }
        }
        return paytmBlueColor()
    }
    
    /*Method to retrieve paytm mall green color
     - returns : This method returns UIColor value.
     */
    
    public class func paytmMallGreenColor() -> UIColor {
        
        return UIColor.colorWithHexString("09AC63")
    }
    
    public class func fade(fromColor: UIColor, toColor: UIColor, withPercentage: CGFloat) -> UIColor {
        
        var fromRedComponent: CGFloat = 0.0
        var fromGreenComponent: CGFloat = 0.0
        var fromBlueComponent: CGFloat = 0.0
        var fromAlphaComponent: CGFloat = 0.0
        
        fromColor.getRed(&fromRedComponent, green: &fromGreenComponent, blue: &fromBlueComponent, alpha: &fromAlphaComponent)
        
        var toRedComponent: CGFloat = 0.0
        var toGreenComponent: CGFloat = 0.0
        var toBlueComponent: CGFloat = 0.0
        var toAlphaComponent: CGFloat = 0.0
        
        toColor.getRed(&toRedComponent, green: &toGreenComponent, blue: &toBlueComponent, alpha: &toAlphaComponent)
        
        //calculate the actual RGBA values of the fade colour
        let red = (toRedComponent - fromRedComponent) * withPercentage + fromRedComponent
        let green = (toGreenComponent - fromGreenComponent) * withPercentage + fromGreenComponent
        let blue = (toBlueComponent - fromBlueComponent) * withPercentage + fromBlueComponent
        let alpha = (toAlphaComponent - fromAlphaComponent) * withPercentage + fromAlphaComponent
        
        // return the fade colour
        return UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    public func hexFormat() -> String {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        
        let multiplier = CGFloat(255.999999)
        
        guard self.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return ""
        }
        
        if alpha == 1.0 {
            return String(
                format: "#%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier)
            )
        }
        else {
            return String(
                format: "#%02lX%02lX%02lX%02lX",
                Int(red * multiplier),
                Int(green * multiplier),
                Int(blue * multiplier),
                Int(alpha * multiplier)
            )
        }
    }
    
    public class func getColorFromHexValue(_ hexValue:UInt64,Alpha alpha:CGFloat)-> UIColor {
        return UIColor(red: ((CGFloat)((hexValue & 0xFF0000) >> 16))/255.0, green: ((CGFloat)((hexValue & 0xFF00) >> 8))/255.0, blue: ((CGFloat)(hexValue & 0xFF))/255.0, alpha: alpha)
    }
    
    public class func getAppDefaultNavigationBarColor() -> UIColor{
        return self.getColorFromHexValue(0x2F1F2F, Alpha: 1)
    }
    
    public class func getAppTextColor() -> UIColor{
        return self.getColorFromHexValue(0x3E303B, Alpha: 1)
    }
    
    public class func getAppDisabledTextColor() -> UIColor{
        return self.getColorFromHexValue(0xBCBCC2, Alpha: 1)
    }
    
    @objc public static var randomColor: UIColor {
        let random = Int.randomNumber(MIN: 0, MAX: colors().count)
        return UIColor.randomColor(number: random)
    }
    
    /* Get color depending on given String. Internally it's get converted to ASCII and specific color in index will be picked.
     Helpful to get same color for same phone number or user id */
    
    @objc public static func randomColor(string: String) -> UIColor {
        var index = 0
        for value in string.asciiArray {
            index += Int(value)
        }
        return UIColor.randomColor(number: index)
    }
    
    @objc public static func randomColor(number: Int) -> UIColor {
        let colors = UIColor.colors()
        let index = number % colors.count
        return colors[index]
    }
    
    @objc public static func colors() -> [UIColor] {
        let colors = [UIColor(red: 71/255.0, green: 209/255.0, blue: 146/255.0, alpha: 1.0),
                      UIColor(red: 08/255.0, green: 124/255.0, blue: 255/255.0, alpha: 1.0),
                      UIColor(red: 174/255.0, green: 104/255.0, blue: 236/255.0, alpha: 1.0),
                      UIColor(red: 68/255.0, green: 204/255.0, blue: 216/255.0, alpha: 1.0),
                      UIColor(red: 252/255.0, green: 90/255.0, blue: 127/255.0, alpha: 1.0),
                      UIColor(red: 241/255.0, green: 193/255.0, blue: 3/255.0, alpha: 1.0),
                      UIColor(red: 242/255.0, green: 106/255.0, blue: 180/255.0, alpha: 1.0),
                      UIColor(red: 60/255.0, green: 181/255.0, blue: 243/255.0, alpha: 1.0),
                      UIColor(red: 166/255.0, green: 182/255.0, blue: 190/255.0, alpha: 1.0)]
        return colors
    }
    
    public class func colorRGB(_ r:Int, g:Int, b:Int, a:CGFloat) -> UIColor {
        let rd = CGFloat(r)/255.0 as CGFloat
        let gr = CGFloat(g)/255.0 as CGFloat
        let bl = CGFloat(b)/255.0 as CGFloat
        return UIColor(red: rd, green: gr, blue: bl, alpha: a)
    }
    
    public class func colorWith(hex: String) -> UIColor { return UIColor(hexString: hex) }
    
    public convenience init(hexString: String) {
        var int = UInt32()
        Scanner(string: hexString).scanHexInt32(&int)
        let a, r, g, b: UInt32
        
        switch hexString.count {
        case 3 : (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17) // RGB (12-bit)
        case 6 : (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)                   // RGB (24-bit)
        case 8 : (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)      // ARGB (32-bit)
        default: (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(red: CGFloat(r) / 255, green: CGFloat(g) / 255, blue: CGFloat(b) / 255, alpha: CGFloat(a) / 255)
    }
    
    public class var seperatorColor: UIColor{
        return UIColor(red: 243/255, green: 247/255, blue: 248/255, alpha: 1.0)
    }
    
    public class var lblBlackColor: UIColor{
        return UIColor(red: 34/255.0, green: 34/255.0, blue: 34/255.0, alpha: 1)
    }
    
    public class var borderGrayColor: UIColor{
        return UIColor(red: 235/255.0, green: 235/255.0, blue: 235/255.0, alpha: 1.0)
    }
    
    public class var verifyProfileGrayColor: UIColor{
        return UIColor(red: 184/255.0, green: 194/255.0, blue: 203/255.0, alpha: 1.0)
    }
    
    public class var verifyProfileGreenColor: UIColor{
        return UIColor(red: 33/255.0, green: 193/255.0, blue: 122/255.0, alpha: 1.0)
    }
    
    @objc public class func appColor() -> UIColor {
        if JRUtilityManager.shared.moduleConfig.varient == .mall{
            return UIColor.paytmRedColor()
        }else{
            return UIColor.paytmBlueColor()
        }
    }

    public convenience init(red: Int, green: Int, blue: Int) {
        assert(red >= 0 && red <= 255, "Invalid red component")
        assert(green >= 0 && green <= 255, "Invalid green component")
        assert(blue >= 0 && blue <= 255, "Invalid blue component")
        
        self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1.0)
    }
    
    public convenience init(rgb: Int) {
        self.init(
            red: (rgb >> 16) & 0xFF,
            green: (rgb >> 8) & 0xFF,
            blue: rgb & 0xFF
        )
    }
}
