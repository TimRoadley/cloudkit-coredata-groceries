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
        for _ in 0..<10 {
            let newItem = Item(context: viewContext)
            newItem.timestamp = Date()
        }
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
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
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
