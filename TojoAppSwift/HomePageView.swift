//
//  HomePageView.swift
//  TojoAppSwift
//
//  Created by Brando Ariel De Los Santos Guzman on 24/11/25.
//



import SwiftUI

struct HomePageView: View {
    
    let sensors = [
        SensorItem(name: "Proximidad", icon: "location.fill", color: Color.orange),
        SensorItem(name: "Humedad", icon: "drop.fill", color: Color.blue),
        SensorItem(name: "Temperatura", icon: "thermometer.medium", color: Color.red),
        SensorItem(name: "Servomotor", icon: "gearshape.fill", color: Color.green),
        SensorItem(name: "Sensor de Gas", icon: "smoke.fill", color: Color.purple),
        SensorItem(name: "Matriz 4x4", icon: "grid.circle.fill", color: Color.cyan)
    ]
    
    let columns = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ZStack {
            Color.purple.opacity(0.30)
                .ignoresSafeArea()
            //Circle()
              //  .scale(1.7)
                //.foregroundColor(.white.opacity(0.15))
            //Circle()
              //  .scale(1.35)
                //.foregroundColor(.white)
            
            VStack(spacing: 20) {
                Text("SENSORES")
                    .font(.largeTitle)
                    .bold()
                    .foregroundColor(.black)
                    .padding(.top, 40)
                
                ScrollView {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(sensors) { sensor in
                            Button(action: {
                                // Acción al presionar el sensor
                                print("Sensor seleccionado: \(sensor.name)")
                            }) {
                                VStack(spacing: 10) {
                                    Image(systemName: sensor.icon)
                                        .font(.system(size: 40))
                                        .foregroundColor(.white)
                                    
                                    Text(sensor.name)
                                        .font(.system(size: 14, weight: .semibold))
                                        .foregroundColor(.white)
                                        .multilineTextAlignment(.center)
                                        .lineLimit(2)
                                }
                                .frame(width: 150, height: 150)
                                .background(sensor.color)
                                .cornerRadius(15)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.bottom, 40)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct SensorItem: Identifiable {
    let id = UUID()
    let name: String
    let icon: String
    let color: Color
}

#Preview {
    HomePageView()
}
