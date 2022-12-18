//
//  Data.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import Foundation

struct TemperatureDataBlock: Decodable {
    let max: Int?
    let min: Int?
}

struct WeatherDataBlock: Decodable {
    let date: Date?
    let weather: String?
    let temp2m: TemperatureDataBlock?
    let wind10m_max: Int?
}

struct MainDataBlock: Decodable {
    let product: String?
    let dataseries: [WeatherDataBlock]?
}

struct City {
    let name: String
    let coordinates: [Double]
}

