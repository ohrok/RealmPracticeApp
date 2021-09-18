//
//  TaskCell.swift
//  RealmPracticeApp
//
//  Created by 大井裕貴 on 2021/08/13.
//

import UIKit
import RealmSwift

protocol TaskCellDelegate: AnyObject {
    func didTapButton(cell: TaskCell)
}

class TaskCell: UITableViewCell {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var button: UIButton!
    weak var delegate: TaskCellDelegate?
    
    func configure(for task: Task) {
        label.text = task.name
        let largeConfig = UIImage.SymbolConfiguration(scale: .large)
        let image = UIImage(systemName: task.isChecked ? "checkmark.circle.fill" : "circle.fill", withConfiguration: largeConfig)
        button.setImage(image, for: .normal)
    }
    
    @IBAction func buttonTapped() {
        delegate?.didTapButton(cell: self)
    }
}
