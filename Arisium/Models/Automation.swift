//
//  Automation.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct AutomationModel: Identifiable {
    var id: UUID = .init()
    var icon: String
    var title: String
    var prompt: String
    var caption: String
}

var automationList: [AutomationModel] = [
    AutomationModel(icon: "handbag", title: "Today's food and beverages shopping", prompt: "Write an article", caption: "Based on your morning routine"),
    AutomationModel(icon: "handbag", title: "Today's food and beverages shopping", prompt: "", caption: "Based on your morning routine"),
    AutomationModel(icon: "handbag", title: "Today's food and beverages shopping", prompt: "", caption: "Based on your morning routine"),
]

struct Automation: View {
    
    @Binding var isClick: Bool
    @Binding var quote: String
    
    var body: some View {
        VStack {
            HStack {
                Text("Automation")
                    .font(.title3)
                    .bold()
                
                Spacer()
                
                Button {
                    isClick.toggle()
                } label: {
                    Image(systemName: "arrow.up.right")
                        .padding(10)
                        .background(.white)
                        .clipShape(Circle())
                        .foregroundColor(.black)
                }
            }
            .padding()
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(automationList, id: \.id) {
                        item in
                        
                        Button {
                            quote = item.prompt
                            isClick.toggle()
                        } label: {
                            VStack(alignment: .leading, spacing: 5) {
                                Image(systemName: item.icon)
                                
                                Text(item.title)
                                    .font(.title3)
                                    .lineLimit(2)
                                
                                Text(item.caption)
                                    .font(.caption2)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Button {
                                    quote = item.prompt
                                    isClick.toggle()
                                } label: {
                                    Text("Generate")
                                        .font(.caption)
                                }
                                .frame(maxWidth: .infinity)
                                .frame(height: 40)
                                .background(Color("Dark"))
                                .clipShape(Capsule())
                                .foregroundColor(.white)
                            }
                            .foregroundColor(.black)
                            .frame(width: 150, height: 150)
                            .padding()
                            .background(.white)
                            .clipShape(RoundedRectangle(cornerRadius: 26))
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
    }
}
