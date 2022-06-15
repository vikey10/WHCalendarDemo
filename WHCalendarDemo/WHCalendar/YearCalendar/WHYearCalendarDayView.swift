//
//  WHCalendarDayView.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/12.
//

import UIKit


class WHYearCalendarDayView: UICollectionViewCell {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.configUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configUI() {
        self.addSubview(self.numberLB)
    }
    
    
    lazy var numberLB: UILabel = {
        let lb = UILabel.init(frame: self.bounds)
        lb.center = self.center
        lb.font = UIFont.systemFont(ofSize: 12)
        lb.textAlignment = .center
        return lb
    }()
    
    func prepareData(num: String,isToday:Bool,color:UIColor) {
        if isToday {
            self.numberLB.text = "今"
        } else {
            self.numberLB.text = num
        }
        self.numberLB.textColor = color
    }
}
