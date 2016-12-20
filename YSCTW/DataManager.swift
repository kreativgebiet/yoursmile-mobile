//
//  DataManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DataManager: NSObject {
    
    func projects(_ callback: @escaping ((_ projects: [Project]) -> () )) {
        APIClient.projects(callback: callback)
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
    
    func profile() -> Profile {
        return MockUpTestData().profile()
    }
    
    func userProfile() -> Profile {
        return MockUpTestData().userProfile()
    }
    
    func login(email: String, password: String,_ callback: @escaping ((_ success: Bool) -> () )) {
        
        let callback = { (success: Bool, errorMessage: String) in
        
            if success {
                UserDefaults.standard.setValue(true, forKey: "loggedIn")
            } else {
                HelperFunctions.presentAlertViewfor(error: errorMessage)
            }
            
            callback(success)
        }
        
        APIClient.login(email: email, password: password, callback: callback)
    }

}
