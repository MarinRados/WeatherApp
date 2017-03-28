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
    var location: Location?
    
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
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Location") as! LocationCell
        
        cell.cityLabel.text = "Osijek"
        cell.countryLabel.text = "Croatia"
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Map" {
            let destinationViewController = segue.destination as! MapViewController
            destinationViewController.locationDelegate = self
        }
    }
    
    func addLocation(_ location: Location) {
        print("Location VC \(location)")
    }
}



