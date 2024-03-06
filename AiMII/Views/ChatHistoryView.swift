//
//  ChatView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct ChatHistoryView: View {
    @StateObject var item = LocalData() // Assumes LocalData handles fetching and storing messages
    @Binding var isChatView: Bool
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                
                messagesScrollView
            }
            .background(background())
        }
        .navigationBarHidden(true)
    }
    
    // MARK: - Components
    private var headerView: some View {
        HStack {
            backButton
            
            Text("Chat History")
                .font(.system(size: 23, weight: .bold, design: .monospaced))
                .foregroundStyle(ai_white)
                .kerning(1.25)
            
            Spacer()
        }
        .padding()
        .background(ai_black)
    }
    
    private var backButton: some View {
        Button(action: {
            isChatView.toggle()
            presentationMode.wrappedValue.dismiss()
        }) {
            Image(systemName: "chevron.left")
                .fontWeight(.heavy)
                .padding(10)
                .background(ai_white)
                .foregroundColor(ai_black)
                .clipShape(Circle())
        }
    }
    
    private var messagesScrollView: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                ForEach(item.messages) { msg in
                    MessageView(msg: convertToMessagesModel(msg))
                }
            }
            .padding()
        }
    }
    
    private func convertToMessagesModel(_ storedMessage: StoredMessage) -> Messages {
        // Conversion from StoredMessage to Messages model
        Messages(id: UUID(), role: storedMessage.sender == "user" ? .user : .assistant, content: storedMessage.content ?? "", createAt: storedMessage.date ?? Date())
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

// MARK: Message View
struct MessageView: View {
    var msg: Messages
    
    var body: some View {
        HStack {
            profileImageView(for: msg.role)
            Text(msg.content)
                .multilineTextAlignment(.leading)
            Spacer()
            if msg.role == .assistant { copyButton }
        }
        .padding()
        .background(msg.role == .user ? Color.clear : Color.white)
        .cornerRadius(20)
        .foregroundColor(msg.role == .user ? ai_white : ai_black)
        .frame(maxWidth: .infinity, alignment: msg.role == .user ? .trailing : .leading)
    }
    
    // MARK: - Helper Views
    @ViewBuilder
    private func profileImageView(for role: SenderRole) -> some View {
        if role == .assistant {
            LogoView()
                .aspectRatio(contentMode: .fit)
                .clipShape(Circle())
                .frame(width: 40)
        } else {
            Image(UserDefaults.standard.string(forKey: "PROFILE") ?? "avt1")
                .resizable()
                .scaledToFit()
                .frame(width: 40)
                .clipShape(Circle())
        }
    }
    
    private var copyButton: some View {
        Button(action: {
            UIPasteboard.general.setValue(msg.content, forPasteboardType: "public.plain-text")
        }) {
            Text("Copy")
                .font(.caption)
                .padding(8)
                .background(ai_black.opacity(0.1))
                .cornerRadius(10)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    ChatHistoryView(isChatView: .constant(true))
}
