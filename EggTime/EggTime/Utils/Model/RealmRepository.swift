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
    func nearTimeFetch() -> Results<EggTime> {
        return localRealm.objects(EggTime.self).filter("openDate >= %@", Date()).sorted(byKeyPath: "openDate", ascending: true)
    }
    
    func deleteItem(item: Results<EggTime>) {
        try! localRealm.write{
            localRealm.delete(item) // 레코드 삭제
        }
    }
    
    lazy var tasks: Results<EggTime>! = self.fetch()

    
    // string -> date로 바꾸기
    func stringToDate(string: String) -> Date {
        let formattor = DateFormatter()
        formattor.locale = Locale(identifier: "ko_KR")
        formattor.timeZone = TimeZone(abbreviation: "KST")
        formattor.dateFormat = "yyyy-MM-dd"
        return formattor.date(from: string) ?? Date()
    }
    
    // date -> string로 바꾸기
    func dateToString(date: Date) -> String {
        let formattor = DateFormatter()
        formattor.locale = Locale(identifier: "ko_KR")
        formattor.timeZone = TimeZone(abbreviation: "KST")
        formattor.dateFormat = "yyyy-MM-dd"
        return formattor.string(from: date) 
    }
    
    
}
