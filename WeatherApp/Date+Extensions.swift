//
//  Date+Extensions.swift
//  WeatherApp
//
//  Created by Marin Rados on 24/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
extension Date {
    
    func dayOfWeek() -> String? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        return dateFormatter.string(from: self).capitalized
        // or use capitalized(with: locale) if you want
    }
    
}
