//
//  PickerEnum.swift
//  EggTime
//
//  Created by useok on 2022/09/12.
//

import Foundation


enum PickerEnum: String, CaseIterable {
    
    case afterOneday = "내일: "
    case afterThreeDay = "3일후: "
    case afterweek = "일주일후: "
    case afterTwoWeek = "이주일후: "
    case afterMonth = "한달후: "
    case userSelect = "사용자지정: "
    
    var pickerLisk: [String] {
        switch self {
        case .afterOneday:
            return [self.rawValue+datePicker(afterday: 1)]
        case .afterThreeDay:
            return [self.rawValue+datePicker(afterday: 3)]
        case .afterweek:
            return [self.rawValue+datePicker(afterday: 7)]
        case .afterTwoWeek:
            return [self.rawValue+datePicker(afterday: 14)]
        case .afterMonth :
            return [self.rawValue+datePicker(afterday: 30)]
        case .userSelect:
            return ["사용자지정"]
        }
    }
    
}

func datePicker(afterday: Int) -> String {
    let dateformattor = DateFormatter()
    dateformattor.dateFormat = "yyyy-MM-dd"
    return dateformattor.string(from: Date(timeInterval: TimeInterval((86400 * afterday)), since: Date()))
}
