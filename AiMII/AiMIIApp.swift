//
//  AiMiiApp.swift
//  AiMII
//
//  Created by Stanford L. Khumalo on 2024-02-28.
//

import SwiftUI
import Foundation
import CoreData
import FirebaseCore
import GoogleSignIn

@main
struct AiMIIApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var dataController = LocalData()
    
    init() {
        Constants.count = UserDefaults.standard.integer(forKey: "Count")
        
        let date = Date()
        let dateFormatter = DateFormatter()
        
        if UserDefaults.standard.string(forKey: "date") != dateFormatter.string(from: date) {
            UserDefaults.standard.set(dateFormatter.string(from: date), forKey: "date")
            UserDefaults.standard.set(0, forKey: "Count")
        }
    }
    
    
    var body: some Scene {
        WindowGroup {
            LandingView()
                .environment(\.managedObjectContext, dataController.container.viewContext)
        }
    }
}
