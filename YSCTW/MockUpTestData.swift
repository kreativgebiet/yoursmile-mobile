//
//  MockUpTestData.swift
//  YSCTW
//
//  Created by Max Zimmermann on 09.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import UIKit

class MockUpTestData: NSObject {
    
    func projects() -> [Project] {
        
        var project1 = Project(name: "wwf-fund", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", progress: 100, id: "1", imageURL: "", logoURL: "", countryCode: "de", sectorCode: "env")
                
        return [project1]
    }
    
    func donations() -> [Upload] {
        
        return []
    }
    
    public func profile() -> Profile {
        return Profile(id: 1, name: "Max Z", email: "test@mail.de", nickname: "nick", avatarURL: "asflkj")
    }
    
    public func userProfile() -> Profile {
        return Profile(id: 1, name: "Max M.", email: "test@mail.de", nickname: "nick", avatarURL: "asflkj")
    }

}
