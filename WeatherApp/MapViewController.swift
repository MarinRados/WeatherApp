//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 27/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate {
    
    var locationDelegate: LocationDelegate?
    
    @IBOutlet weak var mapView: MKMapView! {
        didSet {
            mapView.mapType = .hybrid
            mapView.delegate = self
            let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.getLocationWith(gesture:)))
            gestureRecognizer.minimumPressDuration = 1.0
            gestureRecognizer.delaysTouchesBegan = true
            gestureRecognizer.delegate = self
            self.mapView.addGestureRecognizer(gestureRecognizer)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func getLocationWith(gesture: UILongPressGestureRecognizer) {
        if gesture.state != UIGestureRecognizerState.began {
            return
        }
        let touchLocation = gesture.location(in: mapView)
        let locationCoordinate = mapView.convert(touchLocation, toCoordinateFrom: mapView)
        
        let geoCoder = CLGeocoder()
        let mapLocation = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        
        geoCoder.reverseGeocodeLocation(mapLocation, completionHandler: { (placemarks, error) -> Void in
        
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            guard let city = placeMark?.addressDictionary?["City"] as? String else {
                self.showAlertWith(message: "Please pick an inhabited location.")
                return
            }
            
            guard let country = placeMark?.addressDictionary?["Country"] as? String  else {
                self.showAlertWith(message: "Please pick an inhabited location.")
                return
            }
            
            let coordinate = Coordinate(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let location = Location(city: city, country: country, coordinate: coordinate)
            
            if let delegate = self.locationDelegate {
                delegate.addLocation(location)
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
