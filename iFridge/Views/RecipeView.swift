//
//  RecipeView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI
import Combine
import UserNotifications

struct RecipeView: View {
    @State private var city: String = "Atlanta" // Set default city to Atlanta
    
    @ObservedObject var weatherViewModel = WeatherViewModel()
    
    private let weatherService = WeatherService()
    
    
    
    var body: some View {
        VStack(alignment: .leading) {
            
            HStack {
                Text("Weather in")
                    .font(.headline)
                
                // Dropdown menu to select the city
                Picker("Select City", selection: $city) {
                    Text("Atlanta").tag("Atlanta")
                    Text("New York").tag("New York")
                    Text("London").tag("London")
                }
                .pickerStyle(MenuPickerStyle())
                .onChange(of: city) { oldCity, newCity in
                    weatherViewModel.fetchWeather(city: newCity)
                }
            }
            .padding(.leading)  // Left padding for the HStack
            
            if let weather = weatherViewModel.weather {
                // Temperature and weather description in the same row
                HStack {
                    Text("Temperature: \(weather.main.temp, specifier: "%.1f")°C")
                        .font(.headline)
                    
                    Spacer()
                    
                    Text(weather.weather.first?.description.capitalized ?? "")
                        .font(.subheadline)
                        .foregroundColor(.gray)
                        .padding(.trailing)
                }
                .padding(.leading)  // Left padding for the temperature and description
            }
            
            Button("Request Permision for notification"){
                UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
                    if granted {
                        print("All set!")
                    } else if let error{
                        print("Failed to request permission: \(error.localizedDescription)")
                    }
                }
                
            }.padding()
                .padding(.top,64)
            
            Button("Schedule notification") {
                let content = UNMutableNotificationContent()
                content.title = "Don't forget your food!"
                content.body = "Your food has been sitting for 10 days. Check if it’s still good to consume!"
                content.sound = UNNotificationSound.default
                
                let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
                
                let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
                
                UNUserNotificationCenter.current().add(request)
            }.padding()
            
        }
        .padding()
        .onAppear {
            weatherViewModel.fetchWeather(city: city) // Fetch weather for the default city when the view appears
        }
    }
}


#Preview {
    RecipeView()
}
