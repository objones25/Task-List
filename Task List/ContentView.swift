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

   
    func urgencyScore(urgency: Int)-> String{
        
        switch urgency {
        case 0..<20:
            let string = "Is this a joke"
            return string
        case 21..<40:
            let string = "this seems easy"
            return string
        case 41..<70:
            let string = "ok this is enough"
            return string
        case 71..<100:
            let string = "we can stop now"
            return string
        case 101..<140:
            let string = "I don't like where this is going"
            return string
        case 141...:
            let string = "I think I might need an extension"
            return string
        default:
            let string = "You didn't tell me nothing"
            return string
        }
    }
    
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
                    
                    Section(header: Text("Points")){
                        Slider(value: self.$points, in: 0...250, step: 1)
                    }
                    .font(.body)
                    
                    Button(action: {
                        let toDoItem = ToDoItem(context: self.managedObjectContext)
                        toDoItem.title = self.newToDoItem
                        toDoItem.createdAt = Date()
                        toDoItem.subject = self.newToDoItemSubject
                        toDoItem.dueDate = self.newToDoItemDueDate
                        toDoItem.urgency = self.urgencyScore(urgency: Int(self.points))
                        
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
                            ToDoItemView(title: toDoItem.title.unwrap() as! String , subject: toDoItem.subject.unwrap() as! String, dueDate: self.dateFormatter(date: toDoItem.dueDate.unwrap() as! Date), difficulty: toDoItem.urgency.unwrap() as! String)
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
