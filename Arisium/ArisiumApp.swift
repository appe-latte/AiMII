//
//  ArisiumApp.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-28.
//

import SwiftUI

@main
struct ArisiumApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
