//
//  RealmModel.swift
//  EggTime
//
//  Created by useok on 2022/09/12.
//

import Foundation
import RealmSwift

class EggTime: Object {
    @Persisted var title: String //제목
    @Persisted var regDate: Date //등록일
    @Persisted var openDate: Date //오픈일
    @Persisted var content: String //내용
    @Persisted var latitude: Double?
    @Persisted var longitude: Double?
    
    
    @Persisted var imageList = List<String>()
    
    
    
    @Persisted(primaryKey: true)  var objectId: ObjectId // 객체 id
    
    convenience init(title: String,regDate: Date ,openDate: Date, content: String,latitude: Double, longitude: Double, imageStringArray: [String]) {
        self.init()
        self.title = title
        self.regDate = regDate
        self.openDate = openDate
        self.content = content
        self.latitude = latitude
        self.longitude = longitude
        
        imageStringArray.map {
            self.imageList.append($0)
        }
    }
}

