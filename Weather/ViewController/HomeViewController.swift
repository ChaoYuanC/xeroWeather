//
//  HomeViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController, DailyViewControllerPortocol, CityViewControllerDelegate {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    @IBOutlet var contentHeight: NSLayoutConstraint!
    
    private weak var weaterhMasterVC: MasterWeatherViewController?
    private weak var weaterhHourlyVC: ForecastViewController?
    private weak var weaterhDailyVC: DailyViewController?

    var currentCity: City? = nil {
        didSet {
            if self.isViewLoaded {
                self.reloadWeather()
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SideMenuManager.menuAnimationBackgroundColor = UIColor(red: 0.0, green: 203/255, blue: 220/255, alpha: 1)

        self.reloadWeather()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    func reloadWeather() {
        guard let city = self.currentCity else {
            return
        }
        // set location
        self.setTitleSection(city)
        self.weaterhMasterVC?.cityId = city.id
        self.weaterhDailyVC?.cityId = city.id
        self.weaterhHourlyVC?.cityId = city.id
    }
    
    // MARK: - Title
    func setTitleSection(_ city: City) {
        self.idLabel.text = "Id: \(city.id)"
        self.cityLabel.text = city.locationString()
    }
    
    // MARK: - DailyViewControllerPortocol
    
    func contentHeight(_ height: CGFloat) {
        self.contentHeight.constant = height
        self.view.layoutIfNeeded()
    }
    
    // MARK: - CityViewControllerDelegate
    
    func selectedCity(_ city: City) {
        self.currentCity = city
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WeatherVCProtocol {
            guard let city = self.currentCity else {
                return
            }
            vc.cityId = city.id
            self.setSectionHandler(segue.destination)
        } else if let navi = segue.destination as? UISideMenuNavigationController, let vc = navi.viewControllers[0] as? CityViewController {
            vc.delegate = self
        }
    }
    
    func setSectionHandler(_ vc: UIViewController) {
        if let vc = vc as? DailyViewController {
            vc.delegate = self;
            self.weaterhDailyVC = vc
        } else if let vc = vc as? MasterWeatherViewController {
            self.weaterhMasterVC = vc
        } else if let vc = vc as? ForecastViewController {
            self.weaterhHourlyVC = vc
        }
        
    }
}
