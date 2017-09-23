//
//  WeatherStructure+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/24/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

extension WeatherMain {
    static func parse(_ data: Any?) -> WeatherMain {
        guard let dic = data as? Dictionary<String, Any> else {
            return WeatherMain(temp: "", humidity: "", pressure: "", minTemp: "", maxTemp: "")
        }
        let temp = "\(dic.floatValue("temp"))℃"
        let minTemp = "\(dic.floatValue("temp_min"))℃"
        let maxTemp = "\(dic.floatValue("temp_max"))℃"
        let humidity = "Humidity: \(dic.floatValue("humidity"))%"
        let pressure = "Pressure: \(dic.floatValue("pressure"))Pa"
        
        return WeatherMain(temp: temp, humidity: humidity, pressure: pressure, minTemp: minTemp, maxTemp: maxTemp)
    }
}

extension WeatherDaily {
    static func parse(_ data: Any?) -> WeatherDaily {
        guard let dic = data as? Dictionary<String, Any> else {
            return WeatherDaily(description: "", icon: "")
        }
        
        let icon = dic.stringValue("icon")
        let description = dic.stringValue("description")
        
        return WeatherDaily(description: description, icon: icon)
    }
}



extension Weather: Parser {
    static func parse(_ data: Any) -> Weather? {
        guard let dic = data as? Dictionary<String, Any> else {
            return nil
        }
        let main = WeatherMain.parse(dic.dictionaryValue("main"))
        let array = dic.arrayValue("weather")
        let weartherDic = array?[0] as? Dictionary<String, Any>
        let daily = WeatherDaily.parse(weartherDic)

        var sunrise = ""
        var sunset = ""
        if let sysDic = dic.dictionaryValue("sys") {
            sunrise = "Sunrise: " + Date.shortStyleTimeString(sysDic.doubleValue("sunrise"))
            sunset = "Sunset: " + Date.shortStyleTimeString(sysDic.doubleValue("sunset"))
        }
        return Weather(main: main, daily: daily, sunrise: sunrise, sunset: sunset)
    }
}

extension Forecast: Parser {
    static func parse(_ data: Any) -> Forecast? {
        guard let dic = data as? Dictionary<String, Any> else {
            return nil
        }
        guard let array = dic.arrayValue("list") else {
            return nil
        }
        
        var hourlyArray: Array<ForecastHourly> = []
        for hourlyDic in array {
            if let hourlyDic = hourlyDic as? Dictionary<String, Any> {
                let main = WeatherMain.parse(hourlyDic.dictionaryValue("main"))
                let array = hourlyDic.arrayValue("weather")
                let weartherDic = array?[0] as? Dictionary<String, Any>
                let daily = WeatherDaily.parse(weartherDic)
                let shortTime =  Date.shortStyleTimeString(hourlyDic.doubleValue("dt"))
                hourlyArray.append(ForecastHourly(main: main, daily: daily, shortTime: shortTime))
            }
        }
        return Forecast(hourly: hourlyArray)
    }
}
