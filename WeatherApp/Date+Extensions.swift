//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Marin Rados on 24/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
extension Date {
    
    func dayOfTheWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
    }
    
}
