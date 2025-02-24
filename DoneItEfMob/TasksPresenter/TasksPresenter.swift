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
    //func didFetchTasks(_ tasks: [TaskViewModel])
    
    func didFetchTasks()
    
    
    func didSelectTask(_ task: TaskViewModel)
    func didEditTask(_ task: TaskViewModel)
    func didAddTask()
    func addTask(with title: String, and description: String)
    func deleteTask(_ task: TaskViewModel)
    func onShare(_ task: TaskViewModel)
}

final class TasksPresenter: TasksPresenterProtocol {
   
    
    weak var view: TasksViewControllerProtocol?
    var interactor: TasksInteractorProtocol
    var router: TaskRouterProtocol
    
    private var tasksList: [TaskViewModel] = [] {
        
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.view?.showTasks(self.tasksList)
            }
        }
    }
    
    init(view: TasksViewControllerProtocol, interactor: TasksInteractorProtocol, router: TaskRouterProtocol) {
        self.view = view
        self.interactor = interactor
        self.router = router
    }
    
    func viewDidLoad() {
        tasksList = interactor.loadTasksFromCoreData()
        if tasksList.isEmpty {
            interactor.fetchTasks()
        } else {
            //view?.showTasks(tasksList)
        }
    }
    
    func didFetchTasks() {
        tasksList = interactor.loadTasksFromCoreData()
        
//        DispatchQueue.main.async { [weak self] in
//            guard let self else { return }
//            self.view?.showTasks(self.tasksList)
//        }
    }
    
    //    func didFetchTasks(_ tasks: [TaskViewModel]) {
    //        tasksList = tasks
    //        interactor.saveTasksToCoreData(tasksList)
    //        DispatchQueue.main.async {
    //            self.view?.showTasks(tasks)
    //        }
    //    }
    
    func didFailToLoadTasks(error: String) {
        DispatchQueue.main.async { [weak self] in
            self?.view?.showError(error)
        }
    }
    
    func didSelectTask(_ task: TaskViewModel) {
        let date = interactor.getDate()
        router.showTaskDetails(task: task, with: date)
    }
    
    func didEditTask(_ task: TaskViewModel) {
        interactor.updateTaskInCoreData(task)
        tasksList = interactor.loadTasksFromCoreData()
        DispatchQueue.main.async { [weak self] in
            self?.view?.showTasks(self?.tasksList ?? [])
        }
    }
    
    func didAddTask() {
        router.addTask()
    }
    
    func addTask(with title: String, and description: String) {
        let date = interactor.getDate()
        let task = TaskViewModel(title: title, description: description, date: date)
        interactor.saveTaskToCoreData(task)
        tasksList = interactor.loadTasksFromCoreData()
        
//        DispatchQueue.main.async { [weak self] in
//            self?.view?.showTasks(self?.tasksList ?? [])
//        }
    }
    
    func deleteTask(_ task: TaskViewModel) {
        interactor.deleteTaskFromCoreData(task)
        tasksList = interactor.loadTasksFromCoreData()
//        DispatchQueue.main.async { [weak self] in
//            self?.view?.showTasks(self?.tasksList ?? [])
//        }
    }
    
    func onShare(_ task: TaskViewModel) {
        let taskDetails = "Задача: \(task.title)\nОписание: \(task.description)\nДата: \(task.date)"
        router.onShare(taskDetails)
    }
}


