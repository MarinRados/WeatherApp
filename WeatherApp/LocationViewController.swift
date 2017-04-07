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
    var trackedLocation: Location?
    var currentLocation: Location?
    let locationsKey = "locations"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
    }
    
    @IBAction func cancelModalView(_ sender: UIBarButtonItem) {
        if locations.isEmpty && !LocationService.isAuthorized {
            showAlertWith(message: "You have to enable current location tracking or add at least one location manually to use this app.")
        } else if trackedLocation == nil {
            showAlertWith(message: "Please select one of your added locations to see the weather.")
        } else {
            if let delegate = self.changeLocationDelegate {
                delegate.changeAllLocations(locations)
            }
            dismiss(animated: true, completion: nil)
        }
    }
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
        
        if index == 0 && trackedLocation != nil {
            cell.backgroundColor = UIColor.gray
        }
        
        cell.cityLabel.text = locations[index].city
        cell.countryLabel.text = locations[index].country
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let index = indexPath.row
        
        if index == 0 && trackedLocation != nil {
            return 0.5
        } else {
            return 60
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        let newLocation = locations[index]
        if let delegate = self.changeLocationDelegate {
            delegate.changeAllLocations(locations)
            delegate.changeLocation(newLocation, atIndex: index)
        }
        dismiss(animated: true, completion: nil)

    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            locations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .none)
            if let delegate = self.changeLocationDelegate {
                delegate.changeLocation(locations[0], atIndex: 0)
            }
            locationTableView.reloadData()
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.locationDelegate = self
            destinationViewController.currentLocation = trackedLocation
        }
    }
    
    func addLocation(_ location: Location) {
        locations.append(location)
        locationTableView.reloadData()
    }
}



