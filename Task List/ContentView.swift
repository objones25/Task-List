//
//  ContentView.swift
//  Task List
//
//  Created by Owen Jones on 5/6/20.
//  Copyright © 2020 Owen Jones. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @Environment(\.managedObjectContext) var managedObjectContext
    // keeps track of changes in state managedObjectContext
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    @State private var newToDoItem: String = ""
    @State private var newToDoItemSubject: String = ""
    @State private var newToDoItemDueDate = Date()
    @State private var points: Float = 0
    
    @State private var functions = ConversionFuncs()
    //stores all of our functions
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New Assignment")){
                    TextField("type name", text: self.$newToDoItem)
                        .font(.body)
                    TextField("type subject", text: self.$newToDoItemSubject)
                        .font(.body)
                    DatePicker("due date", selection: self.$newToDoItemDueDate)
                        .font(.body)
                    HStack{
                        Text("choose points! value: \(self.points)")
                        .font(.body)
                    Slider(value: self.$points, in: 0...250, step: 1)
// layout for creating a new assignment
                    }
                    Button(action: {
                        let toDoItem = ToDoItem(context: self.managedObjectContext)
                        toDoItem.title = self.newToDoItem
                        toDoItem.createdAt = Date()
                        toDoItem.subject = self.newToDoItemSubject
                        toDoItem.dueDate = self.newToDoItemDueDate
                        toDoItem.urgency = self.functions.urgencyScore(urgency: Int(self.points))
  // when button is pressed, creates a new to do item
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
// stores data from to do item
                        self.newToDoItem = ""
                        self.newToDoItemSubject = ""
                        self.newToDoItemDueDate = Date()
// resets all variables to default
                        
                    }){
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                }
                .font(.title)
                Section(header: Text("To Do's")) {
                    List{
                        ForEach(self.toDoItems) {toDoItem in
                            ToDoItemView(title: toDoItem.title.unwrap() as! String , subject: toDoItem.subject.unwrap() as! String, dueDate: self.functions.dateFormatter(date: toDoItem.dueDate.unwrap() as! Date), difficulty: toDoItem.urgency.unwrap() as! String)
// for each to do item created, data is displayed in a view of format ToDoItemView
                        } .onDelete {IndexSet in
                            let deleteItem = self.toDoItems[IndexSet.first.unwrap() as! Int]
                            self.managedObjectContext.delete(deleteItem)
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
// when item is deleted, item is removed from index and data is saved
                        }
                    }
                }
                .font(.title)
            }
            .navigationBarTitle("To Do List")
            .navigationBarItems(trailing: EditButton())
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
