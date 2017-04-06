//
//  MapViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 27/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit
import MapKit
import GooglePlaces

class MapViewController: UIViewController, MKMapViewDelegate, UIGestureRecognizerDelegate, CLLocationManagerDelegate, GMSAutocompleteViewControllerDelegate {
    
    var locationDelegate: LocationDelegate?
    var currentLocation: Location?
    let locationManager = CLLocationManager()
    
    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        GMSPlacesClient.provideAPIKey("AIzaSyCivVmBDmFzZkatUnlWxMw7ML79VPrt5ls")
        
        mapView.mapType = .standard
        mapView.delegate = self
        let gestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(MapViewController.getLocationWith(gesture:)))
        gestureRecognizer.minimumPressDuration = 1.0
        gestureRecognizer.delaysTouchesBegan = true
        gestureRecognizer.delegate = self
        self.mapView.addGestureRecognizer(gestureRecognizer)
        guard let centerLocation = currentLocation else {
            return
        }
        getMapCenterFrom(currentLocation: centerLocation)
    }
    
    func getMapCenterFrom(currentLocation: Location) {
        var centerCoordinate = CLLocationCoordinate2D()
        centerCoordinate.latitude = currentLocation.coordinate.latitude
        centerCoordinate.longitude = currentLocation.coordinate.longitude
        self.mapView.setCenter(centerCoordinate, animated: false)
        let span = MKCoordinateSpanMake(5.0, 5.0)
        let region = MKCoordinateRegion(center: centerCoordinate, span: span)
        self.mapView.setRegion(region, animated: false)
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
                self.showAlertWith(message: "Please pick a location closer to a settlement.")
                return
            }
            
            guard let country = placeMark?.addressDictionary?["Country"] as? String  else {
                self.showAlertWith(message: "Please pick a location closer to a settlement.")
                return
            }
            
            let coordinate = Coordinate(latitude: locationCoordinate.latitude, longitude: locationCoordinate.longitude)
            let location = Location(city: city, country: country, coordinate: coordinate)
            
            if let delegate = self.locationDelegate, let newLocation = location {
                delegate.addLocation(newLocation)
            }
            
            _ = self.navigationController?.popViewController(animated: true)
        })
    }
    
    @IBAction func openAutocomplete(_ sender: Any) {
        let autocompleteController = GMSAutocompleteViewController()
        autocompleteController.delegate = self
        present(autocompleteController, animated: true, completion: nil)
    }
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}

extension MapViewController {
    
    func viewController(_ viewController: GMSAutocompleteViewController, didAutocompleteWith place: GMSPlace) {
        print("Place name: \(place.name)")
        print("Place address: \(place.formattedAddress ?? "")")
        print("Place coordinate lat: \(place.coordinate.latitude)")
        print("Place coordinate long: \(place.coordinate.longitude)")
        
        guard let address = place.formattedAddress else {
            return
        }
        
        let parts = address.components(separatedBy: ", ")
        
        if parts.count < 2 {
            showAlertWith(message: "Please provide a location with more information.")
            return
        }
        
        guard let city = parts.first else {
            return
        }
        
        guard let country = parts.last else {
            return
        }
        
        let coordinate = Coordinate(latitude: place.coordinate.latitude, longitude: place.coordinate.longitude)
        
        let location = Location(city: city, country: country, coordinate: coordinate)
        
        if let delegate = self.locationDelegate, let newLocation = location {
            delegate.addLocation(newLocation)
        }
        
        dismiss(animated: false, completion: nil)
        _ = self.navigationController?.popViewController(animated: false)
    }
    
    func viewController(_ viewController: GMSAutocompleteViewController, didFailAutocompleteWithError error: Error) {
        print("Error: ", error.localizedDescription)
    }
    
    func wasCancelled(_ viewController: GMSAutocompleteViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func didRequestAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
    }
    
    func didUpdateAutocompletePredictions(_ viewController: GMSAutocompleteViewController) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = false
    }
}


















