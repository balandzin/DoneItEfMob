//
//  TaskEntity+CoreDataProperties.swift
//  DoneItEfMob
//
//  Created by Антон Баландин on 24.02.25.
//
//

import Foundation
import CoreData


extension TaskEntity {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TaskEntity> {
        return NSFetchRequest<TaskEntity>(entityName: "TaskEntity")
    }

    @NSManaged public var id: Int64
    @NSManaged public var title: String?
    @NSManaged public var date: String?
    @NSManaged public var taskDescription: String?
    @NSManaged public var status: Bool

}

extension TaskEntity : Identifiable {

}
