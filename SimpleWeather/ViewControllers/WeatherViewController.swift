//
//  ViewController.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import UIKit

class WeatherViewController: UIViewController {
    
    
    @IBOutlet var latitudeTF: UITextField!
    @IBOutlet var longitudeTF: UITextField!
    @IBOutlet var printoutLabel: UILabel!
    
    
    var longitude = 55.45 // fixed for testing to Moscow
    var latitude = 37.36 // fixed for testing to Moscow
    let reportType = "civillight" // may be updated for more complex report in future
    var requestLink = ""
    var report: MainDataBlock?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        latitudeTF.text = String(latitude)
        longitudeTF.text = String(longitude)
    }
    
    @IBAction func requestWeatherTapped(_ sender: Any) {
        latitude = Double(latitudeTF.text!) ?? 37.36
        longitude = Double(longitudeTF.text!) ?? 55.45
        requestLink = generateRequestLink(
            longitude: longitude,
            latitude: latitude,
            reportType: reportType
        )
        fetchWeatherReport(requestLink: requestLink)
        //print(report)
    }
    
    
    
    
    private func generateRequestLink(longitude: Double, latitude: Double, reportType: String) -> String {
        return "https://www.7timer.info/bin/api.pl?lon=\(longitude)&lat=\(latitude)&product=\(reportType)&output=json"
    }
    
    private func successAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Request fulfilled",
                message: "Forecast data block is printed and labeled",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func failedAlert() {
        DispatchQueue.main.async {
            let alert = UIAlertController(
                title: "Request failed",
                message: "Error message is printed",
                preferredStyle: .alert
            )
            
            let okAction = UIAlertAction(title: "OK", style: .default)
            alert.addAction(okAction)
            self.present(alert, animated: true)
        }
    }
    
    private func fetchWeatherReport(requestLink: String) {
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
}
// link example
// https://www.7timer.info/bin/api.pl?lon=55.45&lat=37.36&product=civillight&output=json
