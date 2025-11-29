//
//  SplashView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 28/11/25.
//

import SwiftUI

struct SplashView: View {
    
    @State private var scale: CGFloat = 0.8
    @State private var opacity: Double = 0.0
    @State private var navigateToHome = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.red
                    .ignoresSafeArea()
                
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack {
                    Spacer()
                    
                    Image("tojoLogo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 220, height: 220)
                        .scaleEffect(scale)
                        .opacity(opacity)
                        .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
                        .onAppear {
                            // Animación de aparición suave
                            withAnimation(.easeOut(duration: 0.8)) {
                                opacity = 1.0
                                scale = 1.05
                            }
                            // Animación de “latido” repetitiva
                            withAnimation(
                                .easeInOut(duration: 0.9)
                                .repeatForever(autoreverses: true)
                            ) {
                                scale = 0.95
                            }
                            
                            // Después de X segundos, pasamos a HomeView
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
                                navigateToHome = true
                            }
                        }
                    
                    Spacer()
                    
                    Text("SYSTEM")
                        .font(.headline)
                        .foregroundColor(.black.opacity(0.7))
                        .padding(.bottom, 40)
                }
            }
            // Navegación automática al Home
            .navigationDestination(isPresented: $navigateToHome) {
                HomeView()
                    .navigationBarBackButtonHidden(true)
            }
        }
    }
}

struct SplashView_Previews: PreviewProvider {
    static var previews: some View {
        SplashView()
    }
}
