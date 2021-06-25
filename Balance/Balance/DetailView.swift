//
//  DetailView.swift
//  appBalance
//
//  Created by student on 02.06.2021.
//

import SwiftUI

struct DetailView: View {
    var task: Invoice? = nil
    
    var body: some View {
        Form{
            Section(header: Text("Description")){
                Text("\(task?.descriptionText ?? "No description")")
            }
            Section(header: Text("Type")){
                Text("\(task?.type ?? "No type")")
            }
            Section(header: Text("Category")){
                Text("\(task?.category ?? "Other")")
            }
            Section(header: Text("Money")){
                Text("\(task?.money ?? 0)")
            }
            
            Section(header: Text("Created")){
                if let myTask = self.task{
                    Text("\(itemFormatter.string(from: myTask.date ?? Date()))")
                }
            }
        }
        .navigationBarTitle(Text("Transaction Detail"))
        
        //
    }
}
