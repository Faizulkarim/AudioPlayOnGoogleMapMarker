//
//  UIButton+Extension.swift
//  Technical Test Venturas
//
//  Created by Faizul Karim on 7/11/21.
//

import UIKit

extension UIButton {
    func roundCornersToBtn(corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        layer.mask = mask
    }
    
}
