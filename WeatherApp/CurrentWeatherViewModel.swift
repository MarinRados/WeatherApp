//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import UIKit

struct CurrentWeatherViewModel {
    let temperature: String
    let pressure: String
    let humidity: String
    let windSpeed: String
    let cloudiness: String
    let summary: String
    let icon: UIImage
    
    init(model: CurrentWeather) {
        
        self.temperature = "\(model.temperature)"
        self.pressure = "\(model.pressure)"
        self.humidity = "\(Int(model.humidity * 100))"
        self.windSpeed = "\(model.windSpeed)"
        self.cloudiness = "\(Int(model.cloudiness * 100))"
        self.summary = model.summary
        self.icon = #imageLiteral(resourceName: "clear-day")
    }
}














