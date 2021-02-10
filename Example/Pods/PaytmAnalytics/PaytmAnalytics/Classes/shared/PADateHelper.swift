//
//  PADateUtils.swift
//  PaytmAnalytics
//
//  Created by Abhinav Kumar Roy on 05/07/18.
//  Copyright © 2018 Abhinav Kumar Roy. All rights reserved.
//

import UIKit

class PADateHelper: NSObject {

    class var date: Date {
        get{
           return PADateHelper.getCurrentDate()
        }
    }
    
    static func getCurrentDate() -> Date {
        let dateFormatter : DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        if let date = dateFormatter.date(from: dateFormatter.string(from: Date())){
            return date
        }else{
            return Date()
        }
    }
    
    static func getCurrentDateInMillis() -> Double {
        return PADateHelper.date.timeIntervalSince1970
    }

}
