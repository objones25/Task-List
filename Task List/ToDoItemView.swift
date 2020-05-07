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
    
    var body: some View {
        HStack{
            VStack(alignment: .leading){
                Text(title)
                    .font(.headline)
                HStack(alignment: .top){
                    Text(dueDate)
                    .font(.caption)
                    Text(subject)
                    .font(.caption)
                }
            }
        }
        
    }
}

struct ToDoVIew_Previews: PreviewProvider {
    static var previews: some View {
        ToDoItemView(title: "My Great To Do", createdAt: "Today")
    }
}
