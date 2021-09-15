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
    func editingChangedTextField(text: String?)
}

protocol TaskDetailPresenterOutput: AnyObject {
    func setupAddMode()
    func setupEditMode(task: Task)
    func addTask(_ task: Task)  // FIXME: ideal name
    func editTask(_ task: Task) // FIXME: ideal name
    func enableDoneButton()
    func disableDoneButton()
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
    
    func editingChangedTextField(text: String?) {
        guard let text = text else { return }
        if text.isEmpty {
            view.disableDoneButton()
        } else {
            view.enableDoneButton()
        }
    }
}
