//
//  TaskListPresenter.swift
//  RealmSample
//
//  Created by 大井裕貴 on 2021/09/13.
//

import Foundation

protocol TaskListPresenterInput {
    var numberOfTasks: Int { get }
    func task(forRow row: Int) -> Task?
    func row(of task: Task) -> Int?
    func didTapAddButton()
    func didTapCellButton(indexPath: IndexPath)
    func didSelectRow(at indexPath: IndexPath)
    func commitDeleteForRow(at indexPath: IndexPath)
}

protocol TaskListPresenterOutput: AnyObject {
    func updateTask(_ task: Task, forRowAt indexPath: IndexPath)
    func transitionToTaskDetail(taskToEdit: Task?)
}

final class TaskListPresenter: TaskListPresenterInput {
    private var tasks: [Task] {
        return model.tasks
    }
    
    private weak var view: TaskListPresenterOutput!
    private var model: TaskListModelInput
    
    init(view: TaskListPresenterOutput, model: TaskListModelInput) {
        self.view = view
        self.model = model
    }
    
    var numberOfTasks: Int {
        return tasks.count
    }
    
    func task(forRow row: Int) -> Task? {
        guard row < tasks.count else { return nil }
        return tasks[row]
    }
    
    func row(of task: Task) -> Int? {
        return tasks.firstIndex(of: task)
    }
    
    func didTapAddButton() {
        view.transitionToTaskDetail(taskToEdit: nil)
    }
    
    func didTapCellButton(indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        let task = tasks[indexPath.row]
        model.toggleTask(task)
        view.updateTask(task, forRowAt: indexPath)
    }
    
    func didSelectRow(at indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        let task = tasks[indexPath.row]
        view.transitionToTaskDetail(taskToEdit: task)
    }
    
    func commitDeleteForRow(at indexPath: IndexPath) {
        guard indexPath.row < tasks.count else { return }
        let task = tasks[indexPath.row]
        model.deleteTask(task)
    }
}
