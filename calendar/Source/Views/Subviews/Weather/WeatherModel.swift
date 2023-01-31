//
//  WeatherModel.swift
//  calendar
//
//  Created by Tadeo Durazo on 30/01/23.
//

import Foundation

struct WeatherModel: Codable {
    let name: String
    let main: CurrentWeather
    let weather: [Weather]
}

struct CurrentWeather: Codable {
    let temp: Float
    let temp_min: Float
    let temp_max: Float
    let feels_like: Float
}

struct Weather: Codable {
    let icon: String
    let main: String
}
