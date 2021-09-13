//
//  TaskListModel.swift
//  RealmSample
//
//  Created by 大井裕貴 on 2021/09/13.
//

import Foundation
import RealmSwift

protocol TaskListModelInput {
    func fetchTasks() -> Results<Task>
    func toggleTask(_ task: Task)
    func deleteTask(_ task: Task)
}

final class TaskListModel: TaskListModelInput {
    private let localRealm = try! Realm()
    
    func fetchTasks() -> Results<Task> {
        return localRealm.objects(Task.self)
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
    
    private func addDummyTask() {
        ["Running",
         "Meeting",
         "Programming",
         "Make dinner",
         "Write a diary"
        ].forEach { name in
            try! localRealm.write{
                localRealm.add(Task(name: name))
            }
        }
    }
}
