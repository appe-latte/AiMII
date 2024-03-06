//
//  UserPromptsView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct UserPromptsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack {
            ZStack {
                HStack(spacing: 10) {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .fontWeight(.heavy)
                            .padding(10)
                            .background(ai_black)
                            .foregroundColor(ai_white)
                            .clipShape(Circle())
                    }
                    
                    Text("Automation")
                        .font(.system(size: 23, weight: .bold, design: .monospaced))
                        .kerning(1)
                        .foregroundColor(ai_black)
                    
                    Spacer()
                }
                .padding()
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10, content: {
                    ForEach(automationList, id: \.id) { item in
                        VStack(alignment: .leading, spacing: 5) {
                            HStack {
                                Image(systemName: item.icon)
                                    .font(.caption)
                                
                                Text(item.title)
                                    .font(.system(size: 10, weight: .heavy))
                                    .fontDesign(.monospaced)
                                    .multilineTextAlignment(.leading)
                                    .minimumScaleFactor(0.5)
                                    .textCase(.uppercase)
                                    .kerning(0.25)
                                    .lineLimit(2)
                            }
                            
                            Text(item.caption)
                                .font(.system(size: 10, weight: .medium))
                                .fontDesign(.monospaced)
                                .multilineTextAlignment(.leading)
                                .minimumScaleFactor(0.5)
                                .lineLimit(4)
                            
                            Spacer()
                            
                            Button {
                                //
                            } label: {
                                Text("Generate")
                                    .font(.system(size: 12, weight: .bold, design: .monospaced))
                                    .textCase(.uppercase)
                                    .kerning(0.75)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 40)
                            .background(ai_white.opacity(0.15))
                            .clipShape(Capsule())
                            .foregroundColor(.white)
                        }
                        .foregroundColor(ai_white)
                        .frame(width: 140, height: 150)
                        .padding()
                        .background(ai_black)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                        .padding(.horizontal)
                        
                    }
                })
                .padding(.horizontal)
            }
        }
        .background(background())
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
    UserPromptsView()
}
