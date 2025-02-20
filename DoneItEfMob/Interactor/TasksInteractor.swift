//
//  TasksInteractor.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

protocol TasksInteractorProtocol: AnyObject {
    func fetchTasks()
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
}
