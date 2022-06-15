//
//  WHCalendarMonthView.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/17.
//

import Foundation
import UIKit

protocol WHCalendarMonthViewDelegate: AnyObject {
    func calendarDateSelected(date: WHPeriodDateInfo)
}

class WHCalendarMonthView: UICollectionViewCell {
    private var dates = [WHPeriodDateInfo]()
    private var selectedIndex: Int?
    weak var monthDelegate: WHCalendarMonthViewDelegate?
    private var monthStr: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.collectionView)
    }
    
    lazy var collectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout.init()
        flowLayout.scrollDirection = .vertical
        let width = frame.size.width
        flowLayout.itemSize = CGSize.init(width: width/7, height: width/7)
        flowLayout.minimumLineSpacing = 0
        flowLayout.minimumInteritemSpacing = 0
        //最多6周
        let view = UICollectionView.init(frame: self.bounds, collectionViewLayout: flowLayout)
        view.delegate = self
        view.dataSource = self
        view.backgroundColor = UIColor.white
        view.isScrollEnabled = false
        view.isPagingEnabled = false
        view.alwaysBounceHorizontal = false
        view.alwaysBounceVertical = false
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.registerCell(WHPeriodDayView.self)
        return view
    }()
    
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    
    func setInfo(dates:[WHPeriodDateInfo],selectedIndex:Int?) {
        self.dates = dates
        self.selectedIndex = selectedIndex
        self.collectionView.reloadData()
    }
    
    func setSelected(index:Int?) {
        guard var currentIndex = index else{
            if let lastIndex = self.selectedIndex {
                self.collectionView.reloadItems(at: [IndexPath.init(row: lastIndex, section: 0)])
            }
            return
        }
        currentIndex = min(currentIndex,self.dates.count-1)
        guard self.selectedIndex != currentIndex else {return}
        var arr = [IndexPath.init(row: currentIndex, section: 0)]
        if let lastIndex = self.selectedIndex {
            arr.append(IndexPath.init(row: lastIndex, section: 0))
        }
        self.selectedIndex = currentIndex
        self.collectionView.reloadItems(at: arr)
    }
}

extension WHCalendarMonthView: UICollectionViewDataSource,UICollectionViewDelegate {
        public func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return self.dates.count
        }
        
        public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
            if let date = self.dates[safe: indexPath.row] {
                if date.isValidInfo {
                    guard self.selectedIndex != indexPath.row else{return}
                    self.monthDelegate?.calendarDateSelected(date: date)
                    var arr = [indexPath]
                    if let lastIndex = self.selectedIndex {
                        arr.append(IndexPath.init(row: lastIndex, section: 0))
                    }
                    self.selectedIndex = indexPath.row
                    collectionView.reloadItems(at: arr)
                }
            }
        }
        
        public func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueCell(indexPath) as WHPeriodDayView
            cell.empty()
            if let info = self.dates[safe: indexPath.row],
               info.isValidInfo {
                cell.prepareData(num: info.displayNum, isToday: info.isToday, dayType: info.periodType,isSelected:indexPath.row == self.selectedIndex)
                if indexPath.row == self.selectedIndex,
                    let date = self.dates[safe: indexPath.row],
                    date.isValidInfo {
                    self.monthDelegate?.calendarDateSelected(date: date)
                }
            } 
           return cell
        }
}
