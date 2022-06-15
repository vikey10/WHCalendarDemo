//
//  WHCalendarConfig.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/12.
//

import Foundation
import UIKit

typealias WHCalendarScrollDirection = UICollectionView.ScrollDirection

struct WHCalendarConfig {
    static let shared = WHCalendarConfig()
    var daySelectedBackgroundColor: UIColor = UIColor(hex: 0xFF00FF)
    var dayBackgroudColor: UIColor = UIColor(hex: 0xFFFFFF)
    var dayBottomDotColor: UIColor = UIColor(hex: 0xFF00FF)
    var dayBottomDotWidth: CGFloat = 6
    
    var dayNumColor: UIColor = UIColor(hex: 0xFFFFFF)
    var dayHighlightColor: UIColor = UIColor(hex: 0xFF0000)
    var dayBorderColor: UIColor = UIColor(hex:0xFC3075)
    var dayBorderWidth: CGFloat = 2
    var dayBorderRadius: CGFloat = 4
    var showChineseDate: Bool = true
    var daySubNumColor: UIColor = UIColor(hex: 0xFF0000)
    
    var scrollDirection: WHCalendarScrollDirection = .vertical
    var allowMultipleSelection: Bool = false
    var allowSelection: Bool = true
    var calendarStartYear = 1970
    var calendarEndYear = 2050
}

extension WHCalendarConfig {
    enum PeriodDayType {
//        MARK：经期
        case period_start
        case period_end
        case period
//        MARK：其它
        case normal
//       MARK:易孕期
        case fertile
//       MARK:排卵日
        case ovulation
        
        func color() ->  UIColor {
            switch self {
            case .normal:
                return UIColor(hex:0x1CB164)
            case .period:
                return UIColor(hex:0xFC3075)
            case .period_start:
                return UIColor(hex:0xFC3075)
            case .period_end:
                return UIColor(hex:0xFC3075)
            case .fertile:
                return UIColor(hex:0x782CFB)
            case .ovulation:
                return UIColor(hex: 0x782CFB)
                
           }
        }
        
        func icon() -> UIImage? {
            switch self {
            case .normal,.fertile,.period:
                return nil
            case .period_start:
                return UIImage.init(named: "period_start")
            case .period_end:
                return UIImage.init(named: "period_end")
            case .ovulation:
                return UIImage.init(named: "ovulation")
                
           }
        }
        
    }
}

struct WHPeriodSettings {
    //月经周期
    var periodInterval: Int = 30
    //月经持续时间
    var periodDuration: Int = 5
}

struct WHPeriodInfo {
    var periodStartDate: String?
    var periodEndDate: String?
}

struct WHPeriodDateInfo {
    var isValidInfo: Bool = false
    var displayNum: String = ""
    var date: Date? = nil
    var isToday: Bool = false
    var periodType: WHCalendarConfig.PeriodDayType = .normal
}


struct WHCalendarDate {
    var year: Int = Date().year
    var month: Int = Date().month
    
    func toDate() -> Date {
        return Date.init(year: year, month: month, day: 1, hour: 0, minute: 0)
    }
    
    func compare(toDate refDate: WHCalendarDate) -> ComparisonResult {
        if self.year > refDate.year {
            return .orderedDescending
        }else if self.year == refDate.year {
            if self.month > refDate.month {
                return .orderedDescending
            } else if self.month == refDate.month {
                return .orderedSame
            } else {
                return .orderedAscending
            }
        }else {
            return .orderedAscending
        }
    }
    
    func addMonth(_ month: Int) -> WHCalendarDate {
        let month = (self.month + month)%12
        var year = (self.month + month) > 12 ? year + 1  : year
        year = self.month + month <= 0 ? year - 1 : year
        return WHCalendarDate.init(year: year, month: month)
    }
}



