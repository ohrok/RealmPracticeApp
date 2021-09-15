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

final class TaskDetailViewController: UIViewController {
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIButton!
    
    weak var delegate: TaskDetailViewControllerDelegate?
    private var presenter: TaskDetailPresenterInput!
    
    func inject(presenter: TaskDetailPresenterInput) {
        self.presenter = presenter
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @IBAction func doneButtonTapped() {
        presenter.didTapDoneButton(text: textField.text)
    }
    
    @IBAction func editingChanged(_ textField: UITextField) {
        guard let text = textField.text else {
            return
        }
        doneButton.isEnabled = !text.isEmpty
        doneButton.backgroundColor = text.isEmpty ? .systemGray : .systemBlue
    }
}

extension TaskDetailViewController: TaskDetailPresenterOutput {
    func setupEditMode(task: Task) {
        self.title = "Edit"
        textField.text = task.name
    }
    
    func setupAddMode() {
        self.title = "Add"
        doneButton.isEnabled = false
        doneButton.backgroundColor = .systemGray
    }
    
    func editTask(_ task: Task) {
        delegate?.taskDetailViewController(self, didFinishingEditing: task)
    }
    
    func addTask(_ task: Task) {
        delegate?.taskDetailViewController(self, didFinishingAdding: task)
    }
}
