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
    func addTaskToList(_ task: Task)  
    func editTaskInList(_ task: Task)
    func enableDoneButton()
    func disableDoneButton()
}

final class TaskDetailPresenter: TaskDetailPresenterInput {
    private let taskToEdit: Task?
    private weak var view: TaskDetailPresenterOutput!
    private let model: TaskDetailModelInput
    
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
        guard let text = text else { return }
        let taskName = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if let task = taskToEdit {
            model.editTaskName(task: task, name: taskName)
            view.editTaskInList(task)
        } else {
            let task = Task(name: taskName)
            model.addTask(task)
            view.addTaskToList(task)
        }
    }
    
    func editingChangedTextField(text: String?) {
        guard let text = text else { return }
        let trimmedText = text.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if trimmedText.isEmpty {
            view.disableDoneButton()
        } else {
            view.enableDoneButton()
        }
    }
}
