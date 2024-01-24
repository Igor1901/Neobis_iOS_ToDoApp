//
//  ViewController.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Игорь Пачкин on 12/1/24.
//

import UIKit

protocol TaskCellDelegate: AnyObject {
    func taskCellDidToggleDone(for cell: TableViewCell)
}

class TableViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    

    var dataManager = UserDefaultsManager.shared
    var isNew = false
    var isEditingMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let nib = UINib(nibName: TableViewCell.id, bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: TableViewCell.id)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewIsAppearing(_ animated: Bool) {
        tableView.reloadData()
    }
    
    // button to change cells and delete
    @IBAction func editPressed(_ sender: Any) {
        tableView.isEditing = !isEditingMode
            let imageName = isEditingMode ? "pencil.circle.fill" : "x.circle.fill"
            editButton.setImage(UIImage(systemName: imageName), for: .normal)
            
            for cell in tableView.visibleCells {
                if let taskCell = cell as? TableViewCell {
                    taskCell.setEditingMode(!isEditingMode)
                }
            }
            
            isEditingMode.toggle()
    }
    
    // button to go to screen 2 to create tasks
    @IBAction func presentModalController(_ sender: UIButton) {
        let modalController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController

        modalController.closeAction = { [weak self] in
            self?.tableView.reloadData()
        }
        present(modalController, animated: true, completion: nil)
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    // I only have one section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    // checking the number of cells
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getCount()
    }
    // Adding data to a cell
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        cell.delegate = self
        cell.configureCell(title: dataManager.tasks[indexPath.row].title, descriptionText: dataManager.tasks[indexPath.row].description, isDone: dataManager.tasks[indexPath.row].isDone, image: (dataManager.tasks[indexPath.row].isDone ? "checkmark.circle" : "circle"))
        return cell
    }
    // clicking on a cell
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        isNew = false
        
        guard indexPath.row < dataManager.tasks.count else {
               // Обработка ситуации, когда индекс выходит за границы массива
               print("Index out of range")
               return
           }
           
        let task = dataManager.tasks[indexPath.row]
        
        let taskViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController
        taskViewController.task = task
        taskViewController.isNew = false
        taskViewController.index = indexPath.row
        taskViewController.closeAction = { [weak self] in
            self?.tableView.reloadData()
        }
        
        let navigationController = UINavigationController(rootViewController: taskViewController)
        taskViewController.modalPresentationStyle = .fullScreen
        present(navigationController, animated: true)
    }

    
    // Remove separato line
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.tasks.count - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
    //for move
    func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        dataManager.moveTask(from: sourceIndexPath.row, into: destinationIndexPath.row)
    }
    // for Delete
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { [weak self] (_, _, completionHandler) in
            self?.handleDeleteAction(at: indexPath)
            completionHandler(true)
        }

        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        return configuration
    }

    private func handleDeleteAction(at indexPath: IndexPath) {
        dataManager.removeTask(index: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .fade)
    }

    
    func taskCellDidToggleDone(for cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.toggleDone(index: indexPath.row, isDone: cell.doneTask)
            tableView.reloadRows(at: [indexPath], with: .none)
            dataManager.refreshData()
        }
    }
}
