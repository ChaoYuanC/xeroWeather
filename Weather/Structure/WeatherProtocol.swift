//
//  WeatherProtocol.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

protocol WeatherMainProtocol {
    var temp: String { get }
    var minTemp: String { get }
    var maxTemp: String { get }
    var humidity: String { get }
    var pressure: String { get }
    var tempFloat: Float { get }
}

protocol WeatherDailyProtocol {
    var icon: String { get }
    var description: String { get }
}

protocol WeatherWindProtocol {
    var windSpeed: String { get }
    var windDirection: String { get }
}

protocol WeatherProtocol {
    var main: WeatherMainProtocol { get }
    var daily: WeatherDailyProtocol { get }
}
