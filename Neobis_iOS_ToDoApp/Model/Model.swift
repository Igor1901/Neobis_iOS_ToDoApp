//
//  Model.swift
//  Neobis_iOS_ToDoApp
//
//  Created by Игорь Пачкин on 15/1/24.
//

import UIKit

struct ToDoList: Codable{
    var title: String
    var description: String
    var isDone: Bool
}

extension ToDoList {
    // Метод для создания нового экземпляра ToDoList с дополнительным описанием
    func withDescription(_ newDescription: String) -> ToDoList {
        return ToDoList(title: title, description: newDescription, isDone: isDone)
    }
    
    // Метод для создания нового экземпляра ToDoList с измененным статусом выполнения
    func toggledDone() -> ToDoList {
        return ToDoList(title: title, description: description, isDone: !isDone)
    }
}

// Пример использования
var initialToDo = ToDoList(title: "Задача 1", description: "Описание задачи", isDone: false)


