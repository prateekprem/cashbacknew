//
//  Ext_Date.swift
//  Jarvis
//
//  Created by Abhinav Kumar Roy on 13/09/18.
//  Copyright © 2018 One97. All rights reserved.
//

import UIKit

extension Date {
    
    public var age: Int? {
        return Calendar.current.dateComponents([.year], from: self, to: Date()).year
    }
    
    //en_IN
    fileprivate static var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeZone = TimeZone.ReferenceType.default
        formatter.locale = Locale.init(identifier: "en_IN")
        return formatter
    }()
    
    fileprivate static var moviesDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_IN")
        formatter.amSymbol = "AM"
        formatter.pmSymbol = "PM"
        return formatter
    }()
    
    // MARK: - Instance Methods
    /**
     Method to retrieve the date components from calendar.
     - returns : This method returns DateComponents value.
     */
    public func dateComponent() -> DateComponents {
        return Calendar.current.dateComponents([.year, .month, .day, .weekday, .calendar] , from: self)
    }
    
    /**
     Method to retrieve the date components feom calendar in specified format
     -parameters : Possible values "yy", "MM", etc.
     - returns : A string
     */
    public func dateStringComponent(fromDateFormat: String) -> String? {
        let format = DateFormatter()
        format.dateFormat = fromDateFormat
        return format.string(from: self)
    }
    
    /**
     Method to get timestamp from selected date.
     - returns : A string Date in "eee, MMM dd, hh:mm a" format.
     */
    public func getTimeStampForDate() -> String? {
        
        return Date.date(self, inFormat: "eee, MMM dd, hh:mm a")
    }
    
    /**
     Method to get start date of month.
     - returns : Start date of month.
     */
    public func startOfMonth() -> Date? {
        
        let calendar = Calendar.current
        let currentDateComponents = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: currentDateComponents)
    }
    
    /**
     Method to get end date of month.
     - returns : End date of month.
     */
    public func endOfMonth() -> Date? {
        
        let calendar = Calendar.current
        let plusOneMonthDate = self.dateByAddingMonths(1)
        
        if let plusOneMonthDate = plusOneMonthDate {
            
            let plusOneMonthDateComponents = calendar.dateComponents([.year, .month], from: plusOneMonthDate)
            // One second before the start of next month
            let endOfMonth = calendar.date(from: plusOneMonthDateComponents)?.addingTimeInterval(-1)
            return endOfMonth
        }
        return nil
    }
    
    /**
     Method to get a new date by adding months.
     - parameter monthsToAdd : Number of months to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingMonths(_ monthsToAdd: Int) -> Date? {
        
        let calendar = Calendar.current
        var months = DateComponents.init()
        months.month = monthsToAdd
        return calendar.date(byAdding: months, to: self)
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
        return calendar.date(byAdding: yearsComponent, to: self)
    }
    
    /**
     Method to get a new date by adding days.
     - parameter monthsToAdd : Number of days to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingDays(_ days: Int) -> Date? {
        
        let calendar = Calendar.current
        var dayComponent = DateComponents.init()
        dayComponent.day = days
        return calendar.date(byAdding: dayComponent, to: self)
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
        return calendar.date(byAdding: secComponent, to: self)
    }
    
    /**
     Method to get a new date by adding minutes.
     - parameter minute : Number of minutes to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingMinutes(_ minute: Int) -> Date? {
        
        let calendar = Calendar.current
        var secComponent = DateComponents.init()
        secComponent.minute = minute
        return calendar.date(byAdding: secComponent, to: self)
    }
    
    /**
     Method to get a new date by adding minutes.
     - parameter hour : Number of hours to add.
     - returns : A new date of type Date.
     */
    public func dateByAddingHours(_ hour: Int) -> Date? {
        
        let calendar = Calendar.current
        var secComponent = DateComponents.init()
        secComponent.hour = hour
        return calendar.date(byAdding: secComponent, to: self)
    }
    
    /**
     Method to get date components till given date.
     - parameter endDate : date till which we need get components.
     - returns : DateComponents value will be returned after calculating.
     */
    public func dateComponentsTillDate(_ endDate: Date) -> DateComponents {
        
        return Calendar.current.dateComponents([.year, .month, .day, .hour, .minute, .second, .timeZone], from: self, to: endDate)
    }
    
    /**
     Method to get number of days passed after a particular date.
     - parameter date : A date upto which we want the days count.
     - returns : Number of days available till that date.
     */
    public func numberOfDaysSinceDate(_ date: Date) -> Int {
        
        let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
        let components = gregorianCalendar.dateComponents([.day], from: date, to: self)
        if let days = components.day {
            return days
        }
        return 0
    }
    
    
    /**
     Reatined English Locale to the Default date formatter.
     Hence no need of below method.
     */
    //    /**
    //     This function should give the date string in "en_US_POSIX" locale (english date for server). It will be useful in case of localisation to get the date string for server query.
    //     - parameter dateFormat: A string having the date format to be used for string output.
    //     - returns: A string date in the "en_US_POSIX" local using the specified format.
    //     */
    //    func dateEnUSPosixStringInDateFormat(let dateFormat: String) -> String {
    //        let enUSPOSIXLocale: NSLocale = NSLocale.init(localeIdentifier: "en_US_POSIX")
    //        let formatter: NSDateFormatter = NSDateFormatter()
    //        formatter.locale = enUSPOSIXLocale;
    //        formatter.timeZone = NSTimeZone.defaultTimeZone()
    //        formatter.dateFormat = dateFormat
    //
    //        return formatter.stringFromDate(self)
    //    }
    
    
    // MARK: - Class methods
    /**
     Method to convert given date in particular string format.
     - parameter date: A date to convert into string form.
     - parameter inFormat: A format in which you want to dispaly the date.
     - returns : A string Date in given format.
     */
    public static func date(_ date: Date, inFormat: String) -> String? {
        formatter.dateFormat = inFormat
        return formatter.string(from: date)
    }
    
    /**
     Method to convert given string date into standard Date.
     - parameter dateString: Format in which date is converted to string.
     - parameter date: Date in the string format.
     - returns : A Date from the given input.
     */
    public static func dateForDateformat(_ dateString: String?, date: String?) -> Date? {
        if let dateString = dateString, let date = date {
            formatter.dateFormat = dateString
            return formatter.date(from: date)
        }
        return nil
    }
    
    
    public static func convertToOrdinalDateFormate(date : Date, inFormat: String) -> String?{
        let calendar = Calendar.current
        let anchorComponents = calendar.dateComponents([.day, .month, .year], from: date)
        guard let dateString = self.date(date, inFormat: "MMMM") else {
            return nil
        }
        let suffixString = String.ordinalNumberSuffix(number: anchorComponents.day!)
        return "\(anchorComponents.day!)\(suffixString) \(dateString)"
        
    }
    
    /**
     Method to convert given seconds into Date.
     - parameter seconds: Pass the double timestamp value.
     - returns : A Date from the given input.
     */
    public static func dateFromSeconds(_ seconds: TimeInterval) -> Date {
        
        let timeInSecond = seconds/1000
        return Date.init(timeIntervalSince1970: timeInSecond)
    }
    
    /**
     Method to convert server string into Date.
     - parameter dateString: Date in the string format.
     - returns : A Date from the given input of "yyyy'-'MM'-'dd'T'HH':'mm':'ss.sssZ" format.
     */
    public static func dateFromServerString(_ dateString: String) -> Date? {
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        return formatter.date(from: dateString)
    }
    
    public static func isDateFromSameMonth(_ firstDate: Date?, secondDate: Date?) -> Bool {
        
        if let firstDate = firstDate, let secondDate = secondDate {
            let currentMonth = date(firstDate, inFormat: "MMM")
            let secondDateMonth = date(secondDate, inFormat: "MMM")
            
            if currentMonth == secondDateMonth {
                return true
            }
        }
        return false
    }
    
    /**
     Method to remove time from a date.
     - parameter hours: Number of hours to add.
     - parameter minutes: Number of minutes to add.
     - parameter seconds: Number of seconds to add.
     - parameter toDate: A date to which you want to add the hours, minutes, seconds.
     - returns : A new date of type Date will be returned.
     */
    public func removeTimeFromDate() -> Date? {
        
        let calendar = Calendar.current
        var dateComponents = calendar.dateComponents([.day, .month, .year, .hour, .minute, .second], from: self)
        
        dateComponents.hour = 5
        dateComponents.minute = 30
        dateComponents.second = 0
        
        return calendar.date(from: dateComponents)
    }
    
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
    
    /**
     Method to get the number of days between two days.
     - parameter fromDate: A date from which you need to begin counting.
     - parameter toDate: A date to which you need to end counting.
     - returns : Number of days are returned.
     */
    public static func durationFromDate(_ fromDate: Date?, toDate: Date?) -> (hours: Int, minutes: Int) {
        
        if let fromDate = fromDate, let toDate = toDate {
            
            let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let components = gregorianCalendar.dateComponents([.hour, .minute], from: fromDate, to: toDate)
            if let hour = components.hour, let minute = components.minute {
                return (hour, minute)
            }
        }
        return (-1, -1)
    }
    
    
    /**
     Method to get the number of days between two days.
     - parameter fromDate: A date from which you need to begin counting.
     - parameter toDate: A date to which you need to end counting.
     - returns : Number of days are returned.
     */
    public static func differnceBetween(_ fromDate: Date?, toDate: Date?) -> (minute: Int, seconds: Int) {
        
        if let fromDate = fromDate, let toDate = toDate {
            
            let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let components = gregorianCalendar.dateComponents([.minute, .second], from: fromDate, to: toDate)
            if let second = components.second, let minute = components.minute {
                return (minute, second)
            }
        }
        return (-1, -1)
    }
    
    public static func differnce(inComponent: Calendar.Component, fromDate: Date?, toDate: Date?) -> Int {
        let defaultValue: Int = -1
        var diff = defaultValue
        if let fromDate = fromDate, let toDate = toDate {
            let gregorianCalendar = Calendar.init(identifier: Calendar.Identifier.gregorian)
            let components = gregorianCalendar.dateComponents([inComponent], from: fromDate, to: toDate)
            switch inComponent {
            case .nanosecond:
                diff = components.nanosecond ?? defaultValue
            case .second:
                diff = components.second ?? defaultValue
            case .minute:
                diff = components.minute ?? defaultValue
            case .hour:
                diff = components.hour ?? defaultValue
            case .day:
                diff = components.day ?? defaultValue
            case .month:
                diff = components.month ?? defaultValue
            case .quarter:
                diff = components.quarter ?? defaultValue
            case .year:
                diff = components.year ?? defaultValue
            case .weekday:
                diff = components.weekday ?? defaultValue
            case .weekOfYear:
                diff = components.weekOfYear ?? defaultValue
            case .weekOfMonth:
                diff = components.weekOfMonth ?? defaultValue
            case .era:
                diff = components.era ?? defaultValue
            case .weekdayOrdinal:
                diff = components.weekdayOrdinal ?? defaultValue
            default:
                break
            }
        }
        return diff
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
    
    public static func getMonthAndYearFromDate(_ currentDate: Date?) -> (String?, String?) {
        
        if let currentDate = currentDate {
            if let stringDate = Date.date(currentDate, inFormat: "MMM yyyy") {
                let components = stringDate.components(separatedBy: " ")
                return (components.first, components.last)
            }
        }
        return (nil, nil)
    }
    
    
    // MARK: - Class methods
    /**
     Method to convert given date in particular string format.
     - parameter date: A date to convert into string form.
     - parameter inFormat: A format in which you want to dispaly the date.
     - returns : A string Date in given format.
     */
    public static func dateInIST(_ date: Date, inFormat:String, needIST: Bool) -> String? {
        moviesDateFormatter.dateFormat = inFormat
        if needIST {
            moviesDateFormatter.timeZone = TimeZone.init(identifier: "IST")
        } else {
            moviesDateFormatter.timeZone = TimeZone.ReferenceType.default
        }
        return moviesDateFormatter.string(from: date)
    }
    
    /**
     Method to convert given string date into standard Date.
     - parameter dateString: Format in which date is converted to string.
     - parameter date: Date in the string format.
     - returns : A Date from the given input.
     */
    public static func dateInISTForDateformat(_ dateString: String?, date: String?, needIST: Bool) -> Date? {
        if let dateString = dateString, let date = date {
            moviesDateFormatter.dateFormat = dateString
            if needIST {
                moviesDateFormatter.timeZone = TimeZone.init(identifier: "IST")
            } else {
                moviesDateFormatter.timeZone = TimeZone.ReferenceType.default
            }
            return moviesDateFormatter.date(from: date)
        }
        return nil
    }
    
    
    public static func timeIn12HourFormatForTimeString(_ timeString:String?) -> String {
        if let timeString = timeString {
            let date = NSDate.dateForDateformat("HHmm", date:timeString)
            if let date = date {
                let formattedDateString = NSDate.date(date, inFormat:"h:mm a")
                
                //if we get formatted date string then return that...else return "NA" as default string
                if let formattedDateString = formattedDateString {
                    return formattedDateString;
                }
            }
        }
        return "NA";
    }
    
    public static func convertDateToString(_ date: Date, _ format: String, _ timeZone: String? = nil) -> String{
        let dateFormatter = DateFormatter()
        
        if let timeZone = timeZone{
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        
        dateFormatter.dateFormat = format
        let dateString = dateFormatter.string(from: date)
        return  dateString
    }
    
    public static func convertStringToDate(_ dateString: String, _ format: String, _ timeZone: String? = nil) -> Date?{
        let dateFormatter = DateFormatter()
        
        if let timeZone = timeZone{
            dateFormatter.timeZone = TimeZone(abbreviation: timeZone)
        }
        
        dateFormatter.dateFormat = format
        let date = dateFormatter.date(from: dateString)
        return  date
    }
    
    public static func combineDateWithTime(date: Date, time: Date) -> Date? {
        let timeString = Date.convertDateToString(time, "HH:mm", "UTC")
        let dateString = Date.convertDateToString(date, "dd-MM-yyyy", "UTC")
        let combinedString = "\(dateString) \(timeString)"
        
        return Date.convertStringToDate(combinedString, "dd-MM-yyyy HH:mm", "UTC")
    }
    
    public func stringInIST(format: DateFormat) -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = format.rawValue
        formatter.timeZone = TimeZone(abbreviation: "IST")
        return formatter.string(from: self)
    }
    
    public func toString(_ format  : String, dateFormatter : DateFormatter ) -> String{
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func toString(_ format  : String ) -> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format
        return dateFormatter.string(from: self)
    }
    
    public func getSeconds(calendar : Calendar) -> Int{
        var seconds = 0
        let components = calendar.dateComponents([.hour, .minute, .second], from: self)
        if let hour = components.hour, let minutes = components.minute, let secondsComponent = components.second{
            seconds = hour * 3600 + minutes * 60 + secondsComponent
        }
        return seconds
    }
    
    public func compareTimeOnly(to: Date,calendar : Calendar) -> ComparisonResult {
        
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!
        
        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        if seconds == 0 {
            return .orderedSame
        } else if seconds > 0 {
            // Ascending means before
            return .orderedAscending
        } else {
            // Descending means after
            return .orderedDescending
        }
    }
    
    public func timeDifferenceOnly(to: Date) -> Double {
        
        let calendar = Calendar.current
        let components2 = calendar.dateComponents([.hour, .minute, .second], from: to)
        let date3 = calendar.date(bySettingHour: components2.hour!, minute: components2.minute!, second: components2.second!, of: self)!
        
        let seconds = calendar.dateComponents([.second], from: self, to: date3).second!
        if seconds == 0 {
            return Double(seconds)
        } else if seconds > 0 {
            //Before Date
            return Double(seconds)
        } else {
            // After Date
            return -Double(seconds)
        }
    }
    
    public func getNewDateTimeStamp(to: Date)->Date {
        
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day,.hour, .minute, .second], from: to)
        
        if let date = calendar.date(bySettingHour: components.hour ?? 0, minute: components.minute ?? 0, second: components.second ?? 0, of: self) {
            return date
        }
        return self
    }
    
    public func minutes(from date: Date) -> Int {
        return Calendar.current.dateComponents([.minute], from: date, to: self).minute ?? 0
    }
    
    public var timeStamp: Double {
        get { return self.timeIntervalSince1970 }
    }
    
    public func stringIn(format: DateFormat) -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    public func stringIn(format: DateFormat, isGMT: Bool) -> String {
        let formatter        = DateFormatter()
        formatter.timeZone = TimeZone(abbreviation: isGMT ? "GTM" : "UTC")
        formatter.dateFormat = format.rawValue
        return formatter.string(from: self)
    }
    
    public func utcToLocalStringIn(format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        let str = dateFormatter.string(from: self)
        if let dt = dateFormatter.date(from: str) {
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.string(from: dt)
        }
        return str
    }
    
    public func stringWithFormat(_ format: String, isGTM: Bool) -> String {
        let formatter        = DateFormatter()
        formatter.dateFormat = format
        if isGTM {
            formatter.timeZone = TimeZone(identifier:"GMT")
        }
        return formatter.string(from: self)
    }
    
    public func stringWith(format: DateFormat, isGTM: Bool) -> String {
        return self.stringWithFormat(format.rawValue, isGTM: isGTM)
    }
    
    public func stringWith(format: DateFormat) -> String {
        return self.stringWithFormat(format.rawValue, isGTM: true)
    }
    
    public static func dateOneMonthBefore(format: DateFormat) -> String{
        return Calendar.current.date(byAdding: .day, value: -30, to: Date())!.stringWith(format: DateFormat(rawValue: format.rawValue)!)
    }
    
    public func getCurrentWeek() -> Date {
        var cal = Calendar.current
        cal.firstWeekday = 2
        let comps = cal.dateComponents([.weekOfYear, .yearForWeekOfYear], from: self)
        if let date = cal.date(from: comps) {
            let components = cal.dateComponents([.day], from: date, to: self)
            if let day = components.day {
                if day > 5 {
                    return self
                }
            }
            return date
        }
        
        return Date()
        //        return beginningOfWeek.stringWith(format:DateFormat(rawValue: format.rawValue)!)
    }
    
    public func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        formatter.timeZone = TimeZone(identifier:"GMT")
        return formatter
    }
    
    public func convertToLocalTimeZone(with format: DateFormat) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = format.rawValue
        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
        
        if let dt = dateFormatter.date(from: self.stringWith(format: format)) {
            
            dateFormatter.timeZone = TimeZone.current
            dateFormatter.dateFormat = format.rawValue
            return dateFormatter.string(from: dt)
        } else {
            return dateFormatter.string(from: self)
        }
    }
    
    public func days(from date: Date) -> Int {
        return Calendar.current.dateComponents([.day], from: date, to: self).day ?? 0
    }
    
    public func add(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        var targetDay: Date
        targetDay = Calendar.current.date(byAdding: .year, value: years, to: self)!
        targetDay = Calendar.current.date(byAdding: .month, value: months, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .day, value: days, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .hour, value: hours, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .minute, value: minutes, to: targetDay)!
        targetDay = Calendar.current.date(byAdding: .second, value: seconds, to: targetDay)!
        return targetDay
    }
    
    public func subtract(years: Int = 0, months: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0) -> Date {
        let inverseYears = -1 * years
        let inverseMonths = -1 * months
        let inverseDays = -1 * days
        let inverseHours = -1 * hours
        let inverseMinutes = -1 * minutes
        let inverseSeconds = -1 * seconds
        return add(years: inverseYears, months: inverseMonths, days: inverseDays, hours: inverseHours, minutes: inverseMinutes, seconds: inverseSeconds)
    }
    
    public func getDaysBefore(days:Int) ->Date {
        if let finalDate = Calendar.current.date(byAdding: .day, value: -1 * (days), to: self) {
            return finalDate
        }
        return self
    }
}
