//
//  Database.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import Foundation
import UIKit
import SwiftUI
import CoreData

class LocalData: ObservableObject {
    let container: NSPersistentContainer
    @Published var messages: [StoredMessage] = []
    
    init() {
        container = NSPersistentContainer(name: "LocalData")
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Failed to load data in DataController \(error.localizedDescription)")
            }
        }
        fetchRequest()
    }
    
    func save(context: NSManagedObjectContext) {
        do {
            try context.save()
            fetchRequest()
        } catch {
            // Handle errors in our database
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
    }
    
    func fetchRequest() {
        let request = NSFetchRequest<StoredMessage>(entityName: "StoredMessage")
        
        do {
            messages = try container.viewContext.fetch(request)
        } catch {
            print("Error fetching stored messages: \(error)")
        }
    }
    
    func addChat(list: Messages, context: NSManagedObjectContext) {
        let newItem = StoredMessage(context: context)
        newItem.id = list.id.uuidString
        newItem.content = list.content
        newItem.date = list.createAt
        
        switch list.role {
        case .assistant:
            newItem.sender = "assistant"
        case .user:
            newItem.sender = "user"
        case .system:
            newItem.sender = "system"
        }
        
        save(context: context)
    }
}

