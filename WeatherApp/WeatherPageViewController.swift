//
//  WeatherPageViewController.swift
//  
//
//  Created by Marin Rados on 07/04/2017.
//
//

import UIKit
import CoreLocation

class WeatherPageViewController: UIPageViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, CLLocationManagerDelegate {
    
    var locations: [Location] = []
    let defaults = UserDefaults.standard
    let locationsKey = "locations"
    var weatherViewControllers: [WeatherViewController] = []
    let locationManager = CLLocationManager()
    var trackedLocation: Location?
    let locationService = LocationService()
   
    
    override func viewWillDisappear(_ animated: Bool) {
        if trackedLocation != nil && !locations.isEmpty {
            locations.remove(at: 0)
        }
        locationService.saveLocations(locations)
    }
    
    func createWeatherViewController()-> WeatherViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        locations = locationService.getSavedLocations()
        
        dataSource = self
        delegate = self
        
        for location in locations {
            let newViewController = createWeatherViewController()
            newViewController.currentLocation = location
            weatherViewControllers.append(newViewController)
        }
        
        if let firstViewController = weatherViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
        
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            LocationService.isAuthorized = false
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            LocationService.isAuthorized = true
            locationManager.startUpdatingLocation()
        case .denied:
            LocationService.isAuthorized = false
            showAlertForDeniedAuthorization()
        default:
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let userLocation = locations[0]
        
        let geoCoder = CLGeocoder()
        
        geoCoder.reverseGeocodeLocation(userLocation, completionHandler: { (placemarks, error) -> Void in
            
            var placeMark: CLPlacemark?
            placeMark = placemarks?[0]
            
            guard let city = placeMark?.addressDictionary?["City"] as? String else {
                return
            }
            
            guard let country = placeMark?.addressDictionary?["Country"] as? String  else {
                return
            }
            
            let newCoordinate = Coordinate(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            
            let newLocation = Location(city: city, country: country, coordinate: newCoordinate)
            if self.trackedLocation == nil {
                guard let newTrackedLocation = newLocation else {
                    return
                }
                self.trackedLocation = newLocation
                let trackedViewController = self.createWeatherViewController()
                trackedViewController.currentLocation = self.trackedLocation
                self.locations.insert(newTrackedLocation, at: 0)
                self.weatherViewControllers.append(trackedViewController)
                
                if let firstViewController = self.weatherViewControllers.first {
                    self.setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
                }
            }
        })
    }
    
    func showAlertForDeniedAuthorization() {
        let alertController = UIAlertController (title: nil, message: "Application authorization disabled. To re-enable go to settings.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let manualAction = UIAlertAction(title: "Add location manually", style: .default) { (_) -> Void in
            self.performSegue(withIdentifier: "Location", sender: nil)
        }
        alertController.addAction(manualAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherPageViewController {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = weatherViewControllers.index(of: viewController as! WeatherViewController) else {
            return nil
        }
        
        let previousIndex = viewControllerIndex - 1
        
        guard previousIndex >= 0 else {
            return weatherViewControllers.last
        }
        
        guard weatherViewControllers.count > previousIndex else {
            return nil
        }
        
        return weatherViewControllers[previousIndex]
    }
    
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = weatherViewControllers.index(of: viewController as! WeatherViewController) else {
            return nil
        }
        
        let nextIndex = viewControllerIndex + 1
        let weatherViewControllersCount = weatherViewControllers.count
        
        
        guard weatherViewControllersCount != nextIndex else {
            return weatherViewControllers.first
        }
        
        guard weatherViewControllersCount > nextIndex else {
            return nil
        }
        
        return weatherViewControllers[nextIndex]
    }
}













