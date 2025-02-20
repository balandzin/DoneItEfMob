//
//  TaskViewModel.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

struct TaskViewModel {
    let title: String
    let description: String
    var status: Bool
    let date: String
    
    init(task: Task) {
        self.title = task.todo
        self.description = "No description"
        self.status = task.completed
        self.date =  "No date"
    }
}
