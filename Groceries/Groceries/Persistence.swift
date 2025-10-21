//
//  Persistence.swift
//  Groceries
//
//  Created by Tim Roadley on 19/10/2025.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    @MainActor
    static let preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        
        // Insert some example items
        for _ in 0..<5 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
        
        // Insert some example building
        let newBuilding = Building(context: viewContext)
        newBuilding.name = "Test Building"
        newBuilding.buildingType = 0
        
        do {
            try viewContext.save()
        } catch {
            let error = error as NSError
            #if DEBUG
                fatalError(
                    "Failed to save preview data: \(error), \(error.userInfo)"
                )
            #else
                log.error(
                    "Failed to save preview data: \(error), \(error.userInfo)"
                )
            #endif
        }
        return result
    }()

    let container: NSPersistentCloudKitContainer

    init(inMemory: Bool = false) {
        container = NSPersistentCloudKitContainer(name: "Groceries")
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(
                fileURLWithPath: "/dev/null"
            )
        }
        container.loadPersistentStores(completionHandler: {
            (storeDescription, error) in
            if let error = error as NSError? {
                #if DEBUG
                    fatalError("Unresolved error \(error), \(error.userInfo)")
                #else
                    log.error("Unresolved error \(error), \(error.userInfo)")
                #endif
            }
        })
        container.viewContext.automaticallyMergesChangesFromParent = true
    }
}
