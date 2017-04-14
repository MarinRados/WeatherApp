//
//  LocationService.swift
//  WeatherApp
//
//  Created by Marin Rados on 03/04/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    var isAuthorized: Bool {
        
        let status = CLLocationManager.authorizationStatus()
        switch status {
        case .authorizedAlways:
            fallthrough
        case .authorizedWhenInUse:
            return true
        default:
            return false
        }
    }
    
    let locationsKey = "locations"
    let defaults = UserDefaults.standard
    
    
    func getSavedLocations() -> [Location] {
        if let newLocations = defaults.object(forKey: locationsKey) {
            return convertToArrayFrom(newLocations as! [[String : Any]])
        }
        
        return []
    }
    
    func saveLocations(_ locations: [Location]) {
        let dictionary = convertToDictionaryArrayFrom(locations)
        defaults.set(dictionary, forKey: locationsKey)
    }
    
    func addLocation(_ location: Location) {
        var allLocations = getSavedLocations()
        allLocations.append(location)
        saveLocations(allLocations)
    }
    
    func convertToArrayFrom(_ dictionary: [[String: Any]]) -> [Location] {
        var convertedLocations = [Location]()
        for dict in dictionary {
            guard let city = dict["city"] as? String,
                let country = dict["country"] as? String,
                let coordinate = dict["coordinate"] as? [String: Any],
                let latitude = coordinate["latitude"] as? Double,
                let longitude = coordinate["longitude"] as? Double else { return [] }
            
            if let location = Location(city: city, country: country, coordinate: Coordinate(latitude: latitude, longitude: longitude)) {
                convertedLocations.append(location)
            }
        }
        return convertedLocations
    }
    
    func convertToDictionaryArrayFrom(_ array: [Location]) -> [[String: Any]] {
        var convertedDictionary = [[String: Any]]()
        for data in array {
            let dictionary: [String: Any] = [
                "city": data.city,
                "country": data.country,
                "coordinate": [
                    "latitude": data.coordinate.latitude,
                    "longitude": data.coordinate.longitude
                ]
            ]
            convertedDictionary.append(dictionary)
        }
        return convertedDictionary
    }

}
