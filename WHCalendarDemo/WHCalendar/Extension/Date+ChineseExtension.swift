//
//  Date+ChineseExtension.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/13.
//

import Foundation

extension Date {
    
    func lunnarDay() -> String {
        let chineseCalendar = Calendar.init(identifier: .chinese)
        let components = chineseCalendar.dateComponents([.year,.month,.day], from: self)
        let gregorianCalendar = Calendar.init(identifier: .gregorian)
        let gregComponents = gregorianCalendar.dateComponents([.year,.month,.day], from: self)
        
        let chineseDays = ["初一", "初二", "初三", "初四", "初五", "初六", "初七", "初八", "初九", "初十","十一", "十二", "十三", "十四", "十五", "十六", "十七", "十八", "十九", "二十", "廿一", "廿二", "廿三", "廿四", "廿五", "廿六", "廿七", "廿八", "廿九", "三十"]
        let chineseMonths = ["正月", "二月", "三月", "四月", "五月", "六月", "七月", "八月","九月", "十月", "冬月", "腊月"]
        
        if let chineseDay = components.day,
           let chineseMonth = components.month{
            var day = chineseDay == 1 ? chineseMonths[chineseMonth-1] : chineseDays[chineseDay-1]
            if chineseDay == 1 && chineseMonth == 1 {
                day = "春节"
            } else if chineseDay == 15 && chineseMonth == 8 {
                day = "中秋"
            } else if chineseDay == 7 && chineseMonth == 7 {
                day = "七夕"
            } else if chineseDay == 5 && chineseMonth == 5 {
                day = "端午"
            }
            if let gregDay = gregComponents.day,
               let gregMonth = gregComponents.month {
                if gregDay == 1 && gregMonth == 1 {
                    day = "元旦"
                }else if gregDay == 5 && gregMonth == 4 {
                    day = "清明"
                }
            }
            return day
        }
        return ""
    }
    
    
}
