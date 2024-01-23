//
//  DataManager.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Игорь Пачкин on 20/1/24.
//

import Foundation

class UserDefaultsManager {
    // Статическое свойство для доступа к менеджеру UserDefaults
    static let shared = UserDefaultsManager()
    
    var tasks: [ToDoList] = []
    
    private init() {}
    
    func refreshData() {
        let encoder = JSONEncoder()
        
        if let encoded = try? encoder.encode(tasks) {
            UserDefaults.standard.set(encoded, forKey: "tasks")
            print("Data saved to UserDefaults")
        }
    }
    
    func getCount() -> Int{
        return tasks.count
    }
    
    func removeTask(index: Int) {
        tasks.remove(at: index)
        refreshData()
    }
    
    func moveTask(from: Int, into: Int) {
        let movedTask = tasks.remove(at: from)
        tasks.insert(movedTask, at: into)
    }
    
    func toggleDone(index: Int, isDone: Bool) {
        tasks[index].isDone = isDone
    }
}
