//
//  NewBookView.swift
//  exam
//
//  Created by student on 22.06.2021.
//

import SwiftUI

struct NewBookView: View {
    @Environment(\.managedObjectContext) private var viewContext

    
    @State var bookObsah: String = ""
    @State var bookName: String = ""
    @State var bookAutor: String = ""
    @State var image: UIImage = UIImage()
    @State var isPhotoLibPresented = false
    
    
    @Binding var isViewPresented: Bool
    
    var body: some View {
        NavigationView{
            Form{
                Section(header: Text("Nazev knihy")){
                    TextField("Nazev",text: $bookName)
                }
                Section(header: Text("Autor knihy")){
                    TextField("Autor",text: $bookAutor)
                }
                Section(header: Text("Obsah knihy")){
                    TextEditor(text: $bookObsah)
                }
                
                Section(header: Text("Obrazek")){
                    Image(uiImage: self.image)
                        .resizable()
                        .scaledToFill()
                    Button(action: {
                        self.isPhotoLibPresented = true
                    }){
                        Text("Obrazek")
                    }.sheet(isPresented: $isPhotoLibPresented){
            
                        ImagePicker(selectedImage: $image, isPickerPresented: $isPhotoLibPresented, sourceType: .photoLibrary)
                    }
                }
            }
            .navigationBarTitle(Text("Nova kniha"))
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
        let standartImg:UIImage  = UIImage(systemName: "book") ?? UIImage()
        
        let newBook = Kniha(context: viewContext)
        newBook.created = Date()
        newBook.obsah = self.bookObsah
        newBook.autor = self.bookAutor
        newBook.nazev = self.bookName
        if isPhotoLibPresented {
            newBook.img = self.image.pngData()
        }else{
            newBook.img = standartImg.pngData()
            
        }
        
        
        do {
            try viewContext.save()
            print("Book saved.")
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
}

struct NewBookView_Previews: PreviewProvider {
    static var previews: some View {
        NewBookView(isViewPresented: .constant(true))
    }
}

