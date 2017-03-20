//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit

class WeatherViewController: UITableViewController {

    fileprivate let apiKey = "e6db5dcb86641d91ffd8b6ac2c1df2ed"
    let cityId = "3193935"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let forecastURL = URL(string: "api.openweathermap.org/data/2.5/forecast/city?id=\(cityId)&APPID=\(apiKey)")
        
        let configuration = URLSessionConfiguration.default
        let session = URLSession(configuration: configuration)
        
        
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
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeather") as! CurrentWeatherCell
        
        headerCell.temperatureLabel.text = "20"
        headerCell.locationLabel.text = "Osijek, Croatia"
        headerCell.weatherImage.image = #imageLiteral(resourceName: "clear-day")
        headerCell.summaryLabel.text = "Sunny"
        
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfo") as! AdditionalInfoCell
        
        footerCell.pressureLabel.text = "Pressure: 23 bar"
        footerCell.humidityLabel.text = "Humidity: 34%"
        footerCell.windSpeedLabel.text = "Wind speed: 5 km/h"
        footerCell.cloudinessLabel.text = "Cloudiness: 26%"
        
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
