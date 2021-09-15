//
//  Task.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import RealmSwift

class Task: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String = ""
    @Persisted var isChecked: Bool = false
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
