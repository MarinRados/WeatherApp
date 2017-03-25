//
//  WeatherIcon.swift
//  WeatherApp
//
//  Created by Marin Rados on 21/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import UIKit

enum WeatherIcon {
    case clearSky
    case fewClouds
    case scatteredClouds
    case brokenClouds
    case showerRain
    case rain
    case thunderstrom
    case snow
    case mist
    case `default`
    
    init(iconString: String) {
        switch iconString {
        case "01n", "01d": self = .clearSky
        case "02n", "02d": self = .fewClouds
        case "03n", "03d": self = .scatteredClouds
        case "04n", "04d": self = .brokenClouds
        case "09n", "09d": self = .showerRain
        case "10n", "10d": self = .rain
        case "11n", "11d": self = .thunderstrom
        case "13n", "13d": self = .snow
        case "50n", "50d": self = .mist
        default: self = .default
        }
    }
}

extension WeatherIcon {
    var image: UIImage {
        switch self {
        case .clearSky: return #imageLiteral(resourceName: "clear-day")
        case .fewClouds: return #imageLiteral(resourceName: "partly-cloudy-day")
        case .scatteredClouds: return #imageLiteral(resourceName: "cloudy")
        case .brokenClouds: return #imageLiteral(resourceName: "cloudy")
        case .showerRain: return #imageLiteral(resourceName: "rain")
        case .rain: return #imageLiteral(resourceName: "rain")
        case .thunderstrom: return #imageLiteral(resourceName: "rain")
        case .snow: return #imageLiteral(resourceName: "snow")
        case .mist: return #imageLiteral(resourceName: "fog")
        case .default: return #imageLiteral(resourceName: "default")
        }
    }
}






