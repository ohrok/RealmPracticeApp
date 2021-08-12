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
}

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    var delegate: TaskDetailViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonPushed() {
        guard  let name = textField.text else {
            return
        }
        let task = Task(name: name)
        let localRealm = try! Realm()
        try! localRealm.write {
            localRealm.add(task)
        }
        delegate?.taskDetailViewController(self, didFinishingAdding: task)
    }
}
