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
    
    func doubleValue(_ key: String) -> Double {
        if let value = self[key] as? NSNumber {
            return value.doubleValue
        }
        return 0
    }
    
    func floatValue(_ key: String) -> Float {
        if let value = self[key] as? NSNumber {
            return value.floatValue
        }
        return 0
    }
    
    func dictionaryValue(_ key: String) -> Dictionary? {
        if let value = self[key] as? Dictionary {
            return value
        }
        return nil
    }
    
    func arrayValue(_ key: String) -> Array<Any>? {
        if let value = self[key] as? Array<Any> {
            return value
        }
        return nil
    }
}
