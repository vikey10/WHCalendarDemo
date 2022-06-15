//
//  WHCalendarUtils.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/19.
//

import Foundation
import SwiftDate

class WHCalendarUtils {
    static let shared = WHCalendarUtils()
    
    static func getDefaultMonthArr(str:String) -> [WHPeriodDateInfo] {
        var dates = [WHPeriodDateInfo]()
        let monthDate = str.month2Date()
        let days = monthDate?.monthDays ?? 30
        let firstDay = (monthDate?.weekday ?? 1) - 1
        for _ in  0..<firstDay {
            dates.append(WHPeriodDateInfo())
        }
        for index in 0..<days {
            let date = (str + "-" + formatDay(number: index + 1)).day2Date()
            let info = WHPeriodDateInfo.init(isValidInfo: true, displayNum: "\(index + 1)", date: date?.date, isToday: (date?.isToday ?? false), periodType: .normal)
            dates.append(info)
        }
        return dates
    }
    
    static func formatDay(number: Int) -> String {
        return number < 10 ? "0\(number)" : "\(number)"
    }
    
    static func getDayIndex(month:WHCalendarDate,day:Int) -> Int {
        return getMonthFirstIndex(month: month) + day - 1
    }
    
    static func getMonthFirstIndex(month:WHCalendarDate) -> Int {
        return (getMonthStr(month: month).month2Date()?.weekday ?? 1 ) - 1
    }
    
    static func monthWeeks(month:WHCalendarDate) -> Int {
        if let monthDate = getMonthStr(month: month).month2Date() {
            return Int(ceil(Double(monthDate.monthDays + monthDate.weekday - 1)/7))
        }
        return 6
    }
    
    static func getMonthStr(month:WHCalendarDate) -> String {
        return "\(month.year)-" + formatDay(number: month.month)
    }
}
