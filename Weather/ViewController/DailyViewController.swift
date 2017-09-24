//
//  DailyViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

protocol DailyViewControllerPortocol: class {
    func contentHeight(_ height: CGFloat)
}

class DailyViewController: BaseViewController, WeatherVCProtocol {
    
    private let dailyViewHeight: CGFloat = 80
    
    weak var delegate: DailyViewControllerPortocol? = nil
    
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
        self.hideloadingView(false)
        WebService.sharedInstance.daily(id) { (result, message) in
            self.hideloadingView(true)
            if let result = result {
                self.setDailyView(result.daily)
            } else if let message = message {
                self.showAlerWith(message)
            }
        }
    }

    func setDailyView(_ dailyArray: Array<ForecastDaily>) {
        for view in self.view.subviews {
            view.removeFromSuperview()
        }
        
        let contentHeight = self.dailyViewHeight * CGFloat(dailyArray.count)
        self.delegate?.contentHeight(contentHeight)
        
        for index in 0...dailyArray.count-1 {
            let dailyView = Bundle.main.loadNibNamed("ForecastDailyView", owner: nil, options: nil)![0] as! ForecastDailyView
            dailyView.frame = CGRect(x: 0, y: self.dailyViewHeight * CGFloat(index), width: self.view.frame.size.width, height: self.dailyViewHeight)
            dailyView.setHourlyData(dailyArray[index])
            self.view.addSubview(dailyView)
        }
        

    }
}
