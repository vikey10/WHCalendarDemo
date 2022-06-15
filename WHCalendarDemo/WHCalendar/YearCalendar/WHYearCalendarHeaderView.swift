//
//  WHCalendarHeaderView.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/13.
//

import Foundation
import UIKit

class WHYearCalendarHeaderView: UICollectionViewCell {
    
    private var year: Int = Date().year
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.contentView.addSubview(self.yearLB)
        self.contentView.addSubview(self.bottomLine)
    }
    
    
    func setInfo(year:Int) {
        self.yearLB.text = "\(year)年"
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    lazy var yearLB: UILabel = {
        let lb = UILabel.init(frame: CGRect.init(x: 15, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        lb.font = UIFont.boldSystemFont(ofSize: 26)
        lb.textColor = .black
        lb.textAlignment = .left
        return lb
    }()
    
    lazy var bottomLine: UIView = {
        let view = UIView.init(frame: CGRect.init(x: 0, y: self.bounds.size.height - 1, width: self.bounds.size.width, height: 0.5))
        view.backgroundColor = UIColor.lightGray
        return view
    }()
    
    
}
