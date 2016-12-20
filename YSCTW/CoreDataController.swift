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
    
    func profileModel() -> ProfileModel {
        
        let profileModel = self.fetchProfileModel()
        
        if profileModel == nil {
            return  NSEntityDescription.insertNewObject(forEntityName: "ProfileModel", into: self.managedObjectContext) as! ProfileModel
        } else {
            return profileModel!
        }
        
    }
    
    func fetchProfileModel() -> ProfileModel? {
        let fetchRequest: NSFetchRequest<ProfileModel> = ProfileModel.fetchRequest()

        do {
            let searchResults = try self.managedObjectContext.fetch(fetchRequest)
            print ("num of results = \(searchResults.count)")
            return searchResults.count > 0 ? searchResults[0] : nil
            
        } catch {
            print("Error with request: \(error)")
            return nil
        }
    }
    
    func save(profile: Profile) {
        let profileModel = self.profileModel()
        
        profileModel.id = profile.id as NSNumber?
        profileModel.name = profile.name
        profileModel.email = profile.email
        profileModel.nickname = profile.nickname
        profileModel.avatar_url = profile.avatarUrl
        profileModel.avatar_thumb_url = profile.avatarThumbUrl
        
        self.save()
    }
    
    func profile() -> Profile {
        let profileModel = self.profileModel()
        
        return Profile(id: Int(profileModel.id!), name: profileModel.name!, email: profileModel.email!, nickname: profileModel.nickname!, avatarURL: profileModel.avatar_url!, avatarThumbUrl: profileModel.avatar_thumb_url)
    }
    
    public func deleteProfileModel() {
        let profile = self.fetchProfileModel()
        
        if profile != nil {
            self.managedObjectContext.delete(profile!)
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
