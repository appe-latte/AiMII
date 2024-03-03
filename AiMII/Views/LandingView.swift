//
//  LandingVIew.swift
//  Arisium
//
//  Created by Stanford L. Khumalo on 2024-02-29.
//

import SwiftUI
import FirebaseCore
import FirebaseAuth

struct LandingView: View {
    @State private var scale: CGFloat = 0.4
    @State var isActive =   false
    @State var isCurrent = false
    
    var body: some View {
        if self.isActive {
            if Auth.auth().currentUser?.uid == nil {
                UserLoginView()
            } else {
                ContentView()
            }
        } else {
            VStack {
                LogoView()
                    .aspectRatio(contentMode: .fit)
                    .clipShape(Circle())
                    .frame(width: 150)
                    .frame(maxHeight: .infinity)
                    .scaleEffect(scale)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .ignoresSafeArea()
            .onAppear() {
                withAnimation(.easeIn(duration: 2)) {
                    scale = scale == 0.4 ? 1.0 : 1.0
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                    self.isActive = true
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(background())
            .foregroundColor(.white)
        }
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
    LandingView()
}
