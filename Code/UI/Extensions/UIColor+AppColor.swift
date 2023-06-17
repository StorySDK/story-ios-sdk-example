//
//  UIColor+AppColor.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 11.06.2023.
//

import UIKit

extension UIColor {
    static func palette(_ name: Palette) -> UIColor {
        guard let color = UIColor(named: name.rawValue) else {
            print("Error: Color \(name.rawValue) not found in Palette")
            return .systemRed
        }
        return color
    }
    
    static var spBackground: UIColor { palette(.background) }
    static var spBlack: UIColor { palette(.black) }
    static var spDark2: UIColor { palette(.dark2) }
    static var spGray2: UIColor { palette(.gray2) }
    static var spRose: UIColor { palette(.rose) }
    static var spPrimary: UIColor { palette(.primary) }
    static var spLabelPrimary: UIColor { palette(.labelPrimary) }
    static var spTableBackground: UIColor { palette(.tableBackground) }
}
