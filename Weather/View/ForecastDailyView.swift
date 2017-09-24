//
//  ForecastDailyView.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class ForecastDailyView: UIView {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var desLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    
    func setHourlyData(_ data: ForecastDaily) {
        let imageUrl = Constants.weatherIconUrl(data.daily.icon)
        self.iconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "xero"), options: .refreshCached, completed: nil)
        self.dateLabel.text = data.dateString
        self.desLabel.text = data.daily.description
        self.maxTempLabel.text = data.main.maxTemp
        self.minTempLabel.text = data.main.minTemp
        self.humidityLabel.text = data.main.humidity
        self.pressureLabel.text = data.main.pressure
    }
}
