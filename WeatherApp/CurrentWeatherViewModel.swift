//
//  CurrentWeatherViewModel.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import UIKit
struct CurrentWeatherPresentable {
    let temperature: String
    let pressure: String
    let humidity: String
    let windSpeed: String
    let cloudiness: String
    let summary: String
    let icon: UIImage
    
    init(model: CurrentWeather) {
        
        self.temperature = "\(Int(model.temperature))"
        self.pressure = "\(model.pressure)"
        self.humidity = "\(Int(model.humidity))"
        self.windSpeed = "\(model.windSpeed)"
        self.cloudiness = "\(Int(model.cloudiness))"
        self.summary = model.summary.capitalized
        
        let weatherIcon = WeatherIcon(iconString: model.icon)
        self.icon = weatherIcon.image
    }
}














