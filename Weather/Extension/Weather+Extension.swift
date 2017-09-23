//
//  Weather+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

extension Weather: Parser {
    static func parse(_ data: Any) -> Weather? {
        guard let dic = data as? Dictionary<String, Any> else {
            return nil
        }
        print(dic)
        var temp = "unknow"
        var minTemp = "unknow"
        var maxTemp = "unknow"
        var humidity = "unknow"
        var pressure = "unknow"
        if let mainDic = dic.dictionaryValue("main") {
            temp = "\(mainDic.floatValue("temp"))℃"
            minTemp = "\(mainDic.floatValue("temp_min"))℃"
            maxTemp = "\(mainDic.floatValue("temp_max"))℃"
            humidity = "Humidity: \(mainDic.floatValue("humidity"))%"
            pressure = "Pressure: \(mainDic.floatValue("pressure"))Pa"
        }
        
        var icon = ""
        var description = ""
        if let array = dic.arrayValue("weather"), let weartherDic = array[0] as? Dictionary<String, Any> {
            print(weartherDic)
            icon = weartherDic.stringValue("icon")
            description = weartherDic.stringValue("description")
        }
        var sunrise = "unknow"
        var sunset = "unknow"
        if let sysDic = dic.dictionaryValue("sys") {
            sunrise = "Sunrise: " + Date.shortStyleTimeString(sysDic.doubleValue("sunrise"))
            sunset = "Sunset: " + Date.shortStyleTimeString(sysDic.doubleValue("sunset"))
        }
        return Weather(
                    temp: temp,
                    description: description,
                    icon: icon,
                    humidity: humidity,
                    pressure: pressure,
                    minTemp: minTemp,
                    maxTemp: maxTemp,
                    sunrise: sunrise,
                    sunset: sunset)
    }
}
