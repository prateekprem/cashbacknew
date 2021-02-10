//
//  Ext_UIFont.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIFont {
    
    //MARK: class Methods
    
    fileprivate class func willReturnFontOfDifferentWeight() -> Bool {
        
        return UIFont.responds(to: #selector(UIFont.systemFont(ofSize:weight:)))
    }
    
    /**
     Method to get font of regular weight
     - returns :This method returns UIFont value
     */
    @objc public class func helveticaNeueFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.regular)
            
        }
        return UIFont(name: "HelveticaNeue", size: fontSize)!
    }
    
    /**
     Method to get font of Medium weight
     - returns :This method returns UIFont value
     */
    @objc public class func systemMediumFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
            
        }
        return helveticaNeueMediumFontOfSize(fontSize)
    }
    
    /**
     Method to get font of semi bold weight
     - returns :This method returns UIFont value
     */
    @objc public class func systemSemiBoldFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.semibold)
            
        }
        return helveticaNeueMediumFontOfSize(fontSize)
    }
    
    /**
     Method to get font of bold weight
     - returns :This method returns UIFont value
     */
    @objc public class func helveticaNeueBoldFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.bold)
            
        }
        return UIFont(name: "HelveticaNeue-Bold", size: fontSize)!
    }
    
    /**
     Method to get font of Medium weight
     - returns :This method returns UIFont value
     */
    @objc public class func helveticaNeueMediumFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.medium)
        }
        return UIFont(name: "HelveticaNeue-Medium", size: fontSize)!
    }
    
    /**
     Method to get font of light weight
     - returns :This method returns UIFont value
     */
    @objc public class func helveticaNeueLightFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.light)
        }
        return UIFont(name: "HelveticaNeue-Light", size: fontSize)!
    }
    
    /**
     Method to get font of UltraLight weight
     - returns :This method returns UIFont value
     */
    @objc public class func helveticaNeueUltraLightFontOfSize(_ fontSize: CGFloat) -> UIFont {
        
        if willReturnFontOfDifferentWeight() {
            return UIFont.systemFont(ofSize: fontSize, weight: UIFont.Weight.ultraLight)
            
        }
        return UIFont(name: "HelveticaNeue-UltraLight", size: fontSize)!
    }
    
    /**
     Method to get font of given font name
     - returns :This method returns UIFont value
     */
    @objc public class func fontForFontName(_ fontName: String, pointSize size: CGFloat) -> UIFont {
        
        if "SystemMedium".range(of: fontName) != nil{
            return UIFont.helveticaNeueMediumFontOfSize(size)
        }
        return UIFont.helveticaNeueFontOfSize(size)
    }
    
    @objc public static func fontLightOf(size: CGFloat) -> UIFont {
        var lightFont: UIFont? = nil
        if UIFont.responds(to: #selector(UIFont.systemFont(ofSize:weight:))) {
            lightFont = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.light)
        }
        
        return lightFont ?? UIFont.systemFont(ofSize: size)
    }
    
    public static func fontMediumOf(size: CGFloat) -> UIFont {
        var mediumFont: UIFont? = nil
        if UIFont.responds(to: #selector(UIFont.systemFont(ofSize:weight:))) {
            mediumFont = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.medium)
        }
        
        return mediumFont ?? UIFont.systemFont(ofSize: size)
    }
    
    public static func fontSemiBoldOf(size: CGFloat) -> UIFont {
        var semiBoldFont: UIFont? = nil
        if UIFont.responds(to: #selector(UIFont.systemFont(ofSize:weight:))) {
            semiBoldFont = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.semibold)
        }
        
        return semiBoldFont ?? UIFont.systemFont(ofSize: size)
    }
    
    public static func fontBoldOf(size: CGFloat) -> UIFont {
        var semiBoldFont: UIFont? = nil
        if UIFont.responds(to: #selector(UIFont.systemFont(ofSize:weight:))) {
            semiBoldFont = UIFont.systemFont(ofSize: size, weight: UIFont.Weight.bold)
        }
        
        return semiBoldFont ?? UIFont.systemFont(ofSize: size)
    }
    
    fileprivate func withTraits(traits:UIFontDescriptor.SymbolicTraits...) -> UIFont {
        let descriptor = self.fontDescriptor
            .withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits))
        return UIFont(descriptor: descriptor!, size: 0)
    }
    
    /**
     Method to get italic Font without altering the font size
     - returns :This method returns UIFont value
     */
    public func italic() -> UIFont {
        return withTraits(traits: .traitItalic)
    }
    
    public class func getAppTitleFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "BubbleboddyNeueTrial-Light", size: size)
    }
    public class func getAppRegularFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Regular", size: size)
    }
    public class func getAppSemiboldFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Semibold", size: size)
    }
    public class func getAppThinFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Thin", size: size)
    }
    public class func getAppUltralightFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Ultralight", size: size)
    }
    public class func getAppBoldFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Bold", size: size)
    }
    public class func getAppMediumFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Medium", size: size)
    }
    public class func getAppHeavyFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Heavy", size: size)
    }
    public class func getAppLightFontWithSize(_ size:CGFloat) -> UIFont?{
        return UIFont(name: "SFUIDisplay-Light", size: size)
    }
    
    public class func getSizeWithFont(_ text : NSString, font : UIFont, constraintSize : CGSize) -> CGSize
    {
        return text.boundingRect(with: constraintSize, options: NSStringDrawingOptions.usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : font], context: nil).size
    }
}
