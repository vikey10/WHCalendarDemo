//
//  WHYearCalendarView.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/20.
//

import Foundation
import UIKit

class WHYearCalendarViewController: UIViewController {
    
    var finishBlock: ((WHCalendarDate)->Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.addSubview(self.mainView)
    }
    
    lazy var mainView: UICollectionView = {
        let layout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        let view = UICollectionView.init(frame: self.view.bounds, collectionViewLayout: layout)
        view.delegate = self
        view.dataSource = self
        view.registerCell(WHYearCalendarHeaderView.self)
        view.registerCell(WHYearCelandarMonthView.self)
        view.backgroundColor = UIColor.white
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        let indexPath = IndexPath.init(row: 0, section: (Date().year - config.calendarStartYear))
        view.selectItem(at: indexPath, animated: true, scrollPosition: .top)
        return view
    }()
    
    private var config: WHCalendarConfig = .shared
    private var currentMonth = WHCalendarDate.init(year: Date().year, month: Date().month)
    convenience init(calendarConfig:WHCalendarConfig = .shared,currentDate:WHCalendarDate = WHCalendarDate.init(year: Date().year, month: Date().month)) {
        self.init()
        self.config = config
        self.currentMonth = currentDate
    }
    
}

extension WHYearCalendarViewController: UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return (self.config.calendarEndYear - self.config.calendarStartYear)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row == 0 {
            //title
            let cell = collectionView.dequeueCell(indexPath) as WHYearCalendarHeaderView
            cell.setInfo(year: config.calendarStartYear+indexPath.section)
            return cell
        } else {
            //月份日期
            let cell = collectionView.dequeueCell(indexPath) as WHYearCelandarMonthView
            let year = config.calendarStartYear+indexPath.section
            let month = indexPath.row
            cell.setInfo(WHCalendarUtils.getDefaultMonthArr(str: "\(year)-" + WHCalendarUtils.formatDay(number: month)),month: month)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if indexPath.row == 0 {
            //title
            return CGSize.init(width: kwindow_width, height: 40)
        } else {
            //月份日期
            return CGSize.init(width: kwindow_width/3, height: (kwindow_height - 40 - navigationBarHeight - statusHeight)/4)
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 13
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let year = config.calendarStartYear+indexPath.section
        let month = indexPath.row
        self.finishBlock?(WHCalendarDate.init(year: year, month: month))
        self.navigationController?.popViewController(animated: true)
    }
    
}
