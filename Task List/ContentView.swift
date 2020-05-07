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
    @FetchRequest(fetchRequest: ToDoItem.getAllToDoItems()) var toDoItems:FetchedResults<ToDoItem>
    
    @State private var newToDoItem = ""
    @State private var newToDoItemSubject = ""
    @State private var newToDoItemDueDate = Date()
    @State private var selection = 0
    
    func dateFormatter(date: Date )-> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date)
        return dateString
    }
    
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New Assignment")){
                    Section(header: Text("Name")){

                            TextField("type name", text: self.$newToDoItem)
                    }
                    .font(.body)
                    Section(header: Text("Subject")){
                        TextField("type subject", text: self.$newToDoItemSubject)
                    }
                    .font(.body)

                    Section(header: Text("Due Date")){
                        DatePicker("choose", selection: self.$newToDoItemDueDate)
                        .labelsHidden()
                        
                    }
                    .font(.body)
                    
                    Button(action: {
                        let toDoItem = ToDoItem(context: self.managedObjectContext)
                        toDoItem.title = self.newToDoItem
                        toDoItem.createdAt = Date()
                        toDoItem.subject = self.newToDoItemSubject
                        toDoItem.dueDate = self.newToDoItemDueDate
                        
                        do {
                            try self.managedObjectContext.save()
                        } catch {
                            print(error)
                        }
                        
                        self.newToDoItem = ""
                        self.newToDoItemSubject = ""
                        self.newToDoItemDueDate = Date()
                        
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
                            ToDoItemView(title: toDoItem.title.unwrap() as! String , subject: toDoItem.subject.unwrap() as! String, dueDate: self.dateFormatter(date: toDoItem.dueDate.unwrap() as! Date ))
                        } .onDelete {IndexSet in
                            let deleteItem = self.toDoItems[IndexSet.first.unwrap() as! Int]
                            self.managedObjectContext.delete(deleteItem)
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
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
