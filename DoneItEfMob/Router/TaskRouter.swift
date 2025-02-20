//
//  TaskRouter.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 20.02.25.
//

import UIKit

protocol TaskRouterProtocol: AnyObject {
    //static func createModule() -> UIViewController
    func showTaskDetails(task: TaskViewModel)
}

final class TaskRouter: TaskRouterProtocol {
    weak var viewController: UIViewController?
    
    static func createModule() -> UIViewController {
        let controller = TasksViewController()
        let interactor = TasksInteractor()
        let router = TaskRouter()
        let presenter = TasksPresenter(view: controller, interactor: interactor, router: router)
        
        controller.presenter = presenter
        interactor.presenter = presenter
        router.viewController = controller
        
        return controller
    }
    
    func showTaskDetails(task: TaskViewModel) {
        //viewController.pushViewController(DetailsViewController(task: task), animated: true)
    }
}
