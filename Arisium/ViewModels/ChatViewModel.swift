//
//  ChatViewModel.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import CoreData
import Combine

extension NewChat {
    class ChatViewModel: ObservableObject {
        @Published var messages: [Messages] = []
        @Published var currentInput: String = ""
        
        @StateObject var localData = LocalData()
        @Environment(\.managedObjectContext) var managedObjContext

        private var openAiService: OpenAiService
        
        init(isPremiumUser: Bool) {
            self.openAiService = OpenAiService(isPremiumUser: isPremiumUser)
        }

        func sendMessage(context: NSManagedObjectContext) {
            let newMessage = Messages(id: UUID(), role: .user, content: currentInput, createAt: Date())
            
            messages.append(newMessage)
            currentInput = ""
            
            localData.addChat(list: newMessage, context: context)

            Task {
                let response = await openAiService.sendMessage(message: messages)
                guard let receiveOpenAiMessage = response?.choices.first?.message else {
                    print("Had no received message")
                    return
                }
                
                let receiveMessage = Messages(id: UUID(), role: .user, // Assuming this should be .user or mapped correctly from the API response
                                              content: receiveOpenAiMessage.content, createAt: Date())
                await MainActor.run {
                    localData.addChat(list: receiveMessage, context: context)
                    messages.append(receiveMessage)
                }
            }
        }
    }
}
