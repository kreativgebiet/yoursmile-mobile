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
    
    func userDataFor(id: String, _ callback: @escaping ((_ user: Profile?) -> () )) {
        let operation = UserDataOperation(id, {profile in
            callback(profile)
        })
        self.queue.addOperation(operation)
    }
    
    func projects(_ callback: @escaping ((_ projects: [Project]) -> () )) {
        
        if self.projects.count == 0 {
            
            let operation = ProjectsDownloadOperation(callback: { (projects) in
                self.projects = projects
                callback(self.projects)
            })
            self.queue.addOperation(operation)
            
        } else {
            callback(self.projects)
        }
        
    }
    
    func uploadsWith(_ userId: String?, _ callback: @escaping ((_ uploads: [Upload]) -> () )) {
        let operation = UploadsDownloadOperation(userId: userId, callback: { (uploads) in
            let sortedUploads = uploads.sorted(by: { $0.date > $1.date })
            callback(sortedUploads)
        })
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
    
    func updateUser(email: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        let operation = UpdateUserOperation(email, callback)
        self.queue.addOperation(operation)
    }
    
    func resetPassword(password: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        let operation = ResetPasswordOperation(password, callback)
        self.queue.addOperation(operation)
    }
    
    func postPaymentSource(tokenId: String, callback: @escaping ((_ success: Bool, _ errorMessage: String) -> ())) {
        let operation = PostPaymentSourceOperation(tokenId, callback)
        self.queue.addOperation(operation)
    }
    
    func uploadSelfies () {
        let uploadModels = CoreDataController().fetchUploadModelsToUpload()
        
        for upload in uploadModels {
            let operation = UploadSelfiesOperation(upload)
            self.queue.addOperation(operation)
        }
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
