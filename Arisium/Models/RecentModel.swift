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
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Image(systemName: "arrow.up.right")
                    .padding(10)
                    .background(.white)
                    .clipShape(Circle())
                    .foregroundColor(.black)
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(messages.messages, id: \.id) {
                        item in
                        
                        if item.sender == "user" {
                            Text("\(item.content!)")
                                .font(.system(size: 14))
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
