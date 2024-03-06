//
//  RecentModel.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct RecentModel: Identifiable {
    var id: UUID = .init()
    var text: String
}

struct RecentView: View {
    @StateObject var messages = LocalData()
    @Binding var isClick: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Recent Chats")
                    .font(.system(size: 16, weight: .bold, design: .monospaced))
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(ai_black)
                
                Spacer()
                
                Image(systemName: "chevron.right")
                    .fontWeight(.heavy)
                    .padding(10)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(messages.messages, id: \.id) {
                        item in
                        
                        if item.sender == "user" {
                            Text("\(item.content!)")
                                .font(.system(size: 14, design: .monospaced))
                                .foregroundColor(.black)
                                .padding()
                                .background(.white.opacity(0.5))
                                .clipShape(Capsule())
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
