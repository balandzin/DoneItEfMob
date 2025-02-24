//
//  TasksInteractor.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation
import CoreData

protocol TasksInteractorProtocol: AnyObject {
    func fetchTasks()
    func getDate() -> String
    func saveTasksToCoreData(_ tasks: [TaskViewModel])
    func loadTasksFromCoreData() -> [TaskViewModel]
    func saveTaskToCoreData(_ task: TaskViewModel)
    func updateTaskInCoreData(_ task: TaskViewModel)
    func deleteTaskFromCoreData(_ task: TaskViewModel)
}

final class TasksInteractor: TasksInteractorProtocol {
    weak var presenter: TasksPresenterProtocol?
    private let persistentContainer: NSPersistentContainer
    
    init(persistentContainer: NSPersistentContainer) {
        self.persistentContainer = persistentContainer
    }
    
    func fetchTasks() {
        loadTasksFromJSON()
    }
    
    private func loadTasksFromJSON() {
        guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
            presenter?.didFailToLoadTasks(error: "Failed to locate data.json in bundle")
            return
        }
        
        do {
            let data = try Data(contentsOf: url)
            let decodedData = try JSONDecoder().decode(TasksResponse.self, from: data)
            let tasks = decodedData.todos.map { TaskViewModel(task: $0) }
            saveTasksToCoreData(tasks)
        } catch {
            presenter?.didFailToLoadTasks(error: "Failed to parse JSON: \(error.localizedDescription)")
        }
    }
    
    func saveTasksToCoreData(_ tasks: [TaskViewModel]) {
        //let context = persistentContainer.viewContext
        tasks.forEach { saveTaskToCoreData($0) }
        
        presenter?.didFetchTasks()
    }
    
//    func loadTasksFromCoreData() -> [TaskViewModel] {
//        let context = persistentContainer.viewContext
//        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
//        do {
//            return try context.fetch(fetchRequest).map { TaskViewModel(entity: $0) }
//        } catch {
//            return []
//        }
//    }
    
    func loadTasksFromCoreData() -> [TaskViewModel] {
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            
            let sortedTasks = taskEntities.sorted { (task1, task2) -> Bool in
                let dateFormatter = DateFormatter()
                dateFormatter.dateFormat = "dd/MM/yy"
                
                let date1 = task1.date != nil ? dateFormatter.date(from: task1.date!) : nil
                let date2 = task2.date != nil ? dateFormatter.date(from: task2.date!) : nil
                
                if let date1 = date1, let date2 = date2 {
                    return date1 > date2
                } else if date1 != nil {
                    return true
                } else if date2 != nil {
                    return false
                } else {
                    return false
                }
            }
            
            return sortedTasks.map { TaskViewModel(entity: $0) }
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    
    func saveTaskToCoreData(_ task: TaskViewModel) {
        let context = persistentContainer.viewContext
        let taskEntity = TaskEntity(context: context)
        taskEntity.id = Int64(generateUniqueId())
        taskEntity.title = task.title
        taskEntity.taskDescription = task.description
        taskEntity.status = task.status
        taskEntity.date = task.date
        try? context.save()
    }
    
    func updateTaskInCoreData(_ task: TaskViewModel) {
        guard let taskId = task.id else { return }

        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", taskId)
        
        do {
            if let taskEntity = try context.fetch(fetchRequest).first {
                taskEntity.title = task.title
                taskEntity.taskDescription = task.description
                taskEntity.status = task.status
                taskEntity.date = task.date
                try context.save()
            }
        } catch {}
    }
    
    func deleteTaskFromCoreData(_ task: TaskViewModel) {
        guard let taskId = task.id else { return }
        
        let context = persistentContainer.viewContext
        let fetchRequest: NSFetchRequest<TaskEntity> = TaskEntity.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "id == %lld", taskId)
        
        do {
            let taskEntities = try context.fetch(fetchRequest)
            if let taskEntity = taskEntities.first {
                context.delete(taskEntity)
                try context.save()
            } else {
                print("No task found with ID \(taskId).")
            }
        } catch {
            print("Error while deleting task: \(error.localizedDescription)")
        }
    }
    
    func getDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: Date())
    }
    
    func generateUniqueId() -> Int64 {
        var uniqueId: Int64
        let taskList = loadTasksFromCoreData()
        
        repeat {
            uniqueId = Int64.random(in: 1...Int64.max)
        } while taskList.contains(where: { $0.id ?? -1 == uniqueId })
        
        return uniqueId
    }
    
}
