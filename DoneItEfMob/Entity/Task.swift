//
//  Task.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

struct Task: Decodable {
    let todo: String
    let completed: Bool
}

struct TasksResponse: Decodable {
    let todos: [Task]
}
