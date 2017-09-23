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
        return nil

    }
}
