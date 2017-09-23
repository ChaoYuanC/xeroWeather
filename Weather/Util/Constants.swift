//
//  Constants.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

struct Constants {
    static let CityEntity = "City"
    static func weatherIconUrl(_ name: String) -> URL? {
        return URL(string: "https://openweathermap.org/img/w/\(name).png")
    }
}
