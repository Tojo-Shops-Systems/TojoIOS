//
//  BranchActivationView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 28/11/25.
//

import SwiftUI

struct BranchActivationView: View {
    
    @State private var activationKey = ""
    @State private var showAlert = false
    @State private var alertMessage = ""
    @State private var navigateToRegister = false
    
    private let baseURL = URL(string: "http://127.0.0.1:8000/api/branch")!
    
    var body: some View {
        ZStack {
            Color.red
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text("ALTA DE SUCURSAL")
                    .font(.title)
                    .bold()
                    .padding(.bottom, 20)
                
                TextField("Llave de activación", text: $activationKey)
                    .padding()
                    .frame(width: 300, height: 50)
                    .background(Color.black.opacity(0.05))
                    .cornerRadius(10)
                    .autocapitalization(.none)
                
                Button(action: {
                    Task { await activateBranch() }
                }) {
                    Text("DAR ALTA")
                        .foregroundColor(.white)
                        .frame(width: 300, height: 50)
                        .background(Color.green)
                        .cornerRadius(10)
                }
            }
            .foregroundColor(.black)
        }
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Alta de Sucursal"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        // Navegación programática
        .navigationDestination(isPresented: $navigateToRegister) {
            RegisterView()
        }
    }
    
    // MARK: - Activar Sucursal
    func activateBranch() async {
        guard !activationKey.isEmpty else {
            alertMessage = "Ingresa la llave de activación"
            showAlert = true
            return
        }
        
        let url = baseURL.appendingPathComponent("activate")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let body = ["activation_key": activationKey]
        
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { return }
            
            if (200...299).contains(http.statusCode) {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let msg = json["message"] as? String {
                    alertMessage = msg
                } else {
                    alertMessage = "Sucursal dada de alta correctamente"
                }
                showAlert = true
                
                // Ir al registro (puedes quitar el delay si quieres ir directo)
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    navigateToRegister = true
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let msg = json["message"] as? String {
                    alertMessage = msg
                } else {
                    alertMessage = "Error al dar de alta. Código: \(http.statusCode)"
                }
                showAlert = true
            }
        } catch {
            alertMessage = "Error de red"
            showAlert = true
        }
    }
}

struct BranchActionView_Previews: PreviewProvider {
    static var previews: some View {
        BranchActivationView()
    }
}
