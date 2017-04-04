//
//  Location.swift
//  WeatherApp
//
//  Created by Marin Rados on 27/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation

struct Location: Equatable {
    var city: String
    var country: String
    var coordinate: Coordinate
    
    init?(city: String, country: String, coordinate: Coordinate) {
        self.city = city
        self.country = country
        self.coordinate = coordinate
    }
    
    static func == (left: Location, right: Location) -> Bool {
        return left.city == right.city
    }
}












