//
//  View.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation
import UIKit

extension UIButton {
    func roundCorners(cornerRadius: CGFloat, maskedCorners: CACornerMask) {
        clipsToBounds = true
        layer.cornerRadius = cornerRadius
        layer.maskedCorners = CACornerMask(arrayLiteral: maskedCorners)
    }
}
