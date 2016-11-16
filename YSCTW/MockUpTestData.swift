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
        
        let project1 = Project(name: "wwf-fund", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "Project-Image"), logo: #imageLiteral(resourceName: "wwf-logo"))
        let project2 = Project(name: "wwf-fund1longtextfund1longtextfund1longtext", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "Project-Image"), logo: #imageLiteral(resourceName: "wwf-logo"))
        let project3 = Project(name: "wwf-fund2", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et,Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et,Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et,Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "Project-Image"), logo: #imageLiteral(resourceName: "wwf-logo"))
        let project4 = Project(name: "wwf-fund3", description: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "Project-Image"), logo: #imageLiteral(resourceName: "wwf-logo"))
        
        return [project1, project2, project3, project4]
    }
    
    func donations() -> [Donation] {
        
        //Mock data
        let comment1 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment2 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment3 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment4 = Comment(name: "test1", text: " et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment5 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut laboreLorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat,  et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment6 = Comment(name: "test1", text: "sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment7 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment8 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et", image: #imageLiteral(resourceName: "owner"))
        let comment9 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet", image: #imageLiteral(resourceName: "owner"))
        let comment10 = Comment(name: "test1", text: "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam ", image: #imageLiteral(resourceName: "owner"))
        
        let projects = self.projects()
        
        var donation1 = Donation(supportedProjects: projects , selfieImage: #imageLiteral(resourceName: "Selfie"), profileImage: #imageLiteral(resourceName: "owner"), name: "User1", time: "12m", comments: "666")
        
        donation1.comments = [comment1,comment2,comment3,comment4,comment5,comment6,comment7,comment8,comment9,comment10]
        donation1.profile = self.profile()
        
        donation1.selfieUserComment = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et"
        
        var donation2 = Donation(supportedProjects: projects, selfieImage: #imageLiteral(resourceName: "Selfie"), profileImage: #imageLiteral(resourceName: "owner"), name: "User2", time: "12m", comments: "666")
        
        donation2.profile = self.profile()
        
        donation2.selfieUserComment = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua. At vero eos et accusam et justo duo dolores et ea rebum. Stet clita kasd gubergren,"
        
        var donation3 = Donation(supportedProjects: projects, selfieImage: #imageLiteral(resourceName: "Selfie"), profileImage: #imageLiteral(resourceName: "owner"), name: "User3", time: "12m", comments: "666")
        
        donation3.profile = self.profile()
        
        donation3.selfieUserComment = "Lorem ipsum dolor sit amet, consetetur sadipscing elitr, sed diam nonumy eirmod tempor invidunt ut labore et dolore magna aliquyam erat, sed diam voluptua."
        
        var donation4 = Donation(supportedProjects: projects, selfieImage: #imageLiteral(resourceName: "Selfie"), profileImage: #imageLiteral(resourceName: "owner"), name: "User4", time: "12m", comments: "666")
        donation4.profile = self.profile()
        
        var donation5 = Donation(supportedProjects: projects, selfieImage: #imageLiteral(resourceName: "Selfie"), profileImage: #imageLiteral(resourceName: "owner"), name: "User5", time: "12m", comments: "666")
        
        donation5.profile = self.profile()
        
        return [donation1,donation2,donation3,donation4,donation5]
    }
    
    public func profile() -> Profile {
        return Profile(name: "Max Mustermann", image: #imageLiteral(resourceName: "Profile-Pic"))
    }
    
    public func userProfile() -> Profile {
        return Profile(name: "Max Mustermann 2", image: nil)
    }

}
