//
//  DailyForecast.swift
//  WeatherApp
//
//  Created by Marin Rados on 24/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

struct DailyForecast {
    let maxTemperature: Double
    let minTemperature: Double
    let day: Date
    let icon: String
}

extension DailyForecast {
    
    struct Key {
        static let list = "list"
        static let weather = "weather"
        static let temp = "temp"
        static let min = "min"
        static let max = "max"
        static let date = "dt"
        static let icon = "icon"
    }
    
    init?(json: [String: Any], index: Int) {
        guard let list = json[Key.list] as? [[String: Any]],
            let temp = list[index][Key.temp] as? [String: Any],
            let maxValue = temp[Key.max] as? Double,
            let minValue = temp[Key.min] as? Double,
            let weather = list[index][Key.weather] as? [[String: Any]],
            let iconString = weather[0][Key.icon] as? String,
            let unixTime = list[index][Key.date] as? Double else { return nil }
        
        self.maxTemperature = maxValue
        self.minTemperature = minValue
        self.icon = iconString
        self.day = Date(timeIntervalSince1970: unixTime)
    }
}
