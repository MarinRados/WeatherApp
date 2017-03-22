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
    var data: CurrentWeatherPresentable? = nil
    let coordinate = Coordinate(latitude: 45.557968, longitude: 18.677825)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setViewModel()
        viewModel.getWeather(coordinates: coordinate)

        viewModel.onSuccess = { [weak self] data in
            self?.data = data
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
        self.refreshControl?.addTarget(self, action: #selector(WeatherViewController.refreshWeather(refreshControl:)), for: UIControlEvents.valueChanged)

    }
    
    func refreshWeather(refreshControl: UIRefreshControl) {
        viewModel.getWeather(coordinates: coordinate)
    }
    
    private func setViewModel(){
        viewModel = WeatherViewModel()
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

        cell.dayLabel.text = "Monday"
        cell.weatherImage.image = #imageLiteral(resourceName: "partly-cloudy-day")
        cell.highTemperatureLabel.text = "22°"
        cell.lowTemperatureLabel.text = "10°"
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeather") as! CurrentWeatherCell
        headerCell.temperatureLabel.text = data?.temperature
        headerCell.locationLabel.text = "Osijek, Croatia"
        headerCell.weatherImage.image = data?.icon
        headerCell.summaryLabel.text = data?.summary
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfo") as! AdditionalInfoCell
        
        guard let data = data else {
            return nil
        }
        
        footerCell.pressureLabel.text = "Pressure: \(data.pressure) hPa"
        footerCell.humidityLabel.text = "Humidity: \(data.humidity) %"
        footerCell.windSpeedLabel.text = "Wind speed: \(data.windSpeed) km/h"
        footerCell.cloudinessLabel.text = "Cloudiness: \(data.cloudiness) %"
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 220
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 200
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
