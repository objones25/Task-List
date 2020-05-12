//
//  ToDoVIew.swift
//  Task List
//
//  Created by Owen Jones on 5/6/20.
//  Copyright © 2020 Owen Jones. All rights reserved.
//

import SwiftUI

struct ToDoItemView: View {
    var title: String = ""
    var createdAt: String = ""
    var subject: String = ""
    var dueDate: String = ""
    var difficulty: String = ""
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                HStack(alignment: .top){
                    Text(subject)
                    .font(.caption)
                    Text("due date: \(dueDate)")
                    .font(.caption)
                    Text("points: \(difficulty)")
                    .font(.caption)
                }
            }
        }
// to do items are displayed with name of task on top with additional information below
    }
}

struct ToDoVIew_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(title: "My Great To Do", createdAt: "Today")
    }
}
