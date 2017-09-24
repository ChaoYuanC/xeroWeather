//
//  WebRequest.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

class BasicRequest {
    fileprivate(set) var parameter: [String: Any]
    
    init() {
        var para: Dictionary<String, Any> = ["appid": WebConstants.appId]
        para["units"] = WebConstants.unit
        self.parameter = para
    }
}

class CurrentWeatherRequest: BasicRequest, Request {
    let path: String = "weather"
    typealias Response = Weather
    
    init(_ cityId: Int64) {
        super.init()
        self.parameter["id"] = cityId
    }
    
    init(_ lat: Double, _ lon: Double) {
        super.init()
        self.parameter["lat"] = lat
        self.parameter["lon"] = lon
    }
}

class ForecastRequest: BasicRequest, Request {
    let path: String = "forecast"
    typealias Response = Forecast
    
    init(_ cityId: Int64) {
        super.init()
        self.parameter["id"] = cityId
    }
}

class DailyRequest: BasicRequest, Request {
    let path: String = "forecast/daily"
    typealias Response = Daily
    
    init(_ cityId: Int64) {
        super.init()
        self.parameter["id"] = cityId
    }
}
