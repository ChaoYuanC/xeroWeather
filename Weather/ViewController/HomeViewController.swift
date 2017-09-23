//
//  HomeViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import SideMenu

class HomeViewController: UIViewController {
    
    @IBOutlet var idLabel: UILabel!
    @IBOutlet var cityLabel: UILabel!
    
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
        
    }
    
    // MARK: - Title
    func setTitleSection(_ city: City) {
        self.idLabel.text = "Id: \(city.id)"
        self.cityLabel.text = city.locationString()
    }
    
    
    // MARK: - Segue
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? WeatherVCProtocol {
            guard let city = self.currentCity else {
                return
            }
            vc.cityId = city.id
        }
    }
}
