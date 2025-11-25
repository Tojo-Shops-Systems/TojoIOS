//
//  RegisterView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 24/11/25.
//

import SwiftUI

struct RegisterView: View {
    
    @State private var email = ""
    @State private var username = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            
            VStack{
                Text("REGISTRO")
                    .font(.largeTitle)
                    .bold()
                    .padding()
                
                TextField("Correo electrónico", text: $email)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                TextField("Nombre de usuario", text: $username)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                
                SecureField("Contraseña", text: $password)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                
                SecureField("Confirmar contraseña", text: $confirmPassword)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                
                Button("CREAR CUENTA"){
                    // LOGICA DE REGISTRO PENDIENTE
                }
                .foregroundColor(.white)
                .frame(width:300,height: 50)
                .background(Color.blue)
                .cornerRadius(10)
                    
            }
            .foregroundColor(.black)
        }
        .navigationBarHidden(true)
    }
}

#Preview {
    RegisterView()
}
