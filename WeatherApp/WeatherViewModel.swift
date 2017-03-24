//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marin Rados on 22/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import UIKit

class WeatherViewModel {
  
    let client =  APIClient()
    var onSuccess: ((CurrentWeatherPresentable)->Void)?
    var onForecastSuccess: ((SevenDayForecastPresentable)->Void)?
    var onError: ((ForecastError)->Void)?
    
    
    
    func getWeather(coordinates: Coordinate) {
        client.getCurrentWeather(at: coordinates) { [weak self] (currentWeather, error) in
            if let currentWeather = currentWeather {
                let presentableData = CurrentWeatherPresentable(model: currentWeather)
                self?.onSuccess?(presentableData)
            } else {
                self?.onError?(error!)
            }
        }
    }
    
    func getForecast(coordinates: Coordinate) {
        client.getSevenDayForecast(at: coordinates) { [weak self] (sevenDayForecast, error) in
            if let sevenDayForecast = sevenDayForecast {
                let presentableData = SevenDayForecastPresentable(model: sevenDayForecast)
                self?.onForecastSuccess?(presentableData)
            } else {
                self?.onError?(error!)
            }
        }
    }
}

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

struct SevenDayForecastPresentable {
    let maxTemperature: String
    let minTemperature: String
    let day: String
    let icon: UIImage
    
    init(model: SevenDayForecast) {
        
        self.maxTemperature = "\(Int(model.maxTemperature))"
        self.minTemperature = "\(Int(model.minTemperature))"
        self.day = "\(model.day.dayOfWeek())"
        
        let weatherIcon = WeatherIcon(iconString: model.icon)
        self.icon = weatherIcon.image
    }
}

