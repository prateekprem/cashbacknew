//
//  GlobalEnums.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import Foundation

@objc public enum DeviceType: Int {
    
    //Apple UnknownDevices
    case unknownDevice = 0
    
    //Simulator
    case simulator
    
    //Apple TV
    case appleTV2G
    case appleTV3G
    case appleTV4G
    case appleTV4K
    
    //Homepod
    case homePod
    
    //Apple Watch
    case appleWatch
    
    //Apple iPad
    case appleIpad
    case appleIpad2
    case appleIpad3
    case appleIpad4
    case appleIpad5
    case appleIpad6
    case appleIpadAir
    case appleIpadAir2
    case appleIpadPro9Inch
    case appleIpadPro12Inch
    case appleIpadPro12Inch2Gen
    case appleIpadPro10Inch
    case appleIpadMini
    case appleIpadMini2
    case appleIpadMini3
    case appleIpadMini4
    
    //Apple iPhone
    case appleIphone
    case appleIphone3G
    case appleIphone3GS
    case appleIphone4
    case appleIphone4S
    case appleIphone5
    case appleIphone5C
    case appleIphone5S
    case appleIphone6
    case appleIphone6P
    case appleIphone6S
    case appleIphone6SP
    case appleIphone7
    case appleIphone7Plus
    case appleIphone8
    case appleIphone8Plus
    case appleIphoneX
    
    //Apple iPod touch
    case appleIpodTouch
    case appleIpodTouch2G
    case appleIpodTouch3G
    case appleIpodTouch4G
    case appleIpodTouch5G
    case appleIpodTouch6G
}

public enum DateFormat: String {
    case standerd      = "yyyy-MM-dd'T'HH:mm:ss"
    case standerd1     = "yyyy-MM-dd'T'HH:mm:ss.sssZ"
    case yyyymmddTT    = "yyyy-MM-dd HH:mm:ss"
    case mmmYY         = "MMMM yyyy"             // March 2017
    case mmYY          = "MMM yyyy"              // Mar 2017
    case ddMMM         = "dd MMM"                // 20 Mar
    case ddmmmYY       = "dd MMM yyyy"           // 31 March 2018
    case YYYYmm        = "yyyy-MM"               // 2017 03
    case YYYYmmdd      = "yyyy-MM-dd"            // 2017-03-23
    case ddmmYYYY      = "dd-MM-yyyy"            // 21-12-2027
    case ddMMMYYYA     = "dd MMM, yyyy hh:mm a"  // 25 Aug, 2017 7:59 AM
    case ddMMMYYY      = "dd MMM, yyyy"
    case hhmm          = "hh:mm a"               // 7:59 AM
    case ddmmmhha      = "dd MMM hh:mm a"        // 25 Aug 7:59 AM
    case eeehha        = "EEE, hh:mm a"          // Fri, 02:59 PM
    case ddMMMMyyyy    = "dd MMMM yyyy"
    case ddMMMyyyya   = "dd MMM yyyy hh:mm a"
    
    case liveStander   = "yyyy-MM-dd'T'HH:mm:ssZZZZ"
    case resultStander = "yyyyMMdd'T'HH:mm:ss"
    case customFormat  = "dd MMM 'at' hh:mm a"
    
    case standard      = "yyyy-MM-dd'T'HH:mm:ssZ"
    case edmy          = "EEEE, dd MMM yyyy"
    case dmy           = "dd MMM YY"
    case dayddmmmyyyy  = "EEE d MMM y"          // Thu 23 jan 2017
    case dayddmmm      = "EEE, d MMM"          // Thu, 23 jan
    case mmyyyy        = "MM/yyyy"
    case mmmYYYY         = "MMM-yyyy"               // Sep'17
    case mmmmYYYY      = "MMMM-yyyy"            // Sep'17
    case dayCddmmmyy   = "EEE, d MMM YY"        // Thu, 23 jan 17
    
    case mmddyyyy      = "MM/dd/yyyy"           // 02/13/2018
    case ddmmyyyy      = "dd/MM/yyyy"           // 12/02/2018
    case ddMMyyyyHHmmss = "dd/MM/yyyy HH:mm:ss" // 08/02/2018 15:29:13
    case dMMM          = "d MMM"
    case HHmmss        = "HH:mm:ss Z"
    case HHmmssa       = "hh:mm:ss a"
    case ddMMMM        = "dd-MMMM-yyyy"
    case dmmmhhmmssa   = "d MMM, hh:mm:ss a"
    case dmmmyyyyhhmma = "d MMM yyyy, hh:mm a"
    case dMM           = "d-MM"
    case MMMYYYY       = "MMMyyyy"
    case MMMM_YYYY     = "MMMM, yyyy"
    case yyyy          = "yyyy"
    
    case dmmmhhmma    = "dd MMM, hh:mm a"    // 28 Feb, 04:12 PM
    case hhmmadmmmyyyy    = "hh:mm a, dd MMM yyyy"    // 12:44 pm 28 Feb 2018
    case ddMMMyyyyHHmmssa = "dd MMM yyyy HH:mm:ss a" // 08/02/2018 15:29:13
}

public enum Currency: String {
    case rupee = "INR"
    case dolor = "Dollar"
    
    public var symbol : String {
        get {
            switch self {
            case .rupee : return "₹"
            case .dolor : return "$"
            }
        }
    }
}

public enum ProfileType: Int {
    case consumer // must be at 0 index for default selection
    case reseller
    case merchant
}
