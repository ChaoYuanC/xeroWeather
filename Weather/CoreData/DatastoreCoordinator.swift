//
//  DatastoreCoordinator.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import CoreData

class DatastoreCoordinator: NSObject {
    fileprivate let objectModelName = "Weather"
    fileprivate let objectModelExtension = "momd"
    fileprivate let dbFilename = "CoreData.sqlite"
    fileprivate let appDomain = "com.xero.Weather"
    
    override init() {
        super.init()
    }
    
    // MARK: - Core Data stack
    
    lazy var applicationDocumentsDirectory: URL = {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        
        return urls[urls.count-1]
    }()
    
    lazy var managedObjectModel: NSManagedObjectModel = {
        let modelURL = Bundle.main.url(forResource: self.objectModelName, withExtension: self.objectModelExtension)!
        
        return NSManagedObjectModel(contentsOf: modelURL)!
    }()
    
    lazy var persistentStoreCoordinator: NSPersistentStoreCoordinator = {
        
        let coordinator = NSPersistentStoreCoordinator(managedObjectModel: self.managedObjectModel)
        let url = self.applicationDocumentsDirectory.appendingPathComponent(self.dbFilename)
        
        do {
            try coordinator.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: url, options: nil)
        } catch {
            // Report any error we got.
            print("There was an error creating or loading the application's saved data.")
            abort()
        }
        
        return coordinator
    }()
}
