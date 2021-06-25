//
//  ContentView.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Invoice>

    @State var showNewIncome: Bool = false
    @State var showNewExpense: Bool = false

    var body: some View {
        let balance:[(income:Double, expense:Double)] = countBalance()
        NavigationView{
            List {
                ForEach(tasks) { task in
                    NavigationLink(destination: DetailView(task: task)){
                        VStack(alignment: .leading){
                            Text("\(task.type ?? "Expense")")
                            let formatDouble:String = String(format: "%.2f", task.money)
                            if task.type == "expense"{
                                Text("\(task.category ?? "Other") : -\(formatDouble) Kč ")
                            }else {
                                Text("\(task.category ?? "Other") : \(formatDouble) Kč ")
                            }
                            
                            
                            if let date = task.date{
                                Text("\(itemFormatter.string(from: date))")
                            }
                        }
                    }
                    
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading){
                    #if os(iOS)
                    EditButton()
                    #endif
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        self.showNewIncome = true
                    }) {
                        Label("+", systemImage: "plus")
                    }
                    
                }
            }
            .navigationBarTitle(Text(String(format: "Balance: %.2f",balance[0].income - balance[0].expense)))
            .sheet(isPresented: $showNewIncome){
                NewTaskView(isViewPresented: $showNewIncome)
            }
            
            
        }
    }
    func countBalance() -> [(income:Double, expense:Double)] {
        var balance:[(income: Double, expense: Double)] = []
        var income:Double = 0.0
        var expense:Double = 0.0
        for task in tasks {
            if task.type == "income" {
                income += task.money
            }else {
                expense += task.money
            }
        }
        balance.append((income: income, expense: expense))
        return balance
    }
    private func addItem() {
        withAnimation {
            let newTask = Invoice(context: viewContext)
            newTask.date = Date()
            newTask.type = "Test task"
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { tasks[$0] }.forEach(viewContext.delete)

            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

let itemFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateStyle = .short
    formatter.timeStyle = .short
    return formatter
}()

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
