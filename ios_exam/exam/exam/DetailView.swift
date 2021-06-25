//
//  DetailView.swift
//  exam
//
//  Created by student on 22.06.2021.
//

import SwiftUI

struct DetailView: View {
    var book: Kniha? = nil
    @State var img: UIImage
    
    init(book: Kniha) {
        self.book = book
        if let imgData = book.img{
            self._img = .init(initialValue: UIImage(data: imgData) ?? UIImage())
        } else {
            self._img = .init(initialValue: UIImage())
        }
    }
    
    var body: some View {
        Form{
            Section(header: Text("Image")){
                Image(uiImage: self.img)
                    .resizable()
                    .scaledToFill()
                    .overlay(Text("\(book?.nazev ?? "Nema nazev")").font(.system(size: 30, weight: .light, design: .serif))
                                .bold(), alignment: .bottomTrailing)
            }
            Section(header: Text("Autor")){
                Text("\(book?.autor ?? "Nema autora")")
            }
            Section(header: Text("Obsah")){
                Text("\(book?.obsah ?? "Nema obsah")").fixedSize(horizontal: false, vertical: true)
            }
        }
        .navigationBarTitle(Text("Book Detail"))
        
//        .toolbar {
//            ToolbarItemGroup(placement: .navigationBarLeading){
//                #if os(iOS)
//                EditButton()
//                #endif
//            }
//        }
    
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView{
            DetailView(book: Kniha())
        }
    }
}
