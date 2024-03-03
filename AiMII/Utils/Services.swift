//
//  Services.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import Foundation
import Alamofire
import Combine

class OpenAiService {
    private let endPointURL = "https://api.openai.com/v1/chat/completions"
    private var isPremiumUser: Bool
    
    init(isPremiumUser: Bool) {
        self.isPremiumUser = isPremiumUser
    }
    
    func sendMessage(message: [Messages]) async -> OpenAiChatResponse? {
        let openAiMessages = message.map({OpenAiChatMessage(role: $0.role, content: $0.content)})
        let model = isPremiumUser ? "gpt-4" : "gpt-3.5-turbo" // Choose model based on user subscription
        
        let body = OpenAiChatBody(model: model, messages: openAiMessages)
        let headers: HTTPHeaders = [
            "Authorization": "Bearer \(Constants.openAIApiKey)"
        ]
        
        return try? await AF.request(endPointURL, method: .post, parameters: body, encoder: .json, headers: headers).serializingDecodable(OpenAiChatResponse.self).value
    }
}

struct OpenAiChatBody: Encodable {
    let model: String
    let messages: [OpenAiChatMessage]
}

struct OpenAiChatMessage: Codable {
    let role: SenderRole
    let content: String
}

enum SenderRole: String, Codable {
    case system
    case user
    case assistant
}

struct OpenAiChatResponse: Decodable {
    let choices: [OpenAiChatChoice]
}

struct OpenAiChatChoice: Decodable {
    let message: OpenAiChatMessage
}

struct Messages: Identifiable, Codable {
    let id: UUID
    let role: SenderRole
    let content: String
    let createAt: Date
}
