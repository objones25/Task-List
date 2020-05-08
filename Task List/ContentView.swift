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
    
    @State private var newToDoItem: String = ""
    @State private var newToDoItemSubject: String = ""
    @State private var newToDoItemDueDate = Date()
    @State private var selection = 0
    @State private var points: Float = 0
    @State private var functions = ConversionFuncs()
    
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
                    Text("choose points")
                        .font(.body)
                    Slider(value: self.$points, in: 0...250, step: 1)
                    }
                    Button(action: {
                        let toDoItem = ToDoItem(context: self.managedObjectContext)
                        toDoItem.title = self.newToDoItem
                        toDoItem.createdAt = Date()
                        toDoItem.subject = self.newToDoItemSubject
                        toDoItem.dueDate = self.newToDoItemDueDate
                        toDoItem.urgency = self.functions.urgencyScore(urgency: Int(self.points))
                        
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
                            ToDoItemView(title: toDoItem.title.unwrap() as! String , subject: toDoItem.subject.unwrap() as! String, dueDate: self.functions.dateFormatter(date: toDoItem.dueDate.unwrap() as! Date), difficulty: toDoItem.urgency.unwrap() as! String)
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
