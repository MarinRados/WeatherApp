//
//  LocationViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 27/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit

class LocationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, LocationDelegate {

    @IBOutlet weak var locationTableView: UITableView!
    var changeLocationDelegate: ChangeLocationDelegate?
    var locations = [Location]()
    var locationsDictionary = [[String: Any]]()
    
    let defaults = UserDefaults.standard
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        let newLocations = defaults.object(forKey: "locations")
        convertToArrayFrom(newLocations as! [[String : Any]])
    }
    
    @IBAction func cancelModalView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    func convertToDictionaryFrom(_ array: [Location]) {
        for data in array {
            let dictionary: [String: Any] = [
                "city": data.city,
                "country": data.country,
                "coordinate": [
                    "latitude": data.coordinate.latitude,
                    "longitude": data.coordinate.longitude
                ]
            ]
            locationsDictionary.append(dictionary)
        }
    }
    
    func convertToArrayFrom(_ dictionary: [[String: Any]]) {
        for dict in dictionary {
            guard let city = dict["city"] as? String,
                let country = dict["country"] as? String,
                let coordinate = dict["coordinate"] as? [String: Any],
                let latitude = coordinate["latitude"] as? Double,
                let longitude = coordinate["longitude"] as? Double else { return }
            
            if let location = Location(city: city, country: country, coordinate: Coordinate(latitude: latitude, longitude: longitude)) {
                locations.append(location)
            }
        }
    }
}

extension LocationViewController {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return locations.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location") as! LocationCell
        
        let index = indexPath.row
        
        cell.cityLabel.text = locations[index].city
        cell.countryLabel.text = locations[index].country
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let newLocation = locations[index]
        if let delegate = self.changeLocationDelegate {
            delegate.changeLocation(newLocation)
        }
        dismiss(animated: true, completion: nil)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.locationDelegate = self
        }
    }
    
    func addLocation(_ location: Location) {
        print("Location VC \(location)")
        locations.append(location)
        convertToDictionaryFrom(locations)
        print("NEW LOCATIONS \(locationsDictionary)")
        defaults.set(locationsDictionary, forKey: "locations")
        locationTableView.reloadData()
    }
}



