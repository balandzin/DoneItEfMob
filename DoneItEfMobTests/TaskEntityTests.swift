//
//  TaskEntityTests.swift
//  DoneItEfMobTests
//
//  Created by Антон Баландин on 24.02.25.
//

import XCTest
import CoreData
@testable import DoneItEfMob

class TaskEntityTests: XCTestCase {
    
    var persistentContainer: NSPersistentContainer!
    
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
    }
    
    func testTaskEntityCreation() {
        let context = persistentContainer.viewContext
        let taskEntity = TaskEntity(context: context)
        
        taskEntity.id = 1
        taskEntity.title = "Test Title"
        taskEntity.taskDescription = "Test Description"
        taskEntity.status = false
        taskEntity.date = "01/01/2023"
        
        XCTAssertNotNil(taskEntity)
        XCTAssertEqual(taskEntity.id, 1)
        XCTAssertEqual(taskEntity.title, "Test Title")
        XCTAssertEqual(taskEntity.taskDescription, "Test Description")
        XCTAssertEqual(taskEntity.status, false)
        XCTAssertEqual(taskEntity.date, "01/01/2023")
    }
}
