//
//  UIView+Extension.swift
//  StoriesPlayer
//
//  Created by Ingvarr Alef on 30.04.2023.
//

import UIKit

extension UIView {
    
    func addMultipleSubviews(with subviews: [UIView?]) {
        subviews.compactMap {$0}.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false;
            addSubview($0)
        }
    }
    
    func addTapTouch(_ target: AnyObject, action: Selector) {
        isUserInteractionEnabled = true

        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: target, action: action)
        tap.numberOfTapsRequired = 1
        addGestureRecognizer(tap)
    }
}
