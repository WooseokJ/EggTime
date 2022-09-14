//
//  SettingEnum.swift
//  EggTime
//
//  Created by useok on 2022/09/11.
//

import Foundation


enum SettingContent: String,CaseIterable {
    case backup = "백업/복구"
    case appGuide = "앱 사용법"
    case appInfo = "앱 정보"
    var settingList : [String] {
        switch self {
        case .backup:
            return ["백업/복구하기"]
        case .appGuide:
            return ["사용법"]
        case .appInfo:
            return ["Open License","버전확인","리뷰쓰기"]
        }
    }
}
