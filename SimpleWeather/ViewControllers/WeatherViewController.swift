//
//  ViewController.swift
//  SimpleWeather
//
//  Created by MacBook Air 13 on 14.12.2022.
//

import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: IBOutlets
    @IBOutlet var cityPickerView: UIPickerView!
    
    // MARK: Properties
    let cityCoordinates = [
        "Moscow":[55.45, 37.36],
        "St.Petersburg":[59.56, 30.18],
        "Klimovsk":[55.3591, 37.5210],
        "London":[51.5072, 0.1276],
        "Brussels":[50.8476, 4.3572],
        "Samara":[53.2038, 50.1606]
    ]
    var cityNames: [String] = []
    var selectedCity = ""
    var requestLink = ""
    var weather: MainDataBlock?
    
    // MARK: viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        cityNames = cityCoordinates.keys.sorted()
    }
    
    // MARK: IBActions
    @IBAction func requestWeatherTapped(_ sender: Any) {
        guard let coordinates = cityCoordinates[selectedCity] else { return }
        let longitude = coordinates[0]
        let latitude = coordinates[1]
        requestLink = generateRequestLink(longitude: longitude, latitude: latitude)
        fetchWeatherReport()
        print(weather)
    }
    
    // MARK: Methods
    
    private func fetchWeatherReport() {
        NetworkManager.shared.fetchWeatherReport(from: requestLink) {[weak self] result in
            switch result {
            case .success(let report):
                self?.weather = report
                self?.successAlert()
            case .failure(let error):
                print(error)
                self?.failedAlert()
            }
        }
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
    
    
  
}
extension WeatherViewController:UIPickerViewDataSource, UIPickerViewDelegate {
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int { 1 }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        cityNames.count
        }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        cityNames[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedCity = cityNames[row]
    }
}
    
