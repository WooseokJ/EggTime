//
//  CustomLabel.swift
//  EggTime
//
//  Created by useok on 2023/01/02.
//

import UIKit

enum labelType {
    case nameLabel
    case titleLabel
    case lageLabel
    case noEggTimeLabel
}

class CustomLabel: UILabel {
    
    convenience init(frame: CGRect = .zero, title: String = "", type: labelType)
    
    {
        self.init(frame: frame)

        switch type {
        case .nameLabel:
            text = title
            textColor = .white
            font = AppFont.font.name
            textAlignment = .center
            numberOfLines = 0
            backgroundColor = .clear
            isHidden = true
            
            
        case .titleLabel:
            text = title
            textColor = .white
            font = AppFont.font.title
            textAlignment = .center
            numberOfLines = 0
            backgroundColor = .clear
            isHidden = true
            
        case .lageLabel:
            textColor = .white
            font = AppFont.font.time
            textAlignment = .center
            numberOfLines = 0
            backgroundColor = .clear
            isHidden = true
        case .noEggTimeLabel:
            text = title
            textColor = .white
            font = AppFont.font.noEgg
            textAlignment = .center
            numberOfLines = 0
            backgroundColor = .clear
            isHidden = true
        }
    }
}

