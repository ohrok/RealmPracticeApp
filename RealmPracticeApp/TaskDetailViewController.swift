//
//  TaskDetailViewController.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/09.
//

import UIKit

class TaskDetailViewController: UIViewController {
    
    @IBOutlet weak var textField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .done,
            target: self,
            action: #selector(doneButtonTapped)
        )
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    @objc func doneButtonTapped() {
        print("Done!")
    }
}
