//
//  SettingsView.swift
//  AiMII
//
//  Created by Stanford L. Khumalo on 2024-03-03.
//

import SwiftUI
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.openURL) var openURL
    
    @State var avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
    @State var first = UserDefaults.standard.string(forKey: "NAME") ?? "AiMII user"
    
    @State var isDeleteDialog = false
    @Binding var isSignedOut: Bool
    @State var isPremium = false
    @State var isAvatar = false
    @State var isChatHistory = false
    @State private var isPresentingShareSheet = false
    
    var body: some View {
        if isChatHistory {
            ChatHistoryView(isChatView: $isChatHistory)
        } else {
            ScrollView {
                VStack {
                    VStack(spacing: 10) {
                        Image("\(avatar)")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 70, height: 70)
                            .clipShape(Circle())
                            .padding(6)
                            .background(ai_black)
                            .clipShape(Circle())
                        
                        Text("\(first)")
                            .font(.system(size: 14, weight: .semibold, design: .monospaced
                                         ))
                            .textCase(.uppercase)
                            .kerning(0.75)
                            .foregroundColor(ai_black)
                    }
                    
                    if !UserDefaults.standard.bool(forKey: "isPremium") {
                        Button {
                            isPremium.toggle()
                        } label: {
                            HStack {
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Upgrade to AiMII+")
                                        .font(.system(size: 14, weight: .heavy, design: .monospaced))
                                        .textCase(.uppercase)
                                        .kerning(1.0)
                                        .multilineTextAlignment(.leading)
                                    
                                    Text("Get 7 Days free and\nunlock all Pro Features")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .textCase(.uppercase)
                                        .kerning(0.75)
                                        .multilineTextAlignment(.leading)
                                }
                                
                                Spacer()
                                
                                Button {
                                    isPremium.toggle()
                                } label: {
                                    Text("Upgrade")
                                        .font(.system(size: 12, weight: .bold, design: .monospaced))
                                        .textCase(.uppercase)
                                        .kerning(0.75)
                                }
                                .foregroundColor(ai_black)
                                .padding()
                                .background(ai_white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(ai_black)
                            .cornerRadius(15)
                            .padding(10)
                            .foregroundStyle(ai_white)
                        }
                        .fullScreenCover(isPresented: $isPremium, content: {
                            PremiumAccountView()
                        })
                    }
                    
                    VStack(spacing: 5) {
                        // MARK: User Account - button
                        Button {
                            isAvatar.toggle()
                        } label: {
                            ItemCard(title: "My Account", icon: "person", subtitle: "Edit your user profile.")
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        .sheet(isPresented: $isAvatar, onDismiss: {
                            avatar = UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1"
                            first = UserDefaults.standard.string(forKey: "NAME") ?? "username"
                        }) {
                            UserAccountView()
                        }
                        
                        // MARK: Send Feedback
                        Button {
                            openURL(URL(string: "mailto:hello@appe-latte.ca")!)
                        } label: {
                            ItemCard(title: "Send Feedback", icon: "ellipsis.message", subtitle: "Send us your feedback.")
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        
                        // MARK: Privacy Policy
                        Button {
                            openURL(URL(string: "https://www.apple.com")!)
                        } label: {
                            ItemCard(title: "Privacy Policy", icon: "checkerboard.shield", subtitle: "Link to our privacy policy.")
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        
                        // MARK: App Rating - button
                        Button {
                            openURL(URL(string: "mailto:hello@appe-latte.ca")!)
                        } label: {
                            ItemCard(title: "Rate This App", icon: "star", subtitle: "Rate us in the app store.")
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        
                        // MARK: Share sheet
                        Button(action: {
                            isPresentingShareSheet = true
                        }) {
                            ItemCard(title: "Share App", icon: "square.and.arrow.up", subtitle: "Love our app? Share it with your friends.")
                        }
                        .sheet(isPresented: $isPresentingShareSheet) {
                            ActivityView(activityItems: ["Check out this link: https://example.com"])
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        
                        // MARK: Log Out
                        Button {
                            //
                        } label: {
                            ItemCard(title: "Log Out", icon: "door.left.hand.open", subtitle: "Log out of the app.")
                        }
                        .foregroundColor(ai_white)
                        .buttonStyle(.plain)
                        
                        // MARK: Delete Account
                        Button {
                            isDeleteDialog.toggle()
                        } label: {
                            DeleteAccountCard(title: "Delete Account", icon: "trash", subtitle: "Permanently close and delete your account.")
                        }
                        .foregroundColor(ai_red)
                        .buttonStyle(.plain)
                        .alert(isPresented: $isDeleteDialog) {
                            Alert(
                                title: Text("Delete Item"),
                                message: Text("Are you sure you want to delete this item?"),
                                primaryButton: .destructive(Text("Delete"), action: {
                                    let db = Firestore.firestore()
                                    let firebaseAuth = Auth.auth()
                                    
                                    db.collection("USERS").document(firebaseAuth.currentUser?.uid ?? "").delete()
                                    UserDefaults.standard.set("", forKey: "NAME")
                                    UserDefaults.standard.set("", forKey: "UID")
                                    UserDefaults.standard.set("", forKey: "PROFILE")
                                    UserDefaults.standard.set("", forKey: "EMAIL")
                                    
                                    do {
                                        try firebaseAuth.signOut()
                                        isSignedOut.toggle()
                                    } catch let signOutError as NSError {
                                        print("Error signing out: %@", signOutError)
                                    }
                                }),
                                secondaryButton: .cancel(Text("Cancel"))
                            )
                        }
                        
                        // MARK: Appé Latte credits
                        VStack(alignment: .center, spacing: 3) {
                            HStack {
                                Text("Developed with")
                                    .font(.system(size: 8))
                                    .fontWeight(.medium)
                                    .kerning(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(ai_black)
                                
                                Text("\(Image(systemName: "heart.fill"))")
                                    .font(.system(size: 8))
                                    .fontWeight(.thin)
                                    .kerning(4)
                                    .textCase(.uppercase)
                                    .foregroundColor(ai_red)
                                
                                Text("by: Appè Latte")
                                    .font(.system(size: 8))
                                    .fontWeight(.medium)
                                    .kerning(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(ai_black)
                            }
                            .padding(.top, 10)
                            
                            // MARK: App Version + Build Number
                            HStack(spacing: 10) {
                                Text("App Version:")
                                    .font(.system(size: 7))
                                    .fontWeight(.medium)
                                    .kerning(2)
                                    .textCase(.uppercase)
                                    .foregroundColor(ai_black)
                                
                                if let buildNumber = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
                                    Text("\(UIApplication.appVersion!) (\(buildNumber))")
                                        .font(.system(size: 7))
                                        .fontWeight(.bold)
                                        .kerning(2)
                                        .textCase(.uppercase)
                                        .foregroundColor(ai_black)
                                }
                            }
                            .padding(.horizontal, 20)
                            
                            // MARK: Social Media links
                            HStack(spacing: 10) {
                                
                                // MARK: Instagram
                                Button(action: {
                                    openURL(URL(string: "https://www.instagram.com/appe.latte")!)
                                }, label: {
                                    Image("instagram")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(ai_black)
                                })
                                
                                // MARK: Facebook
                                Button(action: {
                                    openURL(URL(string: "https://www.facebook.com/appelatteltd")!)
                                }, label: {
                                    Image("facebook")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(ai_black)
                                })
                                
                                // MARK: Twitter
                                Button(action: {
                                    openURL(URL(string: "https://www.twitter.com/appe_latte")!)
                                }, label: {
                                    Image("twitter")
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 20, height: 20)
                                        .foregroundColor(ai_black)
                                })
                            }
                            .padding(10)
                        }
                    }
                    .background(ai_white.opacity(0.5))
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(10)
                }
                .padding(.bottom, 100)
                
            }
            .background(background())
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

struct ItemCard: View {
    var title: String
    var icon: String
    var subtitle: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        .kerning(1.5)
                        .foregroundColor(ai_black)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .kerning(0.75)
                        .foregroundColor(ai_black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .fontWeight(.heavy)
                    .padding(10)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
            }
            .padding(10)
            
            Divider()
                .background(ai_black.opacity(0.5))
        }
    }
}

struct DeleteAccountCard: View {
    var title: String
    var icon: String
    var subtitle: String
    
    var body: some View {
        VStack(spacing: 5) {
            HStack(spacing: 15) {
                Image(systemName: icon)
                    .fontWeight(.bold)
                    .padding(10)
                    .background(ai_red)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                VStack(alignment: .leading, spacing: 5) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                        .kerning(1.5)
                        .foregroundColor(ai_red)
                    
                    Text(subtitle)
                        .font(.system(size: 10, weight: .medium, design: .monospaced))
                        .kerning(0.75)
                        .foregroundColor(ai_black)
                }
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .fontWeight(.heavy)
                    .padding(10)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
            }
            .padding(10)
            
            Divider()
                .background(ai_black.opacity(0.5))
        }
    }
}

struct ActivityView: UIViewControllerRepresentable {
    let activityItems: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let activityViewController = UIActivityViewController(activityItems: activityItems, applicationActivities: nil)
        return activityViewController
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}


struct SettingsView_Previews: PreviewProvider {
    // Mock a binding variable for the preview
    @State static var isSignedOut = false
    
    static var previews: some View {
        // Provide the mock binding variable to SettingsView
        SettingsView(isSignedOut: $isSignedOut)
    }
}

// MARK: "App Version" extension
extension UIApplication {
    static var appVersion: String? {
        return Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String
    }
}
