//
//  GMSAutocompleteViewController+Extensions.swift
//  WeatherApp
//
//  Created by Marin Rados on 06/04/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import Foundation
import GooglePlaces

extension GMSAutocompleteViewController {
    
    func showAlertWith(message: String) {
        let alertController = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }
}
