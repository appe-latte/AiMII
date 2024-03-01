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
                
                HStack {
                    Button {
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "xmark")
                            .padding(14)
                            .background(.white)
                            .foregroundColor(.black)
                            .clipShape(Circle())
                    }
                    Spacer()
                }
                
                Text("Upgrade to\nPremium Plan")
                    .font(.system(size: 40))
                    .bold()
                    .multilineTextAlignment(.center)
                
                VStack(spacing: 15) {
                    Text("And enjoy access to all features of TalkMate\n 1. Ads free experience\n 2. Unlimited questions & answers\n 3. High word limit question & answers")
                        .lineSpacing(8)
                }
                .padding()
                
                Divider()
                
                ScrollView(showsIndicators: false, content: {
                    VStack(spacing: 15) {
                        ForEach(storeKit.storeProducts) { product in
                            Button {
                                // purchase this product
                                Task { try await storeKit.purchase(product)
                                }
                            } label: {
                                VStack (spacing: 5){
                                    Text(product.displayName)
                                        .font(.caption)
                                        .foregroundColor(.black)
                                    Text("\(product.displayPrice)")
                                        .font(.title3)
                                        .bold()
                                        .foregroundColor(.black)
                                }
                                .padding()
                                .frame(maxWidth: .infinity)
                                .background(.white)
                                .foregroundColor(.black)
                                .clipShape(Capsule())
                            }
                        }
                    }
                })
                .frame(maxWidth: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            
        }
        .padding()
        .foregroundColor(.white)
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Image("gradient")
            .resizable()
            .scaledToFill()
            .blur(radius: 40))
        .background(.black)
    }
    
}

#Preview {
    PremiumAccountView()
}
