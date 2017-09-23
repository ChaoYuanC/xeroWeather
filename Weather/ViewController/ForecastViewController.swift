//
//  ForecastViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class ForecastViewController: BaseViewController, WeatherVCProtocol {

    @IBOutlet var scrollView: UIScrollView!
    
    private let hourlyWidth: CGFloat = 60.0
    private let hourlyHeight: CGFloat = 200.0
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
        self.reloadWeather(cityId)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    // MARK: -
    
    func reloadWeather(_ id: Int64) {
//        self.mainSectionView.isHidden = true
//        self.detailSectionView.isHidden = true
        self.hideloadingView(false)
        WebService.sharedInstance.forecaset(id) { (result, message) in
            self.hideloadingView(true)
            if let result = result {
                print(result)
                self.setForecastView(result.hourly)
            } else if let message = message {
                self.showAlerWith(message)
            }
        }
    }

    
    // MARK: - set hourly views
    
    func setForecastView(_ hourlyArray: Array<ForecastHourly>) {
        for view in self.scrollView.subviews {
            view.removeFromSuperview()
        }
        
        self.scrollView.contentSize = CGSize(width: self.hourlyWidth *  CGFloat(hourlyArray.count), height: self.hourlyHeight)
        
        for index in 0...hourlyArray.count-1 {
            let hourlyView = HourlyView.fromNib()
            hourlyView.frame = CGRect(x: self.hourlyWidth * CGFloat(index), y: 0.0, width: self.hourlyWidth, height: self.hourlyHeight)
            hourlyView.setHourlyData(hourlyArray[index])
            self.scrollView.addSubview(hourlyView)
        }

    }
}
