//
//  TaskRouter.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import UIKit

protocol TaskRouterProtocol: AnyObject {
    func showTaskDetails(task: TaskViewModel, with date: String)
    func addTask()
}

final class TaskRouter: TaskRouterProtocol {
    weak var viewController: UIViewController?
    weak var presenter: TasksPresenterProtocol?
    
    static func createModule() -> UIViewController {
        let controller = TasksViewController()
        let interactor = TasksInteractor()
        let router = TaskRouter()
        let presenter = TasksPresenter(view: controller, interactor: interactor, router: router)

        controller.presenter = presenter
        interactor.presenter = presenter
        router.viewController = controller
        router.presenter = presenter
        
        return controller
    }
    
    func showTaskDetails(task: TaskViewModel, with date: String) {
        let detailsVC = EditViewController(task: task, date: date)
        
        detailsVC.editModifiedTask = { [weak self] updatedTask in
            guard let self = self else { return }
            presenter?.didEditTask(updatedTask)
        }
        viewController?.navigationController?.pushViewController(detailsVC, animated: true)
    }

    
    func addTask() {
        let addTaskVC = AddTaskViewController()
        
        addTaskVC.taskDidAdded = { [weak self] title, description in
            guard let self = self else { return }
            presenter?.addTask(with: title, and: description)
        }
        
        viewController?.navigationController?.pushViewController(addTaskVC, animated: true)
    }
}
