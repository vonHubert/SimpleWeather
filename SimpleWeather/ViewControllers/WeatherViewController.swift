
//  ViewController.swift
//  SimpleWeather


import UIKit

class WeatherViewController: UIViewController {
    
    // MARK: IBOutlets
    
    @IBOutlet var cityPickerView: UIPickerView!
    @IBOutlet var weatherTableView: UITableView!
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    
    // MARK: Properties
    
    let cityCoordinates = [
        "Moscow":[55.45, 37.36],
        "St.Petersburg":[59.56, 30.18],
        "Klimovsk":[55.3591, 37.5210],
        "London":[51.5072, 0.1276],
        "Brussels":[50.8476, 4.3572],
        "Samara":[53.2038, 50.1606],
        "Tbilisi":[41.7151, 44.8271],
        "Karaganda":[49.8047, 73.1094],
        "Izmail":[45.3502, 28.8502],
        "Tuapse":[44.0962, 39.0745],
        "Paris":[48.8566, 2.3522],
        "Geneva":[46.2044, 6.1432],
        "Ashgabat":[37.9601, 58.3261]
    ]
    var cityNames: [String] = []
    var selectedCity = ""
    var requestLink = ""
    var weather: [WeatherDataBlock] = []
    let dateFormatter = DateFormatter()

    
    // MARK: viewDidLoad
    
    override func viewDidLoad() {
        super.viewDidLoad()
        cityPickerView.dataSource = self
        cityPickerView.delegate = self
        weatherTableView.dataSource = self
        dateFormatter.dateFormat = "MMM dd,yyyy"
        cityNames = cityCoordinates.keys.sorted()
        selectedCity = cityNames[0]
        activityIndicator.isHidden = true
        activityIndicator.hidesWhenStopped = true

    }
    
    // MARK: IBActions
    
    @IBAction func requestWeatherTapped(_ sender: Any) {
        guard let coordinates = cityCoordinates[selectedCity] else { return }
        let latitude = coordinates[0]
        let longitude = coordinates[1]

    
        requestLink = generateRequestLink(longitude: longitude, latitude: latitude)
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchWeatherReport()
    }
    
    // MARK: Methods
    
    private func fetchWeatherReport() {
        NetworkManager.shared.fetchWeatherReport(from: requestLink) {[weak self] result in
            switch result {
            case .success(let report):
                self?.weather = report.dataseries ?? []
                self?.activityIndicator.stopAnimating()
                self?.weatherTableView.reloadData()
                print(report)
            case .failure(let error):
                print(error)
            }
        }
    }
}
// MARK: City PickerView Ext.

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
    
// MARK: 7 days Weather TableView Ext.

extension WeatherViewController:UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       weather.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "day", for: indexPath)
        let daysWeather = weather[indexPath.row]
        var weatherName = ""
        var weatherImageName = ""
        
        switch daysWeather.weather {
        case "clear": weatherName = "Clear"
        case "cloudy": weatherName =  "Cloudy (80-100%)"
        case "mcloudy": weatherName = "Mild clouds (20-60%)"
        case "pcloudy": weatherName = "More clouds (60-80%)"
        case "rain": weatherName = "Rainy"
        case "lightrain": weatherName = "Light rain"
        case "snow": weatherName = "Snowfall"
        case "ts": weatherName = "Thunderstorm"
        case "tsrain": weatherName = "Thunderstorm with rain"
        case .none: weatherName = ""
        case .some(_): weatherName = ""
        }
        switch daysWeather.weather {
        case "clear": weatherImageName = "about_two_clear"
        case "cloudy": weatherImageName =  "about_two_cloudy"
        case "mcloudy": weatherImageName = "about_two_pcloudy"
        case "pcloudy": weatherImageName = "about_two_pcloudy"
        case "rain": weatherImageName = "about_two_rain"
        case "lightrain": weatherImageName = "about_two_rain"
        case "snow": weatherImageName = "about_two_snow"
        case "ts": weatherImageName = "about_two_ts"
        case "tsrain": weatherImageName = "about_two_tsrain"
        case .none: weatherImageName = ""
        case .some(_): weatherImageName = ""
        }
        
        var content = cell.defaultContentConfiguration()
        content.text = "\(daysWeather.date ?? 0)"
        content.secondaryText = """
    Weather: \(weatherName)
    Minimum temp: \(daysWeather.temp2m?.min ?? 0) degrees
    Maximum temp: \(daysWeather.temp2m?.max ?? 0) degrees
    Wind: \(daysWeather.wind10m_max ?? 0) m/s
"""
        content.image = UIImage(named: weatherImageName)
        cell.contentConfiguration = content
        return cell
    }
}
