//
//  WHPeriodDayView.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/13.
//

import Foundation
import UIKit

class WHPeriodDayView: UICollectionViewCell {
    var calendarConfig: WHCalendarConfig = .shared {
        didSet {
            self.layoutIfNeeded()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    override var isSelected: Bool {
        willSet(newValue) {
            self.borderView.isHidden = !newValue
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.contentView.addSubview(self.borderView)
        self.contentView.addSubview(self.selectedView)
        self.contentView.addSubview(self.img)
        self.contentView.addSubview(self.numberLB)
        self.contentView.addSubview(self.todayLB)
        self.contentView.addSubview(self.bottomLine)
    }
        
    lazy var numberLB: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 0, y: self.bounds.size.height/2 - 10, width: self.bounds.size.width, height: 20))
        lb.font = UIFont.systemFont(ofSize: 14)
        lb.textAlignment = .center
        return lb
    }()
    
    lazy var todayLB: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 0, y: self.numberLB.frame.maxY, width: self.bounds.size.width, height: 16))
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
        lb.isHidden = true
        lb.text = "今天"
        return lb
    }()
    
     lazy var selectedView: UIView = {
         let view = UIView.init(frame: self.bounds.insetBy(dx: 6, dy: 6))
         view.layer.cornerRadius = calendarConfig.dayBorderRadius
         view.clipsToBounds = true
         view.isHidden = true
        return view
    }()
    
    lazy var borderView: UIView = {
        let view = UIView.init(frame: self.bounds.insetBy(dx: 2, dy: 2))
        view.layer.cornerRadius = calendarConfig.dayBorderRadius
        view.layer.borderWidth = calendarConfig.dayBorderWidth
        view.layer.borderColor = calendarConfig.dayBorderColor.cgColor
        view.backgroundColor = UIColor.white
        view.isHidden = true
        view.clipsToBounds = true
        return view
    }()
    
    lazy var img: UIImageView = {
        let img = UIImageView.init(frame: CGRect.init(x: self.bounds.size.width/2 - 5, y: self.numberLB.frame.origin.y - 10, width: 10, height: 10))
        img.isHidden = true
        return img
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.bounds.size.height-1, width: self.bounds.size.width, height: 0.5))
        view.backgroundColor = UIColor.init(hex: 0xdddddd)
        return view
    }()
    
    func prepareData(num: String,isToday:Bool,dayType:WHCalendarConfig.PeriodDayType,isSelected:Bool) {
        self.numberLB.text = num
        self.todayLB.isHidden = !isToday
        self.todayLB.textColor = dayType.color()
        
        if [WHCalendarConfig.PeriodDayType.period,.period_start,.period_end].contains(dayType){
            self.selectedView.isHidden = false
            self.selectedView.backgroundColor = dayType.color()
            self.numberLB.textColor = UIColor.white
        } else {
            self.selectedView.isHidden = true
            self.numberLB.textColor = dayType.color()
        }
        
        if let icon = dayType.icon(){
            self.img.image = icon
            self.img.isHidden = false
        } else {
            self.img.isHidden = true
        }
        self.borderView.isHidden = !isSelected
        self.selectedView.frame = isSelected ? self.bounds.insetBy(dx: 6, dy: 6) : self.bounds.insetBy(dx: 2, dy: 2)
        self.bottomLine.isHidden = false
    }
    
    func empty() {
        self.numberLB.text = ""
        self.todayLB.isHidden = true
        self.selectedView.isHidden = true
        self.borderView.isHidden = true
        self.img.isHidden = true
        self.bottomLine.isHidden = true
    }

}




