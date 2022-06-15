//
//  WHYearCalendarMonthView.swift
//  WHCalendarDemo
//
//  Created by 王红 on 2022/5/20.
//

import Foundation
import UIKit

class WHYearCelandarMonthView: UICollectionViewCell {
    
    var itemsView = [UILabel]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.white
        self.contentView.addSubview(self.monthLB)
        self.contentView.addSubview(self.titleView)
        self.contentView.addSubview(self.mainView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var monthLB: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 10, y: 0, width: self.bounds.size.width, height: 20))
        lb.font = UIFont.boldSystemFont(ofSize: 14)
        lb.textColor = UIColor.black
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var titleView: UIView = {
        let height = (self.bounds.size.height - 20)/7
        let frame =  CGRect.init(x: 10, y: 20, width:self.bounds.size.width - 20 , height: height)
        let view = UIView.init(frame: frame)
        let titles = ["日","一","二","三","四","五","六"]
        let itemWidth = frame.size.width/7
        for index in 0..<titles.count {
            let frame = CGRect.init(x: CGFloat(index)*itemWidth, y: 0, width: itemWidth, height: height)
            let tagView = UILabel.init(frame: frame)
            tagView.text = titles[index]
            tagView.font = UIFont.systemFont(ofSize: 10)
            tagView.textAlignment = .center
            tagView.textColor = UIColor.darkGray
            view.addSubview(tagView)
        }
        return view
    }()
    
    lazy var mainView: UIView = {
        let height = (self.bounds.size.height - 20)/7
        let frame = CGRect.init(x: 10, y: 20+height, width:self.bounds.size.width - 20 , height: height*6)
        let view = UIView.init(frame:frame )
        let itemWidth = frame.size.width/7
        for index in 0..<42 {
            let frame = CGRect.init(x: CGFloat(index%7)*itemWidth, y: CGFloat(index/7)*height, width: itemWidth, height: height)
            let tagView = UILabel.init(frame: frame)
            tagView.font = UIFont.systemFont(ofSize: 10)
            tagView.textAlignment = .center
            tagView.textColor = UIColor.black
            self.itemsView.append(tagView)
            view.addSubview(tagView)
        }
        return view
    }()
    
    func setInfo(_ arr: [WHPeriodDateInfo],month:Int) {
        self.monthLB.text = "\(month)月"
        for index in 0..<42 {
            self.itemsView[index].text = arr[safe:index]?.displayNum ?? ""
        }
    }
                                            
}
