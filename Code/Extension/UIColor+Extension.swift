//
//  UIColor+Extension.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 10/08/2024.
//

import UIKit

extension UIColor {
    
    class func rgba(_ value: UInt32) -> UIColor {
        let r: CGFloat = CGFloat((value & 0xFF000000) >> 24)
        let g: CGFloat = CGFloat((value & 0x00FF0000) >> 16)
        let b: CGFloat = CGFloat((value & 0x0000FF00) >> 8)
        let a: CGFloat = CGFloat(value & 0x000000FF)

        return UIColor(red: r / 0xFF, green: g / 0xFF, blue: b / 0xFF, alpha: a / 0xFF)
    }
}
