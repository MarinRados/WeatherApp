//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CLLocationManagerDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: WeatherViewModel!
    var currentData: CurrentWeatherPresentable? = nil
    var forecastData: [SevenDayForecastPresentable]? = nil
    var currentLocation: Location?
    var trackedLocation: Location?
    var allLocations = [Location]()
    let defaults = UserDefaults.standard
    let locationService = LocationService()
    let lastLocationKey = "lastLocation"
    let locationsKey = "locations"
    var pagerIndex: Int?
    let refreshControl = UIRefreshControl()
    
    override func viewWillAppear(_ animated: Bool) {
        allLocations = locationService.getSavedLocations()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //tableView.refreshControl = refreshControl
        
        setViewModel()
        
        refreshWeather()

        viewModel.onSuccess = { [weak self] data in
            self?.currentData = data
            self?.tableView.reloadData()
            //self?.tableView.refreshControl?.endRefreshing()
        }
        
        viewModel.onForecastSuccess = { [weak self] data in
            self?.forecastData = data
            self?.tableView.reloadData()
            //self?.tableView.refreshControl?.endRefreshing()
        }
        
        viewModel.onError = { [weak self] error in
            switch error {
            case .invalidData: self?.showAlertWith(message: "Invalid data.")
            case .invalidURL: self?.showAlertWith(message: "Invalid URL.")
            case .requestFailed: self?.showAlertWith(message: "Request to fetch data failed.")
            case .responseUnsuccessful: self?.showAlertWith(message: "Response unsuccessful.")
            case .jsonConversionFailure: self?.showAlertWith(message: "JSON conversion failed.")
            case .jsonParsingFailure: self?.showAlertWith(message: "JSON parsing failed.")
            }
            //self?.tableView.refreshControl?.endRefreshing()
        }
        
        //self.tableView.refreshControl?.addTarget(self, action: #selector(WeatherViewController.refreshWeather), for: UIControlEvents.valueChanged)

    }
    
    func refreshWeather() {
        guard let coordinate = currentLocation?.coordinate else {
            return
        }
        viewModel.getWeather(coordinates: coordinate)
        viewModel.getForecast(coordinates: coordinate)
        //tableView.reloadData()
    }
    
    private func setViewModel(){
        viewModel = WeatherViewModel()
    }
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDays", for: indexPath) as! SevenDayForecastCell
        
        let index = indexPath.row + 1

        cell.dayLabel.text = forecastData?[index].day
        cell.weatherImage.image = forecastData?[index].icon
        cell.highTemperatureLabel.text = forecastData?[index].maxTemperature
        cell.lowTemperatureLabel.text = forecastData?[index].minTemperature
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let currentLocation = currentLocation else {
            return nil
        }
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeather") as! CurrentWeatherCell
        headerCell.temperatureLabel.text = currentData?.temperature
        headerCell.locationLabel.text = "\(currentLocation.city), \(currentLocation.country)"
        headerCell.weatherImage.image = currentData?.icon
        headerCell.summaryLabel.text = currentData?.summary
        headerCell.pageControl.numberOfPages = allLocations.count
        if let index = pagerIndex {
            headerCell.pageControl.currentPage = index
        }
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfo") as! AdditionalInfoCell
        
        guard let currentData = currentData else {
            return nil
        }
        
        footerCell.pressureLabel.text = "Pressure: \(currentData.pressure) hPa"
        footerCell.humidityLabel.text = "Humidity: \(currentData.humidity) %"
        footerCell.windSpeedLabel.text = "Wind speed: \(currentData.windSpeed) km/h"
        footerCell.cloudinessLabel.text = "Cloudiness: \(currentData.cloudiness) %"
        return footerCell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
    
    func convertToDictionaryFrom(_ location: Location) -> [String: Any] {
        let dictionary: [String: Any] = [
            "city": location.city,
            "country": location.country,
            "coordinate": [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
        ]
        return dictionary
    }
    
    func convertToLocationFrom(_ dictionary: [String: Any]) -> Location? {
        guard let city = dictionary["city"] as? String,
            let country = dictionary["country"] as? String,
            let coordinate = dictionary["coordinate"] as? [String: Any],
            let latitude = coordinate["latitude"] as? Double,
            let longitude = coordinate["longitude"] as? Double else { return nil }
        
        guard let location = Location(city: city, country: country, coordinate: Coordinate(latitude: latitude, longitude: longitude)) else { return nil }
        
        return location
    }
}
