//
//  TableViewCell.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Ke4a on 23.01.2024.
//

import UIKit


class TableViewCell: UITableViewCell {

    static let id = "TableViewCell"

    var doneTask = false
    weak var delegate: TaskCellDelegate?

    @IBOutlet weak var titleLabel: UILabel!

    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var isDone: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureCell(title: String, descriptionText: String, isDone: Bool, image: String) {
        titleLabel.text = title
        descriptionLabel.text = descriptionText
        doneTask = isDone

    }

    @IBAction func donePressed(_ sender: Any) {
        let newImage = UIImage(systemName: doneTask ? "circle" : "checkmark.circle")
            isDone.setImage(newImage, for: .normal)
            doneTask.toggle()
            delegate?.taskCellDidToggleDone(for: self)
    }
}
