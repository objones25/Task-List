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
    
    func dateFormatter(date: Date )-> String {
        let formatter1 = DateFormatter()
        formatter1.dateStyle = .short
        let dateString = formatter1.string(from: date)
        return dateString
    }
    
    var body: some View {
        NavigationView{
            List{
                Section(header: Text("what's next?")){
                    HStack{
                        TextField("New Item", text: self.$newToDoItem)
                        Button(action: {
                            let toDoItem = ToDoItem(context: self.managedObjectContext)
                            toDoItem.title = self.newToDoItem
                            toDoItem.createdAt = Date()
                            
                            do {
                                try self.managedObjectContext.save()
                            } catch {
                                print(error)
                            }
                            
                            self.newToDoItem = ""
                            
                        }){
                            Image(systemName: "plus.circle.fill")
                                .foregroundColor(.green)
                                .imageScale(.large)
                        }
                    }
                }
                Section(header: Text("To Do's")) {
                    ForEach(self.toDoItems) {toDoItem in
                        ToDoItemView(title: toDoItem.title.unwrap() as! String , createdAt: self.dateFormatter(date: toDoItem.createdAt.unwrap() as! Date ))
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
