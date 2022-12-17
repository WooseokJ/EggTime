////
////  TapBarCase.swift
////  EggTime
////
////  Created by useok on 2022/11/06.
////
//
//import UIKit
//
//enum TabBarCase: , CaseIterable {
//
//    case a,b,c
//
//    init?(rawValue: String) {
//        switch rawValue {
//
//        }
//    }
//
//
//}
//
//
//enum TabBarPageCase: String, CaseIterable {
//    case home, sesacshop, mypage
//
//    init?(index: Int) {
//        switch index {
//        case 0: self = .home
//        case 1: self = .sesacshop
//        case 2: self = .mypage
//        default: return nil
//        }
//    }
//
//    var pageOrderNumber: Int {
//        switch self {
//        case .home: return 0
//        case .sesacshop: return 1
//        case .mypage: return 2
//        }
//    }
//
//    var pageTitle: String {
//        switch self {
//        case .home:
//            return "홈"
//        case .sesacshop:
//            return "새싹샵"
//        case .mypage:
//            return "내정보"
//        }
//    }
//
//    func tabIconName() -> String {
//        return self.rawValue
//    }
//}
