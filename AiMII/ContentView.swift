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
    @State var isAutomation = false
    @State var quote = ""
    @State var isTrending = false
    @State var isSignedOut = false
    
    var body: some View {
        if isSignedOut {
            LandingView()
        } else {
            if isChatView {
                NewChat(quote: quote, isClick: $isChatView)
            } else if isAutomation {
                NewChat(quote: quote, isClick: $isAutomation)
            } else if isTrending {
                NewChat(quote: quote, isClick: $isAutomation)
            } else {
                ZStack {
                    ZStack {
                        switch (selectedIndex) {
                        case 0:
                            UserChatView(quote: $quote, isAutomation: $isAutomation, trending: $isTrending)
                        case 1:
                            ChatHistoryView(isChatView: .constant(true))
                        case 2:
                            SettingsView(isSignedOut: $isSignedOut)
                        default:
                            UserChatView(quote: $quote, isAutomation: $isAutomation, trending: $isTrending)
                        }
                    }
                    .frame(maxHeight: .infinity)
                    
                    VStack {
                        Spacer()
                        
                        ZStack {
                            HStack {
                                Spacer()
                                
                                // MARK: Home Screen
                                Button {
                                    selectedIndex = 0
                                } label: {
                                    VStack {
                                        Image(systemName: "house")
                                        
                                        Text("Home")
                                            .font(.caption)
                                    }
                                }
                                
//                                Spacer()
//                                
//                                // MARK: "New Chat"
//                                Button {
//                                    isChatView.toggle()
//                                } label: {
//                                    Image(systemName: "plus")
//                                        .padding()
//                                        .background(.white)
//                                        .clipShape(Circle())
//                                        .foregroundColor(.black)
//                                }
                                
                                Spacer()
                                
                                // MARK: Chat History
                                Button {
                                    selectedIndex = 1
                                } label: {
                                    VStack {
                                        Image(systemName: "book.pages")
                                        
                                        Text("History")
                                            .font(.caption)
                                    }
                                }
                                
                                Spacer()
                                
                                // MARK: Settings
                                Button {
                                    selectedIndex = 2
                                } label: {
                                    VStack {
                                        Image(systemName: "gear")
                                        
                                        Text("Settings")
                                            .font(.caption)
                                    }
                                }
                                
                                Spacer()
                                
                            }
                            .padding([.top, .bottom])
                            .imageScale(.large)
                            .foregroundColor(.white)
                            .background(ai_black)
                            .clipShape(RoundedRectangle(cornerRadius: 15))
                            .padding()
                            .padding(.horizontal)
                        }
                        .frame(height: 150)
                    }
                    .ignoresSafeArea()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(background())
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
    ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
