//
//  FirstScreen.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 28/11/25.
//

import SwiftUI

struct HomeView: View {
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.green
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack(spacing: 20) {
                    Text("BIENVENIDO")
                        .font(.largeTitle)
                        .bold()
                        .padding(.bottom, 40)
                    
                    NavigationLink(destination: BranchActivationView()) {
                        Text("ALTA DE SUCURSAL")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.orange)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: ContentView()) {
                        Text("INICIAR SESIÓN")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("REGISTRARSE")
                            .foregroundColor(.white)
                            .frame(width: 300, height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                }
                .foregroundColor(.black)
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
