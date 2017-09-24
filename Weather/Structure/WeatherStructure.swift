//
//  WeatherStructure.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

struct WeatherMain: WeatherMainProtocol {
    let temp: String
    let humidity: String
    let pressure: String
    let minTemp: String
    let maxTemp: String
    let tempFloat: Float
}

struct WeatherDaily: WeatherDailyProtocol {
    let description: String
    let icon: String
}

struct Weather: WeatherProtocol {
    let main: WeatherMainProtocol
    
    let daily: WeatherDailyProtocol
    
    let sunrise: String
    let sunset: String
}

struct WeatherWind: WeatherWindProtocol {
    let windSpeed: String
    let windDirection: String
}

struct ForecastHourly: WeatherProtocol {
    let main: WeatherMainProtocol
    let daily: WeatherDailyProtocol
    let shortTime: String
    let wind: WeatherWindProtocol
}

struct Forecast {
    let hourly: Array<ForecastHourly>
}

struct ForecastDaily: WeatherProtocol {
    let main: WeatherMainProtocol
    let daily: WeatherDailyProtocol
    let dateString: String
}

struct Daily {
    let daily: Array<ForecastDaily>
}
