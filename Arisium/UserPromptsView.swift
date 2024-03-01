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
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .padding()
                            .background(.white)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                .padding()
                
                Text("Automation")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10, content: {
                    ForEach(automationList, id: \.id) {
                        item in
                        
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
                        .frame(width: 140, height: 150)
                        .padding()
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 26))
                        .padding(.horizontal)
                        
                    }
                })
                .padding(.horizontal)
            }
        }
        .background(Image("gradient").resizable().scaledToFill().blur(radius: 150))
        .background(.black)
    }
}

#Preview {
    UserPromptsView()
}
