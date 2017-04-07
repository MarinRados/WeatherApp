//
//  ForecastError.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

enum ForecastError: Error {
    case requestFailed
    case responseUnsuccessful
    case invalidData
    case jsonConversionFailure
    case invalidURL
    case jsonParsingFailure
}











