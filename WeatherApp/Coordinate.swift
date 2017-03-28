//
//  Coordinate.swift
//  WeatherApp
//
//  Created by Marin Rados on 23/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

struct Coordinate {
    var latitude: Double
    var longitude: Double
}

extension Coordinate: CustomStringConvertible {
    
    var description: String {
        return "lat=\(latitude)&lon=\(longitude)"
    }
}
