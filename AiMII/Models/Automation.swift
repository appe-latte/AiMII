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
                    .font(.system(size: 16, weight: .heavy, design: .rounded))
                    .kerning(1)
                    .textCase(.uppercase)
                    .foregroundColor(ai_black)
                
                Spacer()
                
                Button {
                    isClick.toggle()
                } label: {
                    Image(systemName: "chevron.right")
                        .fontWeight(.heavy)
                        .padding(10)
                        .background(ai_black)
                        .foregroundColor(ai_white)
                        .clipShape(Circle())
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
                                    .fontDesign(.monospaced)
                                    .lineLimit(2)
                                
                                Text(item.caption)
                                    .font(.caption2)
                                    .fontDesign(.monospaced)
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Button {
                                    quote = item.prompt
                                    isClick.toggle()
                                } label: {
                                    Text("Generate")
                                        .font(.system(size: 12, weight: .medium, design: .monospaced))
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
