//
//  TaskViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Игорь Пачкин on 19/1/24.
//

import UIKit

class TaskViewController: UIViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    
    @IBOutlet weak var deleteButton: UIButton!
    var dataManager = UserDefaultsManager.shared
    var isNew: Bool = true
    var task: ToDoList?
    var index: Int?

   
    
    var closeAction: (() -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()

        if isNew  {
            deleteButton.isHidden = true
        } else {
            deleteButton.isHidden = false
        }
      
        descriptionTextView.layer.borderWidth = 1.0 // Здесь 1.0 - это толщина бордера, вы можете установить любое значение

       // Установка цвета бордера
        descriptionTextView.layer.borderColor = UIColor(red: 236/255, green: 236/255, blue: 236/255, alpha: 1).cgColor
        
        descriptionTextView.layer.cornerRadius = 10.0
    }
    
    @IBAction func saveButton(_ sender: Any) {
        if self.isNew {
            UserDefaultsManager.shared.tasks.append(ToDoList(title: titleTextField.text ?? "Title", description: descriptionTextView.text ?? "Description", isDone: false))
            print(UserDefaultsManager.shared.tasks)
        } else {
            if let i = index {
                UserDefaultsManager.shared.tasks[i] = ToDoList(title: titleTextField.text!, description: descriptionTextView.text, isDone: task?.isDone ?? false)
            }
        }
        dataManager.refreshData()
        self.closeAction?()
        dismiss(animated: true)
    }
    @IBAction func cancelButton(_ sender: Any) {
        self.closeAction?()
        dismiss(animated: true)
    }

    @IBAction func deleteButton(_ sender: Any){
        if let i = index {
        dataManager.removeTask(index: i)
        self.closeAction?()
    }
    dismiss(animated: true)
}
}
