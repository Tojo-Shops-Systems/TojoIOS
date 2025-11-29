//
//  RegisterView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 24/11/25.
//

/*import SwiftUI

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
*/


import SwiftUI

struct RegisterView: View {
    
    // MARK: - Campos UI
    @State private var curp = ""
    
    @State private var email = ""
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Estados para lógica
    @State private var isPersonVerified = false
    @State private var personId: Int? = nil
    
    @State private var isCheckingCurp = false
    @State private var isRegistering = false
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Config fija
    @State private var userType = "admin"       // siempre "admin" como pediste
    private let branchId: Int? = 1             // o nil si no hay sucursal
    
    // Cambiar a tu URL real base (ajusta si el check-curp no va bajo /auth)
    private let baseURL = URL(string: "http://127.0.0.1:8000/api")!
    
    var body: some View {
        ZStack {
            Color.purple
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white.opacity(0.5))
            
            ScrollView {
                VStack(spacing: 16) {
                    Spacer(minLength: 100)
                    Text("REGISTRO")
                        .font(.largeTitle)
                        .bold()
                        .padding(.top, 24)
                    
                    // MARK: - CURP + IDENTIFICAR
                    TextField("CURP", text: $curp)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.allCharacters)
                    
                    Button(action: {
                        Task { await checkCurp() }
                    }) {
                        if isCheckingCurp {
                            ProgressView()
                                .tint(.white)
                                .frame(width: 300, height: 50)
                        } else {
                            Text("IDENTIFICAR")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                        }
                    }
                    .background(Color.orange)
                    .cornerRadius(10)
                    
                    // Estado de verificación
                    if isPersonVerified {
                        Text("Persona encontrada en el sistema.")
                            .font(.footnote)
                            .foregroundColor(.green)
                    } else if !curp.isEmpty {
                        Text("Aún no se ha verificado la CURP.")
                            .font(.footnote)
                            .foregroundColor(.gray)
                    }
                    
                    // MARK: - Campos habilitados solo si está verificado
                    Group {
                        TextField("Correo electrónico", text: $email)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .keyboardType(.emailAddress)
                            .autocapitalization(.none)
                            .disabled(!isPersonVerified)
                            .opacity(isPersonVerified ? 1.0 : 0.4)
                        
                        SecureField("Contraseña", text: $password)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .disabled(!isPersonVerified)
                            .opacity(isPersonVerified ? 1.0 : 0.4)
                        
                        SecureField("Confirmar contraseña", text: $confirmPassword)
                            .padding()
                            .frame(width: 300, height: 50)
                            .background(Color.white)
                            .cornerRadius(10)
                            .disabled(!isPersonVerified)
                            .opacity(isPersonVerified ? 1.0 : 0.4)
                    }
                    
                    Button(action: {
                        Task { await registerUser() }
                    }) {
                        if isRegistering {
                            ProgressView()
                                .tint(.white)
                                .frame(width: 300, height: 50)
                        } else {
                            Text("REGISTRAR")
                                .foregroundColor(.white)
                                .frame(width: 300, height: 50)
                        }
                    }
                    .background(isPersonVerified ? Color.blue : Color.gray)
                    .cornerRadius(10)
                    .disabled(!isPersonVerified)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity, maxHeight:
                .infinity, alignment: .center)
                
                .foregroundColor(.black)
                .padding(.bottom, 40)
            }
            
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbarBackground(.hidden, for: .navigationBar)
        .toolbarColorScheme(.dark, for: .navigationBar)
        .alert(isPresented: $showAlert) {
            Alert(
                title: Text("Registro"),
                message: Text(alertMessage),
                dismissButton: .default(Text("OK"))
            )
        }
    }
    
    // MARK: - Verificar CURP (alta en sistema local)
    func checkCurp() async {
        guard !curp.isEmpty else {
            show(message: "Ingresa la CURP.")
            return
        }
        
        isCheckingCurp = true
        defer { isCheckingCurp = false }
        
        // Ajusta la ruta EXACTA de tu endpoint
        // Por ejemplo: /auth/identifyPerson o /person/check-curp
        let url = baseURL.appendingPathComponent("auth/identifyPerson")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // Ajusta el nombre de la clave según tu backend ("CURP", "curp", etc.)
        let body: [String: Any] = [
            "CURP": curp.uppercased()
        ]
        
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else {
                show(message: "Respuesta inválida del servidor.")
                return
            }
            
            if (200...299).contains(http.statusCode) {
                // Se espera que el backend “retorne el dato de la persona”
                // Ejemplos posibles:
                // { "person": { "id": 1, ... } }
                // { "person_id": 1, ... }
                // { "id": 1, ... }
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    if let person = json["person"] as? [String: Any],
                       let id = person["id"] as? Int {
                        self.personId = id
                    } else if let id = json["person_id"] as? Int {
                        self.personId = id
                    } else if let id = json["id"] as? Int {
                        self.personId = id
                    }
                }
                
                if let _ = personId {
                    isPersonVerified = true
                    show(message: "Persona encontrada. Completa tu registro.")
                } else {
                    isPersonVerified = false
                    show(message: "No se pudo obtener el ID de la persona.")
                }
            } else {
                isPersonVerified = false
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let msg = json["message"] as? String {
                    show(message: msg)
                } else {
                    show(message: "No se encontró a la persona o hubo un error. Código: \(http.statusCode)")
                }
            }
        } catch {
            isPersonVerified = false
            show(message: "Error de red al verificar CURP.")
        }
    }
    
    // MARK: - Registrar usuario
    func registerUser() async {
        guard isPersonVerified, let personId = personId else {
            show(message: "Primero identifica a la persona por CURP.")
            return
        }
        
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty else {
            show(message: "Completa correo y contraseñas.")
            return
        }
        
        guard password == confirmPassword else {
            show(message: "Las contraseñas no coinciden.")
            return
        }
        
        isRegistering = true
        defer { isRegistering = false }
        
        // Endpoint de registro
        let url = baseURL.appendingPathComponent("auth/register")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        var body: [String: Any] = [
            "userType": userType,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "person_id": personId
        ]
        
        // branch_id 1 o null
        if let branchId = branchId {
            body["branch_id"] = branchId
        } else {
            body["branch_id"] = NSNull()
        }
        
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse else {
                show(message: "Respuesta inválida del servidor.")
                return
            }
            
            if (200...299).contains(http.statusCode) {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let msg = json["message"] as? String {
                    show(message: msg)
                } else {
                    show(message: "Registro exitoso. Ahora puedes iniciar sesión.")
                }
            } else {
                if let json = try? JSONSerialization.jsonObject(with: data) as? [String: Any],
                   let msg = json["message"] as? String {
                    show(message: msg)
                } else {
                    show(message: "Error al registrar. Código: \(http.statusCode)")
                }
            }
        } catch {
            show(message: "Error de red al registrar usuario.")
        }
    }
    
    // MARK: - Helper Alert
    func show(message: String) {
        alertMessage = message
        showAlert = true
    }
}

struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
