//
//  TaskListViewController.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import UIKit

final class TaskListViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    private var presenter: TaskListPresenterInput!
    
    func inject(presenter: TaskListPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    private func setup() {
        self.title = "Tasks"
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 50
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonTapped() {
        presenter.didTapAddButton()
    }
}

extension TaskListViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        presenter.didSelectRow(at: indexPath)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        presenter.commitDeleteForRow(at: indexPath)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension TaskListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.numberOfTasks
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        if let task = presenter.task(forRow: indexPath.row) {
            cell.configure(for: task)
        }
        cell.delegate = self
        return cell
    }
}

extension TaskListViewController: TaskCellDelegate {
    func didTapButton(cell: TaskCell) {
        let indexPath = tableView.indexPath(for: cell)!
        presenter.didTapCellButton(indexPath: indexPath)
    }
}

extension TaskListViewController: TaskDetailViewControllerDelegate {
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingAdding task: Task) {
        let indexPath = IndexPath(row: presenter.numberOfTasks - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.navigationController?.popViewController(animated: true)
    }
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingEditing task: Task) {
        let row = presenter.row(of: task)!
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.configure(for: task)
        }
        self.navigationController?.popViewController(animated: true)
    }
}

extension TaskListViewController: TaskListPresenterOutput {
    func updateTask(_ task: Task, forRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.configure(for: task)
        }
    }
    
    func transitionToTaskDetail(taskToEdit: Task?) {
        let taskDetailViewController = UIStoryboard(name: "TaskDetail", bundle: nil).instantiateInitialViewController() as! TaskDetailViewController
        let model = TaskDetailModel()
        let presenter = TaskDetailPresenter(view: taskDetailViewController, model: model, taskToEdit: taskToEdit)
        taskDetailViewController.inject(presenter: presenter, delegate: self)
        self.navigationController?.pushViewController(taskDetailViewController, animated: true)
    }
}
