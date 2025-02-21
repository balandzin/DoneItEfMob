//
//  TasksInteractor.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

protocol TasksInteractorProtocol: AnyObject {
    func fetchTasks()
    func getDate() -> String
    func integrate(_ task: TaskViewModel, to taskList: [TaskViewModel])-> [TaskViewModel]
    func delete(_ task: TaskViewModel, from taskList: [TaskViewModel]) -> [TaskViewModel]
}

final class TasksInteractor: TasksInteractorProtocol {
    weak var presenter: TasksPresenterProtocol?
    
    func fetchTasks() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            presenter?.didFailToLoadTasks(error: "Failed to locate data.json in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(TasksResponse.self, from: data)
            presenter?.didFetchTasks(decodedData.todos)
        } catch {
            presenter?.didFailToLoadTasks(error: "Failed to parse JSON: \(error.localizedDescription)")
        }
    }
    
    func integrate(_ task: TaskViewModel, to taskList: [TaskViewModel]) -> [TaskViewModel] {
        var updatedList = taskList
        var updatedTask = task
        if let index = updatedList.firstIndex(where: { $0.id == task.id }) {
            updatedList[index] = task
        } else {
            let id = generateUniqueId(excluding: taskList)
            updatedTask.id = id
            updatedList.append(task)
        }
        
        let sortedList = sortTasksByDate(tasks: updatedList)
        
        return sortedList
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: Date())
    }
    
    private func sortTasksByDate(tasks: [TaskViewModel]) -> [TaskViewModel] {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        
        return tasks.sorted { (task1, task2) -> Bool in
            if task1.date == "No date" {
                return false
            }
            if task2.date == "No date" {
                return true
            }
            
            guard let date1 = dateFormatter.date(from: task1.date),
                  let date2 = dateFormatter.date(from: task2.date) else {
                return false
            }
            
            return date1 < date2
        }
    }
    
    func generateUniqueId(excluding taskList: [TaskViewModel]) -> Int {
        var uniqueId: Int
        
        repeat {
            uniqueId = Int.random(in: 1...Int.max)
        } while taskList.contains(where: { $0.id == uniqueId })

        return uniqueId
    }
    
    func delete(_ task: TaskViewModel, from taskList: [TaskViewModel]) -> [TaskViewModel] {
        var list = taskList
        if let index = list.firstIndex(where: { $0.id == task.id }) {
            list.remove(at: index)
        }
        
        let sortedList = sortTasksByDate(tasks: list)
        
        return sortedList
    }
}
