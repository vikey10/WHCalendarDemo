//
//  ViewController.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/16.
//

import UIKit

class ViewController: UIViewController,WHCalendarViewDelegate {
 
    
    
    let kwindow_width = UIScreen.main.bounds.size.width
    private let calendarConfig = WHCalendarConfig.shared
    private var currentDate = WHPeriodDateInfo()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "WHCalendarDemo"
        let frame = CGRect.init(x: 0, y: 60, width: kwindow_width, height: 25 + kwindow_width*6/7)
        self.calendarView = WHCalendarView.init(frame:frame,startYear: calendarConfig.calendarStartYear,endYear: calendarConfig.calendarEndYear)
        self.calendarView.calendarDelegate = self
        self.view.addSubview(self.calendarView)
//        self.view.addSubview(self.pageControl)
        self.view.addSubview(self.currentMonth)
        self.view.addSubview(self.backToday)
        self.view.addSubview(self.switchBtn)
        self.calendarPresenter = WHCalendarViewPresenter.init(calendarView: self.calendarView,
                                                              calendarConfig: calendarConfig)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.navigationBar.setBackgroundImage(UIColor.white.image(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIColor.black.image()
        self.navigationController?.navigationBar.titleTextAttributes = [
            NSAttributedString.Key.foregroundColor:UIColor.black,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16)]
    }
    
    var calendarView: WHCalendarView!
    
//    lazy var pageControl: UIPageControl = {
//        let control = UIPageControl.init(frame: CGRect.init(x: kwindow_width/2 - 100, y: self.calendarView.frame.origin.y + self.calendarView.frame.height, width: 200, height: 30))
//        control.numberOfPages = 3
//        control.currentPageIndicatorTintColor = UIColor.red
//        control.currentPage = 1
//        control.pageIndicatorTintColor = UIColor.black
//        return control
//    }()
    
    lazy var backToday : UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.frame = CGRect.init(x: 120, y: 20, width: 80, height: 30)
        btn.setTitle("回到今天", for: .normal)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.addTarget(self, action: #selector(backTodayBtnClicked), for: .touchUpInside)
        btn.isHidden = true
        return btn
    }()
    
    lazy var currentMonth: UIButton = {
        let btn = UIButton.init(type: UIButton.ButtonType.custom)
        btn.frame = CGRect.init(x: 0, y: 20, width: 120, height: 30)
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        btn.setTitleColor(UIColor.red, for: .normal)
        btn.setTitle(Date().toFormat("yyyy-MM"), for: .normal)
        btn.setImage(UIImage.init(named: "back_arrow"), for: .normal)
        btn.addTarget(self, action: #selector(toYearCalendar), for: .touchUpInside)
        btn.isUserInteractionEnabled = true
        return btn
    }()
    
    lazy var switchBtn: UISwitch = {
        let s = UISwitch.init()
        var frame = s.frame
        frame.origin = CGPoint.init(x: kwindow_width - frame.size.width - 15, y: 20)
        s.frame = frame
        s.thumbTintColor = UIColor(hex: 0xFC3075)
        s.onTintColor = UIColor(hex: 0x1CB164)
        s.addTarget(self, action: #selector(switchBtnClicked), for: .valueChanged)
        return s
    }()
    
     private var calendarPresenter: WHCalendarViewPresenter!
    

    func monthShowed(month: WHCalendarDate) {
        self.currentMonth.setTitle(WHCalendarUtils.getMonthStr(month: month), for: .normal)
        if month.month == Date().month && month.year == Date().year {
            self.backToday.isHidden = true
        } else {
            self.backToday.isHidden = false
        }
        self.calendarPresenter.monthShowed(monthStr: WHCalendarUtils.getMonthStr(month: month))
//        UIView.animate(withDuration: 0.3) {
//            let weeks = WHCalendarUtils.monthWeeks(month: month)
//            let height =  self.kwindow_width * CGFloat(weeks) / 7 + 25
//            var frame = self.pageControl.frame
//            frame.origin.y = self.calendarView.frame.origin.y + height
//            self.pageControl.frame = frame
//        }
    }
    
    func dateSelected(date: WHPeriodDateInfo) {
        self.currentDate = date
        self.calendarPresenter.setSelectedDate(date: date)
        self.switchBtn.isEnabled = !(date.date?.isInFuture ?? false)
        if self.switchBtn.isEnabled {
            self.switchBtn.isOn =  [WHCalendarConfig.PeriodDayType.period,.period_start,.period_end].contains(self.currentDate.periodType)
        }
    }
    
    @objc func backTodayBtnClicked() {
        self.calendarPresenter.showToday()
    }
    
    
    @objc func switchBtnClicked(switch:UISwitch) {
        self.calendarPresenter.changeDateType(date: self.currentDate)
    }
    
    @objc func toYearCalendar() {
        let vc = WHYearCalendarViewController.init(calendarConfig: self.calendarConfig)
        vc.finishBlock = {[weak self](date) in
            guard let `self` = self else {return}
            self.calendarPresenter.setYearMonth(date: date)
            let str = WHCalendarUtils.getMonthStr(month: date)
            self.currentMonth.setTitle(str, for: .normal)
        }
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

