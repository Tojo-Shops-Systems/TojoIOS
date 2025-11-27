//
//  ContentView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 24/11/25.
//

/*import SwiftUI

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
*/

//
import SwiftUI

struct ContentView: View {
    
    //
    @State private var email = ""
    @State private var password = ""
    @State private var wrongUsername = 0
    @State private var wrongPassword = 0
    @State private var showingLoginScreen = false
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Cambiar a tu URL real
    private let baseURL = URL(string: "http://127.0.0.1:8000/api/auth")!
    
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
                    
                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongUsername))
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.black.opacity(0.05))
                        .cornerRadius(10)
                        .border(.red, width: CGFloat(wrongPassword))
                    
                    Button(action: {
                        Task { await login() }
                    }) {
                        Text("INGRESAR")
                            .foregroundColor(.white)
                            .frame(width:300,height: 50)
                            .background(Color.red)
                            .cornerRadius(10)
                    }
                    
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
            .alert(isPresented: $showAlert) {
                Alert(title: Text("Login"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    // MARK: - Login
    func login() async {
        guard !email.isEmpty, !password.isEmpty else {
            alertMessage = "Completa email y contraseña"
            showAlert = true
            return
        }
        let url = baseURL.appendingPathComponent("login")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["email": email, "password": password]
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else { return }
            if (200...299).contains(http.statusCode) {
                if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                    // Ajusta la clave según la respuesta real; se espera "access_token"
                    if let token = json["access_token"] as? String {
                        // Guardar token para llamadas protegidas
                        UserDefaults.standard.set(token, forKey: "access_token")
                        alertMessage = "Login exitoso"
                        showAlert = true
                        // navegar a Home si lo deseas
                    } else {
                        alertMessage = "Login exitoso (sin token detectado)"
                        showAlert = true
                    }
                }
            } else {
                // leer mensaje de error si backend lo retorna
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String:Any],
                   let msg = json["message"] as? String {
                    alertMessage = msg
                } else {
                    alertMessage = "Credenciales inválidas. Código: \(http.statusCode)"
                }
                showAlert = true
            }
        } catch {
            alertMessage = "Error de red"
            showAlert = true
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
