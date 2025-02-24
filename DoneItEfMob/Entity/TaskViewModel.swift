//
//  TaskViewModel.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

struct TaskViewModel {
    var id: Int?
    var title: String
    var description: String
    var status: Bool
    var date: String
    
    init(task: Task) {
        self.id = task.id
        self.title = task.todo
        self.description = "No description"
        self.status = task.completed
        self.date =  "No date"
    }
    
    init(title: String, description: String, date: String) {
        self.id = nil
        self.title = title
        self.description = description
        self.status = false
        self.date = date
    }
    
    init(entity: TaskEntity) {
            self.id = Int(entity.id)
            self.title = entity.title ?? "Untitled"
            self.description = entity.taskDescription ?? "No description"
            self.status = entity.status
            self.date = entity.date ?? "No date"
    }
}
