//
//  UIViewController+Extension.swift
//  EggTime
//
//  Created by useok on 2022/09/14.
//

import Foundation
import UIKit

extension UIViewController {
    func documentDirectoryPath() -> URL? {
        guard let documentDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first else { return nil} //Document 경로
        return documentDirectory
    }
}
