//
//  Data.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import Foundation

struct MainDataBlock: Decodable {
    let product: String?
    let dataseries: [WeatherDataBlock]?
}

struct WeatherDataBlock: Decodable {
    let date: Int?
    let weather: String?
    let temp2m: TemperatureDataBlock?
    let wind10m_max: Int?
}

struct TemperatureDataBlock: Decodable {
    let max: Int?
    let min: Int?
}

struct City {
    let name: String
    let coordinates: [Double]
}

