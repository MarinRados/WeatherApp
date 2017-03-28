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

    var coordinate = Coordinate(latitude: 45.557968, longitude: 18.677825)
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
        let location = CLLocation(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
        geoCoder.reverseGeocodeLocation(location, completionHandler: { (placemarks, error) -> Void in
        
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            if let city = placeMark?.addressDictionary?["City"] as? String {
                print("GRAD \(city)")
            }
            
            if let country = placeMark?.addressDictionary?["Country"] as? String {
                print("DRŽAVA \(country)")
            }
            
        })
        
        print("Latitude \(locationCoordinate.latitude), Longitude \(locationCoordinate.longitude)")
        coordinate.latitude = locationCoordinate.latitude
        coordinate.longitude = locationCoordinate.longitude
        
        if let delegate = locationDelegate {
            delegate.addLocation(coordinate: coordinate)
        }
        
        _ = navigationController?.popViewController(animated: true)
    }
}
