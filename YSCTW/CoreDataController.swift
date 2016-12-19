//
//  CoreDataController.swift
//  YSCTW
//
//  Created by Max Zimmermann on 16.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreDataController: NSObject {
    
    var managedObjectContext: NSManagedObjectContext
    
    override init() {
        // This resource is the same name as your xcdatamodeld contained in your project.
        guard let modelURL = Bundle.main.url(forResource: "YSCTW", withExtension:"momd") else {
            fatalError("Error loading model from bundle")
        }
        // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
        guard let mom = NSManagedObjectModel(contentsOf: modelURL) else {
            fatalError("Error initializing mom from: \(modelURL)")
        }
        
        let psc = NSPersistentStoreCoordinator(managedObjectModel: mom)
        self.managedObjectContext = NSManagedObjectContext(concurrencyType: .mainQueueConcurrencyType)
        self.managedObjectContext.persistentStoreCoordinator = psc
        
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docURL = urls[urls.endIndex-1]
        /* The directory the application uses to store the Core Data store file.
         This code uses a file named "DataModel.sqlite" in the application's documents directory.
         */
        let storeURL = docURL.appendingPathComponent("YSCTW")
        do {
            try psc.addPersistentStore(ofType: NSSQLiteStoreType, configurationName: nil, at: storeURL, options: nil)
        } catch {
            fatalError("Error migrating store: \(error)")
        }
        
    }
    
    public func createUploadModel() -> UploadModel {
        
        let entity = NSEntityDescription.insertNewObject(forEntityName: "UploadModel", into: self.managedObjectContext) as! UploadModel
        
        return entity
    }
    
    public func fetchUploadModelsWith(search: NSPredicate?) -> [UploadModel] {
        let fetchRequest: NSFetchRequest<UploadModel> = UploadModel.fetchRequest()
        
        if let predicate = search {
            fetchRequest.predicate = predicate
        }
        
        do {
            let searchResults = try self.managedObjectContext.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")            
            return searchResults
            
        } catch {
            print("Error with request: \(error)")
            return []
        }
    }
    
    public func fetchUploadModelsToUpload() -> [UploadModel] {
        return self.fetchUploadModelsWith(search: NSPredicate(format: "isUploaded == %@", NSNumber(booleanLiteral: false)))
    }
    
    public func save() {
        do {
            try self.managedObjectContext.save()
        } catch {
            fatalError("Failure to save context: \(error)")
        }
    }

}
