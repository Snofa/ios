//
//  examApp.swift
//  exam
//
//  Created by student on 22.06.2021.
//

import SwiftUI

@main
struct examApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
