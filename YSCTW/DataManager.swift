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
    
    func profile() -> Profile {
        return MockUpTestData().profile()
    }
    
    func userProfile() -> Profile {
        return MockUpTestData().userProfile()
    }

}
