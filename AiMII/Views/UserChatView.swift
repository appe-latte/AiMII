//
//  UserChatView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import Firebase
import FirebaseFirestore

struct UserChatView: View {
    @Binding var quote: String
     @Binding var isAutomation: Bool
     @Binding var trending: Bool

     @State private var isRecent = false
     @State private var userName = "AiMII User"  // Default username
     @State private var avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"

     @StateObject private var dataController = LocalData()
    
    var body: some View {
        NavigationView {
            VStack {
                userHeader
                ScrollView {
                    // MARK: Recent Searches Section
                    recentSearches
                    
                    // MARK: Automation Section
//                    automationSection
                    
                    // MARK: Trending Prompts Section
                    trendingSection
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background())
            .foregroundColor(.white)
            .navigationTitle("Chat")
            .navigationBarHidden(true)
        }
    }
    
    private var userHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Good Morning,")
                    .font(.system(size: 16, weight: .semibold, design: .rounded))
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(ai_black)
                
                Text(userName)
                    .font(.system(size: 22, weight: .heavy, design: .rounded))
                    .kerning(1)
                    .foregroundColor(ai_black)
            }
            
            Spacer()
            
            profileImage
        }
        .padding()
    }
    
    private var profileImage: some View {
        Image(UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1")
            .resizable()
            .scaledToFit()
            .frame(width: 60, height: 60)
            .clipShape(Circle())
            .padding(6)
            .background(ai_black)
            .clipShape(Circle())
    }
    
    private var recentSearches: some View {
        NavigationLink(destination: ChatHistoryView(isChatView: $isRecent)
                        .environment(\.managedObjectContext, dataController.container.viewContext)) {
            RecentView(isClick: $isRecent)
        }
    }
    
    private var automationSection: some View {
        Automation(isClick: $isAutomation, quote: $quote)
    }
    
    private var trendingSection: some View {
        Trending(quote: $quote, isClick: $trending)
    }
    
    // MARK: Fetch the username from Firebase
        private func fetchUsername() {
            let db = Firestore.firestore()
            let userId = UserDefaults.standard.string(forKey: "UID") ?? ""

            db.collection("USERS").document(userId).getDocument { document, error in
                if let document = document, document.exists {
                    let data = document.data()
                    if let fetchedUsername = data?["NAME"] as? String {
                        self.userName = fetchedUsername
                    }
                } else {
                    print("Document does not exist")
                    // Handle errors or absence of data as needed
                }
            }
        }
    
    // MARK: Background
    @ViewBuilder
    func background() -> some View {
        GeometryReader { proxy in
            let size = proxy.size
            
            Image("bg-img")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .offset(y: -50)
                .frame(width: size.width, height: size.height + 50)
                .clipped()
        }
        .edgesIgnoringSafeArea(.all)
    }
}

#Preview {
    UserChatView(quote: .constant(""), isAutomation: .constant(false), trending: .constant(false))
}
