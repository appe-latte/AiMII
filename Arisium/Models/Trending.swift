//
//  Trending.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

var trendingList: [RecentModel] = [
    RecentModel(text: "Hello World!"),
    RecentModel(text: "Job UX"),
    RecentModel(text: "Google CEO"),
    RecentModel(text: "India's Capital"),
]

struct Trending: View {
    
    @Binding var quote: String
    @Binding var isClick: Bool
    
    var body: some View {
        VStack {
            HStack {
                Text("Trending Prompts")
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(ai_black)
                
                Spacer()
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(trendingList, id: \.id) {
                        item in
                        
                        Button {
                            quote = item.text
                            isClick.toggle()
                        } label: {
                            Text("#\(item.text)")
                                .font(.system(size: 12, weight: .bold))
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                                .kerning(0.25)
                                .padding()
                                .background(ai_black)
                                .clipShape(Capsule())
                                .overlay(Capsule().stroke(.white, lineWidth: 2))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
