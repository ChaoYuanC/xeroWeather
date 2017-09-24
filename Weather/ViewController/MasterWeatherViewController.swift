//
//  MasterWeatherViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import SDWebImage

class MasterWeatherViewController: BaseViewController, WeatherVCProtocol {

    @IBOutlet var mainSectionView: UIView!
    @IBOutlet var detailSectionView: UIView!
    @IBOutlet var wearthIconImageView: UIImageView!
    @IBOutlet var sunsetLabel: UILabel!
    @IBOutlet var sunriseLabel: UILabel!
    @IBOutlet var maxTempLabel: UILabel!
    @IBOutlet var minTempLabel: UILabel!
    @IBOutlet var pressureLabel: UILabel!
    @IBOutlet var humidityLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var tempLabel: UILabel!
    @IBOutlet var wearthDesLabel: UILabel!
    
    var cityId: Int64 = 0 {
        didSet {
            if self.isViewLoaded {
                self.reloadWeather(cityId)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if cityId != 0 {
            self.reloadWeather(cityId)
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -
    
    func reloadWeather(_ id: Int64) {
        self.mainSectionView.isHidden = true
        self.detailSectionView.isHidden = true
        self.hideloadingView(false)
        WebService.sharedInstance.currentWeather(id) { (weather, error) in
            self.hideloadingView(true)
            if let weather = weather {
                self.mainSectionView.isHidden = false
                self.detailSectionView.isHidden = false
                self.setWeather(weather)
            } else if let error = error {
                self.showAlerWith(error)
            }
        }
    }

    func setWeather(_ weather: Weather) {
        self.wearthDesLabel.text = weather.daily.description
        self.tempLabel.text = weather.main.temp
        self.humidityLabel.text = weather.main.humidity
        self.pressureLabel.text = weather.main.pressure
        self.minTempLabel.text = weather.main.minTemp
        self.maxTempLabel.text = weather.main.maxTemp
        self.sunriseLabel.text = weather.sunrise
        self.sunsetLabel.text = weather.sunset
        self.dateLabel.text = Date.todayString()
        let imageUrl = Constants.weatherIconUrl(weather.daily.icon)
        self.wearthIconImageView.sd_setImage(with: imageUrl, placeholderImage: UIImage(named: "xero"), options: .refreshCached, completed: nil)
    }
}
