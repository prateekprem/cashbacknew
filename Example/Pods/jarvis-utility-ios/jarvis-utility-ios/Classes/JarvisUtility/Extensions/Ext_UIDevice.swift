//
//  Ext_UIDevice.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension UIDevice {
    
    public var modelName: String {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
        case "iPod5,1":                                 return "iPod Touch 5"
        case "iPod7,1":                                 return "iPod Touch 6"
        case "iPhone3,1", "iPhone3,2", "iPhone3,3":     return "iPhone 4"
        case "iPhone4,1":                               return "iPhone 4s"
        case "iPhone5,1", "iPhone5,2":                  return "iPhone 5"
        case "iPhone5,3", "iPhone5,4":                  return "iPhone 5c"
        case "iPhone6,1", "iPhone6,2":                  return "iPhone 5s"
        case "iPhone7,2":                               return "iPhone 6"
        case "iPhone7,1":                               return "iPhone 6 Plus"
        case "iPhone8,1":                               return "iPhone 6s"
        case "iPhone8,2":                               return "iPhone 6s Plus"
        case "iPhone8,4":                               return "iPhone SE"
        case "iPhone9,1", "iPhone9,3":                  return "iPhone 7"
        case "iPhone9,2", "iPhone9,4":                  return "iPhone 7 Plus"
        case "iPhone10,1", "iPhone10,4":                return "iPhone 8"
        case "iPhone10,2", "iPhone10,5":                return "iPhone 8 Plus"
        case "iPhone10,3", "iPhone10,6":                return "iPhone X"
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4":return "iPad 2"
        case "iPad3,1", "iPad3,2", "iPad3,3":           return "iPad 3"
        case "iPad3,4", "iPad3,5", "iPad3,6":           return "iPad 4"
        case "iPad6,11", "iPad6,12":                    return "iPad 5"
        case "iPad7,5", "iPad7,6":                      return "iPad 6"
        case "iPad4,1", "iPad4,2", "iPad4,3":           return "iPad Air"
        case "iPad5,3", "iPad5,4":                      return "iPad Air 2"
        case "iPad2,5", "iPad2,6", "iPad2,7":           return "iPad Mini"
        case "iPad4,4", "iPad4,5", "iPad4,6":           return "iPad Mini 2"
        case "iPad4,7", "iPad4,8", "iPad4,9":           return "iPad Mini 3"
        case "iPad5,1", "iPad5,2":                      return "iPad Mini 4"
        case "iPad6,3", "iPad6,4":                      return "iPad Pro 9.7 Inch"
        case "iPad6,7", "iPad6,8":                      return "iPad Pro 12.9 Inch"
        case "iPad7,1", "iPad7,2":                      return "iPad Pro 12.9 Inch 2. Generation"
        case "iPad7,3", "iPad7,4":                      return "iPad Pro 10.5 Inch"
        case "AppleTV5,3":                              return "Apple TV"
        case "AppleTV6,2":                              return "Apple TV 4K"
        case "AudioAccessory1,1":                       return "HomePod"
        case "i386", "x86_64":                          return "Simulator"
        default:                                        return identifier
        }
    }
    
    public var deviceType: DeviceType {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machineMirror = Mirror(reflecting: systemInfo.machine)
        let identifier = machineMirror.children.reduce("") { identifier, element in
            guard let value = element.value as? Int8, value != 0 else { return identifier }
            return identifier + String(UnicodeScalar(UInt8(value)))
        }
        
        switch identifier {
            
        //Simulator
        case "i386","x86_64": return .simulator
            
        //Apple TV
        case "AppleTV2,1": return .appleTV2G
        case "AppleTV3,1", "AppleTV3,2": return .appleTV3G
        case "AppleTV5,3": return .appleTV4G
        case "AppleTV6,2": return .appleTV4K
            
        //HomePod
        case "AudioAccessory1,1": return .homePod
            
        //Apple Watch
        case "Watch1,1", "Watch1,2": return .appleWatch
            
        //Apple iPad
        case "iPad1,1": return .appleIpad;
        case "iPad2,1", "iPad2,2", "iPad2,3", "iPad2,4": return .appleIpad2;
        case "iPad3,1", "iPad3,2", "iPad3,3": return .appleIpad3;
        case "iPad3,4", "iPad3,5", "iPad3,6": return .appleIpad4;
        case "iPad6,11", "iPad6,12": return .appleIpad5
        case "iPad7,5", "iPad7,6": return .appleIpad6
        case "iPad4,1", "iPad4,2", "iPad4,3": return .appleIpadAir;
        case "iPad5,3", "iPad5,4": return .appleIpadAir2;
        case "iPad6,3", "iPad6,4": return .appleIpadPro9Inch
        case "iPad6,7", "iPad6,8": return .appleIpadPro12Inch;
        case "iPad7,1", "iPad7,2": return .appleIpadPro12Inch2Gen
        case "iPad7,3", "iPad7,4": return .appleIpadPro10Inch
            
        case "iPad2,5", "iPad2,6", "iPad2,7": return .appleIpadMini;
        case "iPad4,4", "iPad4,5", "iPad4,6": return .appleIpadMini2;
        case "iPad4,7", "iPad4,8", "iPad4,9": return .appleIpadMini3;
        case "iPad5,1", "iPad5,2": return .appleIpadMini4;
        //Apple iPhone
        case "iPhone1,1": return .appleIphone;
        case "iPhone1,2": return .appleIphone3G;
        case "iPhone2,1": return .appleIphone3GS;
        case "iPhone3,1", "iPhone3,2", "iPhone3,3": return .appleIphone4;
        case "iPhone4,1": return .appleIphone4S;
        case "iPhone5,1", "iPhone5,2": return .appleIphone5;
        case "iPhone5,3", "iPhone5,4": return .appleIphone5C;
        case "iPhone6,1", "iPhone6,2": return .appleIphone5S;
        case "iPhone7,2": return .appleIphone6;
        case "iPhone7,1": return .appleIphone6P;
        case "iPhone8,1": return .appleIphone6S;
        case "iPhone8,2": return .appleIphone6SP;
        case "iPhone9,1", "iPhone9,3": return .appleIphone7
        case "iPhone9,2", "iPhone9,4": return .appleIphone7Plus
        case "iPhone10,1", "iPhone10,4": return .appleIphone8
        case "iPhone10,2", "iPhone10,5": return .appleIphone8Plus
        case "iPhone10,3", "iPhone10,6": return .appleIphoneX
            
        //Apple iPod touch
        case "iPod1,1": return .appleIpodTouch;
        case "iPod2,1": return .appleIpodTouch2G;
        case "iPod3,1": return .appleIpodTouch3G;
        case "iPod4,1": return .appleIpodTouch4G;
        case "iPod5,1": return .appleIpodTouch5G;
        case "iPod7,1": return .appleIpodTouch6G;
            
        default:
            return .unknownDevice
        }
    }

}
