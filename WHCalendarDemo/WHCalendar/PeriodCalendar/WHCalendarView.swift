//
//  WHCalendarView.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/12.
//

import UIKit
import SwiftDate

protocol WHCalendarViewDelegate: AnyObject {
    func monthShowed(month: WHCalendarDate)
    func dateSelected(date:WHPeriodDateInfo)
}

public class WHCalendarView: UIView{
    
    weak var calendarDelegate: WHCalendarViewDelegate?
    private var selectedDay: Int = Date().day
    private var currentSection: Int = 0
    private var periodDates = [Int:[Int:WHCalendarConfig.PeriodDayType]]()
    private var calendarStartYear: Int = 1970
    private var calendarEndYear: Int = 2050
    
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.addSubview(self.titleView)
        self.addSubview(self.mainView)
        
    }
    
    convenience init(frame:CGRect,startYear:Int,endYear:Int,defaultDate:Date = Date()) {
        self.init(frame: frame)
        self.calendarStartYear = startYear
        self.calendarEndYear = endYear
        self.currentSection = (defaultDate.year - startYear)*12 + defaultDate.month - 1
        self.selectedDay = defaultDate.day
        self.mainView.selectItem(at: IndexPath.init(row: 0, section: self.currentSection), animated:true, scrollPosition: .left)
    }
    
    
    func refreshDates(dates:[Int:[Int:WHCalendarConfig.PeriodDayType]]) {
        var indexPaths = [IndexPath]()
        for item in dates {
            self.periodDates[item.key] = item.value
            indexPaths.append(IndexPath.init(row: 0, section: item.key))
        }
        self.mainView.reloadItems(at: indexPaths)
    }
    
    func showMonth(year:Int,month:Int) {
        self.currentSection = (year - self.calendarStartYear)*12 + month - 1
        self.mainView.scrollToItem(at: IndexPath.init(row: 0, section: self.currentSection), at: .left, animated: true)
    }
    

    func showToday() {
        let date = Date()
        let currentMonth = (date.year - 1970)*12 + (date.month - 1)
        self.selectedDay = date.day
        self.mainView.scrollToItem(at: IndexPath.init(row: 0, section: currentMonth), at: .left, animated: true)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var titleView: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: 0, width:kwindow_width , height: 25))
        let titles = ["日","一","二","三","四","五","六"]
        let itemWidth = kwindow_width/7
        for index in 0..<titles.count {
            let frame = CGRect.init(x: CGFloat(index)*itemWidth, y: 0, width: itemWidth, height: 25)
            let tagView = UILabel.init(frame: frame)
            tagView.text = titles[index]
            tagView.font = UIFont.systemFont(ofSize: 14)
            tagView.textAlignment = .center
            if (1...5).contains(index) {
                tagView.textColor = UIColor.black
            } else {
                tagView.textColor = UIColor.darkGray
            }
            view.addSubview(tagView)
        }
        return view
    }()
    
    lazy var mainView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .horizontal
        flowLayout.itemSize = CGSize.init(width: kwindow_width, height: kwindow_width*6/7)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        
        let view = UICollectionView.init(frame:  CGRect.init(x: 0,
                                                            y: 25,
                                                             width: kwindow_width,
                                                            height:  kwindow_width*6/7),
                                                collectionViewLayout: flowLayout)
        view.backgroundColor = UIColor.white
        view.dataSource = self
        view.delegate = self
        view.isScrollEnabled = true
        view.isPagingEnabled = true
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.registerCell(WHCalendarMonthView.self)
        return view
    }()
    
}

extension WHCalendarView: UICollectionViewDelegate,UICollectionViewDataSource,WHCalendarMonthViewDelegate {
    public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1
    }
            
    //MARK：最多显示80年，12个月
    public func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (calendarEndYear - calendarStartYear)*12
    }
    
    public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueCell(indexPath) as WHCalendarMonthView
        let beginMonthStr = "\(calendarStartYear)-01"
        if let beginMonth = beginMonthStr.toDate("yyyy-MM",region: .ISO){
           let yearMonthStr = beginMonth.dateByAdding(indexPath.section, .month).toString(DateToStringStyles.custom("yyyy-MM"))
            var arr = WHCalendarUtils.getDefaultMonthArr(str: yearMonthStr)
            if let periodDates = self.periodDates[indexPath.section] {
                for item in periodDates {
                    arr[item.key].periodType = item.value
                }
            }
            cell.setInfo(dates: arr,selectedIndex:indexPath.section == self.currentSection ? self.getSelectedIndex() : nil)
            cell.monthDelegate = self
        }
        return cell
    }
    
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        let section = Int(scrollView.contentOffset.x/self.bounds.size.width)
        sectionShowed(section: section)
        self.mainView.isUserInteractionEnabled = true
    }
    
    public func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDragging")
        self.mainView.isUserInteractionEnabled = false
    }
    
    public func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        print("scrollViewWillBeginDecelerating")
        self.mainView.isUserInteractionEnabled = false
    }
    
    func calendarDateSelected(date: WHPeriodDateInfo) {
        self.selectedDay = date.date?.day ?? Date().day
        self.calendarDelegate?.dateSelected(date: date)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        //使用方法 scrollToItem ，滑动停止后，会调用此方法
        let section = Int(scrollView.contentOffset.x/self.bounds.size.width)
        self.sectionShowed(section: section)
        self.mainView.isUserInteractionEnabled = true
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        self.mainView.isUserInteractionEnabled = true
    }
    
    func sectionShowed(section:Int) {
        self.currentSection = section
        self.calendarDelegate?.monthShowed(month: self.getCurrentMonth())
        if let cell = self.mainView.cellForItem(at: IndexPath.init(row: 0, section: section)) as? WHCalendarMonthView {
            cell.setSelected(index: getSelectedIndex())
        }
    }
    
    private func getSelectedIndex() -> Int {
        let selectedIndex = WHCalendarUtils.getDayIndex(month:self.getCurrentMonth(), day: self.selectedDay)
        return selectedIndex
    }
    
    private func getCurrentMonth() -> WHCalendarDate {
        let year = (self.currentSection)/12 + calendarStartYear
        let month = self.currentSection%12 + 1
        return WHCalendarDate.init(year: year, month: month)
    }
    
    
}



