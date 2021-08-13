//
//  TasksViewController.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import UIKit
import RealmSwift

class TasksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private var tasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tasks"
        
        let localRealm = try! Realm()
        tasks = localRealm.objects(Task.self)
        
        if tasks.count == 0 {
            addDummyTask()
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 44
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonTapped() {
        let storybord = UIStoryboard(name: "TaskDetail", bundle: nil)
        let vc = storybord.instantiateViewController(identifier: "TaskDetail") as! TaskDetailViewController
        vc.delegate = self
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    private func addDummyTask() {
        let localRealm = try! Realm()
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

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storybord = UIStoryboard(name: "TaskDetail", bundle: nil)
        let vc = storybord.instantiateViewController(identifier: "TaskDetail") as! TaskDetailViewController
        vc.delegate = self
        vc.idToEdit = tasks[indexPath.row]._id
        self.navigationController?.pushViewController(vc, animated: true)
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let task = tasks[indexPath.row]
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.delete(task)
        }
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! TaskCell
        cell.configure(for: tasks[indexPath.row])
        return cell
    }
}

extension TasksViewController: TaskDetailViewControllerDelegate {
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingAdding task: Task) {
        let indexPath = IndexPath(row: tasks.count - 1, section: 0)
        tableView.insertRows(at: [indexPath], with: .automatic)
        self.navigationController?.popViewController(animated: true)
    }
    
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingEditing task: Task) {
        let row = tasks.firstIndex(of: task)!
        let indexPath = IndexPath(row: row, section: 0)
        if let cell = tableView.cellForRow(at: indexPath) as? TaskCell {
            cell.configure(for: tasks[indexPath.row])
        }
        self.navigationController?.popViewController(animated: true)
    }
}
