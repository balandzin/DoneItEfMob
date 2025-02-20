//
//  TasksPresenter.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import Foundation

protocol TasksPresenterProtocol: AnyObject {
    func viewDidLoad()
    func didFailToLoadTasks(error: String)
    func didFetchTasks(_ tasks: [Task])
    func didSelectTask(_ task: TaskViewModel)
}

final class TasksPresenter: TasksPresenterProtocol {
    weak var view: TasksViewControllerProtocol?
    var interactor: TasksInteractorProtocol
    var router: TaskRouterProtocol
    
    func viewDidLoad() {
        interactor.fetchTasks()
    }
    
    func didFetchTasks(_ tasks: [Task]) {
        let taskViewModels = tasks.map { TaskViewModel(task: $0) }
        
        DispatchQueue.main.async {
            self.view?.showTasks(taskViewModels)
        }
    }
    
    func didFailToLoadTasks(error: String) {
        DispatchQueue.main.async {
            self.view?.showError(error)
        }
    }
    
    func didSelectTask(_ task: TaskViewModel) {
        router.showTaskDetails(task: task)
    }
    
    init(view: TasksViewControllerProtocol, interactor: TasksInteractorProtocol, router: TaskRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
}
