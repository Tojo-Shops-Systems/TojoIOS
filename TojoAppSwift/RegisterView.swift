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

// ...existing code...
import SwiftUI

struct RegisterView: View {
    
    // Campos requeridos por el pendejo del backend
    @State private var email = ""
    @State private var userType = "user" // o "admin" según caso
    @State private var password = ""
    @State private var confirmPassword = ""
    
    // Datos personales requeridos para personalData
    @State private var firstName = ""
    @State private var lastName = ""
    @State private var curp = ""
    @State private var phoneNumber = ""
    
    @State private var showAlert = false
    @State private var alertMessage = ""
    
    // Cambiar a tu URL real
    private let baseURL = URL(string: "http://127.0.0.1:8000/api/auth")!
    
    var body: some View {
        ZStack{
            Color.purple
                .ignoresSafeArea()
            Circle()
                .scale(1.7)
                .foregroundColor(.white.opacity(0.15))
            Circle()
                .scale(1.35)
                .foregroundColor(.white.opacity(0.5))
            
            ScrollView {
                VStack(spacing: 12){
                    Text("REGISTRO")
                        .font(.largeTitle)
                        .bold()
                        .padding()
                    
                    
                    TextField("Correo electrónico", text: $email)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .keyboardType(.emailAddress)
                        .autocapitalization(.none)
                    
                    // Personal data (se muestran si CURP no existe o siempre)
                    TextField("Nombre(s)", text: $firstName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("Apellido(s)", text: $lastName)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    TextField("CURP", text: $curp)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .autocapitalization(.allCharacters)
                    
                    TextField("Teléfono (10 dígitos)", text: $phoneNumber)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                        .keyboardType(.numberPad)
                    
                    SecureField("Contraseña", text: $password)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    SecureField("Confirmar contraseña", text: $confirmPassword)
                        .padding()
                        .frame(width: 300, height: 50)
                        .background(Color.white)
                        .cornerRadius(10)
                    
                    Button("CREAR CUENTA"){
                        Task { await registerFlow() }
                    }
                    .foregroundColor(.white)
                    .frame(width:300,height: 50)
                    .background(Color.blue)
                    .cornerRadius(10)
                }
                .foregroundColor(.black)
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
        .alert(isPresented: $showAlert) {
            Alert(title: Text("Registro"), message: Text(alertMessage), dismissButton: .default(Text("OK")))
        }
    }
    
    // MARK: - Network flow
    func registerFlow() async {
        
        guard !email.isEmpty, !password.isEmpty, !confirmPassword.isEmpty, !curp.isEmpty else {
            show(message: "Completa los campos obligatorios.")
            return
        }
        guard password == confirmPassword else {
            show(message: "Las contraseñas no coinciden.")
            return
        }
        
        if let personId = await identifyPerson(curp: curp) {
            
            await registerUser(personId: personId)
        } else {
            
            if let newPersonId = await createPerson() {
                await registerUser(personId: newPersonId)
            } else {
                show(message: "No se pudo crear la persona.")
            }
        }
    }
    
    func identifyPerson(curp: String) async -> Int? {
        let url = baseURL.appendingPathComponent("identifyPerson")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body = ["CURP": curp]
        do {
            req.httpBody = try JSONEncoder().encode(body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, http.statusCode == 200 else { return nil }
            // Intentar extraer person id de la respuesta JSON
            if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                if let person = json["person"] as? [String:Any], let id = person["id"] as? Int { return id }
                if let id = json["person_id"] as? Int { return id }
                if let id = json["id"] as? Int { return id }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func createPerson() async -> Int? {
        let url = baseURL.appendingPathComponent("personalData")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
            "firstName": firstName,
            "lastName": lastName,
            "CURP": curp,
            "phoneNumber": phoneNumber
        ]
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (data, resp) = try await URLSession.shared.data(for: req)
            guard let http = resp as? HTTPURLResponse, (200...299).contains(http.statusCode) else { return nil }
            if let json = try JSONSerialization.jsonObject(with: data) as? [String:Any] {
                if let person = json["person"] as? [String:Any], let id = person["id"] as? Int { return id }
                if let id = json["id"] as? Int { return id }
                if let id = json["person_id"] as? Int { return id }
            }
            return nil
        } catch {
            return nil
        }
    }
    
    func registerUser(personId: Int) async {
        let url = baseURL.appendingPathComponent("register")
        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let body: [String:Any] = [
            "userType": userType,
            "email": email,
            "password": password,
            "password_confirmation": confirmPassword,
            "person_id": personId
        ]
        do {
            req.httpBody = try JSONSerialization.data(withJSONObject: body)
            let (_, resp) = try await URLSession.shared.data(for: req)
            if let http = resp as? HTTPURLResponse {
                if (200...299).contains(http.statusCode) {
                    show(message: "Registro exitoso. Inicia sesión.")
                } else {
                    show(message: "Error al registrar. Código: \(http.statusCode)")
                }
            }
        } catch {
            show(message: "Error de red al registrar usuario.")
        }
    }
    
    func show(message: String) {
        alertMessage = message
        showAlert = true
    }
}
//
struct RegisterView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterView()
    }
}
