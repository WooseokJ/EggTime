//
//  RealmModel.swift
//  EggTime
//
//  Created by useok on 2022/09/12.
//

import Foundation
import RealmSwift

class RealmModel: Object {
    @Persisted var title: String //제목
    @Persisted var regDate: Date //등록일
    @Persisted var openDate: Date //오픈일
    @Persisted var content: String //내용

    

    
    @Persisted var imageList = List<String>()
    
    @Persisted(primaryKey: true)  var objectId: ObjectId // 객체 id
    
    convenience init(title: String,regDate: Date ,openDate: Date, content: String, imageString: [String]) {
        self.init()
        self.title = title
        self.regDate = regDate
        self.openDate = openDate
        self.content = content
        
        imageString.map {
            self.imageList.append($0)
        }
        
        
        
        
    }
}

