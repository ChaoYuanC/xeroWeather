//
//  Dictionary+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

extension Dictionary where Key == String {
    func intValue(_ key: String) -> Int {
        if let value = self[key] as? Int {
            return value
        }
        return 0
    }
    
    func stringValue(_ key: String) -> String {
        if let value = self[key] as? String {
            return value
        }
        return "unknow"
    }
    
    func dictionaryValue(_ key: String) -> Dictionary? {
        if let value = self[key] as? Dictionary {
            return value
        }
        return nil
    }
    
    func DoubleValue(_ key: String) -> Double {
        if let value = self[key] as? String {
            return Double(value) ?? 0.0
        }
        if let value = self[key] as? Double {
            return value
        }
        return 0.0
    }
}
