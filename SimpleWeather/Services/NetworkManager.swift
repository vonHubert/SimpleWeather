
//  NetworkManager.swift
//  SimpleWeather


import Foundation

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

    func fetchWeatherReport(from link: String?, completion: @escaping(Result<MainDataBlock, NetworkError>) -> Void) {
        guard let url = URL(string: link ?? "") else {
            completion(.failure(.invalidURL))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, _, error in
            guard let data = data else {
                completion(.failure(.noData))
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(MainDataBlock.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(weather))
                }
            } catch {
                completion(.failure(.decodingError))
            }
        }.resume()
    }
}
