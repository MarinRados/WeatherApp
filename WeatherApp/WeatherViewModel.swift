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
    var onForecastSuccess: (([SevenDayForecastPresentable])->Void)?
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
        client.getSevenDayForecast(at: coordinates) { [weak self] (dailyForecast, error) in
            var sevenDayForecastData = [SevenDayForecastPresentable]()
            if let dailyForecast = dailyForecast {
                for index in 0...7 {
                    let presentableData = SevenDayForecastPresentable(model: dailyForecast[index], index: index)
                    sevenDayForecastData.append(presentableData)
                }
                self?.onForecastSuccess?(sevenDayForecastData)
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
    
    init(model: DailyForecast, index: Int) {
        self.maxTemperature = "\(Int(model.maxTemperature))"
        self.minTemperature = "\(Int(model.minTemperature))"
        let dayOfTheWeek = model.day.dayOfTheWeek() ?? ""
        self.day = "\(dayOfTheWeek)"
        
        let weatherIcon = WeatherIcon(iconString: model.icon)
        self.icon = weatherIcon.image
    }
}

