//
//  WeatherService.swift
//  iFridge
//
//  Created by 刘群 on 1/28/25.
//

import Foundation
import Combine

private enum APIKEY {
    static let key = "68aba3008214fe51ea55c548597dc7bd" // Enter your API KEY here
}

class WeatherService {
    
    private let baseURL = "https://api.openweathermap.org/data/2.5/weather"
    
    func getWeather(for city: String) -> AnyPublisher<WeatherResponse, Error> {
        guard let url = URL(string: "\(baseURL)?q=\(city)&appid=\(APIKEY.key)&units=metric") else {
            fatalError("Invalid URL")
        }
        return URLSession.shared.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: WeatherResponse.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
