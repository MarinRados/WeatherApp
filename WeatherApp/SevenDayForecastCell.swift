//
//  SevenDayForecastCell.swift
//  WeatherApp
//
//  Created by Marin Rados on 20/03/2017.
//  Copyright © 2017 Marin Rados. All rights reserved.
//

import UIKit

class SevenDayForecastCell: UITableViewCell {

    
    @IBOutlet weak var dayLabel: UILabel!
    
    @IBOutlet weak var weatherImage: UIImageView!
    @IBOutlet weak var highTemperatureLabel: UILabel!
    @IBOutlet weak var lowTemperatureLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
