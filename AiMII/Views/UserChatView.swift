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
    @State private var userName = "AiMII user"  // Default username
    @State private var avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
    @State var isChatView = false
    @State private var isRecent = false
    @Binding var quote: String
    
    @StateObject private var dataController = LocalData()
    
    var body: some View {
        NavigationView {
            VStack {
                userHeader
                
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background())
            .foregroundColor(ai_white)
            .navigationBarHidden(true)
        }
    }
    
    // MARK: Header Section
    private var userHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 5) {
                Text("Hello,")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(ai_white)
                
                Text(userName)
                    .font(.system(size: 18, weight: .bold, design: .monospaced))
                    .kerning(1)
                    .foregroundColor(ai_white)
            }
            
            Spacer()
            
            // MARK: "New Chat"
            Button {
                isChatView.toggle()
            } label: {
                Image(systemName: "plus")
                    .fontWeight(.heavy)
                    .padding()
                    .background(ai_white)
                    .clipShape(Circle())
                    .foregroundColor(ai_black)
            }
        }
        .padding()
        .background(ai_black)
    }
    
    private var recentSearches: some View {
        NavigationLink(destination: ChatHistoryView(isChatView: $isRecent)
            .environment(\.managedObjectContext, dataController.container.viewContext)) {
                RecentView(isClick: $isRecent)
            }
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
    UserChatView(quote: .constant(""))
}
