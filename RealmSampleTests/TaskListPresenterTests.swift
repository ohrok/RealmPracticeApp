//
//  TaskListPresenterTests.swift
//  RealmSampleTests
//
//  Created by 大井裕貴 on 2021/09/17.
//

import XCTest
@testable import RealmSample

class TaskListPresenterOutputSpy: TaskListPresenterOutput {
    private(set) var countOfInvokingUpdateTask: Int = 0
    private(set) var countOfInvokingTransitionToTaskDetail: Int = 0
    private(set) var taskToEdit: Task?
    
    func updateTask(_ task: Task, forRowAt indexPath: IndexPath) {
        countOfInvokingUpdateTask += 1
    }
    
    func transitionToTaskDetail(taskToEdit: Task?) {
        countOfInvokingTransitionToTaskDetail += 1
        self.taskToEdit = taskToEdit
    }
}

class TaskListModelInputStub: TaskListModelInput {
    var tasks: [Task]
    
    init(tasks: [Task]) {
        self.tasks = tasks
    }
    
    func toggleTask(_ task: Task) {
        task.isChecked.toggle()
    }
    
    func deleteTask(_ task: Task) {
        let index = tasks.firstIndex(of: task)!
        tasks.remove(at: index)
    }
}

class TaskListPresenterTests: XCTestCase {

    override func setUp() {
    }

    override func tearDown() {
    }

    func testDidTapAddButton() {
        let spy = TaskListPresenterOutputSpy()
        let tasks = [Task.mock()]
        let stub = TaskListModelInputStub(tasks: tasks)
        let presenter = TaskListPresenter(view: spy, model: stub)
        presenter.didTapAddButton()
        XCTAssertTrue(spy.countOfInvokingTransitionToTaskDetail == 1)
        XCTAssertNil(spy.taskToEdit)
    }
    
    func testDidTapCellButton() {
        let spy = TaskListPresenterOutputSpy()
        let tasks = [Task.mock()]
        let stub = TaskListModelInputStub(tasks: tasks)
        let presenter = TaskListPresenter(view: spy, model: stub)
        XCTAssertFalse(presenter.task(forRow: 0)!.isChecked)
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didTapCellButton(indexPath: indexPath)
        XCTAssertTrue(presenter.task(forRow: 0)!.isChecked)
        XCTAssertTrue(spy.countOfInvokingUpdateTask == 1)
    }
    
    func testDidSelectRow() {
        let spy = TaskListPresenterOutputSpy()
        let tasks = [Task.mock()]
        let stub = TaskListModelInputStub(tasks: tasks)
        let presenter = TaskListPresenter(view: spy, model: stub)
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.didSelectRow(at: indexPath)
        XCTAssertTrue(spy.countOfInvokingTransitionToTaskDetail == 1)
        XCTAssertNotNil(spy.taskToEdit)
    }
    
    func testCommitDeleteForRow() {
        let spy = TaskListPresenterOutputSpy()
        let tasks = [Task.mock()]
        let stub = TaskListModelInputStub(tasks: tasks)
        let presenter = TaskListPresenter(view: spy, model: stub)
        XCTAssertTrue(presenter.numberOfTasks == 1)
        let indexPath = IndexPath(row: 0, section: 0)
        presenter.commitDeleteForRow(at: indexPath)
        XCTAssertTrue(presenter.numberOfTasks == 0)
    }
}
