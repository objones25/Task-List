//
//  ToDoItem.swift
//  Task List
//
//  Created by Owen Jones on 5/6/20.
//  Copyright © 2020 Owen Jones. All rights reserved.
//

import Foundation
import CoreData

public class ToDoItem:NSManagedObject, Identifiable{
    @NSManaged public var createdAt:Date?
    @NSManaged public var title:String?
    @NSManaged public var subject:String?
    @NSManaged public var dueDate:Date?
}

extension ToDoItem {
    static func getAllToDoItems() -> NSFetchRequest<ToDoItem>{
        let request:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest() as!
            NSFetchRequest<ToDoItem>
        let sortDescriptor = NSSortDescriptor(key: "createdAt", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }
}
