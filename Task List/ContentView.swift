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
    @State private var checkPointsChoice: Double = 1
    // Variables
    
    func howManyToMake(howMany: Double?) {
        let createdAt = Date()
        // based on today's date
        let dueDate = self.newToDoItemDueDate
        // uses due date from Date Picker
        let interval = dueDate.timeIntervalSince(createdAt)
        // find time between due date and today's date
        let checkPoint = Double(interval)/(howMany ?? 1)
        // finds the interval for each "checkpoint"
        var addedInterval = Date()
        // starting point
        
        for item in 1...Int(howMany ?? 1) {
            addedInterval = addedInterval.addingTimeInterval(checkPoint)
            // adds interval to next checkpoint
            
            let toDoItem = ToDoItem(context: self.managedObjectContext)
                toDoItem.title = self.newToDoItem + " part \(item)"
                toDoItem.createdAt = Date()
                toDoItem.subject = self.newToDoItemSubject
                toDoItem.dueDate = addedInterval
                toDoItem.urgency = String(self.points)
            //  Creates a new toDoItem
            do {
                try self.managedObjectContext.save()
            } catch {
                print(error)
            }
            // attempts to save current items
        }
        // repeats for desired number of times
        self.newToDoItem = ""
        self.newToDoItemSubject = ""
        self.newToDoItemDueDate = Date().addingTimeInterval(43400)
        self.checkPointsChoice = 0
        self.points = 0
        // resets all variables
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("New Assignment")){
                    TextField("type name", text: self.$newToDoItem)
                        .font(.body)
                    // name of assignment
                    TextField("type subject", text: self.$newToDoItemSubject)
                        .font(.body)
                    // subject of assignment
                    DatePicker("due date", selection: self.$newToDoItemDueDate, in: Date().addingTimeInterval(43200)...)
                        .font(.caption)
                        .font(.system(size: 8))
                    // due date of assignment
                    HStack {
                        Text("How many checkpoints? number: \(self.checkPointsChoice, specifier: "%g")").font(.caption)
                            .font(.system(size: 8))
                        Slider(value: self.$checkPointsChoice, in: 1...10, step: 1)
                    }
                    // choose the number of checkpoints
                    HStack{
                        Text("choose points! Value: \(self.points, specifier: "%g")")
                            .font(.caption)
                            .font(.system(size: 8))
                        Slider(value: self.$points, in: 0...250, step: 1)
                    }
                    // choose the number of points assignment is worth
                    Button(action: {
                        self.howManyToMake(howMany: self.checkPointsChoice)
                    }){
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.green)
                            .imageScale(.large)
                    }
                    // complete button
                    //layout for creating a new assignment
                }
                .font(.title)
                Section(header: Text("To Do's")) {
                    List{
                        ForEach(self.toDoItems) {toDoItem in
                            ToDoItemView(title: toDoItem.title ?? "" , subject: toDoItem.subject ?? "", dueDate: self.functions.dateFormatter(date: toDoItem.dueDate ?? Date()), difficulty: toDoItem.urgency ?? "NA")
                            // creates a view that includes each of the aforementioned variables
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
                            // deletes selected object
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
