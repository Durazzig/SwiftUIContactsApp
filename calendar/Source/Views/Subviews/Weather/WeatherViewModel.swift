//
//  WeatherViewModel.swift
//  calendar
//
//  Created by Tadeo Durazo on 30/01/23.
//

import Foundation

class WeatherViewModel: ObservableObject {
    
    @Published var city: String = ""
    @Published var minTemp: String = ""
    @Published var maxTemp: String = ""
    @Published var feelingTemp: String = ""
    @Published var temp: String = ""
    @Published var isLoading = false
    
    @Published var lat: String = ""
    @Published var long: String = ""
    
    @Published var weatherIconUrl: String = ""
    
    init(lat: String, long: String) {
        self.lat = lat
        self.long = long
        fetchCurrentWeather()
    }
    
    func fetchCurrentWeather() {
        
        isLoading = true
        
        guard let url = URL(string: "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(long)&units=metric&appid=\(ApiConstants.apiKey)") else { return }
        
        let request = URLRequest.init(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: request, completionHandler: { (data, response, error) in
            do {
                
                let model = try JSONDecoder().decode(WeatherModel.self, from: data!)
                
                DispatchQueue.main.async {
                    self.city = model.name
                    self.minTemp = String(model.main.temp_min)
                    self.maxTemp = String(model.main.temp_max)
                    self.temp = String(model.main.temp)
                    self.feelingTemp = String(model.main.feels_like)
                    if let icon = model.weather.first?.icon {
                        self.weatherIconUrl = "https://openweathermap.org/img/wn/\(icon)@2x.png"
                    }
                    self.isLoading = false
                }
                
            } catch {
                print("Error fetching the weather")
            }
        })
        dataTask.resume()
        
    }
    
}
