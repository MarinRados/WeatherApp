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
        case "clear sky": self = .clearSky
        case "few clouds": self = .fewClouds
        case "scattered clouds": self = .scatteredClouds
        case "broken clouds": self = .brokenClouds
        case "shower rain": self = .showerRain
        case "rain": self = .rain
        case "thunderstorm": self = .thunderstrom
        case "snow": self = .snow
        case "mist": self = .mist
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






