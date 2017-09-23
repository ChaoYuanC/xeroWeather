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
    
    var currentCityId: Int64 = 0 {
        didSet {
            self.reloadWeather()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SideMenuManager.menuAnimationBackgroundColor = UIColor(red: 0.0, green: 203/255, blue: 220/255, alpha: 1)

        
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
        self.getCurrentWether()
    }

    func getCurrentWether() {
        WebService.sharedInstance.currentWeather(self.currentCityId) { (weather, error) in
            if let weather = weather {
                print(weather)
            } else if let error = error {
                
            }
        }
    }
}
