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
    @NSManaged public var urgency:String?
}
// can't take credit for this. Learned this from a tutorial.
// don't completely understand this yet. These are all the pieces of data ToDoItem keeps track of. I want to create a public var of type Int16 to store the points for a given task

extension ToDoItem {
    static func getAllToDoItems() -> NSFetchRequest<ToDoItem>{
        let request:NSFetchRequest<ToDoItem> = ToDoItem.fetchRequest() as!
            NSFetchRequest<ToDoItem>
        let sortDescriptor = NSSortDescriptor(key: "dueDate", ascending: true)
        
        request.sortDescriptors = [sortDescriptor]
        
        return request
    }

}
// can't take credit for this. Learned this from a tutorial.
