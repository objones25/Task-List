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
    @State private var newToDoItemDueDate = Date().addingTimeInterval(43400)
    @State private var selection = 0
    @State private var points: Float = 0
    @State private var functions = ConversionFuncs()
    @State private var checkpointsChoice: Double = 0
    
    func howManyToMake(howMany: Double?) {
        let createdAt = Date()
        let dueDate = self.newToDoItemDueDate
        let interval = dueDate.timeIntervalSince(createdAt)
        let checkPoint = Double(interval)/(howMany ?? 1)
        var addedInterval = Date()
        for _ in 0...Int(howMany ?? 1) {
            addedInterval = addedInterval.addingTimeInterval(checkPoint)
            newToDoItemDueDate = addedInterval
            let toDoItem = ToDoItem(context: self.managedObjectContext)
            toDoItem.title = self.newToDoItem
            toDoItem.createdAt = Date()
            toDoItem.subject = self.newToDoItemSubject
            toDoItem.dueDate = self.newToDoItemDueDate
            toDoItem.urgency = String(self.points)
            
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
        }
        self.newToDoItem = ""
        self.newToDoItemSubject = ""
        self.newToDoItemDueDate = Date().addingTimeInterval(43400)
        self.checkpointsChoice = 0
        self.points = 0
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New Assignment")){
                    TextField("type name", text: self.$newToDoItem)
                        .font(.body)
                    TextField("type subject", text: self.$newToDoItemSubject)
                        .font(.body)
                    DatePicker("due date", selection: self.$newToDoItemDueDate, in: Date().addingTimeInterval(43200)...)
                        .font(.body)
                    HStack {
                        Text("How many checkpoints? number: \(self.checkpointsChoice,  specifier: "%g")").font(.caption)
                            .font(.system(size: 8))
                        Slider(value: self.$checkpointsChoice, in: 1...10, step: 1)
                    }
                    HStack{
                        Text("choose points! Value: \(self.points, specifier: "%g")")
                            .font(.caption)
                            .font(.system(size: 8))
                        Slider(value: self.$points, in: 0...250, step: 1)
                    }
                    Button(action: {
                        self.howManyToMake(howMany: self.checkpointsChoice)
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
                            ToDoItemView(title: toDoItem.title ?? "" , subject: toDoItem.subject ?? "", dueDate: self.functions.dateFormatter(date: toDoItem.dueDate ?? Date()), difficulty: toDoItem.urgency ?? "NA")
                        } .onDelete {IndexSet in
                            if let deletedObject = IndexSet.first as Int?{
                                let deleteItem = self.toDoItems[deletedObject]
                                self.managedObjectContext.delete(deleteItem)
                                do {
                                    try self.managedObjectContext.save()
                                } catch {
                                    print(error)
                                }
                            } else{
                                print("could not find chosen Index item")
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
