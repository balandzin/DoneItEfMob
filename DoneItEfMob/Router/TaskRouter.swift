//
//  TaskRouter.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import UIKit
import CoreData

protocol TaskRouterProtocol: AnyObject {
    func showTaskDetails(task: TaskViewModel, with date: String)
    func addTask()
    func onShare(_ task: String)
}

final class TaskRouter: TaskRouterProtocol {
    
    // MARK: - Properties
    weak var viewController: UIViewController?
    weak var presenter: TasksPresenterProtocol?
    
    // MARK: - Methods
    static func createModule() -> UIViewController {
        let controller = TasksViewController()
        
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "TasksCoreData")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error as NSError? {
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                }
            })
            return container
        }()
        
        let interactor = TasksInteractor(persistentContainer: persistentContainer)
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
    
    func onShare(_ task: String) {
        let activityViewController = UIActivityViewController(activityItems: [task], applicationActivities: nil)
        
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = viewController?.view
            popoverController.sourceRect = CGRect(x: viewController?.view.bounds.midX ?? 0,
                                                  y: viewController?.view.bounds.midY ?? 0,
                                                  width: 0,
                                                  height: 0)
        }
        
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
