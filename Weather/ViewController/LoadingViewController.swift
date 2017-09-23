//
//  LoadingViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit

class LoadingViewController: UIViewController {

    @IBOutlet var indicator: UIActivityIndicatorView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.indicator.startAnimating()
        
        self.fetchCities()
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

    
    func fetchCities() {
        CityManager.sharedInstance.fetchCities {
            self.goHomeViewController()
        }
    }
    
    func goHomeViewController() {
        self.performSegue(withIdentifier: "HomeVCSegue", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeViewController {
            CityManager.sharedInstance.fetchFavCities({ (cities) in
                if cities.count > 0 {
                    vc.currentCityId = cities[0].id
                }
            })
        }
    }
}
