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
    var locations = [Location?]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationTableView.delegate = self
        locationTableView.dataSource = self
    }
    
    @IBAction func cancelModalView(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
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
        
        cell.cityLabel.text = locations[index]?.city
        cell.countryLabel.text = locations[index]?.country
        cell.selectionStyle = .none
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let index = indexPath.row
        guard let newLocation = locations[index] else {
            return
        }
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
        locationTableView.reloadData()
    }
}



