//
//  CityManager.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import Foundation
import CoreData

class CityManager: NSObject {
    static let sharedInstance = CityManager()
    private override init() {}
    
    fileprivate var cities: [City] = []
    fileprivate let contextManager = AppDelegate().sharedInstance().contextManager
    
    func fetchCities(_ completion: @escaping () -> ()) {
        // TODO: Fetch city from server
        guard let path = Bundle.main.path(forResource: "city.list", ofType: "json") else {
            completion()
            return
        }
        
        let citiesFetch = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        
        do {
            let results = try self.contextManager.objectContextInstance.fetch(citiesFetch)
            if let cities = results as? [City], cities.count > 0 {
                self.cities = cities
                self.dispatchFetchCitiesCompletion(completion)
                return
            }
        } catch {
            self.dispatchFetchCitiesCompletion(completion)
        }

        DispatchQueue.global().async {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path))
                let jsonData = try JSONSerialization.jsonObject(with: data)
                
                if let cityJson = jsonData as? Array<Dictionary<String, Any>> {
                    
                    for dic in cityJson {
                        guard let city = NSEntityDescription.insertNewObject(forEntityName: "City", into: self.contextManager.objectContextInstance) as? City else {
                            abort()
                        }
                        city.id = Int64(dic.intValue("id"))
                        city.city = dic.stringValue("name")
                        city.country = dic.stringValue("country")
                        if let coordDic = dic.dictionaryValue("coord") {
                            city.latitude = coordDic.doubleValue("lat")
                            city.longitude = coordDic.doubleValue("lon")
                        } else {
                            city.latitude = 0.0
                            city.longitude = 0.0
                        }
                        city.isFav = false
                    }
                    self.contextManager.saveContext()
                    self.dispatchFetchCitiesCompletion(completion)
                    
                } else {
                    self.dispatchFetchCitiesCompletion(completion)
                }
                
            } catch {
                self.dispatchFetchCitiesCompletion(completion)
            }
        }
    }
    
    func setFavCity(_ id: Int64, _ fav: Bool, _ completion: @escaping (Bool) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        request.predicate = NSPredicate(format: "id == %@", "\(id)")
        
        do {
            guard let cities = try self.contextManager.objectContextInstance.fetch(request) as? [City] else {
                completion(false)
                return
            }
            let city = cities[0]
            city.isFav = fav
            self.contextManager.saveContext()
            completion(true)
        } catch {
            completion(false)
        }
    }
    
    func fetchFavCities(_ completion: @escaping ([City]) -> ()) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "City")
        request.predicate = NSPredicate(format: "isFav == %@", NSNumber(value: true))
        
        do {
            guard let cities = try self.contextManager.objectContextInstance.fetch(request) as? [City] else {
                completion([])
                return
            }
            completion(cities)
        } catch {
            completion([])
        }
    }
    
    fileprivate func dispatchFetchCitiesCompletion(_ completion: @escaping () -> ()) {
        DispatchQueue.main.async {
            completion()
        }
    }
}
