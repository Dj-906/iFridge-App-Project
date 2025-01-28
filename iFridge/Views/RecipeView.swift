//
//  RecipeView.swift
//  iFridge
//
//  Created by 刘群 on 1/25/25.
//

import SwiftUI
import Combine

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
