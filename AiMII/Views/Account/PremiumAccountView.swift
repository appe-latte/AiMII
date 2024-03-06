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
            VStack(spacing: 20) {
                
                closeButton
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("Upgrade to AiMII+")
                        .font(.system(size: 32, weight: .heavy, design: .monospaced))
                    
                    Text("and enjoy access to all features of AiMII, including:")
                        .font(.system(size: 15, weight: .semibold, design: .monospaced))
                }
                .foregroundColor(ai_black)
                .multilineTextAlignment(.leading)
                .kerning(1.0)
                
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
        VStack(alignment: .leading, spacing: 20) {
            // Benefit 1
            HStack(spacing: 10) {
                Image("prime")
                    .padding(8)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                Text("Access to Chat GPT-4: The latest, most powerful AI.")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(ai_black)
            }
            
            // Benefit 2
            HStack(spacing: 10) {
                Image("prime")
                    .padding(8)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                Text("Ad-free experience.")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(ai_black)
            }
            
            // Benefit 3
            HStack(spacing: 10) {
                Image("prime")
                    .padding(8)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                Text("Priority support and updates.")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(ai_black)
            }
            
            // Benefit 4
            HStack(spacing: 10) {
                Image("prime")
                    .padding(8)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                Text("More accurate, detailed responses.")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(ai_black)
            }
            
            // Benefit 5
            HStack(spacing: 10) {
                Image("prime")
                    .padding(8)
                    .background(ai_black)
                    .foregroundColor(ai_white)
                    .clipShape(Circle())
                
                Text("Advanced understanding of context and nuance.")
                    .font(.system(size: 12, weight: .semibold, design: .monospaced))
                    .kerning(2)
                    .foregroundColor(ai_black)
            }
        }
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
                        .background(ai_black)
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
