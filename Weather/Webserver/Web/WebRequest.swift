//
//  WebRequest.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

class CurrentWeatherRequest: Request {
    let path: String = "weather"
    
    let parameter: [String: Any]
    
    typealias Response = Weather
    
    init(_ cityId: Int64) {
        var para = Dictionary<String, Any>.appIdValue()
        para["id"] = cityId
        self.parameter = para
    }
}
