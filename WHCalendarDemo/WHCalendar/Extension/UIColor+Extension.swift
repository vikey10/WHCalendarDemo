//
//  UIColor+Extension.swift
//  WHCalendar
//
//  Created by 王红 on 2022/5/12.
//

import UIKit

extension UIColor {
    convenience init(hex: UInt) {
        let r = CGFloat((hex & 0xFF0000) >> 16) / 255.0
        let g = CGFloat((hex & 0x00FF00) >> 8)/255.0
        let b = CGFloat((hex & 0x0000FF))/255.0
        self.init(red: r, green: g, blue: b, alpha: 1)
    }
    
    func image() -> UIImage {
        let rect = CGRect.init(x: 0.0, y: 0.0, width: 1.0, height: 1.0)
        UIGraphicsBeginImageContext(rect.size)
        let context: CGContext = UIGraphicsGetCurrentContext()!
        context.setFillColor(self.cgColor)
        context.fill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}
