//
//  City+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

extension CityInfoProtocol {
    func locationString() -> String {
        var string = ""
        if let city = self.city {
            string += "\(city), "
        }
        if let country = self.country {
            string += country
        }
        return string
    }
}
