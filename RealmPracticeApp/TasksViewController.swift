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
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView()
    }
    
    @IBAction func addButtonTapped() {
        let storybord = UIStoryboard(name: "TaskDetail", bundle: nil)
        let vc = storybord.instantiateViewController(identifier: "TaskDetail") as! TaskDetailViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
}

extension TasksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

extension TasksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath)
        cell.textLabel?.text = tasks[indexPath.row].name
        return cell
    }
}
