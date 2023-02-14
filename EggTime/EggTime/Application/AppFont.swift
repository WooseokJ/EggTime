//
//  Font.swift
//  EggTime
//
//  Created by useok on 2022/09/27.
//

import Foundation
import UIKit



enum AppFont {
    static var fontName = "SUIT-Medium"
    enum font {
        static let name = UIFont(name: AppFont.fontName, size: 14.0)
        static let title = UIFont(name: AppFont.fontName, size: 16.0)
        static let time = UIFont(name:  AppFont.fontName, size: 50.0)
        static let mapTime = UIFont(name:  AppFont.fontName, size: 24.0)
        static let noEgg = UIFont(name: AppFont.fontName, size: 20.0)

    }
}
