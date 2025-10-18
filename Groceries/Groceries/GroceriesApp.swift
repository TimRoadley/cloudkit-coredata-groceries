//
//  GroceriesApp.swift
//  Groceries
//
//  Created by Tim Roadley on 19/10/2025.
//

import SwiftUI
import CoreData

@main
struct GroceriesApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
