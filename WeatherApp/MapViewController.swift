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
        print("Latitude \(locationCoordinate.latitude), Longitude \(locationCoordinate.longitude)")
    }

}
