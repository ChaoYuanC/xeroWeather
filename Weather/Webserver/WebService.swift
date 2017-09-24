//
//  WebService.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import UIKit

class WebService: NSObject {
    static let sharedInstance = WebService()
    private override init() {}
    
    func currentWeather(_ cityId: Int64, _ completion: @escaping (Weather?, String?) -> ()) {
        let request = CurrentWeatherRequest(cityId)
        CurrentWeatherService().send(request) { (response) in
            switch response {
            case .success(let result):
                completion(result, nil)
            case .failure(let message):
                completion(nil, message)
            }
        }
    }
    
    func locationWeather(_ lat: Double, _ lon: Double, _ completion: @escaping (Weather?, String?) -> ()) {
        let request = CurrentWeatherRequest(lat, lon)
        CurrentWeatherService().send(request) { (response) in
            switch response {
            case .success(let result):
                completion(result, nil)
            case .failure(let message):
                completion(nil, message)
            }
        }
    }
    
    func forecaset(_ cityId: Int64, _ completion: @escaping (Forecast?, String?) -> ()) {
        let request = ForecastRequest(cityId)
        
        ForecastClient().send(request) { (response) in
            switch response {
            case .success(let result):
                completion(result, nil)
            case .failure(let message):
                completion(nil, message)
            }
        }
    }
    
    func daily(_ cityId: Int64, _ completion: @escaping (Daily?, String?) -> ()) {
        let request = DailyRequest(cityId)
        
        DailyClient().send(request) { (response) in
            switch response {
            case .success(let result):
                completion(result, nil)
            case .failure(let message):
                completion(nil, message)
            }
        }
    }
}

