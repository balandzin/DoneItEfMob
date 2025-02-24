//
//  TasksInteractorTests.swift
//  DoneItEfMobTests
//
//  Created by Антон Баландин on 24.02.25.
//

import XCTest
import CoreData
@testable import DoneItEfMob

class TasksInteractorTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    var interactor: TasksInteractor!
    
    override func setUp() {
        super.setUp()
        
        persistentContainer = NSPersistentContainer(name: "TasksCoreData")
        let description = NSPersistentStoreDescription()
        description.type = NSInMemoryStoreType
        persistentContainer.persistentStoreDescriptions = [description]
        
        persistentContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        interactor = TasksInteractor(persistentContainer: persistentContainer)
    }
    
    override func tearDown() {
        persistentContainer = nil
        interactor = nil
        super.tearDown()
    }
    
    func testSaveTaskToCoreData() {
        let task = TaskViewModel(title: "Test Task", description: "Test Description", date: "01/01/2023")
        interactor.saveTaskToCoreData(task)
        
        let tasks = interactor.loadTasksFromCoreData()
        XCTAssertEqual(tasks.count, 1)
        XCTAssertEqual(tasks.first?.title, "Test Task")
    }
    
    func testDeleteTaskFromCoreData() {
        let task = TaskViewModel(title: "Test Task", description: "Test Description", date: "01/01/2023")
        interactor.saveTaskToCoreData(task)
        
        let tasksBeforeDelete = interactor.loadTasksFromCoreData()
        XCTAssertEqual(tasksBeforeDelete.count, 1)
        
        interactor.deleteTaskFromCoreData(tasksBeforeDelete.first!)
        
        let tasksAfterDelete = interactor.loadTasksFromCoreData()
        XCTAssertEqual(tasksAfterDelete.count, 0)
    }
    
    func testUpdateTaskInCoreData() {
        let task = TaskViewModel(title: "Test Task", description: "Test Description", date: "01/01/2023")
        interactor.saveTaskToCoreData(task)
        
        let tasks = interactor.loadTasksFromCoreData()
        var updatedTask = tasks.first!
        updatedTask.title = "Updated Task"
        
        interactor.updateTaskInCoreData(updatedTask)
        
        let updatedTasks = interactor.loadTasksFromCoreData()
        XCTAssertEqual(updatedTasks.first?.title, "Updated Task")
    }
}
