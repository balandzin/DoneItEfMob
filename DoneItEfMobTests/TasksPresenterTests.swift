//
//  TasksPresenterTests.swift
//  DoneItEfMobTests
//
//  Created by Антон Баландин on 24.02.25.
//

import XCTest
@testable import DoneItEfMob

class TasksPresenterTests: XCTestCase {
    
    var presenter: TasksPresenter!
    var interactor: MockTasksInteractor!
    var router: MockTaskRouter!
    var view: MockTasksViewController!
    
    override func setUp() {
        super.setUp()
        view = MockTasksViewController()
        interactor = MockTasksInteractor()
        router = MockTaskRouter()
        presenter = TasksPresenter(view: view, interactor: interactor, router: router)
    }
    
    func testViewDidLoadFetchesTasks() {
        presenter.viewDidLoad()
        XCTAssertTrue(interactor.fetchTasksCalled)
    }
    
    func testDidFetchTasksUpdatesView() {
        interactor.tasksToReturn = [TaskViewModel(title: "Task 1", description: "Description 1", date: "01/01/2023")]
        presenter.didFetchTasks()
    }
}

class MockTasksViewController: TasksViewControllerProtocol {
    var tasksDisplayed: [TaskViewModel] = []
    
    func showTasks(_ tasks: [TaskViewModel]) {
        tasksDisplayed = tasks
    }
    
    func showError(_ error: String) {}
}

class MockTasksInteractor: TasksInteractorProtocol {
    func getDate() -> String {
        ""
    }
    
    func saveTasksToCoreData(_ tasks: [DoneItEfMob.TaskViewModel]) {
        
    }
    
    func saveTaskToCoreData(_ task: DoneItEfMob.TaskViewModel) {
        
    }
    
    func updateTaskInCoreData(_ task: DoneItEfMob.TaskViewModel) {
        
    }
    
    func deleteTaskFromCoreData(_ task: DoneItEfMob.TaskViewModel) {
        
    }
    
    var fetchTasksCalled = false
    var tasksToReturn: [TaskViewModel] = []
    
    func fetchTasks() {
        fetchTasksCalled = true
    }
    
    func loadTasksFromCoreData() -> [TaskViewModel] {
        return tasksToReturn
    }
    
}

class MockTaskRouter: TaskRouterProtocol {
    func showTaskDetails(task: TaskViewModel, with date: String) {}
    func addTask() {}
    func onShare(_ task: String) {}
}
