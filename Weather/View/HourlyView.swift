//
//  HourlyView.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import SDWebImage

class HourlyView: UIView {

    @IBOutlet var iconImageView: UIImageView!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    
    func setHourlyData(_ data: ForecastHourly) {
        let imageUrl = Constants.weatherIconUrl(data.daily.icon)
        self.iconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "xero"), options: .refreshCached, completed: nil)
        self.tempLabel.text = data.main.temp
        self.timeLabel.text = data.shortTime
    }
    
}
