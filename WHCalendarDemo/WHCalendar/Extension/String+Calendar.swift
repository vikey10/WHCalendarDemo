//
//  String+Calendar.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/20.
//

import Foundation

extension String {
 
    func month2Date(format:String = "yyyy-MM") -> Date? {
        return self.toDate(format,region: .ISO)?.date
    }
    
    func day2Date(format:String = "yyyy-MM-dd") -> Date? {
        return self.toDate(format,region: .ISO)?.date
    }
}
