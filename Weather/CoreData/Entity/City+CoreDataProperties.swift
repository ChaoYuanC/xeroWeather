//
//  City+CoreDataProperties.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//
//

import Foundation
import CoreData


extension City {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<City> {
        return NSFetchRequest<City>(entityName: "City")
    }

    @NSManaged public var city: String?
    @NSManaged public var country: String?
    @NSManaged public var id: Int64
    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double

}
