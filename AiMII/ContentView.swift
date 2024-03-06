//
//  ContentView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-28.
//
import SwiftUI

struct ContentView: View {
    @State var selectedIndex = 0
    @State var isChatView = false
    //    @State var isAutomation = false
    @State var quote = ""
    @State var isTrending = false
    @State var isSignedOut = false
    
    var body: some View {
        if isSignedOut {
            LandingView()
        } else {
            if isChatView {
                NewChat(quote: quote, isClick: $isChatView)
            } else {
                ZStack {
                    ZStack {
                        switch (selectedIndex) {
                        case 0:
                            UserChatView(quote: $quote)
                        case 1:
                            ChatHistoryView(isChatView: .constant(true))
                        case 2:
                            TrendingView(quote: $quote, isClick: $isTrending)
                        case 3:
                            SettingsView(isSignedOut: $isSignedOut)
                        default:
                            UserChatView(quote: $quote)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        
                        ZStack {
                            HStack(alignment: .center, spacing: 20) {
                                Spacer()
                                
                                // MARK: Home Screen
                                Button {
                                    selectedIndex = 0
                                } label: {
                                    VStack(spacing: 5) {
                                        Image("home")
                                            .font(.subheadline)
                                        
                                        Text("Home")
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .kerning(0.75)
                                    }
                                }
                                
                                // MARK: Chat History
                                Button {
                                    selectedIndex = 1
                                } label: {
                                    VStack(spacing: 5) {
                                        Image("history")
                                            .font(.subheadline)
                                        
                                        Text("History")
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .kerning(0.75)
                                    }
                                }
                                
                                // MARK: Trending Prompts
                                Button {
                                    selectedIndex = 2
                                } label: {
                                    VStack(spacing: 5) {
                                        Image("trending")
                                            .font(.subheadline)
                                        
                                        Text("Trending")
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .kerning(0.75)
                                    }
                                }
                                
                                // MARK: Settings
                                Button {
                                    selectedIndex = 3
                                } label: {
                                    VStack(spacing: 5) {
                                        Image("settings")
                                            .font(.subheadline)
                                        
                                        Text("Settings")
                                            .font(.system(size: 12, weight: .medium, design: .monospaced))
                                            .kerning(0.75)
                                    }
                                }
                                
                                // MARK: Profile Avatar
                                profileImage
                                
                                Spacer()
                                
                            }
                            .padding(10)
                            .imageScale(.medium)
                            .foregroundColor(ai_white)
                            .background(ai_black)
                        }
                        .frame(maxWidth: .infinity, maxHeight: 150, alignment: .bottomLeading)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(background())
            }
        }
    }
    
    private var profileImage: some View {
        Image(UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1")
            .resizable()
            .scaledToFit()
            .frame(width: 30, height: 30)
            .clipShape(Circle())
            .padding(3)
            .background(ai_grey)
            .clipShape(Circle())
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
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
