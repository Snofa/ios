//
//  ContentView.swift
//  exam
//
//  Created by student on 22.06.2021.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Kniha.created, ascending: true)],
        animation: .default)
    private var books: FetchedResults<Kniha>

    @State var showNewItem: Bool = false

    var body: some View {
        NavigationView{
            List {
                ForEach(books) { book in
                    NavigationLink(destination: DetailView(book: book)){
                        VStack(alignment: .leading){
                            HStack{
                                VStack{
                                    Text("\(book.nazev ?? "Nazev not set")")
                                    Text("\(book.autor ?? "Autor not set")")
                                }
                                Spacer()
                                if let myImg = book.img {
                                    Image(uiImage: UIImage(data: myImg ) ?? UIImage()).resizable().frame(width: 100, height: 100)
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

                ToolbarItemGroup(placement: .navigationBarTrailing){
                    Button(action: {
                        self.showNewItem = true
                    }) {
                        Label("Add Item", systemImage: "plus")
                    }
                }
            }
            .navigationBarTitle(Text("Knihy"))
            .sheet(isPresented: $showNewItem){
                NewBookView(isViewPresented: $showNewItem)
            }
        }
    }
    
    

    private func addItem() {
        withAnimation {
            let newBook = Kniha(context: viewContext)
            newBook.created = Date()
            newBook.nazev = "Test test"
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
            offsets.map { books[$0] }.forEach(viewContext.delete)

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
