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
    @State var isAvatar = false
    @State var isLoading = false
    @State var avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
    
    @State var first = UserDefaults.standard.string(forKey: "NAME") ?? "Your Name"
    @State var email = UserDefaults.standard.string(forKey: "EMAIL") ?? "example@domain.com"
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            HStack {
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.left")
                        .bold()
                        .foregroundColor(.white)
                }
                .foregroundColor(.black)
                
                Text("  My Account")
                    .font(.title2)
                    .bold()
                
                Spacer()
            }
            .padding(.horizontal)
            .padding(.horizontal)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            
            
            
            VStack {
                Button {
                    isAvatar.toggle()
                } label: {
                    Image("\(avatar)")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .clipShape(Circle())
                        .padding(6)
                        .background(.white.opacity(0.1))
                        .clipShape(Circle())
                }
                
                Button {
                    isAvatar.toggle()
                } label: {
                    Text("Change Profile")
                        .font(.caption)
                }
                .sheet(isPresented: $isAvatar, onDismiss: {
                    avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
                }) {
                    AvatarView()
                }
                
                VStack {
                    TextField("First Name", text: $first)
                        .padding()
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                    
                    Divider()
                    
                    TextField("Email", text: $email)
                        .padding()
                        .foregroundColor(.white)
                        .autocorrectionDisabled()
                }
                .padding()
                .frame(maxWidth: .infinity)
                .overlay(RoundedRectangle(cornerRadius: 20).stroke(.white.opacity(0.3), lineWidth: 2))
                .padding()
                
            }
            
            Spacer()
            
            Button {
                let db = Firestore.firestore()
                let data : [String: Any] = [
                    "NAME" : first,
                    "EMAIL" : email,
                    "PROFILE" : "avt1",
                ]
                
                UserDefaults.standard.set(first, forKey: "NAME")
                UserDefaults.standard.set("avt1", forKey: "PROFILE")
                UserDefaults.standard.set(email, forKey: "EMAIL")
                
                db.collection("USERS").addDocument(data: data)
                isLoading.toggle()
                
                presentationMode.wrappedValue.dismiss()
            } label: {
                if isLoading {
                    ProgressView()
                        .padding()
                        .tint(.black)
                } else {
                    Image(systemName: "arrow.right")
                        .padding()
                }
            }
            .background(.white)
            .foregroundColor(.black)
            .clipShape(Circle())
            
        }
        .background(Image("gradient").resizable().scaledToFill().blur(radius: 150))
        .background(.black)
        .foregroundColor(.white)
    }
}

#Preview {
    UserAccountView()
}
