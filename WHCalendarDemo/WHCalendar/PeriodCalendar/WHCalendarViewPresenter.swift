//
//  WHCalendarViewPresenter.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/13.
//

import Foundation
import SwiftDate

public class WHCalendarViewPresenter  {
    
    lazy var periodDates: [String:[WHPeriodInfo]] = {
        var arr = [String:[WHPeriodInfo]]()
        arr["2022-05"] = [WHPeriodInfo.init(periodStartDate: "2022-05-01", periodEndDate: "2022-05-05"),
                          WHPeriodInfo.init(periodStartDate: "2022-05-25", periodEndDate: "2022-05-30")]
        arr["2022-04"] = [WHPeriodInfo.init(periodStartDate: "2022-04-01", periodEndDate: "2022-04-05"),
                          WHPeriodInfo.init(periodStartDate: "2022-04-25", periodEndDate: "2022-04-30")]
        arr["2022-03"] = [WHPeriodInfo.init(periodStartDate: "2022-03-01", periodEndDate: "2022-03-05")]
        arr["2022-02"] = [WHPeriodInfo.init(periodStartDate: "2022-02-01", periodEndDate: "2022-02-05")]
        return arr
    }()   //设置的经期
    var lastRecordPeriod = WHPeriodInfo.init(periodStartDate: "2022-05-25", periodEndDate: "2022-05-30")
    var periodSettings = WHPeriodSettings.init() //经期设置
    private weak var calendarView: WHCalendarView!
    private var currentMonth: WHCalendarDate = WHCalendarDate.init(year: Date().year, month: Date().month)
    private var selectedDay: Int?
    private var calendarConfig: WHCalendarConfig = .shared
   
    convenience init(calendarView:WHCalendarView,calendarConfig:WHCalendarConfig = .shared) {
        self.init()
        self.calendarConfig = calendarConfig
        self.calendarView = calendarView
        let date = Date()
        self.currentMonth = WHCalendarDate.init(year: date.year, month: date.month)
        self.selectedDay = date.day
        self.prepareDates()
    }
    
    //TODO：请求服务器设置数据状态，重新拉取periodDates
    func changeDateType(date:WHPeriodDateInfo) {
        switch date.periodType {
            case .period_start:
                self.removePeriodDate(date: date)
            case .period:
                self.updatePeriodDate(date:date)
            case .period_end:
                self.addPeriodDate(date:date)
        }
    }
    
    func removePeriodDate(date:WHPeriodDateInfo) {
        guard let monthStr = date.date?.toFormat("yyyy-MM", locale: nil) else {return}
        self.periodDates[monthStr]?.removeAll(where: { info in
            return info.periodStartDate == date.date?.toFormat("yyyy-MM-dd", locale: nil)
        })
        self.prepareDates()
    }
    
    func updatePeriodDate(date:WHPeriodDateInfo) {
        guard let currentDate = date.date else {return}
        let monthStr = currentDate.toFormat("yyyy-MM", locale: nil)
        if var arr = self.periodDates[monthStr],
           arr.count > 0{
            for index in 0..<arr.count {
                let item = arr[index]
                if let startDate = item.periodStartDate?.day2Date(),
                   let endDate = item.periodEndDate?.day2Date() {
                    if currentDate.isInRange(date: startDate, and:endDate, orEqual: true, granularity: .day) {
                        arr[index].periodEndDate = currentDate.toFormat("yyyy-MM-dd", locale: nil)
                        self.periodDates[monthStr] = arr
                        self.prepareDates()
                        return
                    }
                }
            }
        }
    }
    
    func addPeriodDate(date: WHPeriodDateInfo) {
        guard let currentDate = date.date else {return}
        let monthStr = currentDate.toFormat("yyyy-MM", locale: nil)
        let startDate = currentDate.toFormat("yyyy-MM-dd", locale: nil)
        let endDate = currentDate.dateByAdding(periodSettings.periodDuration, .day).date.toFormat("yyyy-MM-dd", locale: nil)
        let info = WHPeriodInfo.init(periodStartDate: startDate, periodEndDate: endDate)
        if var arr = self.periodDates[monthStr] {
            if arr.count == 0 {
                arr.insert(info, at: 0)
                self.periodDates[monthStr] = arr
                self.refreshDates(monthStr: monthStr)
            } else {
                for index in 0..<arr.count {
                    if let sDate = arr[index].periodStartDate?.toDate("yyyy-MM-dd", region: .ISO)?.date {
                        if sDate.isAfterDate(currentDate, granularity: .day) {
                            arr.insert(info, at: index)
                            self.periodDates[monthStr] = arr
                            self.refreshDates(monthStr: monthStr)
                            return
                        }
                    }
                }
            }
        } else {
            self.periodDates[monthStr] = [info]
            self.refreshDates(monthStr: monthStr)
        }
    }

    func setYearMonth(date:WHCalendarDate) {
        self.currentMonth = date
        self.prepareDates()
        self.calendarView.showMonth(year: date.year, month: date.month)
    }
    
    func updateYear(_ year: Int) {
        self.currentMonth.year = year
        self.prepareDates()
        self.calendarView.showMonth(year: year, month: self.currentMonth.month)
    }
    
    func updateMonth(_ month: Int) {
        self.currentMonth.month = month
        self.prepareDates()
        self.calendarView.showMonth(year: self.currentMonth.year, month:month)
    }
    
    
    func setSelectedDate(date:WHPeriodDateInfo) {
        // 日期被选择
        self.selectedDay = date.date?.day ?? 1
    }
    
    func showToday() {
        self.currentMonth = WHCalendarDate.init(year: Date().year, month: Date().month)
        self.calendarView?.showToday()
    }
    
    //保证当前月份、前一个月份、后一个月份的数据
    func monthShowed(monthStr:String) {
        //比较当前月份和新月份，储备对应月份的数据
        if  let date = monthStr.month2Date() {
            let currentDate = self.currentMonth.toDate()
            let result = date.compare(toDate: currentDate, granularity: .month)
            if result != .orderedSame {
                var interval = 0
                if result == .orderedAscending {
                    interval = -1
                } else if result == .orderedDescending {
                    interval += 1
                }
                let newMonthstr = date.dateByAdding(interval, .month).toFormat("yyyy-MM")
                self.refreshDates(monthStr: newMonthstr)
            }
            self.currentMonth = WHCalendarDate.init(year: date.year, month: date.month)
        }
    }
    
    private func refreshDates(monthStr:String) {
        print("refreshDate:\(monthStr)")
        DispatchQueue.global().async { [weak self]() in
            guard let `self` = self else {return}
            let currentMonthArr = self.getPeriodDates(monthStr: monthStr)
            var dates = [Int:[Int:WHCalendarConfig.PeriodDayType]]()
            dates[self.getMonthIndex(monthStr: monthStr)] = currentMonthArr
            DispatchQueue.main.async{
                self.calendarView.refreshDates(dates: dates)
            }
        }
    }

    
    private func prepareDates() {
        DispatchQueue.global().async { [weak self]() in
            guard let `self` = self else {return}
            let currentMonthArr = self.getPeriodDates(monthStr: self.getCurrentMonthStr())
            let nextMonthArr = self.getPeriodDates(monthStr: self.getNextMonthStr())
            let preMonthArr = self.getPeriodDates(monthStr: self.getPreMonthStr())
            let currentIndex = (self.currentMonth.year - self.calendarConfig.calendarStartYear)*12 + self.currentMonth.month - 1
            let nextIndex = currentIndex + 1
            let preIndex = currentIndex - 1
            DispatchQueue.main.async{
                var dates = [Int:[Int:WHCalendarConfig.PeriodDayType]]()
                if let pre = preMonthArr {
                    dates[preIndex] = pre
                }
                if let current = currentMonthArr {
                    dates[currentIndex] = current
                }
                if let next = nextMonthArr {
                    dates[nextIndex] = next
                }
                self.calendarView.refreshDates(dates: dates)
            }
        }
    }
    
    private func getPeriodDates(monthStr:String) -> [Int:WHCalendarConfig.PeriodDayType]? {
        guard let monthDate = monthStr.month2Date() else {return nil}
        //获取当月日期和下个月第一个日期
        var defaultArr = [Int:WHCalendarConfig.PeriodDayType]()
        let monthFirstDay = WHCalendarUtils.getMonthFirstIndex(month: WHCalendarDate.init(year: monthDate.year, month: monthDate.month))
        //比较本月最后一个日期和下月第一个日期，保证下月日期影响的日期不在上一个日期的区间内，先显示后面的日期，前面日期计算时，会覆盖前面的日期
        let nextMonthStr = monthDate.dateByAdding(1, .month).toFormat("yyyy-MM")
        if let nextFirst = self.periodDates[nextMonthStr]?.first {
            if let startDate = nextFirst.periodStartDate?.day2Date() {
                let oStart = startDate.dateByAdding(-19, .day).date
                let oEnd = startDate.dateByAdding(-10, .day).date
                let oDay = startDate.dateByAdding(-14, .day).date
                if oStart.toFormat("yyyy-MM") == monthStr {
                    var date = oStart
                    while(date.isInRange(date: oStart, and: oEnd,orEqual: true)) {
                        if date.toFormat("yyyy-MM") == monthStr {
                            let dayIndex = date.day + monthFirstDay - 1
                            defaultArr[dayIndex] = (date == oDay) ? .ovulation : .fertile
                        }
                        date = date.dateByAdding(1, .day).date
                    }
                }
            }
        }
        if let periodArr = self.periodDates[monthStr] {
            for i in 1...periodArr.count {
                let index = periodArr.count - i
                let item = periodArr[index]
                if let startDate = item.periodStartDate?.day2Date(),
                   let endDate = item.periodEndDate?.day2Date() {
                    for item in defaultArr {
                        if item.key < startDate.day + monthFirstDay - 1 {
                            defaultArr.removeValue(forKey: item.key)
                        }
                    }
                    var date = startDate
                    while(date.isInRange(date: startDate, and: endDate,orEqual: true)) {
                        let dayIndex = date.day + monthFirstDay - 1
                        if date == startDate {
                            defaultArr[dayIndex] = .period_start
                        } else if date == endDate {
                            defaultArr[dayIndex] = .period_end
                        } else {
                            defaultArr[dayIndex] = .period
                        }
                        date = date.dateByAdding(1, .day).date
                    }
                    
                    let oStart = startDate.dateByAdding(-19, .day).date
                    let oEnd = startDate.dateByAdding(-10, .day).date
                    let oDay = startDate.dateByAdding(-14, .day).date
                    if oEnd.toFormat("yyyy-MM") == monthStr {
                        date = oStart
                        while(date.isInRange(date: oStart, and: oEnd,orEqual: true)) {
                            if date.toFormat("yyyy-MM") == monthStr {
                                let dayIndex = date.day + monthFirstDay - 1
                                defaultArr[dayIndex] = (date == oDay) ? .ovulation : .fertile
                            }
                            date = date.dateByAdding(1, .day).date
                        }
                    }
                }
            }
        }
        return defaultArr
    }
    
    
    private func getDate(dayIndex:Int) -> Date? {
        return "\(self.currentMonth.year)-\(self.currentMonth.month)-\(dayIndex+1)".toDate(style: StringToDateStyles.custom("yyyy-MM-dd"),region: .ISO)?.date
    }
    
    private func getMonthDays(monthStr:String) -> Int {
        return monthStr.month2Date()?.monthDays ?? 30
    }
    
    private func getPreMonthStr() -> String {
        let month = (self.currentMonth.month - 1) == 0 ? 12 : (self.currentMonth.month - 1)
        let year = self.currentMonth.year + ((self.currentMonth.month - 1) <= 0 ? -1 : 0)
        return "\(year)-" + WHCalendarUtils.formatDay(number: month)
    }
    
    private func getNextMonthStr() -> String {
        let month = (self.currentMonth.month + 1) > 12 ? 1 : (self.currentMonth.month + 1)
        let year = self.currentMonth.year + ((self.currentMonth.month + 1) > 12 ? 1 : 0)
        return "\(year)-" + WHCalendarUtils.formatDay(number: month)
    }
    
    private func getMonthIndex(monthStr:String) -> Int {
        let date = monthStr.month2Date() ?? Date()
        return (date.year - self.calendarConfig.calendarStartYear)*12 + date.month - 1
    }

    private func getCurrentMonthStr() -> String {
        return WHCalendarUtils.getMonthStr(month: self.currentMonth)
    }


}
