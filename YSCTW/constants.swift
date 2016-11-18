//
//  constants.swift
//  YSCTW
//
//  Created by Max Zimmermann on 06.11.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import UIKit

let baseURL = "http://yoursmile-staging.herokuapp.com/"

let feedNotificationIdentifier: String = "FeedNotificationIdentifier"
let preferencesNotificationIdentifier: String = "PreferencesNotificationIdentifier"
let showUploadNotificationIdentifier: String = "UploadNotificationIdentifier"

let orange = UIColor(red: 252.0/255.0, green: 168/255.0, blue: 78/255.0, alpha: 1.0) as UIColor
let green = UIColor(red: 0/255.0, green: 151.0/255.0, blue: 137.0/255.0, alpha: 1.0) as UIColor

let customRed = UIColor(red: 250.0/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0) as UIColor
let customLightGray = UIColor.init(white: 248.0/256.0, alpha: 1)
let customGray = UIColor.init(white: 235.0/256.0, alpha: 1)
let timeGray = UIColor.init(white: 169.0/256.0, alpha: 1)
let customDarkGray = UIColor.init(white: 180.0/256.0, alpha: 1)
let customDarkerGray = UIColor.init(white: 216.0/256.0, alpha: 1)
let spacerGray = UIColor.init(white: 102.0/256.0, alpha: 1)
let navigationBarGray = UIColor.init(white: 68.0/256.0, alpha: 1)
let customMiddleGray = UIColor.init(white: 135.0/256.0, alpha: 1)

//Mock data structure

struct Profile {
    var profileImage: UIImage?
    var userName: String
    
    var numberOfDonations: Int?
    
    init(name: String, image: UIImage?) {
        self.profileImage = image
        self.userName = name
    }
}

struct Project {
    var projectImage: UIImage
    var projectName: String
    var projectDescription: String
    var logoImage: UIImage
    var country: String?
    var sector: String?
    
    init(name: String, description: String, image: UIImage, logo: UIImage) {
        self.projectImage = image
        self.projectName = name
        self.projectDescription = description
        self.logoImage = logo
    }
}

extension Project: Equatable {
    static public func ==(lhs: Project, rhs: Project) -> Bool
    {
        return lhs.projectName == rhs.projectName && lhs.sector == rhs.sector && lhs.projectDescription == rhs.projectDescription
    }
}

struct Comment {
    var commentProfileImage: UIImage
    var commentName: String
    var comment: String
    
    init(name: String, text: String, image: UIImage) {
        self.comment = text
        self.commentName = name
        self.commentProfileImage = image
    }
}

struct Donation {
    
    var selfie: UIImage?
    var donorProfileImage: UIImage?
    var donorName: String?
    var donationTime: String?
    var numberOfComments: String
    
    var selfieUserComment: String?
    var comments: [Comment]?
    
    var projects: [Project]
    var profile: Profile?
    
    init(supportedProjects: [Project], selfieImage: UIImage, profileImage: UIImage, name: String, time: String, comments: String) {
        projects = supportedProjects
        selfie = selfieImage
        donorProfileImage = profileImage
        donorName = name
        donationTime = time
        numberOfComments = comments
    }
    
}
