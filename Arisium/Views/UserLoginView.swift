//
//  UserLoginView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import FirebaseCore
import GoogleSignIn
import FirebaseAuth
import FirebaseFirestore

struct UserLoginView: View {
    @State private var scale: CGFloat = 1.0
    @State private var isCompleted = false
    @State var isShort = false
    @State var isShow = false
    
    @State var email : String = ""
    @State var password : String = ""
    @State var userName : String = ""
    
    @State var isUserSignedUp = false
    @State var isUserSignedIn = false
    @State var isLoading = false
    
    var body: some View {
        if isUserSignedIn {
            AvatarView()
        } else {
            VStack {
                LogoView()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 200)
                    .frame(maxHeight: .infinity)
                    .scaleEffect(scale)
                
                if isShort {
                    Text(isUserSignedUp ? "Create new account" : "Let’s get Started")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                        .textCase(.uppercase)
                        .multilineTextAlignment(.center)
                        .foregroundColor(ai_black)
                        .opacity(isShow ? 1 : 0)
                    
                    VStack {
                        if isUserSignedUp {
                            HStack {
                                TextField("Username", text: $userName)
                                    .font(.system(size: 12, weight: .medium, design: .rounded))
                                    .textCase(.uppercase)
                                    .kerning(0.5)
                                    .padding()
                                    .background(ai_grey.opacity(0.15))
                                    .cornerRadius(10)
                                    .foregroundColor(ai_white)
                                    .autocorrectionDisabled()
                            }
                            
                            Divider()
                        }
                        
                        TextField("Email", text: $email)
                            .font(.system(size: 12, weight: .medium, design: .rounded))
                            .textCase(.uppercase)
                            .kerning(0.5)
                            .padding()
                            .background(ai_grey.opacity(0.15))
                            .cornerRadius(10)
                            .foregroundColor(ai_white)
                            .autocorrectionDisabled()
                        
                        Divider()
                        
                        HStack {
                            SecureField("Password", text: $password)
                                .font(.system(size: 12, weight: .medium, design: .rounded))
                                .textCase(.uppercase)
                                .kerning(0.5)
                                .padding()
                                .background(ai_grey.opacity(0.15))
                                .cornerRadius(10)
                                .foregroundColor(ai_white)
                                .autocorrectionDisabled()
                            
                            if password.count > 0 {
                                HStack {
                                    HStack {
                                        Button {
                                            if isUserSignedUp {
                                                Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
                                                    if error != nil {
                                                        print(error?.localizedDescription ?? "")
                                                        isLoading.toggle()
                                                    } else {
                                                        let db = Firestore.firestore()
                                                        let data : [String: Any] = [
                                                            "NAME" : userName,
                                                            "EMAIL" : email,
                                                            "PROFILE" : "avt1",
                                                        ]
                                                        
                                                        UserDefaults.standard.set(result?.user.uid, forKey: "UID")
                                                        UserDefaults.standard.set(userName, forKey: "NAME")
                                                        UserDefaults.standard.set("avt1", forKey: "PROFILE")
                                                        UserDefaults.standard.set(email, forKey: "EMAIL")
                                                        
                                                        db.collection("USERS").addDocument(data: data)
                                                        isLoading.toggle()
                                                        isUserSignedIn.toggle()
                                                        
                                                    }
                                                }
                                            } else {
                                                UserDefaults.standard.setValue(email, forKey: "EMAIL")
                                                isCompleted.toggle()
                                                
                                                Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
                                                    if error != nil {
                                                        print(error?.localizedDescription ?? "")
                                                        isLoading.toggle()
                                                        
                                                    } else {
                                                        
                                                        Firestore.firestore().collection("USERS").document(result?.user.uid ?? "").getDocument { (document, error) in
                                                            if let document = document, document.exists {
                                                                
                                                                let name = document.get("NAME") as? String ?? ""
                                                                let profile = document.get("PROFILE") as? String ?? ""
                                                                
                                                                UserDefaults.standard.set(name, forKey: "NAME")
                                                                UserDefaults.standard.set(result?.user.uid, forKey: "UID")
                                                                UserDefaults.standard.set(profile, forKey: "PROFILE")
                                                                UserDefaults.standard.set(email, forKey: "EMAIL")
                                                                
                                                                isLoading.toggle()
                                                                
                                                                isUserSignedIn.toggle()
                                                                
                                                                
                                                            } else {
                                                                isLoading.toggle()
                                                                
                                                                print("Document does not exist")
                                                            }
                                                        }
                                                    }
                                                }
                                            }
                                        } label: {
                                            if isLoading {
                                                ProgressView()
                                                    .padding()
                                                    .tint(ai_black)
                                            } else {
                                                Image(systemName: "chevron.right")
                                                    .fontWeight(.heavy)
                                                    .padding(10)
                                                    .background(ai_black)
                                                    .foregroundColor(ai_white)
                                                    .clipShape(Circle())
                                            }
                                        }
                                        .background(ai_white)
                                        .foregroundColor(ai_black)
                                        .clipShape(Circle())
                                    }
                                    .padding(6)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ai_black)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .opacity(isShow ? 1 : 0)
                    .padding()
                    
                    // Continue With
                    if isShow {
                        HStack {
                            VStack {
                                Divider()
                            }
                            
                            Text("or")
                                .font(.system(size: 18, weight: .semibold, design: .monospaced))
                                .kerning(1.0)
                                .foregroundStyle(ai_black)
                            
                            VStack {
                                Divider()
                            }
                        }
                        
                        HStack {
                            Button {
                                guard let clientID = FirebaseApp.app()?.options.clientID else { return }
                                
                                isLoading.toggle()
                                
                                let config = GIDConfiguration(clientID: clientID)
                                GIDSignIn.sharedInstance.configuration = config
                                
                                GIDSignIn.sharedInstance.signIn(withPresenting: getRootViewController()) { result, error in
                                    
                                    guard let user = result?.user,
                                          let idToken = user.idToken?.tokenString
                                    else {
                                        return
                                    }
                                    
                                    let credential = GoogleAuthProvider.credential(withIDToken: idToken,
                                                                                   accessToken: user.accessToken.tokenString)
                                    
                                    Auth.auth().signIn(with: credential) { result, error in
                                        UserDefaults.standard.set(result?.user.uid, forKey: "UID")
                                        UserDefaults.standard.set(result?.user.photoURL, forKey: "PROFILE")
                                        UserDefaults.standard.set(result?.user.displayName, forKey: "NAME")
                                        UserDefaults.standard.set(result?.user.email, forKey: "EMAIL")
                                        
                                    }
                                    
                                    isLoading.toggle()
                                    
                                    isUserSignedIn.toggle()
                                    
                                }
                            } label: {
                                Text("Google")
                                    .font(.system(size: 18, weight: .semibold, design: .monospaced))
                                    .kerning(1.0)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 50)
                            }
                            .background(ai_black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            
                        }
                        .opacity(isShow ? 1 : 0)
                        .foregroundColor(.white)
                        .padding()
                    }
                }
                
                if isShort {
                    Spacer()
                        .frame(maxHeight: .infinity)
                    
                    Button {
                        withAnimation(.easeIn(duration: 1)) {
                            scale = scale == 0.4 ? 1.0 : 1.0
                            isShort.toggle()
                            isShow.toggle()
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                            withAnimation(.easeIn(duration: 1)) {
                                scale = scale == 1.0 ? 0.4 : 0.4
                                isShort.toggle()
                            }
                        }
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                            withAnimation(.easeIn(duration: 1.0)) {
                                isShow.toggle()
                            }
                        }
                        
                        isUserSignedUp.toggle()
                        
                    } label: {
                        Text(isUserSignedUp ? "Already have an account? Sign in" : "Create new Account? Sign up")
                            .font(.system(size: 12, weight: .semibold, design: .monospaced))
                            .textCase(.uppercase)
                            .kerning(1.0)
                    }
                    .foregroundColor(ai_white)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(ai_black)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .background(background())
            .foregroundColor(.white)        .onAppear() {
                withAnimation(.easeIn(duration: 1)) {
                    scale = scale == 1.0 ? 0.4 : 0.4
                    isShort.toggle()
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                    withAnimation(.easeIn(duration: 1.0)) {
                        isShow.toggle()
                    }
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    UserLoginView()
}
