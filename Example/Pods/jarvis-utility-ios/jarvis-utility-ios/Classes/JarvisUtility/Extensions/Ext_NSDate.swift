
//
//  Ext_NSDate.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 14/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension NSDate {
    
    /**
     Method to convert server string into NSDate.
     - parameter dateString: Date in the string format.
     - returns : A NSDate from the given input of "yyyy'-'MM'-'dd'T'HH':'mm':'ss.sssZ" format.
     */
    
    fileprivate static var formatterr: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = NSTimeZone.default
        formatter.locale = Locale.init(identifier: "en_IN")
        return formatter
    }()
    
    @objc public class func dateFromServerString(_ dateString: String) -> Date? {
        
        NSDate.formatterr.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return NSDate.formatterr.date(from: dateString)
    }
    // MARK: - Class methods
    /**
     Method to convert given date in particular string format.
     - parameter date: A date to convert into string form.
     - parameter inFormat: A format in which you want to dispaly the date.
     - returns : A string Date in given format.
     */
    @objc public class func date(_ date: Date?, inFormat:String) -> String? {
        if let date = date {
            NSDate.formatterr.dateFormat = inFormat
            return NSDate.formatterr.string(from: date)
        }
        return nil
    }
    
    @objc public class func differenceInSecondWithDate(date:Date) -> Int {
        let calendar = Calendar.current
        let unitFlags = Set<Calendar.Component>([ .second])
        let datecomponenets = calendar.dateComponents(unitFlags, from: date, to: Date())
        if let second = datecomponenets.second {
            return abs(second)
        }
        return 0
    }
    
    /**
     Method to convert current date in IST date.
     - returns : date in IST Format.
     */
    public class func currentDateIST() -> Date {
        NSDate.formatterr.dateFormat = "yyyy-MM-dd HH:mm:ss.SSSZ"
        let dateString = NSDate.formatterr.string(from: Date())
        NSDate.formatterr.locale = Locale.init(identifier: "en_IN")
        return NSDate.formatterr.date(from: dateString)!
    }
    
    /**
     Method to convert given string date into standard NSDate.
     - parameter dateString: Format in which date is converted to string.
     - parameter date: Date in the string format.
     - returns : A NSDate from the given input.
     */
    @objc public class func dateForDateformat(_ dateString: String?, date: String?) -> Date? {
        if let dateString = dateString, let date = date {
            NSDate.formatterr.dateFormat = dateString
            return NSDate.formatterr.date(from: date)
        }
        return nil
    }
    
    /*
     Method to convert Date into DD MMM yyyy Format
     */
    
    public class func dateDDMMMYYYYFormat(dateString : String, dateFormat : String) -> String {
        
        NSDate.formatterr.dateFormat = dateFormat
        let date = NSDate.formatterr.date(from: dateString)
        NSDate.formatterr.dateFormat = "dd-MMM-yyyy"
        if let date = date {
            return NSDate.formatterr.string(from: date)
        }
        return ""
    }
    
    @objc public class func isDateFromSameMonth(_ firstDate: Date?, secondDate: Date?) -> Bool {
        
        if let firstDate = firstDate, let secondDate = secondDate {
            let currentMonth = date(firstDate, inFormat: "MMM")
            let secondDateMonth = date(secondDate, inFormat: "MMM")
            
            if currentMonth == secondDateMonth {
                return true
            }
        }
        return false
    }
    
    //    class func calculateAge(with birthday:String, format: String) -> Int?{
    //        //        let dateFormater = DateFormatter()
    //        Date.formatter.dateFormat = format
    //        let birthdayDate = Date.formatter.date(from: birthday)
    //        let calendar = Calendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
    //        let now = Date()
    //        let calcAge = //calendar.components(.year, from: birthdayDate!, to: now, options: [])
    //        let age = calcAge.year
    //        return age
    //    }
    
    /**
     Method to get the number of days until from given date.
     - parameter currentDate: A date upto which we need to get number of days.
     - returns : Number of days are returned.
     */
    public static func numberOfDaysUntil(_ currentDate: Date) -> Int {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents([.day], from: Date(), to: currentDate)
        if let componentsDay = components.day {
            return componentsDay
        }
        return -1
    }
    
    
    
    /**
     Method to get new date by adding number of days.
     - parameter days: Number of days to be added.
     - returns : A new date with added days.
     */
    public static func getDateAfterNumberOfDays(_ days: Int) -> Date? {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var dateComponents = DateComponents.init()
        dateComponents.day = days
        return gregorianCalendar.date(byAdding: dateComponents, to: Date())
    }
    
    public static func getDateBeforeNumberOfDays(_dateOfTrip : Date,_days: Int) -> Date{
        
        let dateSelected = _dateOfTrip
        return Calendar.current.date(byAdding: .day, value: -_days, to: dateSelected)!
        
    }
    
    
    /**
     Method to add one day to the current date.
     - parameter currentDate: A date need to be passed.
     - returns : Next date after current date is returned.
     */
    public static func getNextDateFromDate(_ currentDate: Date) -> Date? {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var dateComponents = DateComponents.init()
        dateComponents.day = 1
        return gregorianCalendar.date(byAdding: dateComponents, to: currentDate)
    }
    
    /**
     Method to retrieve the date components from calendar.
     - returns : This method returns DateComponents value.
     */
    @objc public func dateComponent() -> DateComponents {
        
        return NSCalendar.current.dateComponents([.year, .month, .day, .weekday, .calendar] , from: self as Date)
    }
    
    /**
     Method to get number of days passed after a particular date.
     - parameter date : A date upto which we want the days count.
     - returns : Number of days available till that date.
     */
    @objc public func numberOfDaysSinceDate(_ date: Date) -> Int {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents([.day], from: date, to: self as Date)
        if let days = components.day {
            return days
        }
        return 0
    }
    
    @objc public func isEqualDateTo(_ date2:Date) -> Bool {
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let date1 = self as Date
        let order = gregorianCalendar.compare(date1, to: date2, toGranularity: .day)
        switch order {
        case .orderedSame:
            return true
        default:
            return false
        }
    }
    
    /**
     Method to get number of minutes passed after a particular date.
     - parameter date : A date upto which we want the minutes count.
     - returns : Number of minutes available till that date.
     */
    @objc public func numberOfMinutesSinceDate(_ date: Date) -> Int {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents([.minute], from: date, to: self as Date)
        if let minutes = components.minute {
            return minutes
        }
        return 0
    }
    
    /**
     Method to convert given seconds into Date.
     - parameter seconds: Pass the double timestamp value.
     - returns : A Date from the given input.
     */
    @objc public static func dateFromSeconds(_ seconds: TimeInterval) -> Date {
        
        let timeInSecond = seconds/1000
        return Date.init(timeIntervalSince1970: timeInSecond)
    }
    
    
    /**
     Method to get previous date from current date.
     - parameter currentDate: A date need to be passed.
     - returns : Previous date from current date is returned.
     */
    public static func getPreviousDateFromDate(_ currentDate: Date) -> Date? {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        var dateComponents = DateComponents.init()
        dateComponents.day = -1
        return gregorianCalendar.date(byAdding: dateComponents, to: currentDate)
    }
    
    /**
     Method to get a new date by adding months.
     - parameter monthsToAdd : Number of months to add.
     - returns : A new date of type Date.
     */
    @objc public func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var months = DateComponents.init()
        months.month = monthsToAdd
        return calendar.date(byAdding: months, to: self as Date)
    }
    
    /**
     Method to get a new date by adding years.
     - parameter monthsToAdd : Number of years to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingYears(_ years: Int) -> Date? {
        
        let calendar = Calendar.current
        var yearsComponent = DateComponents.init()
        yearsComponent.year = years
        return calendar.date(byAdding: yearsComponent, to: self as Date)
    }
    
    /**
     Method to get a new date by adding seconds.
     - parameter second : Number of seconds to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingSeconds(_ second: Int) -> Date? {
        
        let calendar = Calendar.current
        var secComponent = DateComponents.init()
        secComponent.second = second
        return calendar.date(byAdding: secComponent, to: self as Date)
    }
    
    /**
     Method to get a new date by adding minutes.
     - parameter minute : Number of minutes to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingMinutes(_ minute: Int) -> Date? {
        
        let calendar = Calendar.current
        var minuteComponent = DateComponents.init()
        minuteComponent.minute = minute
        return calendar.date(byAdding: minuteComponent, to: self as Date)
    }
    
    
    
    /**
     Method to get the number of days between two days.
     - parameter fromDate: A date from which you need to begin counting.
     - parameter toDate: A date to which you need to end counting.
     - returns : Number of days are returned.
     */
    public static func numberOfDaysFromDate(_ fromDate: Date, toDate: Date) -> Int {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents([.day], from: fromDate, to: toDate)
        if let componentsDay = components.day {
            return componentsDay
        }
        return -1
    }
    
    @objc
    public func isInSameMonthAsDate(_ otherDate: NSDate) -> Bool {
        let calender = Calendar.current
        let comp1 = calender.dateComponents([.day,.month,.year], from: self as Date)
        let comp2 = calender.dateComponents([.day,.month,.year], from: otherDate as Date)
        return ((comp1.month == comp2.month) && (comp1.year == comp2.year))
    }
    
    @objc
    public func day() -> Int {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.day], from: self as Date)
        return dateComponent.day ?? 0
    }
    
    @objc
    public func month() -> Int {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.month], from: self as Date)
        return dateComponent.month ?? 0
    }
    
    @objc
    public func year() -> Int {
        let calender = Calendar.current
        let dateComponent = calender.dateComponents([.year], from: self as Date)
        return dateComponent.year ?? 0
    }
}

