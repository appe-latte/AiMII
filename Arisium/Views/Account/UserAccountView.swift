//
//  UserAccountView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct UserAccountView: View {
    @State private var avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
    @State private var userName = UserDefaults.standard.string(forKey: "NAME") ?? "Username"
    @State private var email = UserDefaults.standard.string(forKey: "EMAIL") ?? "example@domain.com"
    
    @State private var isAvatar = false
    @State private var isLoading = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            VStack {
                // Navigation Bar
                navigationBar
                
                // Avatar
                avatarSelection
                
                // Form
                accountForm
                
                // "Save" button
                saveButton
                
                Spacer()
            }
        }
        .background(background())
    }
    
    private var navigationBar: some View {
        HStack(spacing: 10) {
            Button(action: { presentationMode.wrappedValue.dismiss() }) {
                Image(systemName: "chevron.left")
                    .fontWeight(.heavy)
                    .padding(10)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
            }
            
            Text("Your Profile")
                .font(.system(size: 22, weight: .heavy, design: .rounded))
                .kerning(1)
                .textCase(.uppercase)
                .foregroundColor(ai_black)
            
            
            Spacer()
        }
        .padding()
    }
    
    // MARK: Avatar Edit
    private var avatarSelection: some View {
        VStack(spacing: 5) {
            Button(action: { isAvatar.toggle() }) {
                if let image = UIImage(named: avatar) {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(6)
                        .background(ai_black)
                        .clipShape(Circle())
                } else {
                    Circle()
                        .fill(ai_grey)
                        .frame(width: 100, height: 100)
                        .overlay(
                            Text("+").foregroundColor(ai_white)
                        )
                }
            }
            
            Button("Edit") { isAvatar.toggle() }
                .font(.system(size: 14, weight: .bold, design: .rounded))
                .textCase(.uppercase)
                .kerning(0.5)
                .foregroundColor(ai_black)
                .sheet(isPresented: $isAvatar) {
                    avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "default_avatar"
                } content: {
                    AvatarView()
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
    
    // MARK: Profile Form
    private var accountForm: some View {
        VStack {
            TextField("Username", text: $userName)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .textCase(.uppercase)
                .kerning(0.5)
                .padding()
                .background(ai_grey.opacity(0.15))
                .cornerRadius(10)
                .foregroundColor(ai_white)
                .autocorrectionDisabled()
            
            Divider()
            
            TextField("Email", text: $email)
                .font(.system(size: 12, weight: .medium, design: .rounded))
                .textCase(.uppercase)
                .kerning(0.5)
                .padding()
                .background(ai_grey.opacity(0.15))
                .cornerRadius(10)
                .foregroundColor(ai_white)
                .autocorrectionDisabled()
        }
        .padding()
        .background(ai_black)
        .cornerRadius(20)
        .padding()
    }
    
    private var saveButton: some View {
        Button(action: saveAccountInfo) {
            if isLoading {
                ProgressView()
                    .padding()
                    .tint(.white)
            } else {
                Image(systemName: "checkmark")
                    .padding()
            }
        }
        .fontWeight(.heavy)
        .padding(10)
        .background(ai_black)
        .foregroundColor(ai_white)
        .clipShape(Circle())
    }
    
    private func saveAccountInfo() {
        isLoading = true
        let db = Firestore.firestore()
        let data: [String: Any] = [
            "NAME": userName,
            "EMAIL": email,
            "PROFILE": avatar,
        ]
        
        // Assuming "UID" is correctly stored in UserDefaults and valid
        if let userID = UserDefaults.standard.string(forKey: "UID") {
            db.collection("USERS").document(userID).setData(data) { error in
                isLoading = false
                if let error = error {
                    print("Error updating document: \(error)")
                } else {
                    UserDefaults.standard.set(userName, forKey: "NAME")
                    UserDefaults.standard.set(email, forKey: "EMAIL")
                    UserDefaults.standard.set(avatar, forKey: "PROFILE")
                    presentationMode.wrappedValue.dismiss()
                }
            }
        }
    }
}

#Preview {
    UserAccountView()
}
