//
//  SettingEnum.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation


enum Setting: CaseIterable {
    
    case content
    var list: [String] {
        switch self{
        case .content:
            return ["백업/복구하기","사용법","Open License","버전확인","리뷰쓰기"]
        }
    }
    
}
