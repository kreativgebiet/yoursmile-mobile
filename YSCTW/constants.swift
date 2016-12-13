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
let uploadProgressNotificationIdentifier: String = "UploadProgressNotificationIdentifier"
let logoutNotificationIdentifier: String = "LogoutProgressNotificationIdentifier"

let orange = UIColor(red: 252.0/255.0, green: 168/255.0, blue: 78/255.0, alpha: 1.0) as UIColor
let green = UIColor(red: 0/255.0, green: 151.0/255.0, blue: 137.0/255.0, alpha: 1.0) as UIColor
let customRed = UIColor(red: 250.0/255.0, green: 80/255.0, blue: 80/255.0, alpha: 1.0) as UIColor
let placeholderColor = UIColor(red: 199.0/255.0, green: 199.0/255.0, blue: 205.0/255.0, alpha: 1.0) as UIColor
let customLightGray = UIColor.init(white: 248.0/256.0, alpha: 1)
let customGray = UIColor.init(white: 235.0/256.0, alpha: 1)
let customGray2 = UIColor.init(white: 248.0/256.0, alpha: 1)
let timeGray = UIColor.init(white: 169.0/256.0, alpha: 1)
let customDarkGray = UIColor.init(white: 180.0/256.0, alpha: 1)
let customDarkerGray = UIColor.init(white: 216.0/256.0, alpha: 1)
let spacerGray = UIColor.init(white: 102.0/256.0, alpha: 1)
let navigationBarGray = UIColor.init(white: 68.0/256.0, alpha: 1)
let customMiddleGray = UIColor.init(white: 135.0/256.0, alpha: 1)

//Mock data structure

enum Payment {
    case none
    case payPal
    case creditCard
}

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
    var projectImage: UIImage?
    var logoImage: UIImage?
    var countryCode: String?
    var sectorCode: String?

    var projectName: String
    var projectDescription: String
    var progress: Int
    var id: String!
    var imageURL: String
    var logoURL: String
    
    init(name: String, description: String, progress: Int, id: String, imageURL: String, logoURL: String, countryCode: String, sectorCode: String) {
        self.projectName = name
        self.projectDescription = description
        self.id = id
        self.progress = progress
        self.logoURL = logoURL
        self.imageURL = imageURL
        self.countryCode = countryCode
        self.sectorCode = sectorCode
    }
}

extension Project: Equatable {
    static public func ==(lhs: Project, rhs: Project) -> Bool
    {
        return lhs.projectName == rhs.projectName && lhs.sectorCode == rhs.sectorCode && lhs.projectDescription == rhs.projectDescription
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

struct Upload {
    
    var projects: [Project]
    var imageURL: String
    var id: String
    
    var date: Date
    var description: String
    var profile: Profile?
    
    var numberOfComments: String?
    var comments: [Comment]?
    
    init(supportedProjects: [Project], imageURL: String, id: String, created_at: String, description: String, profile: Profile) {
        self.projects = supportedProjects
        self.imageURL = imageURL
        self.id = id
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        let dateObj = dateFormatter.date(from: created_at)
        
        self.date = dateObj!
        
        self.description = description
        self.profile = profile
    }
    
}
