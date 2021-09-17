//
//  TaskDetailPresenterTest.swift
//  RealmSampleTests
//
//  Created by 大井裕貴 on 2021/09/17.
//

import XCTest
@testable import RealmSample

class TaskDetailPresenterOutputSpy: TaskDetailPresenterOutput {
    private(set) var countOfInvokingSetupAddMode: Int = 0
    private(set) var countOfInvokingSetupEditMode: Int = 0
    private(set) var countOfInvokingAddTaskToList: Int = 0
    private(set) var countOfInvokingEditTaskInList: Int = 0
    private(set) var countOfInvokingEnableDoneButton: Int = 0
    private(set) var countOfInvokingDisableDoneButton: Int = 0
    
    private(set) var taskOfSetupEditMode: Task?
    private(set) var taskOfAddTaskToList: Task?
    private(set) var taskOfEditTaskInList: Task?
    
    func setupAddMode() {
        countOfInvokingSetupAddMode += 1
    }
    
    func setupEditMode(task: Task) {
        countOfInvokingSetupEditMode += 1
        taskOfSetupEditMode = task
    }
    
    func addTaskToList(_ task: Task) {
        countOfInvokingAddTaskToList += 1
        taskOfAddTaskToList = task
    }
    
    func editTaskInList(_ task: Task) {
        countOfInvokingEditTaskInList += 1
        taskOfEditTaskInList = task
    }
    
    func enableDoneButton() {
        countOfInvokingEnableDoneButton += 1
    }
    
    func disableDoneButton() {
        countOfInvokingDisableDoneButton += 1
    }
}

class TaskDetailModelInputStub: TaskDetailModelInput {
    func addTask(_ task: Task) {
    }
    
    func editTaskName(task: Task, name: String) {
        task.name = name
    }
}


class TaskDetailPresenterTest: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testViewDidLoad() {
        XCTContext.runActivity(named: "ViewDidLoad") { _ in
            XCTContext.runActivity(named: "Add Mode") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: nil)
                presenter.viewDidLoad()
                XCTAssertTrue(spy.countOfInvokingSetupAddMode == 1)
            }
            
            XCTContext.runActivity(named: "Edit Mode") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let task = Task.mock()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: task)
                presenter.viewDidLoad()
                XCTAssertTrue(spy.countOfInvokingSetupEditMode == 1)
                XCTAssertTrue(spy.taskOfSetupEditMode! == task)
            }
        }
    }
    
    func testDidTapDoneButton() {
        XCTContext.runActivity(named: "DidTapDoneButton") { _ in
            XCTContext.runActivity(named: "Add Mode") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: nil)
                let text = "text"
                presenter.didTapDoneButton(text: text)
                XCTAssertTrue(spy.countOfInvokingAddTaskToList == 1)
                XCTAssertTrue(spy.taskOfAddTaskToList!.name == text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
            
            XCTContext.runActivity(named: "Edit Mode") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let task = Task.mock()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: task)
                let text = "text"
                presenter.didTapDoneButton(text: text)
                XCTAssertTrue(spy.countOfInvokingEditTaskInList == 1)
                XCTAssertTrue(spy.taskOfEditTaskInList!.name == text.trimmingCharacters(in: .whitespacesAndNewlines))
            }
        }
    }
    
    func testEditingChangedTextField() {
        XCTContext.runActivity(named: "EditingChangedTextField") { _ in
            XCTContext.runActivity(named: "Trimmed text is empty") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: nil)
                let text = " \n "
                presenter.editingChangedTextField(text: text)
                XCTAssertTrue(spy.countOfInvokingDisableDoneButton == 1)
            }
            
            XCTContext.runActivity(named: "Trimmed text is not empty") { _ in
                let spy = TaskDetailPresenterOutputSpy()
                let stub = TaskDetailModelInputStub()
                let task = Task.mock()
                let presenter = TaskDetailPresenter(view: spy, model: stub, taskToEdit: task)
                let text = "text"
                presenter.editingChangedTextField(text: text)
                XCTAssertTrue(spy.countOfInvokingEnableDoneButton == 1)
            }
        }
    }
}
