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
                    .font(.title3)
                    .bold()
                
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
                                .font(.system(size: 14))
                                .foregroundColor(.white)
                                .padding()
                                .background(.black)
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
