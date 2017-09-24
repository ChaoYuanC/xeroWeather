//
//  LoadingViewController.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import UIKit
import CoreLocation

enum LocationStatus {
    case denied
    case fetched
    case fetching
    case none
}

class LoadingViewController: UIViewController {

    @IBOutlet var indicator: UIActivityIndicatorView!
    
    private let locationManager = CLLocationManager()
    private var fetchedCitiesComplete = false
    private var locationStatus: LocationStatus = .none
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.indicator.startAnimating()
        locationManager.delegate = self
        self.requestLocationService()
        locationManager.startUpdatingLocation()
        self.fetchCities()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        locationManager.stopUpdatingLocation()
    }
    
    func fetchCities() {
        CityManager.sharedInstance.fetchCities {
            self.fetchedCitiesComplete = true
            self.goHomeViewController()
        }
    }
    
    func goHomeViewController(_ weather: Weather? = nil) {
        guard self.fetchedCitiesComplete else {
            return
        }
        
        switch self.locationStatus {
        case .denied:
            self.performSegue(withIdentifier: "HomeVCSegue", sender: weather)
        case .fetched:
            self.performSegue(withIdentifier: "HomeVCSegue", sender: weather)
        default:
            return
        }
    }
    
    func fetchCity(_ lat: Double, _ lon: Double) {
        self.locationStatus = .fetching
        WebService.sharedInstance.locationWeather(lat, lon) { (weather, error) in
            if let weather = weather {
                self.locationStatus = .fetched
                self.goHomeViewController(weather)
            } else if let error = error {
                self.showAlerWith(error)
            }
        }
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? HomeViewController {
            if let cityInfo = sender as? Weather {
                vc.currentCity = cityInfo
            } else {
                self.setCityInfo(vc)
            }
        }
    }
    
    func setCityInfo(_ vc: HomeViewController)  {
        CityManager.sharedInstance.fetchFavCities({ (cities) in
            if cities.count > 0 {
                // TODO: save selected city
                vc.currentCity = cities[0]
            }
        })
    }
}


// TODO: Delete it, use function in MasterWeather instead
extension LoadingViewController: CLLocationManagerDelegate {
    
    func requestLocationService() {
        self.locationManager.requestWhenInUseAuthorization()
        switch CLLocationManager.authorizationStatus() {
        case .denied:
            self.locationStatus = .denied
            self.goHomeViewController()
        case .authorizedWhenInUse, .authorizedAlways:
            // do nothing, waithing for location update
            break
        default:
            self.locationStatus = .none
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .authorizedWhenInUse, .authorizedAlways:
            // do nothing, waithing for location update
            break
        default:
            self.goHomeViewController()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if self.locationStatus != .fetching {
            let location = locations[0]
            self.fetchCity(location.coordinate.latitude, location.coordinate.longitude)
        }

    }
}

