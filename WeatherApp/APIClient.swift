//
//  APIClient.swift
//  WeatherApp
//
//  Created by Marin Rados on 21/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

class APIClient {
    
    fileprivate let apiKey = "e6db5dcb86641d91ffd8b6ac2c1df2ed"
    private let units = "metric"
    
    let downloader = JSONDownloader()
    
    func getCurrentWeather(at coordinate: Coordinate, completionHandler completion: @escaping (CurrentWeather?, ForecastError?) -> Void) {
        
        guard let url = URL(string: "http://api.openweathermap.org/data/2.5/weather?\(coordinate.description)&units=\(units)&APPID=\(self.apiKey)") else {
            completion(nil, .invalidURL)
            return
        }
        
        let request = URLRequest(url: url)
        
        let task = downloader.jsonTask(with: request) { json, error in
            
            guard let json = json else {
                completion(nil, error)
                return
            }
            
            guard let currentWeather = CurrentWeather(json: json) else {
                    completion(nil, .jsonParsingFailure)
                    return
            }
            
            completion(currentWeather, nil)
        }
        
        task.resume()
    }
}















