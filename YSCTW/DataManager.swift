//
//  DataManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    let coreDataController = CoreDataController()
    var projects = [Project]()
    
    func projects(_ callback: @escaping ((_ projects: [Project]) -> () )) {
        
        if self.projects.count == 0 {
            APIClient.projects(callback: { (projects) in
                self.projects = projects
                callback(self.projects)
            })
        } else {
            callback(self.projects)
        }
        
    }
    
    func uploads(_ callback: @escaping ((_ uploads: [Upload]) -> () )) {
        APIClient.uploads { (uploads) in
            let sortedUploads = uploads.sorted(by: { $0.date > $1.date })
            callback(sortedUploads)
        }
    }
    
    func commentsWith(_ uploadId: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        APIClient.commentsWith(uploadId) { (comments) in
            callback(comments)
        }
    }
    
    func postCommentWith(_ uploadId: String, _ text: String, _ callback: @escaping ((_ comments: [Comment]) -> () )) {
        APIClient.postCommentWith(uploadId, text) { (comments) in
            callback(comments)
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
