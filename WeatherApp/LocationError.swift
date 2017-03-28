//
//  LocationError.swift
//  WeatherApp
//
//  Created by Marin Rados on 28/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

enum LocationError: Error {
    case noCityFound
    case noCountryFound
}
