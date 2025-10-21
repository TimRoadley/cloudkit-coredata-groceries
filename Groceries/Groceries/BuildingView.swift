//
//  ContentView.swift
//  Groceries
//
//  Created by Tim Roadley on 19/10/2025.
//

import SwiftUI
import CoreData

struct BuildingView: View {
    @Environment(\.managedObjectContext) private var viewContext

    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \Building.name, ascending: true)],
        animation: .default)
    private var buildings: FetchedResults<Building>

    var body: some View {
        NavigationView {
            List {
                ForEach(buildings) { building in
                    NavigationLink {
                        Text("Building: \(building.name!)")
                    } label: {
                        Text(building.name!)
                    }
                }
                .onDelete(perform: deleteBuildings)
            }
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    EditButton()
                }
                ToolbarItem {
                    Button(action: addBuilding) {
                        Label("Add Building", systemImage: "plus")
                    }
                }
            }
            Text("Select a building")
        }
    }

    private func addBuilding() {
        withAnimation {
            log.info("Creating a new building")
            let newBuilding = Building(context: viewContext)
            newBuilding.name = "Whatever"
            newBuilding.buildingType = 123
            
            log.info("Created a new building!")
            
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

    private func deleteBuildings(offsets: IndexSet) {
        withAnimation {
            offsets.map { buildings[$0] }.forEach(viewContext.delete)

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

#Preview {
    BuildingView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
