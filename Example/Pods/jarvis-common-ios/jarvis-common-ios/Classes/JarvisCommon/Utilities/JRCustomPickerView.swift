//
//  JRCustomPickerView.swift
//  Jarvis
//
//  Created by Sandesh Kumar on 04/02/16.
//  Copyright © 2016 One97. All rights reserved.
//

import Foundation
import jarvis_utility_ios

public class JRCustomPickerView: UIView {
    
    //DatePicker
    public var date: Date? {
        get{
            var value: Date?
            var string: String = ""
            if let keys = keys {
                if !(keys.count > 0) { //check this
                    value = datePickerView?.date
                }
                else {
                    //            let selectedRows = selectedRows
                    var index: Int = 0
                    let finalKey = keys.joined(separator: "-")
                    for key in keys {
                        if "MM" == key {
                            
                            string = "\(string)-\(indexForMonthName(month: seletedValues?[index] as? String) + 1)"
                        } else if "yyyy" == key {
                            string = "\(string)-\(yearForIndex(index: selectedRows?[index] as? Int))"
                        } else if "dd" == key {
                            string = "\(string)-\((selectedRows?[index] as? Int ?? 0) + 1))"
                        }
                        index += 1
                    }
                    
                    if string.length  > 0 {
                        let range = string.startIndex..<string.index(string.startIndex, offsetBy: 1)
                        string = string.replacingCharacters(in: range, with: "")
                    }
                    value = Date.dateForDateformat(finalKey, date: string)
                    
                }
            }
            return value
        }
        set{
             localDate = newValue
        }
    }
    fileprivate var localDate: Date?
    
    public var minimumDate: Date? =  Date().dateByAddingYears(-100)
    public var maximumDate: Date? =  Date().dateByAddingYears(15)
    public var dateFormat: String?{
        get{
            return localDateFormat
        }
        set{
            localDateFormat = newValue
            initializePickerView()
        }
    }
    fileprivate var localDateFormat: String?
    public var dateHandler: ((_: Date, _: Bool) -> Void)?
    public var handler: ((_: [Any], _: [Any]) -> Void)?
    //Normal Picker
    //Send Info as Array of array;
    public var info:[[Any]]?
    public var selectedRows:[Any]? {
        
        if let info = info, let pickerView = pickerView {
            var selectedRow: [Any] = [Any]()
            for comp in 0..<info.count {
                selectedRow.append(pickerView.selectedRow(inComponent: comp))
            }
            return selectedRow
        }
        return nil
    }
    
    
    
    public var seletedValues: [Any]? {
        
        if let info = info , let pickerView = pickerView {
            var selectedValue: [Any] = [Any]()
            for comp in 0..<info.count {
                selectedValue.append(info[comp][pickerView.selectedRow(inComponent: comp)])
            }
            return selectedValue
        }
        return nil
    }
    
   
    
    fileprivate var pickerView: UIPickerView?
    fileprivate var datePickerView: UIDatePicker?
    fileprivate var keys: [String]?
    
    
    fileprivate var monthList:[String] {
        get {
            return ["January", "February ", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
        }
    }
    
    public func setUPPickerViewForMode(dataSourceArray: [[Any]]) {
        pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: JRSwiftConstants.windowWidth, height: 160))
        pickerView?.delegate = self
        pickerView?.dataSource = self
        if let pickerView = pickerView {
            addSubview(pickerView)
        }
        info = dataSourceArray;
    }
    
    
    
    
    public func setUPDatePickerViewForMode(datePickerMode: UIDatePicker.Mode) {
        datePickerView = UIDatePicker(frame: self.frame)
        datePickerView?.backgroundColor = UIColor.white
        datePickerView?.datePickerMode = datePickerMode
        
        
        if let maximumDate = maximumDate {
            datePickerView?.maximumDate = maximumDate
        }
        
        if let minimumDate = minimumDate {
            datePickerView?.minimumDate = minimumDate
        }
        if let date = date {
            datePickerView?.date = date
        }
        
        datePickerView?.addTarget(self, action:
            #selector(JRCustomPickerView.datePicked(picker:)), for: .valueChanged)
        if let datePickerView = datePickerView {
            addSubview(datePickerView)
        }
    }
    
    @objc public func datePicked(picker: UIDatePicker) {
        if let dateHandler = dateHandler, let date = date {
            dateHandler(date, false)
        }
    }
    
    public func yearForIndex(index: Int?) -> Int {
        if let minimumDate = minimumDate {
            return minimumDate.dateComponent().year! + (index ?? 0)
        }
        return 0
    }
    
    
    public func getDateArray() -> [Int] {
        
        
        let today: Date = Date() //Get a date object for today's date
        let cal: Calendar = Calendar.current
        if let days = cal.range(of: .day, in: .month, for: today) {
            var array: [Int] = [Int]()
            
            for index in  1...days.count {
                array.append(index)
            }
            return array
        }
        return []
    }
    
    
    
    public func indexForMonthName(month: String?) -> Int {
        if let month = month, let index = monthList.firstIndex(of: month) {
            return index
        }
        return 0
    }
    
    public func getYearArray() -> [Int]? {
        if let minYear = minimumDate?.dateComponent().year, let maxYear = maximumDate?.dateComponent().year {
            var array: [Int] = [Int]()
            for index in minYear...maxYear {
                
                array.append(index)
                
            }
            return array
        }
        return nil
        
    }
    
    public func getMonthArray() -> [String]? {
        
        let monthnames = monthList
        
        if let maximumDate = maximumDate, let minimumDate = minimumDate {
            if maximumDate.numberOfDaysSinceDate(minimumDate) >= 365 {
                
                return monthnames
            }
            else {
                let startIndex: Int = minimumDate.dateComponent().month! - 1
                var finalIndex: Int = maximumDate.dateComponent().month! - 1
                if finalIndex <= startIndex {
                    finalIndex += 12
                }
                
                var list: [String] = [String]()
                
                for index in startIndex...finalIndex {
                    list.append(monthnames[index%12])
                }
                return list
            }
            
        }
        return nil
    }
    
    public func initializePickerView() {
        
        if let resultString = dateFormat {
        let hasMonth: Bool = resultString.range(of: "MM")?.lowerBound != nil
        let hasYear: Bool = resultString.range(of:"yy")?.lowerBound != nil
        let hasDate: Bool = resultString.range(of:"dd")?.lowerBound != nil
        let hashour: Bool = resultString.range(of:"h")?.lowerBound != nil
        let hasMinutes: Bool = resultString.range(of:"mm")?.lowerBound != nil
        
        
        self.keys = [String]()
        // Wed Nov 15 | 6 | 53 | PM
        if hasDate && hashour && hasMinutes  {
            setUPDatePickerViewForMode(datePickerMode: .dateAndTime)
        }
        else if hashour && hasMinutes // 6 | 53 | PM
        {
            setUPDatePickerViewForMode(datePickerMode: .time)
        }
        else if hasDate && hasMonth && hasYear //  November | 15 | 2007
        {
            setUPDatePickerViewForMode(datePickerMode: .date)
        }
            
        else if hasMonth && hasYear // Nov | 2015
        {
            keys?.append("MM")
            keys?.append("yyyy")
            
            info = [[Any]]()
            if let monthArray = getMonthArray() {
                info?.append(monthArray)
            }
            if let array = getYearArray() {
                info?.append(array)
            }
            if let info = info {
                setUPPickerViewForMode(dataSourceArray: info)
            }
        }
        else if (hasYear) // 2015
        {
            keys?.append("yyyy")
            info = [[Any]]()
            if let array = getYearArray() {
                info?.append(array)
            }
            if let info = info {
                setUPPickerViewForMode(dataSourceArray: info)
            }
        }
            
        else if (hasMonth) //Nov
        {
            keys?.append("MM")
            
            info = [[Any]]()
            if let monthArray = getMonthArray() {
                info?.append(monthArray)
            }
            if let info = info {
            setUPPickerViewForMode(dataSourceArray: info)
            }
        }
        else if (hasDate) // 3
        {
            keys?.append("dd")
            
            info = [[Any]]()
            info?.append(getDateArray())
            if let info = info {
            setUPPickerViewForMode(dataSourceArray: info)
            }
        }
    }
    }
}


extension JRCustomPickerView: UIPickerViewDataSource {
    // returns the number of 'columns' to display.
    
    public func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if let info = info {
            return info.count
        }
        return 0
    }

    
    // returns the # of rows in each component..
    public func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if let info = info {
            return info[component].count
        }
        return 0
    }
}

extension JRCustomPickerView: UIPickerViewDelegate {
    
    public func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if let date = date {
            dateHandler?(date, false)
        }
        if let selectedRows = selectedRows, let seletedValues = seletedValues {
            handler?(selectedRows,seletedValues)
        }
    }
    
    public func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if let value = info?[component][row] {
            //Assuming two possible formates are NSnumber or NSString
            if  value is String {
                return value as? String
            }
            return "\(value)"
        }
        //        return [value isKindOfClass:[NSNumber class]] ? [NSString stringWithFormat:@"%ld",(long)[value integerValue]] : value;
        return nil
    }
}






