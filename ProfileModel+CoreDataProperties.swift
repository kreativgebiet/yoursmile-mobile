//
//  ProfileModel+CoreDataProperties.swift
//  YSCTW
//
//  Created by Max Zimmermann on 20.12.16.
//  Copyright © 2016 MZ. All rights reserved.
//

import Foundation
import CoreData


extension ProfileModel {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ProfileModel> {
        return NSFetchRequest<ProfileModel>(entityName: "ProfileModel");
    }

    @NSManaged public var id: NSNumber?
    @NSManaged public var email: String?
    @NSManaged public var stripe_customer_id: String?
    @NSManaged public var provider: String?
    @NSManaged public var nickname: String?
    @NSManaged public var avatar_url: String?
    @NSManaged public var avatar_thumb_url: String?
    @NSManaged public var uid: String?
    @NSManaged public var name: String?
    @NSManaged public var image: String?
    @NSManaged public var followerCount: NSNumber?
    @NSManaged public var followingCount: NSNumber?

}
