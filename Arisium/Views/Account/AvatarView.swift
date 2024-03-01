//
//  AvatarView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore

struct AvatarView: View {
    @State private var scale: CGFloat = 1.0
    @State private var isCompleted = false
    @State private var isShort = false
    @State private var isShow = false
    @State private var selection = ""
    @State private var isFromSetting = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack {
            background()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                if isShort {
                    HStack {
                        Text(isFromSetting ? "Avatar selection:" : "Select Avatar:")
                            .font(.headline)
                            .textCase(.uppercase)
                            .multilineTextAlignment(.center)
                            .foregroundColor(ai_black)
                            .padding(.top)
                        
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    
                    avatarSelectionGrid
                }
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .onAppear {
            animateLogoAndText()
        }
        .confirmationDialog("Confirm Avatar", isPresented: $isShow, titleVisibility: .visible) {
            Button("Confirm", action: saveAvatar)
            Button("Cancel", role: .cancel) { }
        } message: {
            Text("Do you want to set this as your avatar?")
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
    
    private var avatarSelectionGrid: some View {
        ScrollView {
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible()), GridItem(.flexible())]) {
                ForEach(avatarList) { avatar in
                    Button {
                        selection = avatar.image
                        isShow = true
                    } label: {
                        VStack {
                            Image(avatar.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 75, height: 75)
                                .clipShape(Circle())
                                .padding(3)
                                .background(selection == avatar.image ? ai_red.opacity(0.7) : ai_grey.opacity(0.2))
                                .clipShape(Circle())
                            
                            Text(avatar.title)
                                .font(.caption)
                                .fontWeight(.semibold)
                                .foregroundColor(ai_black)
                        }
                    }
                    .buttonStyle(.plain)
                }
            }
            .padding()
        }
    }
    
    
    private func animateLogoAndText() {
        withAnimation(.easeIn(duration: 1)) {
            scale = 0.4
            isShort = true
        }
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            withAnimation(.easeIn(duration: 1.0)) {
                isShow = true
            }
        }
    }
    
    private func saveAvatar() {
        let db = Firestore.firestore()
        let data: [String: Any] = ["PROFILE": selection]
        
        UserDefaults.standard.set(selection, forKey: "PROFILE")
        
        db.collection("USERS").document(UserDefaults.standard.string(forKey: "UID") ?? "").updateData(data) { error in
            if let error = error {
                print("Error updating document: \(error)")
            } else {
                print("Document successfully updated")
                if isFromSetting {
                    presentationMode.wrappedValue.dismiss()
                } else {
                    isCompleted = true
                }
            }
        }
    }
}

struct AvatarModel: Identifiable {
    let id = UUID()
    let image : String
    let title : String
}

let avatarList: [AvatarModel] = (1...20).map { AvatarModel(image: "avt\($0)", title: "AiMII \($0)") }

#Preview {
    AvatarView()
}
