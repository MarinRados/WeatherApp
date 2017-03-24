//
//  SevenDayForecast.swift
//  WeatherApp
//
//  Created by Marin Rados on 23/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation


struct SevenDayForecast {
    let maxTemperature: Double
    let minTemperature: Double
    let day: Date
    let icon: String
}

extension SevenDayForecast {
    
    struct Key {
        static let list = "list"
        static let weather = "weather"
        static let temp = "temp"
        static let min = "min"
        static let max = "max"
        static let date = "dt"
        static let icon = "description"
    }
    
    init?(json: [String: Any]) {
        guard let list = json[Key.list] as? [[String: Any]],
            let temp = list[0][Key.temp] as? [String: Any],
            let maxValue = temp[Key.max] as? Double,
            let minValue = temp[Key.min] as? Double,
            let weather = list[0][Key.weather] as? [[String: Any]],
            let iconString = weather[0][Key.icon] as? String,
            let unixTime = list[0][Key.date] as? Double else { return nil }
        
        self.maxTemperature = maxValue
        self.minTemperature = minValue
        self.icon = iconString
        self.day = Date(timeIntervalSince1970: unixTime)
    }
}





