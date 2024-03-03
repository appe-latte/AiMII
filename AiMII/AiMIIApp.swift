//
//  ArisiumApp.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-28.
//

import SwiftUI
import Foundation
import FirebaseCore
import GoogleSignIn

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        return true
    }
    
    func application(_ app: UIApplication,
                     open url: URL,
                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        return GIDSignIn.sharedInstance.handle(url)
    }
}

@main
struct ArisiumApp: App {
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
                .environment(\.managedObjectContext,
                              dataController.container.viewContext)
                .preferredColorScheme(.dark)
        }
    }
}
