//
//  TaskListModel.swift
//  RealmSample
//
//  Created by 大井裕貴 on 2021/09/13.
//

import Foundation
import RealmSwift

protocol TaskListModelInput {
    var tasks: [Task] { get }
    func toggleTask(_ task: Task)
    func deleteTask(_ task: Task)
}

final class TaskListModel: TaskListModelInput {
    private let localRealm = try! Realm()
    
    var tasks: [Task] {
        return Array(localRealm.objects(Task.self))
    }
    
    func toggleTask(_ task: Task) {
        try! localRealm.write {
            task.isChecked.toggle()
        }
    }
    
    func deleteTask(_ task: Task) {
        try! localRealm.write {
            localRealm.delete(task)
        }
    }
}
