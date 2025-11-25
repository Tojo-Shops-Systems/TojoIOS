//
//  ContentView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 24/11/25.
//

import SwiftUI

struct ContentView: View {
    
    @State private var username = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    var body: some View {
        NavigationView{
            ZStack{
                Color.red
                    .ignoresSafeArea()
                Circle()
                    .scale(1.7)
                    .foregroundColor(.white.opacity(0.15))
                Circle()
                    .scale(1.35)
                    .foregroundColor(.white)
                
                VStack{
                    Text("INICIO DE SESIÓN")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    TextField("Nombre de usuario", text: $username)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    NavigationLink(destination: HomePageView()){
                    Text("INGRESAR")
                        // LOGIICA DE AUTENTICACION PENDIENTE
                    }
                    .foregroundColor(.white)
                    .frame(width:300,height: 50)
                    .background(Color.red)
                    .cornerRadius(10)
                    
                    //Button("REGISTRATE"){
                        // LOGIICA DE AUTENTICACION PENDIENTE
                    //}
                    //.foregroundColor(.white)
                    //.frame(width:300,height: 50)
                    //.background(Color.blue)
                    //.cornerRadius(10)
                    
                    NavigationLink(destination: RegisterView()) {
                        Text("REGISTRATE")
                            .foregroundColor(.white)
                            .frame(width:300,height: 50)
                            .background(Color.blue)
                            .cornerRadius(10)
                    }
                    
                        
                }
                .foregroundColor(.black)
            }
            //.navigationBarHidden(true)
        }
        
    }
}

#Preview {
    ContentView()
}
