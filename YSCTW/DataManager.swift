//
//  DataManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    let queue = OperationQueue()
    
    let coreDataController = CoreDataController()
    var projects = [Project]()
    
    override init() {
        self.queue.maxConcurrentOperationCount = 1
    }
    
    func projects(_ callback: @escaping ((_ projects: [Project]) -> () )) {
        
        if self.projects.count == 0 {
            
            let operation = ProjectsDownloadOperation(callback: callback)
            self.queue.addOperation(operation)
            
        } else {
            callback(self.projects)
        }
        
    }
    
    func uploads(_ callback: @escaping ((_ uploads: [Upload]) -> () )) {
        let operation = UploadsDownloadOperation { (uploads) in
            let sortedUploads = uploads.sorted(by: { $0.date > $1.date })
            callback(sortedUploads)
        }
        self.queue.addOperation(operation)
    }
    
    func commentsWith(_ uploadId: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        let operation = CommentDownloadOperation(uploadId, callback)
        self.queue.addOperation(operation)
    }
    
    func postCommentWith(_ uploadId: String, _ text: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        let operation = PostCommentOperation(uploadId, text, callback)
        self.queue.addOperation(operation)
    }
    
    func deleteUser(callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        let operation = DeleteUserOperation(callback)
        self.queue.addOperation(operation)
    }
    
    func userProfile() -> Profile {
        return self.coreDataController.profile()
    }
    
    func login(email: String, password: String,_ callback: @escaping ((_ success: Bool) -> () )) {
        
        let callback = { (success: Bool, errorMessage: String, profile: Profile?) in
        
            if success {
                UserDefaults.standard.setValue(true, forKey: "loggedIn")                
                self.coreDataController.save(profile: profile!)
                
            } else {
                HelperFunctions.presentAlertViewfor(error: errorMessage)
            }
            
            callback(success)
        }
        
        APIClient.login(email: email, password: password, callback: callback)
    }

}
