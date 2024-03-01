//
//  ChatView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct ChatView: View {
    
    //    @FetchRequest(sortDescriptors: [SortDescriptor(\.id, order: .reverse)]) var item: FetchedResults<StoredMessage>
    @StateObject var item = LocalData()
    @Binding var isChatView: Bool
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Button {
                        isChatView.toggle()
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.left")
                            .bold()
                    }
                    .foregroundColor(.black)
                    
                    Text("  Chat History")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal)
                .padding(.horizontal)
                .frame(maxWidth: .infinity)
                .frame(height: 60)
                
                ScrollView(showsIndicators: false) {
                    VStack{
                        ForEach(item.messages) { msg in
                            MessageView(msg: Messages(id: UUID(), role: msg.sender! == "user" ? SenderRole.user : SenderRole.assistant, content: msg.content!, createAt: msg.date!))
                        }
                    }
                    .padding(.horizontal)
                }
            }
            .background(Image("gradient").resizable().scaledToFill().blur(radius: 150))
            .background(.black)
            .foregroundColor(.white)
        }
        .navigationBarHidden(true)
    }
}

struct MessageView: View {
    var msg: Messages
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if msg.role == SenderRole.assistant {
                    LogoView()
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 40)
                } else {
                    Image("\(UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1")")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 40)
                        .clipShape(Circle())
                }
                
                Text(msg.content)
                    .multilineTextAlignment(.leading)
                
            }
            
            if msg.role == SenderRole.assistant {
                HStack {
                    Spacer()
                    
                    Button {
                        UIPasteboard.general.setValue(msg.content, forPasteboardType: "public.plain-text")
                    } label: {
                        Text("Copy")
                            .font(.caption)
                            .padding(8)
                            .background(.black.opacity(0.1))
                            .cornerRadius(10)
                    }.buttonStyle(.plain)
                    
                    feedBackButton()
                }
                .padding(.top, 10)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(msg.role == SenderRole.user ? [.top, .bottom] : [.top, .bottom, .leading, .trailing])
        .background(msg.role == SenderRole.user ? .clear : .white)
        .cornerRadius(20)
        .foregroundColor(msg.role == SenderRole.user ? .white : .black)
        
    }
}
