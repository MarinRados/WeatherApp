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
        locationService.saveLocations(locations)
    }
    
    func createWeatherViewController()-> WeatherViewController {
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: "WeatherViewController") as! WeatherViewController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if LocationService.isAuthorized {
            locationManager.startUpdatingLocation()
        }
        
        locations = locationService.getSavedLocations()
        weatherViewControllers = []
        
        var index = 0
        
        for location in locations {
            let newViewController = createWeatherViewController()
            newViewController.currentLocation = location
            newViewController.pagerIndex = index
            weatherViewControllers.append(newViewController)
            index = index + 1
        }
        
        if let firstViewController = weatherViewControllers.first {
            setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.backgroundColor = UIColor(colorLiteralRed: 0/255.0, green: 140/255.0, blue: 255/255.0, alpha: 1.0)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        dataSource = self
        delegate = self
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
            if locations.isEmpty {
                showAlertForDeniedAuthorization()
            } else {
                showAlertForCurrentLocationEnabling()
            }
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
            if self.locations.isEmpty {
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
            } else if self.weatherViewControllers.first?.currentLocation == newLocation {
                return
            } else {
                guard let newTrackedLocation = newLocation else {
                    return
                }
                self.trackedLocation = newLocation
                self.weatherViewControllers.first?.currentLocation = self.trackedLocation
                if !locations.isEmpty {
                    self.locations[0] = newTrackedLocation
                }
                
                self.weatherViewControllers.first?.refreshWeather()
                
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
            if let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LocationViewController") as? LocationViewController
            {
                let navigationController = UINavigationController()
                navigationController.viewControllers = [vc]
                self.present(navigationController, animated: true)
            }
        }
        alertController.addAction(manualAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    func showAlertForCurrentLocationEnabling() {
        let alertController = UIAlertController (title: nil, message: "To see the weather on your current location go to settings and enable the location tracking.", preferredStyle: .alert)
        
        let settingsAction = UIAlertAction(title: "Go to settings", style: .default) { (_) -> Void in
            guard let settingsUrl = URL(string: UIApplicationOpenSettingsURLString) else {
                return
            }
            
            if UIApplication.shared.canOpenURL(settingsUrl) {
                UIApplication.shared.open(settingsUrl, options: [:], completionHandler: nil)
            }
        }
        alertController.addAction(settingsAction)
        let cancelAction = UIAlertAction(title: "Cancel", style: .default, handler: nil)
        alertController.addAction(cancelAction)
        
        present(alertController, animated: true, completion: nil)
    }
}

extension WeatherPageViewController {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewControllerIndex = weatherViewControllers.index(of: viewController as! WeatherViewController) else {
            return nil
        }
        
        if weatherViewControllers.count < 2 {
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
        
        if weatherViewControllersCount < 2 {
            return nil
        }
        
        guard weatherViewControllersCount != nextIndex else {
            return weatherViewControllers.first
        }
        
        guard weatherViewControllersCount > nextIndex else {
            return nil
        }
        
        return weatherViewControllers[nextIndex]
    }
}













