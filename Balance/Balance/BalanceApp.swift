//
//  BalanceApp.swift
//  Balance
//
//  Created by student on 21.06.2021.
//

import SwiftUI

@main
struct BalanceApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
    }
}
}
