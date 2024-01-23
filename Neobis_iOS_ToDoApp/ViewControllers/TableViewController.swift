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

    @IBAction func presentModalController(_ sender: UIButton) {
        let modalController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "TaskViewController") as! TaskViewController

        modalController.closeAction = { [weak self] in
            self?.tableView.reloadData()
        }
        present(modalController, animated: true, completion: nil)
    }
}

extension TableViewController: UITableViewDataSource, UITableViewDelegate, TaskCellDelegate {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataManager.getCount()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: TableViewCell.id, for: indexPath) as! TableViewCell
        //dequeueReusableCell(withIdentifier: "MyTableViewCell", for: indexPath) as! TableViewCell
        
        cell.delegate = self
        
        
        
        cell.configureCell(title: dataManager.tasks[indexPath.row].title, descriptionText: dataManager.tasks[indexPath.row].description, isDone: dataManager.tasks[indexPath.row].isDone, image: (dataManager.tasks[indexPath.row].isDone ? "checkmark.circle" : "circle"))
        return cell
    }
    
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

    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if indexPath.row == dataManager.tasks.count - 1 {
            cell.separatorInset.left = cell.bounds.size.width
        }
    }
    
    
    
    func taskCellDidToggleDone(for cell: TableViewCell) {
        if let indexPath = tableView.indexPath(for: cell) {
            dataManager.toggleDone(index: indexPath.row, isDone: cell.doneTask)
            tableView.reloadRows(at: [indexPath], with: .none)
            dataManager.refreshData()
        }
    }
}
