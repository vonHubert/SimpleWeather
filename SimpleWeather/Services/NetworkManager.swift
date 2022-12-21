
//  NetworkManager.swift
//  SimpleWeather


import Foundation
import Alamofire

func generateRequestLink(longitude: Double, latitude: Double) -> String {
    let reportType = "civillight"
    return "https://www.7timer.info/bin/api.pl?lon=\(longitude)&lat=\(latitude)&product=\(reportType)&unit=Metric&output=json"
}

enum NetworkError: Error {
    case invalidURL
    case noData
    case decodingError
}

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}

    func fetchWeatherReportAF(from link: String, completion: @escaping(Result<[WeatherDataBlock], AFError>) -> Void ) {
        AF.request(link)
            .validate()
            .responseJSON { dataResponse in
                switch dataResponse.result {
                case .success(let value):
                    let report = MainDataBlock.getWeatherData(from: value)
                    completion(.success(report))
                case .failure(let error):
                    completion(.failure(error))
                    
                }
                
            }
    }
}

