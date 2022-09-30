//
//  PickerEnum.swift
//  EggTime
//
//  Created by useok on 2022/09/12.
//

import Foundation


enum Picker: String, CaseIterable {
    
    case afterOneday = "내일: "
    case afterThreeDay = "3일후: "
    case afterweek = "일주일후: "
    case afterTwoWeek = "이주일후: "
    case afterMonth = "한달후: "
    case afterTwoMonth = "두달후: "
    case afterThridMonth = "세달후: "
    case afterHalfMonth = "반년후: "
    case afterYear = "일년후: "
//    case userSelect = "사용자지정: "
    
    var pickerLisk: [String] {
        switch self {
        case .afterOneday:
            return [self.rawValue+datePicker(afterday: 1)]
//            return [Date(timeIntervalSinceNow: 86400 * 1)]
        case .afterThreeDay:
            return [self.rawValue+datePicker(afterday: 3)]
//            return [Date(timeIntervalSinceNow: 86400 * 3)]
        case .afterweek:
            return [self.rawValue+datePicker(afterday: 7)]
//            return [Date(timeIntervalSinceNow: 86400 * 7)]

        case .afterTwoWeek:
            return [self.rawValue+datePicker(afterday: 14)]
//            return [Date(timeIntervalSinceNow: 86400 * 14)]

        case .afterMonth :
            return [self.rawValue+datePicker(afterday: 31)]
//            return [Date(timeIntervalSinceNow: 86400 * 31)]


        case .afterTwoMonth:
            return [self.rawValue+datePicker(afterday: 60)]
        case .afterThridMonth:
            return [self.rawValue+datePicker(afterday: 90)]
        case .afterHalfMonth:
            return [self.rawValue+datePicker(afterday: 182)]
        case .afterYear:
            return [self.rawValue+datePicker(afterday: 365)]
//        case .userSelect:
//            return ["사용자입력"]
            }
    }
    
}

func datePicker(afterday: Int) -> String {
    let formattor = DateFormatter()
    formattor.locale = Locale(identifier: "ko_KR")
    formattor.timeZone = TimeZone(abbreviation: "KST")
    formattor.dateFormat = "yyyy-MM-dd"
    return formattor.string(from: Date(timeInterval: TimeInterval((86400 * afterday)), since: Date()))
}
