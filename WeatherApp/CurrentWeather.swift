//
//  CurrentWeather.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation


struct CurrentWeather {
    let temperature: Double
    let pressure: Double
    let humidity: Double
    let windSpeed: Double
    let cloudiness: Double
    let summary: String
    let icon: String
}

extension CurrentWeather {
    
    struct Key {
        static let main = "main"
        static let wind = "wind"
        static let clouds = "clouds"
        static let weather = "weather"
        static let temperature = "temp"
        static let pressure = "pressure"
        static let humidity = "humidity"
        static let speed = "speed"
        static let cloudiness = "all"
        static let summary = "description"
        static let icon = "description"
    }
    
    init?(json: [String: Any]) {
        guard let main = json[Key.main] as? [String: Any],
            let tempValue = main[Key.temperature] as? Double,
            let pressureValue = main[Key.pressure] as? Double,
            let humidityValue = main[Key.humidity] as? Double,
            let wind = json [Key.wind] as? [String: Any],
            let speedValue = wind[Key.speed] as? Double,
            let clouds = json [Key.clouds] as? [String: Any],
            let cloudsValue = clouds[Key.cloudiness] as? Double,
            let weather = json[Key.weather] as? [[String: Any]],
            let summaryString = weather[0][Key.summary] as? String,
            let iconString = weather[0][Key.icon] as? String else { return nil }
        
        self.temperature = tempValue
        self.pressure = pressureValue
        self.humidity = humidityValue
        self.windSpeed = speedValue
        self.cloudiness = cloudsValue
        self.summary = summaryString
        self.icon = iconString
    }
}
















