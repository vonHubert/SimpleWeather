//
//  Data.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import Foundation

struct MainDataBlock: Decodable {
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
        
//    static func getMainData(from value: Any) -> [MainDataBlock] {
//        guard let mainData = value as? [[String: Any]] else { return[] }
//        return mainData.compactMap{ MainDataBlock(mainData: $0) }
//     }
    
//    static func getMainData(from value: Any) -> [MainDataBlock] {
//        print("VALUE RECIEVED BY getMainData:\(value)")
//        guard let mainData = value as? [[String: Any]] else {
//            print("GUARD ELSE ACTIVATED! value NOT CHECKED AS")
//            return []
//        } // здесь выполняется else ((((
//        print("MAIN DATA: \(mainData)")
//        var mainDataBlock: [MainDataBlock] = []
//        for mainDataPack in mainData {
//            let pack = MainDataBlock(mainData: mainDataPack)
//            print("PACK:\(pack)")
//            mainDataBlock.append(pack)
//        }
//        return mainDataBlock
//    }
    
    static func getWeatherData(from value: Any) -> [WeatherDataBlock] {
        print("VALUE RECIEVED BY getMainData:\(value)")
        guard let mainData = value as? [String: Any] else {
            print("GUARD ELSE ACTIVATED! value NOT CHECKED AS INITIAL DICTIONARY [String: Any]")
            return []
        }
        print("MAIN DATA: \(mainData)")
        guard let weatherData = mainData["dataseries"] as? [[String: Any]] else {
            print("GUARD ELSE ACTIVATED! value NOT CHECKED AS [[String: Any]]")
            return []
        }
        print("WEATHER DATA: \(mainData)")
        var weatherDataBlock: [WeatherDataBlock] = []
        for weatherDataPacket in weatherData {
            let pack = WeatherDataBlock(weatherData: weatherDataPacket)
            print("PACK:\(pack)")
            weatherDataBlock.append(pack)
        }
        return weatherDataBlock
    }
    
    
}

struct WeatherDataBlock: Decodable {
    let date: Int
    let weather: String
    let temp2m: TemperatureDataBlock
    let wind10mMax: Int
    
    init(weatherData: [String: Any]) {
        date = weatherData["date"] as? Int ?? 0
        weather = weatherData["weather"] as? String ?? ""
        temp2m = weatherData["temp2m"] as? TemperatureDataBlock ?? TemperatureDataBlock(max: 0, min: 0)
        wind10mMax = weatherData["wind10m_max"] as? Int ?? 0
    }
    
    init(date: Int, weather: String, temp2m: TemperatureDataBlock, wind10m_max: Int) {
        self.date = date
        self.weather = weather
        self.temp2m = temp2m
        self.wind10mMax = wind10m_max
    }
    
    static func getWeatherData(from value: Any) -> [WeatherDataBlock] {
        guard let weatherData = value as? [[String: Any]] else {
            print("GUARD ELSE ACTIVATED! value NOT CHECKED AS WeatherDataBlock")
            return[]
        }
        return weatherData.compactMap{ WeatherDataBlock(weatherData: $0) }
     }
    
}

struct TemperatureDataBlock: Decodable {
    let max: Int
    let min: Int
    
    init(temperatureData: [String: Any]) {
        max = temperatureData["max"] as? Int ?? 0
        min = temperatureData["min"] as? Int ?? 0
    }
    
    init(max: Int, min: Int) {
        self.max = max
        self.min = min
    }
    
    static func getTemperatureData(from value: Any) -> [TemperatureDataBlock] {
        guard let temperatureData = value as? [[String: Any]] else { return[] }
        return temperatureData.compactMap{ TemperatureDataBlock(temperatureData: $0) }
     }
}

struct City {
    let name: String
    let coordinates: [Double]
}
