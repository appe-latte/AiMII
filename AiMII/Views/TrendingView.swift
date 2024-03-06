//
//  TrendingView.swift
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

struct TrendingView: View {
    @Binding var quote: String
    @Binding var isClick: Bool
    
    var body: some View {
        VStack {
            headerView
            
            ScrollView(.horizontal, showsIndicators: false) {
                LazyHGrid(rows: [GridItem(.flexible())]) {
                    ForEach(trendingList, id: \.id) {
                        item in
                        
                        Button {
                            quote = item.text
                            isClick.toggle()
                        } label: {
                            Text("#\(item.text)")
                                .font(.system(size: 12, weight: .semibold, design: .monospaced))
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                                .textCase(.uppercase)
                                .kerning(0.25)
                                .padding()
                                .background(ai_black)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .foregroundColor(ai_white)
                        }
                    }
                }
                .padding(.horizontal)
            }
            
            Spacer()
        }
    }
    
    private var headerView: some View {
        HStack {
            Text("Trending")
                .font(.system(size: 23, weight: .bold, design: .monospaced))
                .foregroundStyle(ai_white)
                .kerning(1.25)
            
            Spacer()
        }
        .padding()
        .background(ai_black)
    }
}
