//
//  WeatherViewModel.swift
//  WeatherApp
//
//  Created by Marin Rados on 22/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
class WeatherViewModel {
  
    let client =  APIClient()
    var onSuccess: ((CurrentWeatherPresentable)->Void)?
    var onError: ((String)->Void)?
    
    
    
    func getWeather(coordinates: Coordinate) {
        client.getCurrentWeather(at: coordinates) { [weak self] (currentWeather, error) in
            if let currentWeather = currentWeather {
                let presentableData = CurrentWeatherPresentable(model: currentWeather)
                self?.onSuccess?(presentableData)
            } else {
                self?.onError?(String(describing: error))
            }
        }
    }
}
