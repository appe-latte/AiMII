//
//  NewChat.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import SwiftUI
import CoreData
import Combine

struct NewChat: View {
    @State private var isClicked = false
    @State private var isPremium = false
    @State private var shouldScrollToBottom = false
    @State var cancellabs = Set<AnyCancellable>()
    @State var quote = ""
    
    // MARK:
    @StateObject var messages = LocalData()
    @StateObject var localData = LocalData()
    @StateObject var viewModel = ChatViewModel(isPremiumUser: UserDefaults.standard.bool(forKey: "isPremium"))
    @Environment(\.managedObjectContext) var managedObjContext
    
    @Binding var isClick : Bool
    
    var body: some View {
        VStack {
            ZStack {
                HStack {
                    Button {
                        isClick.toggle()
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
                
                Text("New Chat")
                    .font(.system(size: 16, weight: .bold))
            }
            .foregroundColor(.white)
            
            if viewModel.messages.isEmpty {
                VStack {
                    Spacer()
                    
                    Image("logo")
                        .aspectRatio(contentMode: .fit)
                        .clipShape(Circle())
                        .frame(width: 100)
                    
                    Text("AiMII")
                        .font(.title)
                        .bold()
                        .padding()
                    
                    // Check and update this statement
                    Text("Welcome! When typing a prompt in AiMII, remember to:\n\n1. Keep your sentences concise and clear.\n2. Avoid ambiguity or vagueness in your language.\n3. Use appropriate and respectful language.4. Refrain from sharing personal or confidential information.\n5. Understand that the model's knowledge is based on data up until September 2021.\n\nFollowing these guidelines ensures better interactions✨")
                        .font(.system(size: 16))
                        .opacity(0.6)
                        .padding()
                    
                    Spacer()
                }
                
            } else {
                ScrollViewReader { value in
                    ScrollView (showsIndicators: false) {
                        LazyVStack {
                            ForEach(viewModel.messages, id: \.id) {
                                message in
                                messageView(msg: message)
                                    .id(message.id)
                                
                            }
                        }
                        .padding(.horizontal)
                        .onAppear {
                            // Scroll to the bottom initially
                            scrollToBottom(proxy: value)
                        }
                        .onChange(of: messages.messages) { _ in
                            // Scroll to the bottom when new messages are added
                            if shouldScrollToBottom {
                                scrollToBottom(proxy: value)
                            }
                        }
                    }
                }
            }
            
            HStack {
                TextField("Write something..", text: $viewModel.currentInput)
                    .padding(24)
                    .background(.black)
                    .foregroundColor(.white)
                    .clipShape(Capsule())
                    .autocorrectionDisabled()
                
                Button {
                    
                    if !UserDefaults.standard.bool(forKey: "isPremium") {
                        if Constants.count >= Constants.ad_after {
                            isPremium.toggle()
                        } else {
                            Constants.count = Constants.count + 1
                            UserDefaults.standard.set(Constants.count, forKey: "Count")
                            viewModel.sendMessage(context: managedObjContext)
                            shouldScrollToBottom.toggle()
                        }
                    } else {
                        viewModel.sendMessage(context: managedObjContext)
                        shouldScrollToBottom.toggle()
                    }
                    
                } label: {
                    Image(systemName: "paperplane")
                        .foregroundColor(.black)
                        .imageScale(.large)
                        .padding(20)
                        .background(.white)
                        .clipShape(Circle())
                }
                .sheet(isPresented: $isPremium) {
                    PremiumAccountView()
                }
            }
            .padding()
            .ignoresSafeArea()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("gradient").resizable().scaledToFill().blur(radius: 150))
        .background(.black)
        .onAppear() {
            viewModel.currentInput = quote
        }
    }
    
    func scrollToBottom(proxy: ScrollViewProxy) {
        withAnimation {
            //                proxy.scrollTo(viewModel.messages.last.id, anchor: .bottom)
        }
    }
    
    func messageView(msg: Messages) -> some View {
        VStack(alignment: .leading) {
            HStack {
                if msg.role == SenderRole.assistant {
                    Image("logo")
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
                
                Spacer()
                
                if msg.role == SenderRole.user {
                    Button {
                        viewModel.currentInput = msg.content
                        //                         = msg.content
                        viewModel.sendMessage(context: managedObjContext)
                    } label: {
                        Image(systemName: "arrow.clockwise")
                            .padding(8)
                            .background(.white)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                }
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

// MARK: Feedback Button
struct feedBackButton: View {
    @State var isLiked = false
    @State var isDisliked = false
    
    var body: some View{
        HStack {
            Button {
                isLiked.toggle()
            } label: {
                Text("🥰")
                    .font(.caption)
                    .padding(4)
                    .background(isLiked ? .blue.opacity(0.4) : .clear)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
            
            Button {
                isDisliked.toggle()
            } label: {
                Text("😒")
                    .font(.caption)
                    .padding(4)
                    .background(isDisliked ? .blue.opacity(0.4) : .clear)
                    .cornerRadius(10)
            }.buttonStyle(.plain)
        }
        .padding(4)
        .background(.black.opacity(0.1))
        .cornerRadius(10)
    }
}
