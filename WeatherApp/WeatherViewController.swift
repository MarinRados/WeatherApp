//
//  WeatherViewController.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit
import CoreLocation

class WeatherViewController: UITableViewController, ChangeLocationDelegate, CLLocationManagerDelegate {
    
    var viewModel: WeatherViewModel!
    var currentData: CurrentWeatherPresentable? = nil
    var forecastData: [SevenDayForecastPresentable]? = nil
    var currentLocation: Location?
    var trackedLocation: Location?
    var allLocations = [Location]()
    let locationManager = CLLocationManager()
    let defaults = UserDefaults.standard
    let lastLocationKey = "lastLocation"
    let locationsKey = "locations"
    var pagerIndex = 0
    
    override func viewWillDisappear(_ animated: Bool) {
        if trackedLocation != nil {
            allLocations.remove(at: 0)
        }
        let dictionary = convertToDictionaryArrayFrom(allLocations)
        defaults.set(dictionary, forKey: locationsKey)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let newLocations = defaults.object(forKey: locationsKey) {
           allLocations = convertToArrayFrom(newLocations as! [[String : Any]])
        }
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        self.view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.respondToSwipeGesture))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        self.view.addGestureRecognizer(swipeLeft)
        
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyThreeKilometers
        
        setViewModel()

        viewModel.onSuccess = { [weak self] data in
            self?.currentData = data
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
        viewModel.onForecastSuccess = { [weak self] data in
            self?.forecastData = data
            self?.tableView.reloadData()
            self?.refreshControl?.endRefreshing()
        }
        
        viewModel.onError = { [weak self] error in
            switch error {
            case .invalidData: self?.showAlertWith(message: "Invalid data.")
            case .invalidURL: self?.showAlertWith(message: "Invalid URL.")
            case .requestFailed: self?.showAlertWith(message: "Request to fetch data failed.")
            case .responseUnsuccessful: self?.showAlertWith(message: "Response unsuccessful.")
            case .jsonConversionFailure: self?.showAlertWith(message: "JSON conversion failed.")
            case .jsonParsingFailure: self?.showAlertWith(message: "JSON parsing failed.")
            }
            self?.refreshControl?.endRefreshing()
        }
        
        self.refreshControl?.addTarget(self, action: #selector(WeatherViewController.refreshWeather), for: UIControlEvents.valueChanged)

    }
    
    func respondToSwipeGesture(gesture: UIGestureRecognizer) {
        var index = 0
        var currentIndex = 0
        for location in allLocations {
            if currentLocation?.city == location.city {
                index = currentIndex
            }
            currentIndex = currentIndex + 1
        }
        if let swipeGesture = gesture as? UISwipeGestureRecognizer {
            switch swipeGesture.direction {
            case UISwipeGestureRecognizerDirection.right:
                onSwipeRightFrom(index: index)
            case UISwipeGestureRecognizerDirection.left:
                onSwipeLeftFrom(index: index)
            default:
                break
            }
        }
    }
    
    func onSwipeRightFrom(index: Int) {
        let previousIndex = index - 1
        
        guard previousIndex >= 0 else {
            return
        }
        
        guard allLocations.count > previousIndex else {
            return
        }
        
        currentLocation = allLocations[previousIndex]
        pagerIndex = previousIndex
        refreshWeather()
    }
    
    func onSwipeLeftFrom(index: Int) {
        let nextIndex = index + 1
        
        let locationsCount = allLocations.count
        
        guard locationsCount != nextIndex else {
            return
        }
        
        guard locationsCount > nextIndex else {
            return
        }
        
        currentLocation = allLocations[nextIndex]
        pagerIndex = nextIndex
        refreshWeather()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .notDetermined:
            LocationService.isAuthorized = false
            locationManager.requestWhenInUseAuthorization()
        case .authorizedWhenInUse:
            LocationService.isAuthorized = true
            defaults.removeObject(forKey: lastLocationKey)
            locationManager.startUpdatingLocation()
        case .denied:
            LocationService.isAuthorized = false
            if let newLocations = defaults.object(forKey: locationsKey) {
                showAlertForCurrentLocationEnabling()
                allLocations = convertToArrayFrom(newLocations as! [[String : Any]])
                if !allLocations.isEmpty {
                    currentLocation = allLocations[0]
                }
            }
            refreshWeather()
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
            if self.trackedLocation != nil {
                self.trackedLocation = newLocation
                if let firstLocation = self.trackedLocation {
                    if !self.allLocations.isEmpty {
                        self.allLocations[0] = firstLocation
                    }
                }
            } else {
                self.trackedLocation = newLocation
                if let firstLocation = self.trackedLocation {
                    self.allLocations.insert(firstLocation, at: 0)
                }
            }
            
            if self.currentLocation != self.trackedLocation {
                for location in self.allLocations {
                    if self.currentLocation == location {
                        return
                    }
                }
                self.currentLocation = self.trackedLocation
                self.refreshWeather()
            }
        })
    }

    func refreshWeather() {
        guard let coordinate = currentLocation?.coordinate else {
            return
        }
        viewModel.getWeather(coordinates: coordinate)
        viewModel.getForecast(coordinates: coordinate)
        tableView.reloadData()
    }
    
    private func setViewModel(){
        viewModel = WeatherViewModel()
    }
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
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
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SevenDays", for: indexPath) as! SevenDayForecastCell
        
        let index = indexPath.row + 1

        cell.dayLabel.text = forecastData?[index].day
        cell.weatherImage.image = forecastData?[index].icon
        cell.highTemperatureLabel.text = forecastData?[index].maxTemperature
        cell.lowTemperatureLabel.text = forecastData?[index].minTemperature
        cell.isUserInteractionEnabled = false
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        
        guard let currentLocation = currentLocation else {
            return nil
        }
        
        let headerCell = tableView.dequeueReusableCell(withIdentifier: "CurrentWeather") as! CurrentWeatherCell
        headerCell.temperatureLabel.text = currentData?.temperature
        headerCell.locationLabel.text = "\(currentLocation.city), \(currentLocation.country)"
        headerCell.weatherImage.image = currentData?.icon
        headerCell.summaryLabel.text = currentData?.summary
        headerCell.pageControl.numberOfPages = allLocations.count
        headerCell.pageControl.currentPage = pagerIndex
        return headerCell
    }
    
    override func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        
        let footerCell = tableView.dequeueReusableCell(withIdentifier: "AdditionalInfo") as! AdditionalInfoCell
        
        guard let currentData = currentData else {
            return nil
        }
        
        footerCell.pressureLabel.text = "Pressure: \(currentData.pressure) hPa"
        footerCell.humidityLabel.text = "Humidity: \(currentData.humidity) %"
        footerCell.windSpeedLabel.text = "Wind speed: \(currentData.windSpeed) km/h"
        footerCell.cloudinessLabel.text = "Cloudiness: \(currentData.cloudiness) %"
        return footerCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 300
    }
    
    override func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 140
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        var destinationViewController = segue.destination
        if let navigationController = destinationViewController as? UINavigationController {
            destinationViewController = navigationController.visibleViewController ?? destinationViewController
        }
        if let locationViewController = destinationViewController as? LocationViewController {
            locationViewController.changeLocationDelegate = self
            locationViewController.trackedLocation = trackedLocation
            locationViewController.locations = allLocations
        }
    }
    
    func convertToDictionaryFrom(_ location: Location) -> [String: Any] {
        let dictionary: [String: Any] = [
            "city": location.city,
            "country": location.country,
            "coordinate": [
                "latitude": location.coordinate.latitude,
                "longitude": location.coordinate.longitude
            ]
        ]
        return dictionary
    }
    
    func convertToDictionaryArrayFrom(_ array: [Location]) -> [[String: Any]] {
        var convertedDictionary = [[String: Any]]()
        for data in array {
            let dictionary: [String: Any] = [
                "city": data.city,
                "country": data.country,
                "coordinate": [
                    "latitude": data.coordinate.latitude,
                    "longitude": data.coordinate.longitude
                ]
            ]
            convertedDictionary.append(dictionary)
        }
        return convertedDictionary
    }
    
    func convertToLocationFrom(_ dictionary: [String: Any]) -> Location? {
        guard let city = dictionary["city"] as? String,
            let country = dictionary["country"] as? String,
            let coordinate = dictionary["coordinate"] as? [String: Any],
            let latitude = coordinate["latitude"] as? Double,
            let longitude = coordinate["longitude"] as? Double else { return nil }
        
        guard let location = Location(city: city, country: country, coordinate: Coordinate(latitude: latitude, longitude: longitude)) else { return nil }
        
        return location
    }
    
    func convertToArrayFrom(_ dictionary: [[String: Any]]) -> [Location] {
        var convertedLocations = [Location]()
        for dict in dictionary {
            guard let city = dict["city"] as? String,
                let country = dict["country"] as? String,
                let coordinate = dict["coordinate"] as? [String: Any],
                let latitude = coordinate["latitude"] as? Double,
                let longitude = coordinate["longitude"] as? Double else { return [] }
            
            if let location = Location(city: city, country: country, coordinate: Coordinate(latitude: latitude, longitude: longitude)) {
                convertedLocations.append(location)
            }
        }
        return convertedLocations
    }

    func changeLocation(_ location: Location, atIndex index: Int) {
        currentLocation = location
        pagerIndex = index
        if !LocationService.isAuthorized {
            let lastLocationDictionary = convertToDictionaryFrom(location)
            defaults.set(lastLocationDictionary, forKey: lastLocationKey)
        }
        refreshWeather()
    }
    
    func changeAllLocations(_ locations: [Location]) {
        allLocations = locations
    }
}
