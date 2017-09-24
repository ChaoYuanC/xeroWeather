//
//  NSDate+Extension.swift
//  Weather
//
//  Created by Chao Yuan on 9/23/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation

extension Date {
    static func shortStyleTimeString(_ seconds: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    static func todayString() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: Date())
    }
    
    static func mediumDateString(_ seconds: TimeInterval) -> String {
        let date = Date(timeIntervalSince1970: seconds)
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
}
