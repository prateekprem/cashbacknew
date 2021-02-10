//
//  Converter.swift
//  jarvis-utility-ios
//
//  Created by Abhinav Kumar Roy on 26/12/18.
//

import UIKit

public class Converter: NSObject {
    
    public class func stringWithInterval(_ interval: Int64) -> String {
        return Converter.stringWithInterval(interval, full: false)
    }
    
    public class func fullStringWithInterval(_ interval: Int64) -> String {
        return Converter.stringWithInterval(interval, full: true)
    }
    
    public class func dispStringForHome(date: Date) -> String {
        
        if date.stringWith(format: .YYYYmmdd) == Date().stringWith(format: .YYYYmmdd) { // Today
            return Converter.stringWithDate(date, full: true) + " ago"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        //
        dateFormatter.timeZone =  TimeZone(abbreviation: "UTC")
        dateFormatter.doesRelativeDateFormatting = true
        
        let fStr = dateFormatter.string(from: date)
        if fStr.lowercased() == "yesterday" {
            let timeFormatter = DateFormatter()
            timeFormatter.dateFormat = "h:mm a"
            timeFormatter.timeZone =  TimeZone(abbreviation: "GMT")
            let time = "\(dateFormatter.string(from: date).replacingOccurrences(of: "-", with: " ")), \(timeFormatter.string(from: date))" //"Today at, 5:10 PM"
            return time
        }
        
        
        return date.stringWith(format: .dmmmhhmma)
        
    }
    
    public class func stringWithDate(_ dt: Date, full: Bool) -> String {
        var mm = 0; var hr = 0; var dy = 0; var wk = 0; var yr = 0
        let now = Date().convertToLocalTimeZone(with: .ddMMyyyyHHmmss).dateIn(formate: .ddMMyyyyHHmmss)
        let secs = abs(now.timeIntervalSince(dt))
        
        if(secs >= 60) {
            mm = Int(secs/60) // calculate min.
            
            if(mm >= 60) {
                hr = Int(mm/60) // calculate hour.
                
                if(hr >= 24) {
                    dy = Int(hr/24) // calculate day.
                    
                    if(dy >= 7) {
                        wk = Int(dy/7) // calculate weeks
                        
                        if(wk >= 52) {
                            yr = Int(wk/52) // calculate year.
                        }
                    }
                }
            }
        }
        
        // years
        var counter = yr
        if(counter > 0) {
            let aStr = (full) ? ((counter > 1) ? "years" : "year") : "y"
            return "\(counter) \(aStr)"
        }
        
        // weeks
        counter = wk
        if(counter > 0) {
            let aStr = (full) ? ((counter > 1) ? "weeks" : "week") : "w"
            return "\(counter) \(aStr)"
        }
        
        // days
        counter = dy
        if(counter > 0) {
            let aStr = (full) ? ((counter > 1) ? "days" : "day") : "d";
            return "\(counter) \(aStr)"
        }
        
        // hours
        counter = hr;
        if(counter > 0) {
            let aStr = (full) ? ((counter > 1) ? "hours" : "hour") : "h";
            return "\(counter) \(aStr)"
        }
        
        // mins
        counter = mm
        if(counter > 0) {
            let aStr = (full) ? ((counter > 1) ? " minutes" : " minute") : "m";
            return "\(counter) \(aStr)"
        }
        
        return "1 m"
    }
    
    public class func stringWithInterval(_ interval: Int64, full: Bool) -> String {
        let preDate = Date(timeIntervalSince1970: TimeInterval(interval/1000))
        return Converter.stringWithDate(preDate, full: full)
    }
}
