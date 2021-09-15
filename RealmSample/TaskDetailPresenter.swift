//
//  TaskDetailPresenter.swift
//  RealmSample
//
//  Created by 大井裕貴 on 2021/09/15.
//

import Foundation

protocol TaskDetailPresenterInput {
    func viewDidLoad()
    func didTapDoneButton(text: String?)
}

protocol TaskDetailPresenterOutput: AnyObject {
    func setupEditMode(task: Task)
    func setupAddMode()
    func editTask(_ task: Task)
    func addTask(_ task: Task)
}

final class TaskDetailPresenter: TaskDetailPresenterInput {
    private(set) var taskToEdit: Task?
    private weak var view: TaskDetailPresenterOutput!
    private var model: TaskDetailModelInput
    
    init(view: TaskDetailPresenterOutput, model: TaskDetailModelInput, taskToEdit: Task?) {
        self.view = view
        self.model = model
        self.taskToEdit = taskToEdit
    }
    
    func viewDidLoad() {
        if let task = taskToEdit {
            view.setupEditMode(task: task)
        } else {
            view.setupAddMode()
        }
    }
    
    func didTapDoneButton(text: String?) {
        guard let taskName = text else { return }
        
        if let task = taskToEdit {
            model.editTaskName(task: task, name: taskName)
            view.editTask(task)
        } else {
            let task = Task(name: taskName)
            model.addTask(task)
            view.addTask(task)
        }
    }
}
