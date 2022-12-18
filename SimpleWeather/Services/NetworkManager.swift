//
//  NetworkManager.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 18.12.2022.
//

import Foundation

class NetworkManager {
    
    static let shared = NetworkManager()
    private init() {}
    /*
    func fetchWeatherReport(requestLink: String) {
        guard let link = URL(string: requestLink) else { return }
        
        URLSession.shared.dataTask(with: link) { [weak self] data, _, error in
            guard let data else {
                print(error?.localizedDescription ?? "No error")
                return
            }
            
            do {
                let weather = try JSONDecoder().decode(MainDataBlock.self, from: data)
                self?.report = weather
                print(self?.report)
                
                DispatchQueue.main.async {
                    self?.printoutLabel.text = """
Date: \(String(describing: self!.report!.dataseries![0].date!))
Weather: \(String(describing: self!.report!.dataseries![0].weather!))
Minimum temp: \(String(describing: self!.report!.dataseries![0].temp2m!.max!)) degrees
Maximum temp: \(String(describing: self!.report!.dataseries![0].temp2m!.max!)) degrees
Wind: \(String(describing: self!.report!.dataseries![0].wind10m_max!)) m/s
"""
                }
                self?.successAlert()
            } catch let error {
                print(error)
                self?.failedAlert()
            }
        }.resume()
        
    }
     */
}
