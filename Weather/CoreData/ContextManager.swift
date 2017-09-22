//
//  ContextManager.swift
//  Weather
//
//  Created by Chao Yuan on 9/22/17.
//  Copyright © 2017 Chao Yuan. All rights reserved.
//

import Foundation
import CoreData

class ContextManager: NSObject {
    let datastore: DatastoreCoordinator!
    
    override init() {
        let appDelegate: AppDelegate = AppDelegate().sharedInstance()
        self.datastore = appDelegate.datastoreCoordinator
        super.init()
    }
    
    lazy var objectContextInstance: NSManagedObjectContext = {
        var objectContextInstance = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        objectContextInstance.persistentStoreCoordinator = self.datastore.persistentStoreCoordinator
        
        return objectContextInstance
    }()
    
    func saveContext() {
        DispatchQueue.main.async(execute: {
            do {
                try self.objectContextInstance.save()
            } catch let mocSaveError as NSError {
                print("Master Managed Object Context error: \(mocSaveError.localizedDescription)")
            }
        })
    }
}
