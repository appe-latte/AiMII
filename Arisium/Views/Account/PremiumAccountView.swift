//
//  PremiumAccountView.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI

struct PremiumAccountView: View {
    @StateObject var storeKit = StoreKitManager()
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                
                closeButton
                
                VStack {
                    Text("Upgrade to AiMII+")
                        .font(.system(size: 32, weight: .heavy, design: .rounded))
                    
                    
                    Text("And enjoy access to all features of AiMII, including:")
                        .font(.footnote)
                        .fontWeight(.semibold)
                }
                .foregroundColor(ai_black)
                .multilineTextAlignment(.leading)
                .kerning(3)
                
                // MARK: Description of Premium Features
                premiumFeatures
                
                // MARK: Options for Purchases
                purchaseOptions
            }
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
    
    // MARK: Custom "dismiss" button
    private var closeButton: some View {
        HStack {
            Button {
                presentationMode.wrappedValue.dismiss()
            } label: {
                Image(systemName: "xmark")
                    .padding(14)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
            }
            
            Spacer()
        }
    }
    
    // MARK: Premium Features
    private var premiumFeatures: some View {
        Text("1. Access to Chat GPT-4: The latest, most powerful AI.\n2. Ads-free experience\n3. High word limit for queries\n4. Unlimited questions & answers\n5. More accurate, detailed responses\n6. Advanced understanding of context and nuance.\n7. Priority support and updates")
            .font(.system(size: 16, weight: .medium, design: .rounded))
            .kerning(2)
            .foregroundColor(ai_black)
            .lineSpacing(10)
            .padding()
    }
    
    private var purchaseOptions: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 15) {
                ForEach(storeKit.storeProducts) { product in
                    Button {
                        Task {
                            do {
                                try await storeKit.purchase(product)
                            } catch {
                                print(error.localizedDescription) // Consider better error handling
                            }
                        }
                    } label: {
                        VStack(spacing: 5) {
                            Text(product.displayName)
                                .font(.caption)
                                .foregroundColor(ai_black)
                            
                            Text(product.displayPrice)
                                .font(.title3)
                                .bold()
                                .foregroundColor(ai_black)
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(ai_white)
                        .clipShape(Capsule())
                    }
                }
            }
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PremiumAccountView()
}
