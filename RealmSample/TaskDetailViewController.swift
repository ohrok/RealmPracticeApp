//
//  TaskDetailViewController.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import UIKit
import RealmSwift

protocol TaskDetailViewControllerDelegate: AnyObject {
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingAdding task: Task)
    func taskDetailViewController(_ controller: TaskDetailViewController, didFinishingEditing task: Task)
}

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: TaskDetailViewControllerDelegate?
    var idToEdit: ObjectId?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let idToEdit = idToEdit {
            self.title = "Edit"
            let localRealm = try! Realm()
            let task = localRealm.object(ofType: Task.self, forPrimaryKey: idToEdit)!
            textField.text = task.name
        } else {
            self.title = "Add"
            doneButton.isEnabled = false
            doneButton.backgroundColor = .systemGray
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonPushed() {
        guard let name = textField.text else {
            return
        }
        
        let localRealm = try! Realm()
        
        guard let idToEdit = idToEdit else {
            let task = Task(name: name)
            try! localRealm.write {
                localRealm.add(task)
            }
            delegate?.taskDetailViewController(self, didFinishingAdding: task)
            return
        }
        
        let editToTask = localRealm.object(ofType: Task.self, forPrimaryKey: idToEdit)!
        try! localRealm.write {
            editToTask.name = name
        }
        delegate?.taskDetailViewController(self, didFinishingEditing: editToTask)
    }
    
    @IBAction func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        doneButton.isEnabled = !text.isEmpty
        doneButton.backgroundColor = text.isEmpty ? .systemGray : .systemBlue
    }
}
