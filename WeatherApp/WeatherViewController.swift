//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {
    

    var viewModel: WeatherViewModel!
    var currentData: CurrentWeatherPresentable? = nil
    var forecastData: [SevenDayForecastPresentable]? = nil
    let coordinate = Coordinate(latitude: 45.557968, longitude: 18.677825)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel.getWeather(coordinates: coordinate)
        viewModel.getForecast(coordinates: coordinate)

        viewModel.onSuccess = { [weak self] data in
            self?.currentData = data
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
        viewModel.onForecastSuccess = { [weak self] data in
            self?.forecastData = data
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
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
            self?.refreshControl?.endRefreshing()
        }
        
        self.refreshControl?.addTarget(self, action: #selector(WeatherViewController.refreshWeather(refreshControl:)), for: UIControlEvents.valueChanged)

    }
    
    func refreshWeather(refreshControl: UIRefreshControl) {
        viewModel.getWeather(coordinates: coordinate)
        viewModel.getForecast(coordinates: coordinate)
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

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDays", for: indexPath) as! SevenDayForecastCell
        
        let index = indexPath.row + 1

        cell.dayLabel.text = forecastData?[index].day
        cell.weatherImage.image = forecastData?[index].icon
        cell.highTemperatureLabel.text = forecastData?[index].maxTemperature
        cell.lowTemperatureLabel.text = forecastData?[index].minTemperature
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeather") as! CurrentWeatherCell
        headerCell.temperatureLabel.text = currentData?.temperature
        headerCell.locationLabel.text = "Osijek, Croatia"
        headerCell.weatherImage.image = currentData?.icon
        headerCell.summaryLabel.text = currentData?.summary
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
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
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
}
