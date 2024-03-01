//
//  UserChatView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct UserChatView: View {
    @Binding var quote : String
    @Binding var isAutomation :Bool
    @Binding var Trending: Bool
    
    @State var isRecent = false
    
    @StateObject private var dataController = LocalData()
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    VStack(alignment: .leading) {
                        Text("Good Morning,")
                            .font(.title2)
                        
                        Text("Aimee User")
                            .font(.title)
                            .bold()
                    }
                    
                    Spacer()
                    
                    Image("\(UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1")")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                        .clipShape(Circle())
                        .padding(6)
                        .background(.white.opacity(0.1))
                        .clipShape(Circle())
                }
                .padding()
                
                ScrollView {
                    // Recent Search's
                    NavigationLink {
                        ChatView(isChatView: $isRecent)
                            .environment(\.managedObjectContext,
                                          dataController.container.viewContext)
                    } label: {
                        RecentView(isClick: $isRecent)
                    }
                    
                    
                    // Automation
                    Automation(isClick: $isAutomation, quote: $quote)
                    
                    // Treanding
                    Arisium.Trending(quote: $quote, isClick: $Trending)
                    
                }
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Image("gradient").resizable().scaledToFill().blur(radius: 150))
            .background(.black)
            .foregroundColor(.white)
        }
    }
}
