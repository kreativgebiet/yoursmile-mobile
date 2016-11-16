//
//  DataManager.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class DataManager: NSObject {
        
    func projects() -> [Project] {
        return MockUpTestData().projects()
    }
    
    func donations() -> [Donation] {
        return MockUpTestData().donations()
    }
    
    func profile() -> Profile {
        return MockUpTestData().profile()
    }
    
    func userProfile() -> Profile {
        return MockUpTestData().userProfile()
    }

}
