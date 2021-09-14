//
//  TaskListViewController.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import UIKit

class TaskListViewController: UIViewController {
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
    
    @objc func cellButtonTapped(_ button: UIButton) {
        let indexPath = IndexPath(row: button.tag, section: 0)
        presenter.didTapCellButton(indexPath: indexPath)
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
        cell.button.tag = indexPath.row
        cell.button.addTarget(self, action: #selector(cellButtonTapped(_:)), for: .touchUpInside)
        return cell
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
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell,
           let task = presenter.task(forRow: row) {
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
        let storybord = UIStoryboard(name: "TaskDetail", bundle: nil)
        let vc = storybord.instantiateViewController(identifier: "TaskDetail") as! TaskDetailViewController
        vc.delegate = self
        vc.idToEdit = taskToEdit?._id
        self.navigationController?.pushViewController(vc, animated: true)
    }
}
