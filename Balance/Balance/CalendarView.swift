//
//  CalendarView.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI

struct CalendarView: View {
    @State var selectedDate = Date()
    @Environment(\.managedObjectContext) private var viewContext
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Invoice.date, ascending: true)],
        animation: .default)
    private var tasks: FetchedResults<Invoice>
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
    var body: some View {
       
                NavigationView{
                    
                    List {
                        DatePicker("Choose day", selection: $selectedDate, displayedComponents: .date)
                        ForEach(tasks) { task in
                            let calendarDate = Calendar.current.dateComponents([.day, .month, .year], from: task.date ?? Date())
                            let pickDate = Calendar.current.dateComponents([.day, .month, .year], from: selectedDate)
                            if((calendarDate.year == pickDate.year)&&(calendarDate.month == pickDate.month)&&(calendarDate.day == pickDate.day)){
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
                            
                            
                            
                        }
                        .onDelete(perform: deleteItems)
                    }
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarLeading){
                            #if os(iOS)
                            EditButton()
                            #endif
                        }
                        
                    }
                    
                    .navigationBarTitle( Text("Transaction"))

                }
            }
    }


struct CalendarView_Previews: PreviewProvider {
    static var previews: some View {
        CalendarView()
    }
}
