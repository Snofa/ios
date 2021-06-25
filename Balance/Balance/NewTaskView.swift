//
//  NewTaskView.swift
//  appBalance
//
//  Created by student on 02.06.2021.
//

import SwiftUI

struct NewTaskView: View {
    
    let formatter: NumberFormatter = {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter
    }()
    @ObservedObject var locManager = LocationManager()
    @Environment(\.managedObjectContext) private var viewContext
    @State var taskDecription: String = ""
    @State var countMoney: String = "0.0"
    @State var taskType = TypeTransaction.expense
    @State var pickCategory: String = "Other"
    @Binding var isViewPresented: Bool
    
    var TypeCategory:[String] = [
         "food", "car", "transport", "house", "taxi", "health", "restaurant", "toiletry", "entertainment", "sports", "clother", "communication", "gifts", "pets", "other"]

      
    
    enum TypeTransaction:String, CaseIterable, Identifiable {
        case income
        case expense
        
        var id: String { self.rawValue }
    }
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Description")){
                    TextField("No description", text: $taskDecription)
                    
                }
                Section(header: Text("Type transaction")){
                    
                    Picker("Type", selection: $taskType)  {
                        Text("income").tag(TypeTransaction.income)
                        Text("expense").tag(TypeTransaction.expense)
                        
                    }
                }
                Section(header: Text("Category")){
                    Picker("Category", selection: $pickCategory) {
                        
                        ForEach(TypeCategory,id: \.self ){ temp in
                            Text("\(temp)").tag(temp)
                            
                        }
                    }
                        
  
                }
                Section(header: Text("Money")){
                    TextField("Money",text: $countMoney)
                        .keyboardType(.numberPad)
                }
            
                
            }
            .navigationBarTitle(Text("New transaction"))
            .toolbar{
                ToolbarItemGroup(placement: .navigationBarLeading){
                    Button(action: {
                        self.isViewPresented = false
                    }) {
                        Text("Cancel")
                    }
                }
                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        addItem()
                        self.isViewPresented = false
                    }) {
                        Text("Save")
                    }
                }
            }
        }
    }
    private func addItem() {
        
        let newTask = Invoice(context: viewContext)
        newTask.date = Date()
        newTask.descriptionText = self.taskDecription
        if(self.taskType.rawValue == "income"){
            newTask.category = "Salary"
        }else {
            newTask.category = self.pickCategory
        }
        newTask.type = self.taskType.rawValue
        newTask.money = Double(self.countMoney) ?? 0.0
        if let lat = locManager.location?.coordinate.latitude{
            newTask.latitude = lat
            print(lat)
        }
        if let long = locManager.location?.coordinate.longitude{
            newTask.longitude  = long
            print(long)
        }
        
        
        do {
            try viewContext.save()
            print("Task saved.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}


struct NewTaskView_Previews: PreviewProvider {
    static var previews: some View {
        NewTaskView(isViewPresented: .constant(true))
    }
}
