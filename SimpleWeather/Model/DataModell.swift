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
    
    static func getWeatherData(from value: Any) -> [WeatherDataBlock] {
       // print("VALUE RECIEVED BY getMainData:\(value)")
        guard let mainData = value as? [String: Any] else {
      //      print("GUARD ELSE ACTIVATED! value NOT CHECKED AS INITIAL DICTIONARY [String: Any]")
            return []
        }
      //  print("MAIN DATA: \(mainData)")
        guard let weatherData = mainData["dataseries"] as? [[String: Any]] else {
      //      print("GUARD ELSE ACTIVATED! value NOT CHECKED AS [[String: Any]]")
            return []
        }
      //  print("WEATHER DATA: \(mainData)")
        var weatherDataBlock: [WeatherDataBlock] = []
        for weatherDataPacket in weatherData {
            let pack = WeatherDataBlock(weatherData: weatherDataPacket)
       //     print("PACK:\(pack)")
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
}

struct TemperatureDataBlock: Decodable {
    let max: Int
    let min: Int
    
    init(max: Int, min: Int) {
        self.max = max
        self.min = min
    }
}

struct City {
    let name: String
    let coordinates: [Double]
}
