//
//  TaskDetailModel.swift
//  RealmSample
//
//  Created by 大井裕貴 on 2021/09/15.
//

import Foundation
import RealmSwift

protocol TaskDetailModelInput {
    func addTask(_ task: Task)
    func editTaskName(task: Task, name: String)
}

final class TaskDetailModel: TaskDetailModelInput {
    private let localRealm = try! Realm()
    
    func addTask(_ task: Task) {
        try! localRealm.write {
            localRealm.add(task)
        }
    }
    
    func editTaskName(task: Task, name: String) {
        try! localRealm.write {
            task.name = name
        }
    }
}
