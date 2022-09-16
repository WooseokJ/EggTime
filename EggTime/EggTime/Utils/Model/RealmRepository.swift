//
//  RealmRepository.swift
//  EggTime
//
//  Created by useok on 2022/09/12.
//

import Foundation
import RealmSwift

protocol RealmRepositoryType {
    func fetch() -> Results<EggTime>
    func stringToDate(string: String) -> Date
    func dateToString(date: Date) -> String 
    
    
}


class RealmRepository: RealmRepositoryType {
    
    let localRealm = try! Realm()
    
    
    
    
    func fetch() -> Results<EggTime> {
        return localRealm.objects(EggTime.self)
    }
    
    func deleteItem(item: EggTime) {
//        removeImageFromDocument(fileName: "\(item.objectId).jpg") //도큐먼트의 이미지 삭제 10
        try! localRealm.write{
            localRealm.delete(item) // 레코드 삭제
        }
    }
    
    // string -> date로 바꾸기
    func stringToDate(string: String) -> Date {
        let formattor = DateFormatter()
        formattor.locale = Locale(identifier: "ko_KR")
        formattor.timeZone = TimeZone(abbreviation: "KST")
        formattor.dateFormat = "yyyy-MM-dd hh:mm"
        return formattor.date(from: string) ?? Date()
    }
    
    // date -> string로 바꾸기
    func dateToString(date: Date) -> String {
        let formattor = DateFormatter()
        formattor.locale = Locale(identifier: "ko_KR")
        formattor.timeZone = TimeZone(abbreviation: "KST")
        formattor.dateFormat = "yyyy-MM-dd hh:mm"
        return formattor.string(from: date) 
    }
    
    
}
