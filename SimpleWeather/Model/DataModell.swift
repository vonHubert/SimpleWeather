//
//  Data.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import Foundation

struct MainDataBlock {
    let product: String
    let dataseries: [WeatherDataBlock]?
    
    init(mainData: [String: Any]) {
        product = mainData["product"] as? String ?? ""
        dataseries = mainData["dataseries"] as? [WeatherDataBlock] ?? []
    }

    init(product: String, dataseries: [WeatherDataBlock]) {
        self.product = product
        self.dataseries = dataseries
    }
    
    static func getWeatherData(from value: Any) -> [WeatherDataBlock] {
        guard let mainData = value as? [String: Any] else {
            return []
        }
        guard let weatherData = mainData["dataseries"] as? [[String: Any]] else {
            return []
        }
        var weatherDataBlock: [WeatherDataBlock] = []
        for weatherDataPacket in weatherData {
            let packet = WeatherDataBlock(weatherData: weatherDataPacket)
            weatherDataBlock.append(packet)
        }
        return weatherDataBlock
    }
}

struct WeatherDataBlock {
    let date: Int
    let weather: String
    let temp2m: [String : Any]
    let wind10mMax: Int
    
    init(weatherData: [String: Any]) {
        date = weatherData["date"] as? Int ?? 0
        weather = weatherData["weather"] as? String ?? ""
        temp2m = weatherData["temp2m"] as? [String : Any] ?? ["": 0]
        wind10mMax = weatherData["wind10m_max"] as? Int ?? 0
    }
}

struct City {
    let name: String
    let coordinates: [Double]
}

