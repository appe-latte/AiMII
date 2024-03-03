//
//  Persistence.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-28.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let result = PersistenceController(inMemory: true)
        let viewContext = result.container.viewContext
        for _ in 0..<10 {
            let newItem = Item(context: viewContext) // Assuming Item is a CoreData entity
            newItem.timestamp = Date()
        }
        do {
            try viewContext.save()
        } catch {
            // Improved error handling
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return result
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "YourCoreDataModelName") // Make sure to use your actual Core Data model name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                // It's better to handle the error in a more user-friendly way in a production app
                // This could include logging the error, attempting to recover, or displaying an error message to the user
                print("Unresolved error \(error), \(error.userInfo)")
                // fatalError("Unresolved error \(error), \(error.userInfo)") // Consider removing or handling differently for production
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        
        // Optionally, you may want to add this line to improve performance by avoiding unnecessary disk writes for unchanged data.
        container.viewContext.undoManager = nil
        
        // For debugging or development purposes, you might want to print the location of the SQLite file
        #if DEBUG
        if !inMemory, let url = container.persistentStoreDescriptions.first?.url {
            print("Core Data store location:", url)
        }
        #endif
    }
}
